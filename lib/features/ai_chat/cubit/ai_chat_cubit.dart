// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wordstock/bootstrap.dart';
import 'package:wordstock/model/word.dart';

part 'ai_chat_state.dart';

/// AI Chat Cubit responsible for managing conversation state with OpenAI
///
/// This cubit handles:
/// - Initiating conversations about specific vocabulary words
/// - Sending user messages and receiving AI responses
/// - Managing conversation history and loading states
/// - Enforcing vocabulary-focused conversation scope
class AIChatCubit extends Cubit<AIChatState> {
  /// Creates a new [AIChatCubit] instance with initial state
  AIChatCubit() : super(const AIChatInitial());

  // OpenAI API configuration constants
  static const _openAIEndpoint = 'https://api.openai.com/v1/chat/completions';
  static const _openAIModel = 'gpt-3.5-turbo';
  final _client = http.Client();

  /// Initiates a conversation about the specified [word]
  ///
  /// This method:
  /// - Shows initial conversation state with user's query visible immediately
  /// - Displays loading indicator while AI generates response
  /// - Establishes the conversation context focused on vocabulary learning
  /// - Provides smooth UX by showing user message before AI response
  ///
  /// Parameters:
  /// - [word]: The vocabulary word to discuss
  /// - [systemMessage]: Localized system message describing the AI assistant
  /// - [initialPrompt]: Localized initial prompt for the conversation
  Future<void> startChatWithWord(
    Word word, {
    required String systemMessage,
    required String initialPrompt,
  }) async {
    try {
      // First, show the user's initial message immediately for better UX
      // This lets users see their query while AI is thinking
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

      // Emit loaded state with user message visible and AI loading
      emit(
        AIChatLoaded(
          word: word,
          messages: initialMessages,
          isLoading: true, // Show typing indicator for AI response
        ),
      );

      // Now send the prompt to AI and get response
      final response = await _sendChatRequest(initialPrompt, systemMessage);

      // Add AI response to conversation and update state
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
          isLoading: false, // Hide typing indicator
        ),
      );
    } catch (e) {
      emit(AIChatError(errorMessage: e.toString()));
    }
  }

  /// Sends a user message and gets AI response
  ///
  /// This method:
  /// - Validates that we're in a loaded conversation state
  /// - Adds the user message to conversation history
  /// - Sends the full conversation context to OpenAI
  /// - Appends the AI response to the conversation
  /// - Maintains vocabulary-focused conversation scope
  ///
  /// Parameters:
  /// - [message]: The user's message
  /// - [vocabularySystemMessage]: Localized system message for vocabulary focus
  Future<void> sendMessage(
    String message, {
    required String vocabularySystemMessage,
  }) async {
    if (state is! AIChatLoaded) return;

    final currentState = state as AIChatLoaded;
    final currentWord = currentState.word;

    // Add user message to the conversation
    final updatedMessages = List<ChatMessage>.from(currentState.messages)
      ..add(
        ChatMessage(
          role: MessageRole.user,
          content: message,
        ),
      );

    // Update state to show user message and loading indicator
    emit(
      currentState.copyWith(
        messages: updatedMessages,
        isLoading: true,
      ),
    );

    try {
      // Prepare conversation history for OpenAI API with localized system message
      final conversationHistory = [
        {
          'role': 'system',
          'content':
              vocabularySystemMessage.replaceAll('{word}', currentWord.word),
        },
      ];

      // Add conversation history excluding system messages for context
      for (final msg in currentState.messages) {
        if (msg.role != MessageRole.system) {
          conversationHistory.add({
            'role': msg.role.name,
            'content': msg.content,
          });
        }
      }

      // Add the new user message to conversation history
      conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Send to OpenAI API and get response
      final apiResponse = await _sendOpenAIRequest(conversationHistory);
      final responseContent = _extractResponseContent(apiResponse);

      // Add AI response to conversation and update state
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
        ),
      );
    } catch (e) {
      emit(AIChatError(errorMessage: e.toString()));
    }
  }

  /// Sends the initial chat request to OpenAI
  ///
  /// This is a simplified version used for the first interaction
  /// with vocabulary-focused system instructions
  ///
  /// Parameters:
  /// - [prompt]: The user's initial prompt
  /// - [systemMessage]: Localized system message for the AI assistant
  Future<String> _sendChatRequest(String prompt, String systemMessage) async {
    final conversationHistory = [
      {
        'role': 'system',
        'content': systemMessage,
      },
      {
        'role': 'user',
        'content': prompt,
      },
    ];

    final apiResponse = await _sendOpenAIRequest(conversationHistory);
    return _extractResponseContent(apiResponse);
  }

  /// Sends a request to OpenAI API with conversation history
  ///
  /// Handles:
  /// - API key authentication with proper UTF-8 encoding
  /// - Request formatting and serialization with UTF-8 support
  /// - HTTP client configuration for international characters
  /// - Error handling for API failures
  Future<Map<String, dynamic>> _sendOpenAIRequest(
    List<Map<String, dynamic>> messages,
  ) async {
    final apiKey = _getOpenAIApiKey();

    // Encode request body as UTF-8 to properly handle international characters
    final requestData = {
      'model': _openAIModel,
      'messages': messages,
      'max_tokens': 500,
    };
    final requestBody = utf8.encode(json.encode(requestData));

    final response = await _client.post(
      Uri.parse(_openAIEndpoint),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/json; charset=utf-8',
      },
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get response from AI: ${response.body}');
    }

    // Decode response body as UTF-8 to properly handle international characters
    final responseBody = utf8.decode(response.bodyBytes);
    return json.decode(responseBody) as Map<String, dynamic>;
  }

  /// Extracts the content from OpenAI API response
  ///
  /// Parses the API response structure and extracts the actual
  /// message content from the first choice in the response
  String _extractResponseContent(Map<String, dynamic> apiResponse) {
    try {
      logger.d('API Response: $apiResponse');
      final choices = apiResponse['choices'] as List<dynamic>;
      final firstChoice = choices[0] as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>;
      logger.d('AI Message: $message');
      return message['content'] as String;
    } catch (e) {
      throw Exception('Invalid response format from AI service');
    }
  }

  /// Retrieves OpenAI API key from environment variables
  ///
  /// Validates that the API key is present and non-empty
  /// Throws exception if key is missing for security
  String _getOpenAIApiKey() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenAI API key not found');
    }
    return apiKey;
  }

  /// Cleanup method called when cubit is disposed
  ///
  /// Ensures HTTP client is properly closed to prevent memory leaks
  @override
  Future<void> close() {
    _client.close();
    return super.close();
  }
}
