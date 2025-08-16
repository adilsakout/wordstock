import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/model/english_test_question.dart';

/// {@template english_test_repository}
/// Repository for managing English test questions from JSON asset files.
///
/// This repository handles:
/// - Loading question sets from JSON files based on difficulty level
/// - Caching loaded questions for performance
/// - Providing randomized question subsets for tests
/// - Following clean architecture principles with proper error handling
/// {@endtemplate}
class EnglishTestRepository {
  /// {@macro english_test_repository}
  const EnglishTestRepository();

  // Cache for loaded question sets to avoid repeated file reads
  static final Map<String, EnglishTestQuestionSet> _questionCache = {};

  /// Loads questions for the specified vocabulary level.
  ///
  /// Returns a randomized subset of 5 questions from the appropriate
  /// difficulty level. Falls back to intermediate level for invalid inputs.
  ///
  /// Throws [Exception] if the JSON file cannot be loaded or parsed.
  Future<List<EnglishTestQuestion>> getQuestionsForLevel(int levelId) async {
    try {
      // Determine the appropriate question set based on level
      final questionSet = await _getQuestionSetForLevel(levelId);

      // Return a randomized subset of 5 questions
      return _getRandomQuestions(questionSet.questions, 5);
    } catch (e) {
      throw Exception('Failed to load English test questions: $e');
    }
  }

  /// Loads all questions for the specified vocabulary level.
  ///
  /// Returns the complete question set without randomization.
  /// Useful for displaying all available questions or analytics.
  Future<EnglishTestQuestionSet> getAllQuestionsForLevel(int levelId) async {
    try {
      return await _getQuestionSetForLevel(levelId);
    } catch (e) {
      throw Exception('Failed to load English test question set: $e');
    }
  }

  /// Internal method to get the question set for a specific level.
  ///
  /// Uses caching to avoid repeated file system access.
  /// Maps vocabulary level IDs to appropriate JSON asset files.
  Future<EnglishTestQuestionSet> _getQuestionSetForLevel(int levelId) async {
    // Determine the asset path based on vocabulary level
    String assetPath;
    String cacheKey;

    if (VocabularyLevels.isValidId(levelId)) {
      switch (levelId) {
        case 0: // Beginner
          assetPath = 'assets/data/english_test_beginner.json';
          cacheKey = 'beginner';
        case 1: // Intermediate
          assetPath = 'assets/data/english_test_intermediate.json';
          cacheKey = 'intermediate';
        case 2: // Advanced
          assetPath = 'assets/data/english_test_advanced.json';
          cacheKey = 'advanced';
        default:
          // Should not reach here due to isValidId check, but fallback to
          // intermediate
          assetPath = 'assets/data/english_test_intermediate.json';
          cacheKey = 'intermediate';
      }
    } else {
      // Invalid level ID - default to intermediate
      assetPath = 'assets/data/english_test_intermediate.json';
      cacheKey = 'intermediate';
    }

    // Check cache first to avoid repeated file reads
    if (_questionCache.containsKey(cacheKey)) {
      return _questionCache[cacheKey]!;
    }

    // Load and parse the JSON file
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final questionSet = EnglishTestQuestionSet.fromJson(jsonData);

    // Cache the result for future use
    _questionCache[cacheKey] = questionSet;

    return questionSet;
  }

  /// Returns a random subset of questions from the provided list.
  ///
  /// If the requested count is greater than available questions,
  /// returns all available questions.
  List<EnglishTestQuestion> _getRandomQuestions(
    List<EnglishTestQuestion> allQuestions,
    int count,
  ) {
    if (count >= allQuestions.length) {
      // If requesting more questions than available, return all shuffled
      final shuffled = List<EnglishTestQuestion>.from(allQuestions)
        ..shuffle(math.Random());
      return shuffled;
    }

    // Shuffle and take the requested number of questions
    final shuffled = List<EnglishTestQuestion>.from(allQuestions)
      ..shuffle(math.Random());
    return shuffled.take(count).toList();
  }

  /// Clears the question cache.
  ///
  /// Useful for testing or if you need to reload questions from disk.
  static void clearCache() {
    _questionCache.clear();
  }
}
