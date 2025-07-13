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

      // Apply fallback mechanism for quality vs quantity balance
      final finalQuestions = _applyFallbackMechanism(questions, words.length);

      if (finalQuestions.isNotEmpty) {
        logger.i(
          'Successfully generated ${finalQuestions.length} questions '
          'from OpenAI',
        );
        return finalQuestions;
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
          (word) => '''
- Word: ${word.word}
  Definition: ${word.definition}
  Example: ${word.example ?? "N/A"}
  Phonetic: ${word.phonetic ?? "N/A"}
  Level: ${word.level?.name ?? "intermediate"}
  Favorite: ${word.isFavorite ?? false ? "User favorite" : "Regular word"}''',
        )
        .join('\n');
  }

  /// Builds the prompt for OpenAI
  String _buildPrompt(String wordDetails, int wordCount) {
    return '''

TASK: Create a high-quality vocabulary assessment with $wordCount sentence completion questions.

VOCABULARY WORDS:
$wordDetails

ASSESSMENT OBJECTIVES:
- Test genuine understanding of word meanings in context
- Evaluate ability to distinguish between similar concepts
- Assess contextual usage comprehension
- Ensure appropriate cognitive challenge

QUESTION GENERATION GUIDELINES:

1. SENTENCE CONSTRUCTION:
   - Use varied sentence structures (simple, compound, complex)
   - Maintain 8th-12th grade reading level
   - Provide sufficient context clues without making answers obvious
   - Ensure sentences are authentic and naturally flowing
   - Avoid overly academic or artificial language

2. CONTEXT VARIETY:
   - Academic contexts (25%): scholarly discussions, research, education
   - Professional/workplace scenarios (25%): business, career, industry
   - Everyday situations (25%): daily life, relationships, common experiences
   - Literary/descriptive passages (25%): creative writing, descriptive scenes

3. DISTRACTOR CREATION STRATEGY:
   - Include words from similar semantic fields or categories
   - Use words with overlapping but distinct meanings
   - Ensure distractors are grammatically correct in context
   - Make distractors plausible to someone with partial understanding
   - Avoid synonyms that would also be correct in context
   - Consider words that might be confused due to similar spelling/sound

4. DIFFICULTY CALIBRATION:
   - Beginner level: Simple contexts with clear contextual clues
   - Intermediate level: Moderate complexity requiring some inference
   - Advanced level: Complex contexts requiring nuanced understanding
   - Ensure questions require understanding, not just recognition
   - Balance between too easy and impossibly difficult

5. QUALITY VALIDATION:
   - Each sentence must make logical sense with only one answer
   - Verify that context supports the correct answer uniquely
   - Ensure distractors don't create valid alternative meanings
   - Check for cultural bias or overly specific knowledge requirements
   - Avoid trick questions or overly technical terminology

STRICT OUTPUT FORMAT:
{
  "questions": [
    {
      "question_id": "1",
      "question": "The scientist's ___ research methodology yielded groundbreaking results in the field.",
      "options": ["meticulous", "cursory", "erratic"],
      "correct_answer": "meticulous"
    }
  ]
}

CRITICAL REQUIREMENTS:
1. Each sentence MUST contain exactly one blank (___)
2. The blank must be positioned where the target word naturally fits
3. Context must provide enough information to determine the correct answer
4. All three options must be grammatically correct in the sentence
5. Only ONE option should create a logically coherent sentence
6. Generate exactly $wordCount questions, one per vocabulary word
7. Ensure perfect JSON formatting with no syntax errors
8. The correct answer must be the exact vocabulary word from the provided list

DISTRACTOR SELECTION STRATEGIES:
- For adjectives: Use contrasting qualities or intensities
- For verbs: Use actions with different implications or outcomes
- For nouns: Use items from related categories with distinct characteristics
- For adverbs: Use words that modify actions differently

CONTEXT CLUES GUIDELINES:
- Provide enough context to distinguish between similar words
- Include consequences, causes, or descriptions that point to the correct answer
- Use surrounding words that create logical relationships
- Avoid giving away the answer through direct synonyms in the context

AVOID:
- Overly obvious context clues that make other options impossible
- Distractors that are completely unrelated to the correct answer
- Sentences that work logically with multiple answer choices
- Cultural references or specialized knowledge requirements
- Grammatically awkward or forced sentence constructions
- Using the exact definition words in the sentence context
- Making the correct answer too obvious through process of elimination

ENSURE EACH QUESTION:
- Tests actual vocabulary knowledge, not just basic reading comprehension
- Requires understanding of subtle differences between word meanings
- Provides a meaningful, realistic context for word usage
- Challenges the user appropriately without being unfair
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

        // Convert to PracticeQuizQuestion objects and validate
        final validQuestions = <PracticeQuizQuestion>[];

        for (final item in questionsJson) {
          try {
            final question =
                PracticeQuizQuestion.fromJson(item as Map<String, dynamic>);

            // Validate question quality
            if (_validateQuestionQuality(question)) {
              question.options.shuffle(); // Shuffle options for each question
              validQuestions.add(question);
            } else {
              logger.w('Question failed validation: ${question.question}');
            }
          } catch (e) {
            logger.e('Error parsing question: $e\nQuestion data: $item');
            // Continue with other questions rather than failing completely
          }
        }

        if (validQuestions.isEmpty) {
          throw Exception('No valid questions generated from OpenAI response');
        }

        logger.i(
          'Successfully validated ${validQuestions.length} out of '
          '${questionsJson.length} questions',
        );
        return validQuestions;
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

  /// Validates the quality of a generated quiz question
  bool _validateQuestionQuality(PracticeQuizQuestion question) {
    // Check if question contains exactly one blank
    if (!_hasExactlyOneBlank(question.question)) {
      logger.w('Question validation failed: incorrect number of blanks');
      return false;
    }

    // Verify correct answer is in options
    if (!question.options.contains(question.correctAnswer)) {
      logger.w('Question validation failed: correct answer not in options');
      return false;
    }

    // Ensure options are unique
    if (question.options.toSet().length != question.options.length) {
      logger.w('Question validation failed: duplicate options');
      return false;
    }

    // Check if question has exactly 3 options
    if (question.options.length != 3) {
      logger.w('Question validation failed: incorrect number of options');
      return false;
    }

    // Validate question length (not too short or too long)
    if (!_isValidQuestionLength(question.question)) {
      logger.w('Question validation failed: invalid question length');
      return false;
    }

    // Check for obvious quality issues
    if (_hasObviousQualityIssues(question)) {
      logger.w('Question validation failed: quality issues detected');
      return false;
    }

    return true;
  }

  /// Checks if question contains exactly one blank
  bool _hasExactlyOneBlank(String question) {
    final blankCount = '___'.allMatches(question).length;
    return blankCount == 1;
  }

  /// Validates question length is appropriate
  bool _isValidQuestionLength(String question) {
    final wordCount = question.split(' ').length;
    return wordCount >= 5 && wordCount <= 30; // Reasonable sentence length
  }

  /// Checks for obvious quality issues in the question
  bool _hasObviousQualityIssues(PracticeQuizQuestion question) {
    final questionLower = question.question.toLowerCase();
    final correctAnswerLower = question.correctAnswer.toLowerCase();

    // Check if the question contains the correct answer
    // (avoiding obvious hints)
    if (questionLower.contains(correctAnswerLower) &&
        correctAnswerLower.length > 3) {
      return true;
    }

    // Check if any option appears directly in the question text
    for (final option in question.options) {
      if (option.toLowerCase() != correctAnswerLower &&
          questionLower.contains(option.toLowerCase()) &&
          option.length > 3) {
        return true;
      }
    }

    // Check for overly short options (likely low quality)
    if (question.options.any((option) => option.length < 2)) {
      return true;
    }

    // Check for suspiciously similar options
    if (_hasSuspiciouslySimilarOptions(question.options)) {
      return true;
    }

    return false;
  }

  /// Checks if options are too similar to each other
  bool _hasSuspiciouslySimilarOptions(List<String> options) {
    for (var i = 0; i < options.length; i++) {
      for (var j = i + 1; j < options.length; j++) {
        // Check if two options are very similar
        if (_calculateSimilarity(options[i], options[j]) > 0.8) {
          return true;
        }
      }
    }
    return false;
  }

  /// Calculates similarity between two strings (basic implementation)
  double _calculateSimilarity(String str1, String str2) {
    if (str1 == str2) return 1;

    final longer = str1.length > str2.length ? str1 : str2;
    final shorter = str1.length > str2.length ? str2 : str1;

    if (longer.isEmpty) return 1;

    final editDistance = _calculateEditDistance(longer, shorter);
    return (longer.length - editDistance) / longer.length;
  }

  /// Calculates edit distance between two strings
  int _calculateEditDistance(String str1, String str2) {
    final matrix = List.generate(
      str1.length + 1,
      (i) => List.generate(str2.length + 1, (j) => 0),
    );

    for (var i = 0; i <= str1.length; i++) {
      matrix[i][0] = i;
    }

    for (var j = 0; j <= str2.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= str1.length; i++) {
      for (var j = 1; j <= str2.length; j++) {
        final cost = str1[i - 1] == str2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[str1.length][str2.length];
  }

  /// Applies fallback mechanism to ensure adequate question quantity
  /// while maintaining quality standards
  List<PracticeQuizQuestion> _applyFallbackMechanism(
    List<PracticeQuizQuestion> validatedQuestions,
    int targetQuestionCount,
  ) {
    // If we have enough validated questions, return them
    if (validatedQuestions.length >= (targetQuestionCount * 0.8).round()) {
      logger.i(
        'Sufficient validated questions available: '
        '${validatedQuestions.length}',
      );
      return validatedQuestions;
    }

    // If we have too few validated questions, log warning but return
    // what we have
    // This prevents complete failure due to overly strict validation
    if (validatedQuestions.isNotEmpty) {
      logger.w(
        'Only ${validatedQuestions.length} out of $targetQuestionCount '
        'questions passed validation. Returning available questions.',
      );
      return validatedQuestions;
    }

    // If no questions passed validation, this indicates a serious issue
    logger
        .e('No questions passed validation - this may indicate prompt issues');
    return validatedQuestions; // Return empty list, let caller handle
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
