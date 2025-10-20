import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/model/models.dart';

/// {@template word_definitions_repository}
/// Repository for managing word definitions from JSON asset files.
///
/// This repository handles:
/// - Loading word definitions from JSON files based on difficulty level
/// - Caching loaded definitions for performance
/// - Providing quick lookup for word definitions
/// - Following clean architecture principles with proper error handling
///
/// The repository loads definitions for vocabulary words used in English tests
/// and other learning features, organizing them by difficulty level.
/// {@endtemplate}
class WordDefinitionsRepository {
  /// {@macro word_definitions_repository}
  const WordDefinitionsRepository();

  // Cache for loaded definition sets to avoid repeated file reads
  static final Map<String, WordDefinitionSet> _definitionCache = {};

  /// Gets the definition for a specific word.
  ///
  /// First attempts to find the word in all cached definition sets.
  /// If not found in cache, loads definitions for all levels and searches.
  /// Returns a default message if the word is not found.
  ///
  /// [word] - The word to get the definition for (case-insensitive)
  ///
  /// Returns the definition string or a default message if not found.
  Future<String> getDefinitionForWord(String word) async {
    try {
      final normalizedWord = word.toLowerCase().trim();

      // Check if we already have the word in any cached definition set
      for (final definitionSet in _definitionCache.values) {
        final definition = definitionSet.definitions
            .where((def) => def.word.toLowerCase() == normalizedWord)
            .firstOrNull;
        if (definition != null) {
          return definition.definition;
        }
      }

      // If not found in cache, load all definition sets and search
      await _loadAllDefinitionSets();

      // Search again in the newly loaded cache
      for (final definitionSet in _definitionCache.values) {
        final definition = definitionSet.definitions
            .where((def) => def.word.toLowerCase() == normalizedWord)
            .firstOrNull;
        if (definition != null) {
          return definition.definition;
        }
      }

      // Word not found in any definition set
      log('Definition not found for word: $word');
      return 'a valuable word to learn';
    } catch (e) {
      log('Error getting definition for word $word: $e');
      return 'a valuable word to learn';
    }
  }

  /// Gets all definitions for a specific vocabulary level.
  ///
  /// Loads and caches definitions for the specified level if not already
  /// cached.
  /// Maps vocabulary level IDs to appropriate JSON asset files.
  ///
  /// [levelId] - The vocabulary level ID (0=beginner, 1=intermediate,
  /// 2=advanced)
  ///
  /// Returns a [WordDefinitionSet] for the specified level.
  /// Throws [Exception] if the definitions cannot be loaded.
  Future<WordDefinitionSet> getDefinitionsForLevel(int levelId) async {
    try {
      return await _getDefinitionSetForLevel(levelId);
    } catch (e) {
      throw Exception('Failed to load word definitions for level $levelId: $e');
    }
  }

  /// Gets all definitions across all vocabulary levels.
  ///
  /// Loads definitions for all levels and returns them as a combined map
  /// where keys are words (lowercase) and values are definitions.
  ///
  /// Returns a Map<String, String> of all word definitions.
  Future<Map<String, String>> getAllDefinitions() async {
    try {
      await _loadAllDefinitionSets();

      final allDefinitions = <String, String>{};

      for (final definitionSet in _definitionCache.values) {
        for (final definition in definitionSet.definitions) {
          allDefinitions[definition.word.toLowerCase()] = definition.definition;
        }
      }

      return allDefinitions;
    } catch (e) {
      throw Exception('Failed to load all word definitions: $e');
    }
  }

  /// Internal method to get the definition set for a specific level.
  ///
  /// Uses caching to avoid repeated file system access.
  /// Maps vocabulary level IDs to appropriate JSON asset files.
  Future<WordDefinitionSet> _getDefinitionSetForLevel(int levelId) async {
    // Determine the asset path based on vocabulary level
    String assetPath;
    String cacheKey;

    if (VocabularyLevels.isValidId(levelId)) {
      switch (levelId) {
        case 0: // Beginner
          assetPath = 'assets/data/word_definitions_beginner.json';
          cacheKey = 'beginner';
        case 1: // Intermediate
          assetPath = 'assets/data/word_definitions_intermediate.json';
          cacheKey = 'intermediate';
        case 2: // Advanced
          assetPath = 'assets/data/word_definitions_advanced.json';
          cacheKey = 'advanced';
        default:
          // Should not reach here due to isValidId check, but fallback to
          // intermediate
          assetPath = 'assets/data/word_definitions_intermediate.json';
          cacheKey = 'intermediate';
      }
    } else {
      // Invalid level ID - default to intermediate
      assetPath = 'assets/data/word_definitions_intermediate.json';
      cacheKey = 'intermediate';
    }

    // Check cache first to avoid repeated file reads
    if (_definitionCache.containsKey(cacheKey)) {
      return _definitionCache[cacheKey]!;
    }

    // Load and parse the JSON file
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final definitionSet = WordDefinitionSet.fromJson(jsonData);

    // Cache the result for future use
    _definitionCache[cacheKey] = definitionSet;

    log('Loaded ${definitionSet.definitions.length} definitions for level: '
        '${definitionSet.level}');
    return definitionSet;
  }

  /// Loads definition sets for all vocabulary levels into cache.
  ///
  /// This method loads definitions for beginner, intermediate, and advanced
  /// levels to populate the cache for fast lookups.
  Future<void> _loadAllDefinitionSets() async {
    // Load all levels concurrently for better performance
    await Future.wait([
      _getDefinitionSetForLevel(0), // Beginner
      _getDefinitionSetForLevel(1), // Intermediate
      _getDefinitionSetForLevel(2), // Advanced
    ]);
  }

  /// Clears the definition cache.
  ///
  /// Useful for testing or if you need to reload definitions from disk.
  static void clearCache() {
    _definitionCache.clear();
  }

  /// Gets a random encouraging message for vocabulary learning.
  ///
  /// Returns one of several motivational messages to encourage
  /// users during their vocabulary learning journey.
  String getEncouragingMessage(String word) {
    final encouragingMessages = [
      'Every expert was once a beginner! 🌟',
      'Learning is a journey, not a destination! 🚀',
      "You're expanding your vocabulary universe! 🌌",
      'Knowledge is power - keep building yours! 💪',
      'Every new word is a new superpower! ⚡',
      "You're one step closer to mastery! 🎯",
      'Great minds learn from every experience! 🧠',
      'Your curiosity is your greatest strength! 🔍',
      'Building vocabulary, building confidence! 💎',
      'Learning never stops, and neither do you! 🌊',
    ];

    return encouragingMessages[word.hashCode % encouragingMessages.length];
  }
}
