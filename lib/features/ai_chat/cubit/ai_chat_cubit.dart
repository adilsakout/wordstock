import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/chat_repository.dart';
import 'package:wordstock/repositories/supabase_repository.dart';

part 'ai_chat_state.dart';

/// AI Chat Cubit responsible for managing conversation state
///
/// This cubit handles:
/// - Initiating conversations about specific vocabulary words
/// - Sending user messages and receiving AI responses via Edge Function
/// - Managing conversation history and loading states
/// - Consuming a daily credit only after the first successful response
class AIChatCubit extends Cubit<AIChatState> {
  /// Creates a new [AIChatCubit] instance.
  ///
  /// If [creditCubit] is provided, a credit is consumed only after
  /// the first successful AI response — never before.
  /// If [chatRepository] is provided, conversations are persisted.
  AIChatCubit({
    CreditCubit? creditCubit,
    ChatRepository? chatRepository,
  })  : _creditCubit = creditCubit,
        _chatRepository = chatRepository,
        super(const AIChatInitial());

  final CreditCubit? _creditCubit;
  final ChatRepository? _chatRepository;
  bool _creditConsumed = false;

  /// Initiates a conversation about the specified [word]
  ///
  /// Shows the user's message immediately, then fetches the AI response
  /// via the Supabase Edge Function (API key stays server-side).
  Future<void> startChatWithWord(
    Word word, {
    required String systemMessage,
    required String initialPrompt,
  }) async {
    try {
      final initialMessages = [
        ChatMessage(
          role: MessageRole.system,
          content: systemMessage,
        ),
        ChatMessage(
          role: MessageRole.user,
          content: initialPrompt,
        ),
      ];

      // Show user message immediately while AI is thinking
      emit(
        AIChatLoaded(
          word: word,
          messages: initialMessages,
          isLoading: true,
        ),
      );

      // Call Edge Function instead of direct OpenAI
      final response = await _callEdgeFunction([
        {'role': 'system', 'content': systemMessage},
        {'role': 'user', 'content': initialPrompt},
      ]);

      final messagesWithResponse = List<ChatMessage>.from(initialMessages)
        ..add(
          ChatMessage(
            role: MessageRole.assistant,
            content: response,
          ),
        );

      emit(
        AIChatLoaded(
          word: word,
          messages: messagesWithResponse,
          isLoading: false,
        ),
      );

      // Consume credit only after first successful response
      await _tryConsumeCredit();
    } catch (e) {
      // Keep loaded state so conversation is preserved
      if (state is AIChatLoaded) {
        final s = state as AIChatLoaded;
        emit(
          s.copyWith(
            isLoading: false,
            errorMessage: e.toString,
          ),
        );
      } else {
        emit(AIChatError(errorMessage: e.toString()));
      }
    }
  }

  /// Sends a user message and gets AI response
  ///
  /// Maintains full conversation context and routes through the
  /// Supabase Edge Function for secure API key handling.
  Future<void> sendMessage(
    String message, {
    required String vocabularySystemMessage,
  }) async {
    if (state is! AIChatLoaded) return;

    final currentState = state as AIChatLoaded;
    final currentWord = currentState.word;

    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(
        ChatMessage(
          role: MessageRole.user,
          content: message,
        ),
      );

    emit(
      currentState.copyWith(
        messages: updatedMessages,
        isLoading: true,
        errorMessage: () => null, // clear any previous error
      ),
    );

    try {
      // Build conversation history for the Edge Function
      final conversationHistory = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': vocabularySystemMessage.replaceAll(
            '{word}',
            currentWord.word,
          ),
        },
      ];

      for (final msg in currentState.messages) {
        if (msg.role != MessageRole.system) {
          conversationHistory.add({
            'role': msg.role.name,
            'content': msg.content,
          });
        }
      }

      conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      final responseContent = await _callEdgeFunction(
        conversationHistory,
      );

      final messagesWithResponse = List<ChatMessage>.from(updatedMessages)
        ..add(
          ChatMessage(
            role: MessageRole.assistant,
            content: responseContent,
          ),
        );

      emit(
        currentState.copyWith(
          messages: messagesWithResponse,
          isLoading: false,
          errorMessage: () => null, // clear any previous error
        ),
      );
    } catch (e) {
      // Preserve conversation — show inline error with retry
      emit(
        currentState.copyWith(
          messages: updatedMessages,
          isLoading: false,
          errorMessage: e.toString,
        ),
      );
    }
  }

  /// Attempts to load a previously saved conversation for [word].
  ///
  /// Returns `true` if a saved conversation was restored, in which
  /// case the caller should skip starting a fresh chat.
  Future<bool> loadPreviousChat(Word word) async {
    if (_chatRepository == null) return false;
    try {
      final messages =
          await _chatRepository.loadConversation(word.id);
      if (messages != null && messages.isNotEmpty) {
        emit(
          AIChatLoaded(
            word: word,
            messages: messages,
            isLoading: false,
          ),
        );
        return true;
      }
    } catch (_) {
      // Non-critical — fall through to start fresh.
    }
    return false;
  }

  /// Persists the current conversation to Supabase.
  ///
  /// Called when the bottom sheet closes. Only saves if at least
  /// one assistant message exists (i.e. a real conversation).
  Future<void> saveCurrentChat() async {
    if (_chatRepository == null) return;
    if (state is! AIChatLoaded) return;

    final s = state as AIChatLoaded;
    final hasResponse =
        s.messages.any((m) => m.role == MessageRole.assistant);
    if (!hasResponse) return;

    await _chatRepository.saveConversation(
      wordId: s.word.id,
      messages: s.messages,
    );
  }

  /// Calls the Supabase `chat-completion` Edge Function.
  ///
  /// The Edge Function holds the OpenAI API key server-side,
  /// preventing key exposure on the client.
  Future<String> _callEdgeFunction(
    List<Map<String, dynamic>> messages,
  ) async {
    final response = await SupabaseRepository.client.functions
        .invoke(
          'chat-completion',
          body: {'messages': messages},
        )
        .timeout(const Duration(seconds: 30));

    final data = response.data;
    if (data is Map && data.containsKey('error')) {
      throw Exception(data['error'] as String);
    }

    if (data is String) {
      final parsed = json.decode(data) as Map<String, dynamic>;
      return parsed['content'] as String;
    }

    if (data is Map && data.containsKey('content')) {
      return data['content'] as String;
    }

    throw Exception('Invalid response format from AI service');
  }

  /// Consume a credit once after the first successful response.
  Future<void> _tryConsumeCredit() async {
    if (_creditConsumed || _creditCubit == null) return;
    _creditConsumed = true;
    await _creditCubit.tryConsumeCredit();
  }
}
