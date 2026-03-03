import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;
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

  /// Maximum number of non-system messages (after the first exchange)
  /// to include in the API payload. 10 messages ≈ 5 user+assistant pairs.
  static const int _maxHistoryMessages = 10;

  /// Maximum number of automatic retry attempts for transient errors.
  static const int _maxRetries = 3;

  /// Exponential backoff delays between retry attempts.
  static const List<Duration> _retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
  ];

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

      // Call Edge Function with automatic retry for transient errors
      final response = await _callEdgeFunctionWithRetry([
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
            isRetrying: false,
            retryAttempt: 0,
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
      // Build windowed conversation history for the Edge Function
      final conversationHistory = _buildSlidingWindowMessages(
        currentMessages: currentState.messages,
        newUserMessage: message,
        systemMessage: vocabularySystemMessage.replaceAll(
          '{word}',
          currentWord.word,
        ),
      );

      final responseContent = await _callEdgeFunctionWithRetry(
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
          isRetrying: false,
          retryAttempt: 0,
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

  /// Builds a windowed message list for the API payload.
  ///
  /// Always includes:
  /// 1. The system message (context for the AI)
  /// 2. The first user + assistant exchange (initial word explanation)
  /// 3. The last [_maxHistoryMessages] from the remaining conversation
  /// 4. The new user message
  ///
  /// The full conversation stays visible in the UI — only the API
  /// payload is capped to control token usage and latency.
  List<Map<String, dynamic>> _buildSlidingWindowMessages({
    required List<ChatMessage> currentMessages,
    required String newUserMessage,
    required String systemMessage,
  }) {
    final nonSystemMessages = currentMessages
        .where((m) => m.role != MessageRole.system)
        .toList();

    final result = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemMessage},
    ];

    if (nonSystemMessages.length <= 2) {
      // Short conversation — send everything.
      for (final msg in nonSystemMessages) {
        result.add({'role': msg.role.name, 'content': msg.content});
      }
    } else {
      // Always keep the first exchange (user question + assistant answer).
      result
        ..add({
          'role': nonSystemMessages[0].role.name,
          'content': nonSystemMessages[0].content,
        })
        ..add({
          'role': nonSystemMessages[1].role.name,
          'content': nonSystemMessages[1].content,
        });

      // Sliding window over the rest.
      final remaining = nonSystemMessages.sublist(2);
      final windowStart = remaining.length > _maxHistoryMessages
          ? remaining.length - _maxHistoryMessages
          : 0;
      for (var i = windowStart; i < remaining.length; i++) {
        result.add({
          'role': remaining[i].role.name,
          'content': remaining[i].content,
        });
      }
    }

    // Append the new user message.
    result.add({'role': 'user', 'content': newUserMessage});
    return result;
  }

  /// Whether [error] is a transient failure worth retrying.
  ///
  /// Retries on: network errors, timeouts, 5xx server errors.
  /// Does NOT retry on: 4xx client errors, response format issues.
  bool _isRetryableError(Object error) {
    if (error is TimeoutException) return true;
    if (error is SocketException) return true;
    if (error is FunctionException) return error.status >= 500;

    final msg = error.toString().toLowerCase();
    return msg.contains('socketexception') ||
        msg.contains('connection') ||
        msg.contains('timeout') ||
        msg.contains('network');
  }

  /// Wraps [_callEdgeFunction] with automatic retry for transient errors.
  ///
  /// Up to [_maxRetries] attempts with exponential backoff (1s → 2s → 4s).
  /// Emits [AIChatLoaded] with `isRetrying: true` between attempts so the
  /// UI can show a retrying indicator. Rethrows if the error is
  /// non-retryable or all attempts are exhausted.
  Future<String> _callEdgeFunctionWithRetry(
    List<Map<String, dynamic>> messages,
  ) async {
    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        return await _callEdgeFunction(messages);
      } catch (e) {
        final isLastAttempt = attempt == _maxRetries - 1;
        if (!_isRetryableError(e) || isLastAttempt) {
          rethrow;
        }

        // Emit retrying state so the UI can show progress.
        if (state is AIChatLoaded) {
          emit(
            (state as AIChatLoaded).copyWith(
              isRetrying: true,
              retryAttempt: attempt + 1,
            ),
          );
        }

        await Future<void>.delayed(_retryDelays[attempt]);
      }
    }
    // Unreachable — loop either returns or rethrows.
    throw Exception('All retry attempts exhausted');
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
