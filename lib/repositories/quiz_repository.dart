import 'dart:async';
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
        _userId = SupabaseRepository.client.auth.currentUser?.id ?? '';

  final SupabaseClient _supabase;
  final String _userId;
  final Logger logger = Logger();

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

  /// Generates a quiz using AI based on provided vocabulary words.
  ///
  /// Routes through the Supabase `chat-completion` Edge Function so the
  /// OpenAI API key stays server-side.
  Future<List<PracticeQuizQuestion>> getQuizFromOpenAI({
    required List<Word> words,
    int retryCount = 0,
  }) async {
    if (words.isEmpty) {
      logger.w('No words provided for quiz generation');
      throw Exception('No vocabulary words provided for quiz generation');
    }

    final stopwatch = Stopwatch()..start();
    logger.i('Starting AI quiz generation for ${words.length} words');

    try {
      final wordDetails = _formatWordDetails(words);
      final prompt = _buildPrompt(wordDetails, words.length);

      final requestPrepTime = stopwatch.elapsedMilliseconds;
      logger.d('Request preparation completed in ${requestPrepTime}ms');

      // Call Edge Function instead of direct OpenAI
      final content = await _callEdgeFunction(
        systemMessage:
            'You are an expert language teacher creating vocabulary '
            'quizzes.',
        userMessage: prompt,
        maxTokens: 2000,
        temperature: 0.6,
      );

      final apiResponseTime = stopwatch.elapsedMilliseconds - requestPrepTime;
      logger.i('AI API responded in ${apiResponseTime}ms');

      final questions = _processContent(content);

      stopwatch.stop();
      _logPerformanceMetrics(
        stopwatch.elapsedMilliseconds,
        requestPrepTime,
        apiResponseTime,
      );

      // Apply fallback mechanism for quality vs quantity balance
      final finalQuestions = _applyFallbackMechanism(
        questions,
        words.length,
      );

      if (finalQuestions.isNotEmpty) {
        logger.i(
          'Successfully generated ${finalQuestions.length} questions',
        );
        return finalQuestions;
      } else {
        throw Exception('Generated quiz contained no questions');
      }
    } catch (e) {
      stopwatch.stop();
      logger.e('Error generating quiz from AI: $e');

      // Implement retry logic for recoverable errors
      if (retryCount < _maxQuizGenerationRetries) {
        logger.w('Retrying quiz generation (attempt ${retryCount + 1})');
        return getQuizFromOpenAI(
          words: words,
          retryCount: retryCount + 1,
        );
      }

      rethrow;
    }
  }

  /// Calls the Supabase `chat-completion` Edge Function.
  Future<String> _callEdgeFunction({
    required String systemMessage,
    required String userMessage,
    int? maxTokens,
    double? temperature,
  }) async {
    final response = await SupabaseRepository.client.functions
        .invoke(
          'chat-completion',
          body: {
            'messages': [
              {'role': 'system', 'content': systemMessage},
              {'role': 'user', 'content': userMessage},
            ],
            if (maxTokens != null) 'max_tokens': maxTokens,
            if (temperature != null) 'temperature': temperature,
          },
        )
        .timeout(const Duration(seconds: 60));

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

  /// Formats word details for the prompt
  String _formatWordDetails(List<Word> words) {
    return words
        .map(
          (word) => '''
- ID: ${word.id}
  Word: ${word.word}
  Definition: ${word.definition}
  Example: ${word.example ?? "N/A"}
  Phonetic: ${word.phonetic ?? "N/A"}
  Level: ${word.level?.name ?? "intermediate"}
  Favorite: ${word.isFavorite ?? false ? "User favorite" : "Regular word"}''',
        )
        .join('\n');
  }

  /// Builds the prompt for quiz generation
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
      "word_id": "<exact ID from the vocabulary word above>",
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
9. The word_id field MUST be the exact ID string from the vocabulary word's "ID:" field above

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

  /// Processes the AI response content and converts to quiz questions
  List<PracticeQuizQuestion> _processContent(String content) {
    try {
      // Extract JSON from content (might be wrapped in markdown code blocks)
      final jsonMatch = RegExp(r'{[\s\S]*}').firstMatch(content);
      if (jsonMatch == null) {
        logger.e(
          'Failed to extract JSON from AI response: $content',
        );
        throw Exception('Invalid response format from AI');
      }

      final jsonStr = jsonMatch.group(0) ?? '{}';
      final parsedData = jsonDecode(jsonStr);

      return _extractQuestionsFromParsedData(parsedData);
    } catch (e) {
      logger.e('Error processing AI response: $e');
      throw Exception('Failed to process AI response: $e');
    }
  }

  /// Extracts questions from parsed JSON data
  List<PracticeQuizQuestion> _extractQuestionsFromParsedData(
    dynamic parsedData,
  ) {
    if (parsedData is Map && parsedData.containsKey('questions')) {
      final questionsData = parsedData['questions'];

      if (questionsData is List) {
        final questionsJson = questionsData;
        logger.d('Found ${questionsJson.length} questions in response');

        final validQuestions = <PracticeQuizQuestion>[];

        for (final item in questionsJson) {
          try {
            final question =
                PracticeQuizQuestion.fromJson(item as Map<String, dynamic>);

            if (_validateQuestionQuality(question)) {
              question.options.shuffle();
              validQuestions.add(question);
            } else {
              logger.w(
                'Question failed validation: ${question.question}',
              );
            }
          } catch (e) {
            logger.e(
              'Error parsing question: $e\nQuestion data: $item',
            );
          }
        }

        if (validQuestions.isEmpty) {
          throw Exception(
            'No valid questions generated from AI response',
          );
        }

        logger.i(
          'Successfully validated ${validQuestions.length} out of '
          '${questionsJson.length} questions',
        );
        return validQuestions;
      } else {
        logger.e(
          'The "questions" field is not a list: '
          '${questionsData.runtimeType}',
        );
        throw Exception(
          'Invalid response format: questions field is not a list',
        );
      }
    } else {
      logger.e(
        'Response missing "questions" key or not a map: $parsedData',
      );
      throw Exception(
        'Invalid response format: missing questions field',
      );
    }
  }

  /// Validates the quality of a generated quiz question
  bool _validateQuestionQuality(PracticeQuizQuestion question) {
    if (!_hasExactlyOneBlank(question.question)) {
      logger.w('Question validation failed: incorrect number of blanks');
      return false;
    }

    if (!question.options.contains(question.correctAnswer)) {
      logger.w(
        'Question validation failed: correct answer not in options',
      );
      return false;
    }

    if (question.options.toSet().length != question.options.length) {
      logger.w('Question validation failed: duplicate options');
      return false;
    }

    if (question.options.length != 3) {
      logger.w(
        'Question validation failed: incorrect number of options',
      );
      return false;
    }

    if (!_isValidQuestionLength(question.question)) {
      logger.w('Question validation failed: invalid question length');
      return false;
    }

    if (_hasObviousQualityIssues(question)) {
      logger.w('Question validation failed: quality issues detected');
      return false;
    }

    return true;
  }

  bool _hasExactlyOneBlank(String question) {
    final blankCount = '___'.allMatches(question).length;
    return blankCount == 1;
  }

  bool _isValidQuestionLength(String question) {
    final wordCount = question.split(' ').length;
    return wordCount >= 5 && wordCount <= 30;
  }

  bool _hasObviousQualityIssues(PracticeQuizQuestion question) {
    final questionLower = question.question.toLowerCase();
    final correctAnswerLower = question.correctAnswer.toLowerCase();

    if (questionLower.contains(correctAnswerLower) &&
        correctAnswerLower.length > 3) {
      return true;
    }

    for (final option in question.options) {
      if (option.toLowerCase() != correctAnswerLower &&
          questionLower.contains(option.toLowerCase()) &&
          option.length > 3) {
        return true;
      }
    }

    if (question.options.any((option) => option.length < 2)) {
      return true;
    }

    if (_hasSuspiciouslySimilarOptions(question.options)) {
      return true;
    }

    return false;
  }

  bool _hasSuspiciouslySimilarOptions(List<String> options) {
    for (var i = 0; i < options.length; i++) {
      for (var j = i + 1; j < options.length; j++) {
        if (_calculateSimilarity(options[i], options[j]) > 0.8) {
          return true;
        }
      }
    }
    return false;
  }

  double _calculateSimilarity(String str1, String str2) {
    if (str1 == str2) return 1;

    final longer = str1.length > str2.length ? str1 : str2;
    final shorter = str1.length > str2.length ? str2 : str1;

    if (longer.isEmpty) return 1;

    final editDistance = _calculateEditDistance(longer, shorter);
    return (longer.length - editDistance) / longer.length;
  }

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

  List<PracticeQuizQuestion> _applyFallbackMechanism(
    List<PracticeQuizQuestion> validatedQuestions,
    int targetQuestionCount,
  ) {
    if (validatedQuestions.length >=
        (targetQuestionCount * 0.8).round()) {
      logger.i(
        'Sufficient validated questions available: '
        '${validatedQuestions.length}',
      );
      return validatedQuestions;
    }

    if (validatedQuestions.isNotEmpty) {
      logger.w(
        'Only ${validatedQuestions.length} out of $targetQuestionCount '
        'questions passed validation. Returning available questions.',
      );
      return validatedQuestions;
    }

    logger.e(
      'No questions passed validation - '
      'this may indicate prompt issues',
    );
    return validatedQuestions;
  }

  void _logPerformanceMetrics(
    int totalTime,
    int requestPrepTime,
    int apiResponseTime,
  ) {
    final processingTime = totalTime - requestPrepTime - apiResponseTime;

    logger
      ..i('Performance metrics for AI quiz generation:')
      ..i('- Request preparation: ${requestPrepTime}ms')
      ..i('- API response time: ${apiResponseTime}ms')
      ..i('- Response processing: ${processingTime}ms')
      ..i('- Total time: ${totalTime}ms');
  }

  /// Streams quiz questions from the AI one-by-one as they are generated.
  ///
  /// Uses the SSE streaming endpoint so the first question is yielded after
  /// ~1-2 seconds instead of waiting for the full 5-15 second batch.
  Stream<PracticeQuizQuestion> getQuizFromOpenAIStream({
    required List<Word> words,
  }) async* {
    if (words.isEmpty) return;

    final wordDetails = _formatWordDetails(words);
    final prompt = _buildPrompt(wordDetails, words.length);

    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    final authToken =
        SupabaseRepository.client.auth.currentSession?.accessToken ?? anonKey;

    final uri = Uri.parse('$supabaseUrl/functions/v1/chat-completion');
    final body = jsonEncode({
      'stream': true,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are an expert language teacher creating vocabulary quizzes.',
        },
        {'role': 'user', 'content': prompt},
      ],
      'max_tokens': 2000,
      'temperature': 0.6,
    });

    final client = http.Client();
    try {
      final request = http.Request('POST', uri)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $authToken'
        ..headers['apikey'] = anonKey
        ..body = body;

      final streamedResponse =
          await client.send(request).timeout(const Duration(seconds: 90));

      if (streamedResponse.statusCode != 200) {
        throw Exception(
          'Edge function returned status ${streamedResponse.statusCode}',
        );
      }

      final contentBuffer = StringBuffer();
      var extractedCount = 0;

      await for (final line in streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (!line.startsWith('data: ')) continue;

        final data = line.substring(6).trim();
        if (data == '[DONE]') break;
        if (data.isEmpty) continue;

        try {
          final chunkJson = jsonDecode(data) as Map<String, dynamic>;
          final choices = chunkJson['choices'] as List?;
          if (choices == null || choices.isEmpty) continue;

          final delta =
              (choices[0] as Map<String, dynamic>)['delta']
                  as Map<String, dynamic>?;
          final content = delta?['content'] as String?;
          if (content == null || content.isEmpty) continue;

          contentBuffer.write(content);

          final newQuestions = _parseNewQuestionsFromBuffer(
            contentBuffer.toString(),
            extractedCount,
          );

          for (final q in newQuestions) {
            extractedCount++;
            yield q;
          }
        } catch (_) {
          // Skip malformed SSE chunks
        }
      }

      // Final pass — catch any remaining complete questions in the buffer
      final remaining = _parseNewQuestionsFromBuffer(
        contentBuffer.toString(),
        extractedCount,
      );
      for (final q in remaining) {
        yield q;
      }
    } finally {
      client.close();
    }
  }

  /// Parses complete question JSON objects from a partial JSON buffer.
  ///
  /// Uses bracket-depth tracking to find complete `{...}` objects inside the
  /// `"questions": [...]` array without needing the outer JSON to be complete.
  /// Returns only objects after [alreadyExtracted] (so we never re-yield).
  List<PracticeQuizQuestion> _parseNewQuestionsFromBuffer(
    String content,
    int alreadyExtracted,
  ) {
    final questionsKeyIdx = content.indexOf('"questions"');
    if (questionsKeyIdx == -1) return [];

    final bracketIdx = content.indexOf('[', questionsKeyIdx);
    if (bracketIdx == -1) return [];

    final results = <PracticeQuizQuestion>[];
    var pos = bracketIdx + 1;
    var objectCount = 0;

    while (pos < content.length) {
      // Skip whitespace and commas
      while (pos < content.length) {
        final c = content[pos];
        if (c == ' ' || c == '\n' || c == '\r' || c == '\t' || c == ',') {
          pos++;
        } else {
          break;
        }
      }

      if (pos >= content.length) break;
      if (content[pos] == ']') break;
      if (content[pos] != '{') break;

      // Walk the object using depth tracking, respecting strings
      final objStart = pos;
      var depth = 0;
      var inString = false;
      var escaped = false;

      while (pos < content.length) {
        final c = content[pos];
        if (escaped) {
          escaped = false;
        } else if (inString) {
          if (c == r'\') {
            escaped = true;
          } else if (c == '"') {
            inString = false;
          }
        } else {
          if (c == '"') {
            inString = true;
          } else if (c == '{') {
            depth++;
          } else if (c == '}') {
            depth--;
            if (depth == 0) {
              pos++;
              break;
            }
          }
        }
        pos++;
      }

      if (depth != 0) break; // Incomplete object — stop parsing

      objectCount++;

      if (objectCount > alreadyExtracted) {
        final objStr = content.substring(objStart, pos);
        try {
          final jsonMap = jsonDecode(objStr) as Map<String, dynamic>;
          final question = PracticeQuizQuestion.fromJson(jsonMap);
          if (_validateQuestionQuality(question)) {
            question.options.shuffle();
            results.add(question);
          }
        } catch (_) {
          // Skip questions that fail parsing or validation
        }
      }
    }

    return results;
  }

  /// Saves a completed practice session to the database.
  Future<void> savePracticeSession({
    required int totalQuestions,
    required int correctAnswers,
    required String mode,
  }) async {
    if (totalQuestions <= 0) return;
    final scorePercent =
        (correctAnswers / totalQuestions * 100).clamp(0, 100).toDouble();
    try {
      await _supabase.from('practice_sessions').insert({
        'user_id': _userId,
        'total_questions': totalQuestions,
        'correct_answers': correctAnswers,
        'score_percent': scorePercent,
        'mode': mode,
      });
    } catch (e) {
      logger.e('Failed to save practice session: $e');
    }
  }

  /// Returns practice sessions for the current user over the last [days] days.
  Future<List<PracticeSession>> getPracticeHistory({int days = 14}) async {
    try {
      final since =
          DateTime.now().subtract(Duration(days: days)).toIso8601String();
      final response = await _supabase
          .from('practice_sessions')
          .select()
          .eq('user_id', _userId)
          .gte('completed_at', since)
          .order('completed_at');

      return (response as List<dynamic>)
          .map(
            (json) =>
                PracticeSession.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      logger.e('Failed to fetch practice history: $e');
      return [];
    }
  }

  /// Disposes resources
  void dispose() {
    // No HTTP client to clean up — Supabase client is managed globally
  }
}
