// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wordstock/model/word.dart';

part 'chat_ai_state.dart';

class ChatAICubit extends Cubit<ChatAIState> {
  ChatAICubit() : super(const ChatAIInitial());

  // OpenAI API constants
  static const _openAIEndpoint = 'https://api.openai.com/v1/chat/completions';
  static const _openAIModel = 'gpt-3.5-turbo';
  final _client = http.Client();

  Future<void> startChatWithWord(Word word) async {
    emit(const ChatAILoading());

    try {
      final initialPrompt = _generateInitialPrompt(word);
      final response = await _sendChatRequest(initialPrompt);

      final messages = [
        ChatMessage(
          role: MessageRole.system,
          content:
              "I'm an AI language assistant that can explain vocabulary words in a friendly, educational way. I focus only on vocabulary and language learning topics.",
        ),
        ChatMessage(
          role: MessageRole.user,
          content: initialPrompt,
        ),
        ChatMessage(
          role: MessageRole.assistant,
          content: response,
        ),
      ];

      emit(
        ChatAILoaded(
          word: word,
          messages: messages,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(ChatAIError(errorMessage: e.toString()));
    }
  }

  Future<void> sendMessage(String message) async {
    if (state is! ChatAILoaded) return;

    final currentState = state as ChatAILoaded;
    final currentWord = currentState.word;

    // Add user message to the state
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
      ),
    );

    try {
      // Prepare conversation history for API
      final conversationHistory = [
        {
          'role': 'system',
          'content':
              "You are a vocabulary learning assistant focused solely on explaining words and their usage, specifically the word '${currentWord.word}'. You can explain definitions, provide example sentences, discuss synonyms, antonyms, and usage contexts for words. If asked about anything unrelated to vocabulary, language learning, or the specific word being discussed, respond with a polite message explaining that you can only discuss vocabulary-related topics. For example: 'I'm here to help you understand vocabulary words better. Could we focus on word meanings, usage, or language learning instead?'",
        },
      ];

      // Add conversation history excluding system messages
      for (final msg in currentState.messages) {
        if (msg.role != MessageRole.system) {
          conversationHistory.add({
            'role': msg.role.name,
            'content': msg.content,
          });
        }
      }

      // Add the new user message
      conversationHistory.add({
        'role': 'user',
        'content': message,
      });

      // Send to API
      final apiResponse = await _sendOpenAIRequest(conversationHistory);
      final responseContent = _extractResponseContent(apiResponse);

      // Add AI response to messages
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
      emit(ChatAIError(errorMessage: e.toString()));
    }
  }

  String _generateInitialPrompt(Word word) {
    return "Can you explain the word '${word.word}' in simple terms? Include its definition, some example sentences, and maybe related words. The dictionary definition is: '${word.definition}'. An example usage is: '${word.example ?? ""}'";
  }

  Future<String> _sendChatRequest(String prompt) async {
    final conversationHistory = [
      {
        'role': 'system',
        'content':
            "You are a vocabulary learning assistant focused solely on explaining words and their usage. You can explain definitions, provide example sentences, discuss synonyms, antonyms, and usage contexts for words. If asked about anything unrelated to vocabulary, language learning, or the specific word being discussed, respond with a polite message explaining that you can only discuss vocabulary-related topics. For example: 'I'm here to help you understand vocabulary words better. Could we focus on word meanings, usage, or language learning instead?'",
      },
      {
        'role': 'user',
        'content': prompt,
      },
    ];

    final apiResponse = await _sendOpenAIRequest(conversationHistory);
    return _extractResponseContent(apiResponse);
  }

  Future<Map<String, dynamic>> _sendOpenAIRequest(
    List<Map<String, dynamic>> messages,
  ) async {
    final apiKey = _getOpenAIApiKey();
    final requestBody = json.encode({
      'model': _openAIModel,
      'messages': messages,
      'max_tokens': 500,
    });

    final response = await _client.post(
      Uri.parse(_openAIEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get response from AI: ${response.body}');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  String _extractResponseContent(Map<String, dynamic> apiResponse) {
    try {
      final choices = apiResponse['choices'] as List<dynamic>;
      final firstChoice = choices[0] as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>;
      return message['content'] as String;
    } catch (e) {
      throw Exception('Invalid response format from AI service');
    }
  }

  String _getOpenAIApiKey() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenAI API key not found');
    }
    return apiKey;
  }

  @override
  Future<void> close() {
    _client.close();
    return super.close();
  }
}
