import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/repositories/supabase_repository.dart';

/// Repository responsible for quiz-related operations
class QuizRepository {
  QuizRepository()
      : _supabase = SupabaseRepository.client,
        _userId = SupabaseRepository.client.auth.currentUser?.id ?? '',
        _client = http.Client();

  final SupabaseClient _supabase;
  final String _userId;
  final Logger logger = Logger();
  final http.Client _client;

  // OpenAI API constants
  static const _openAIEndpoint = 'https://api.openai.com/v1/chat/completions';
  static const _openAIModel = 'gpt-3.5-turbo';
  static const _maxQuizGenerationRetries = 2;

  /// Fetches quiz questions from Supabase
  Future<List<PracticeQuizQuestion>> getQuiz() async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'generate_practice_quiz',
        params: {
          'user_id_param': _userId,
          'total_questions': 10,
        },
      );

      return _parseSupabaseQuizResponse(response);
    } catch (e) {
      logger.e('Failed to get quiz from Supabase: $e');
      rethrow;
    }
  }

  /// Parses quiz data from Supabase response
  List<PracticeQuizQuestion> _parseSupabaseQuizResponse(dynamic response) {
    try {
      final questions = (response as List<dynamic>).map(
        (item) {
          final question =
              PracticeQuizQuestion.fromJson(item as Map<String, dynamic>);
          question.options.shuffle();
          return question;
        },
      ).toList();

      return questions;
    } catch (e) {
      logger.e('Error parsing Supabase quiz response: $e');
      throw Exception('Invalid quiz data format from Supabase');
    }
  }

  /// Generates a quiz using OpenAI based on provided vocabulary words
  Future<List<PracticeQuizQuestion>> getQuizFromOpenAI({
    required List<Word> words,
    int retryCount = 0,
  }) async {
    if (words.isEmpty) {
      logger.w('No words provided for quiz generation');
      throw Exception('No vocabulary words provided for quiz generation');
    }

    final stopwatch = Stopwatch()..start();
    logger.i('Starting OpenAI quiz generation for ${words.length} words');

    try {
      final apiKey = _getOpenAIApiKey();
      final wordDetails = _formatWordDetails(words);
      final prompt = _buildPrompt(wordDetails, words.length);
      final requestBody = _buildRequestBody(prompt);

      final requestPrepTime = stopwatch.elapsedMilliseconds;
      logger.d('Request preparation completed in ${requestPrepTime}ms');

      final response = await _sendOpenAIRequest(apiKey, requestBody);

      final apiResponseTime = stopwatch.elapsedMilliseconds - requestPrepTime;
      logger.i('OpenAI API responded in ${apiResponseTime}ms');

      final questions = _processApiResponse(response.body);

      stopwatch.stop();
      _logPerformanceMetrics(
        stopwatch.elapsedMilliseconds,
        requestPrepTime,
        apiResponseTime,
      );

      if (questions.isNotEmpty) {
        logger.i(
          'Successfully generated ${questions.length} questions from OpenAI',
        );
        return questions;
      } else {
        throw Exception('Generated quiz contained no questions');
      }
    } catch (e) {
      stopwatch.stop();
      logger.e('Error generating quiz from OpenAI: $e');

      // Implement retry logic for recoverable errors
      if (retryCount < _maxQuizGenerationRetries) {
        logger.w('Retrying quiz generation (attempt ${retryCount + 1})');
        return getQuizFromOpenAI(words: words, retryCount: retryCount + 1);
      }

      rethrow;
    }
  }

  /// Gets the OpenAI API key from environment variables
  String _getOpenAIApiKey() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null) {
      throw Exception('OpenAI API key not found in environment variables');
    }
    return apiKey;
  }

  /// Formats word details for the prompt
  String _formatWordDetails(List<Word> words) {
    return words
        .map(
          (word) => '- Word: ${word.word}\n'
              '  Definition: ${word.definition}\n'
              '  Example: ${word.example ?? "N/A"}',
        )
        .join('\n');
  }

  /// Builds the prompt for OpenAI
  String _buildPrompt(String wordDetails, int wordCount) {
    return '''
I need to generate a vocabulary quiz with $wordCount sentence completion questions based on the following words:

$wordDetails

For each word, create a question where the user must select the correct word to complete a sentence. 
The format of each question should be: "[Sentence with ___ where the word should go]"

The sentence should demonstrate the word's proper usage and context.
Each question should have 3 options with only one correct answer (which is the word itself).
The other options should be plausible but incorrect alternatives that are similar in meaning or usage.

The format must be exactly as follows:
{
  "questions": [
    {
      "question_id": "1",
      "question": "The professor's ___ lecture kept the students engaged for hours.",
      "options": ["profound", "mundane", "verbose"],
      "correct_answer": "profound"
    }
  ]
}

Important requirements:
1. Each sentence must contain a blank (___) where the target word should go
2. The sentence should provide enough context to determine the correct word
3. The correct answer must be the actual vocabulary word from the list
4. The options should include the correct word and two plausible alternatives
5. The options should not be overly obvious - they should require understanding of the word meanings
''';
  }

  /// Builds the request body for OpenAI API
  String _buildRequestBody(String prompt) {
    return jsonEncode({
      'model': _openAIModel,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are an expert language teacher creating vocabulary quizzes.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'temperature': 0.6,
      'max_tokens': 2000,
    });
  }

  /// Sends request to OpenAI API
  Future<http.Response> _sendOpenAIRequest(
    String apiKey,
    String requestBody,
  ) async {
    final response = await _client.post(
      Uri.parse(_openAIEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: requestBody,
    );

    if (response.statusCode != 200) {
      logger.e('OpenAI API error: ${response.body}');
      throw Exception('Failed to generate quiz: ${response.statusCode}');
    }

    return response;
  }

  /// Processes the API response and converts it to quiz questions
  List<PracticeQuizQuestion> _processApiResponse(String responseBody) {
    try {
      // Parse the response
      final dynamic decodedJson = jsonDecode(responseBody);
      if (decodedJson is! Map<String, dynamic>) {
        throw Exception('Invalid API response: root is not a JSON object');
      }

      final jsonResponse = decodedJson;
      logger.d('OpenAI API response received');

      if (!jsonResponse.containsKey('choices') ||
          jsonResponse['choices'] is! List ||
          (jsonResponse['choices'] as List).isEmpty) {
        throw Exception('Invalid API response: missing or empty choices array');
      }

      final firstChoice = (jsonResponse['choices'] as List).first;
      if (firstChoice is! Map ||
          !firstChoice.containsKey('message') ||
          firstChoice['message'] is! Map) {
        throw Exception('Invalid API response: malformed choice object');
      }

      final message = firstChoice['message'] as Map;
      if (!message.containsKey('content') || message['content'] is! String) {
        throw Exception('Invalid API response: missing or invalid content');
      }

      final content = message['content'] as String;
      logger.d('Content extracted from response');

      // Extract JSON from content (it might be wrapped in markdown code blocks)
      final jsonMatch = RegExp(r'{[\s\S]*}').firstMatch(content);
      if (jsonMatch == null) {
        logger.e('Failed to extract JSON from OpenAI response: $content');
        throw Exception('Invalid response format from OpenAI');
      }

      final jsonStr = jsonMatch.group(0) ?? '{}';
      logger.d('JSON extracted from content');

      // Parse the JSON into our data model
      final parsedData = jsonDecode(jsonStr);
      logger.d('Parsed JSON data: ${parsedData.runtimeType}');

      return _extractQuestionsFromParsedData(parsedData);
    } catch (e) {
      logger.e('Error processing API response: $e');
      throw Exception('Failed to process OpenAI response: $e');
    }
  }

  /// Extracts questions from parsed JSON data
  List<PracticeQuizQuestion> _extractQuestionsFromParsedData(
    dynamic parsedData,
  ) {
    // Check if 'questions' key exists
    if (parsedData is Map && parsedData.containsKey('questions')) {
      final questionsData = parsedData['questions'];

      // Check if questions is a list
      if (questionsData is List) {
        final questionsJson = questionsData;
        logger.d('Found ${questionsJson.length} questions in response');

        // Convert to PracticeQuizQuestion objects
        return questionsJson.map((item) {
          try {
            final question =
                PracticeQuizQuestion.fromJson(item as Map<String, dynamic>);
            question.options.shuffle(); // Shuffle options for each question
            return question;
          } catch (e) {
            logger.e('Error parsing question: $e\nQuestion data: $item');
            rethrow;
          }
        }).toList();
      } else {
        logger.e(
          'The "questions" field is not a list: ${questionsData.runtimeType}',
        );
        throw Exception(
          'Invalid response format: questions field is not a list',
        );
      }
    } else {
      logger.e('Response missing "questions" key or not a map: $parsedData');
      throw Exception('Invalid response format: missing questions field');
    }
  }

  /// Logs performance metrics for quiz generation
  void _logPerformanceMetrics(
    int totalTime,
    int requestPrepTime,
    int apiResponseTime,
  ) {
    final processingTime = totalTime - requestPrepTime - apiResponseTime;

    logger
      ..i('Performance metrics for OpenAI quiz generation:')
      ..i('- Request preparation: ${requestPrepTime}ms')
      ..i('- API response time: ${apiResponseTime}ms')
      ..i('- Response processing: ${processingTime}ms')
      ..i('- Total time: ${totalTime}ms');
  }

  /// Disposes resources
  void dispose() {
    _client.close();
  }
}
