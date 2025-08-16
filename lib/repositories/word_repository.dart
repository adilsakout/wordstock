import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/repositories/supabase_repository.dart';

class WordRepository {
  WordRepository() : _supabase = SupabaseRepository.client;
  final SupabaseClient _supabase;

  String _getUserId() {
    return _supabase.auth.currentUser?.id ?? '';
  }

  /// Helper method to convert integer vocabulary level to string level
  /// Maps database integer values to words table string values
  /// 0 -> "beginner", 1 -> "intermediate", 2 -> "advanced"
  String _vocabularyLevelToString(int levelId) {
    final config = VocabularyLevels.getById(levelId);
    if (config != null) {
      return config.displayName.toLowerCase();
    }
    // Default fallback to intermediate if invalid level
    return 'intermediate';
  }

  /// Get user's vocabulary level from user_profiles table
  /// Returns the string representation of the user's vocabulary level
  Future<String> _getUserVocabularyLevel() async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('vocabulary_level')
          .eq('user_id', _getUserId())
          .maybeSingle();

      if (response != null && response['vocabulary_level'] != null) {
        final levelId = response['vocabulary_level'] as int;
        return _vocabularyLevelToString(levelId);
      }

      // Default to intermediate if user has no vocabulary level set
      return 'intermediate';
    } catch (e) {
      log('Error getting user vocabulary level: $e');
      // Default to intermediate on error
      return 'intermediate';
    }
  }

  // ================== Core Word Operations ================== //

  /// Get words filtered by user's vocabulary level
  /// Automatically filters words based on the user's selected vocabulary level
  /// from their profile (beginner, intermediate, or advanced)
  Future<List<Word>> getWords({
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      // Get the user's vocabulary level from their profile
      final userVocabularyLevel = await _getUserVocabularyLevel();

      log('Filtering words for vocabulary level: $userVocabularyLevel');

      // Query words filtered by the user's vocabulary level
      final response = await _supabase
          .from('words')
          .select('''
      id,
      word,
      definition,
      example,
      level,
      phonetic,
      synonyms,
      user_favorites!left(user_id, word_id)
    ''')
          .eq('level', userVocabularyLevel) // Filter by user's vocabulary level
          .eq('user_favorites.user_id', _getUserId())
          .range(page * pageSize, (page + 1) * pageSize - 1); // Add pagination

      final words = response.map((json) {
        final isFavorite =
            (json['user_favorites'] as List<dynamic>?)?.isNotEmpty ?? false;

        return Word.fromJson({...json, 'isFavorite': isFavorite});
      }).toList()
        ..shuffle();

      log('Loaded ${words.length} words for level: $userVocabularyLevel');
      return words;
    } catch (e) {
      log('Error in getWords: $e');
      throw Exception('Failed to load words: $e');
    }
  }

  /// Get words for a specific vocabulary level
  /// Useful for testing different levels or admin functionality
  Future<List<Word>> getWordsForLevel({
    required String level,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      log('Filtering words for vocabulary level: $level');

      // Query words filtered by the specified vocabulary level
      final response = await _supabase
          .from('words')
          .select('''
      id,
      word,
      definition,
      example,
      level,
      phonetic,
      synonyms,
      user_favorites!left(user_id, word_id)
    ''')
          .eq('level', level) // Filter by vocabulary level
          .eq('user_favorites.user_id', _getUserId())
          .range(page * pageSize, (page + 1) * pageSize - 1); // Add pagination

      final words = response.map((json) {
        final isFavorite =
            (json['user_favorites'] as List<dynamic>?)?.isNotEmpty ?? false;

        return Word.fromJson({...json, 'isFavorite': isFavorite});
      }).toList()
        ..shuffle();

      log('Loaded ${words.length} words for level: $level');
      return words;
    } catch (e) {
      log('Error loading words for level $level: $e');
      throw Exception('Failed to load words for level $level: $e');
    }
  }

  Future<List<Word>> getQuizWords() async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_words_in_order',
        params: {
          'user_id_param': _getUserId(),
          'total_questions': 10,
        },
      );

      log('response: $response');

      final words = (response as List<dynamic>)
          .map((dynamic json) => Word.fromJson(json as Map<String, dynamic>))
          .toList();

      return words;
    } catch (e) {
      throw Exception('Failed to load words: $e');
    }
  }

  /// Get words due for review today (spaced repetition)
  Future<List<Word>> getTodaysReviewWords() async {
    try {
      final response = await _supabase
          .from('user_progress')
          .select('word_id, words!inner(*)')
          .eq('user_id', _getUserId())
          .order('next_review_date')
          .limit(10);

      return response
          .map(
            (json) => Word.fromJson(
              json['words'] as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load review words: $e');
    }
  }

  Future<void> toggleFavorite({
    required String wordId,
  }) async {
    try {
      final isFavorited = await _supabase
          .from('user_favorites')
          .select()
          .eq('user_id', _getUserId())
          .eq('word_id', wordId)
          .maybeSingle();

      if (isFavorited != null) {
        await _supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', _getUserId())
            .eq('word_id', wordId);
      } else {
        await _supabase.from('user_favorites').insert({
          'user_id': _getUserId(),
          'word_id': wordId,
        });
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  /// Get all favorite words for a user
  Future<List<Word>> getFavorites() async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select('words(*)') // Fetch related words
          .eq('user_id', _getUserId());

      return response
          .map((json) => Word.fromJson(json['words'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load favorites: $e');
    }
  }

  /// Check if a word is favorited
  Future<bool> isFavorited(int wordId) async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select()
          .eq('user_id', _getUserId())
          .eq('word_id', wordId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Mark words as learned
  Future<void> markWordAsLearned(List<String> wordIds) async {
    try {
      if (wordIds.isEmpty) return;

      // Filter out empty or invalid word IDs
      final validWordIds =
          wordIds.where((id) => id.isNotEmpty).toSet().toList();
      if (validWordIds.isEmpty) return;

      final now = DateTime.now();
      final nextReviewDate = now.add(const Duration(days: 1));

      await _supabase.from('user_progress').upsert(
            validWordIds
                .map(
                  (wordId) => {
                    'user_id': _getUserId(),
                    'word_id': wordId,
                    'mastered': true,
                    'next_review_date': nextReviewDate.toIso8601String(),
                  },
                )
                .toList(),
            onConflict: 'user_id,word_id',
          );
    } catch (e) {
      throw Exception('Failed to learn word: $e');
    }
  }

  /// Get the latest reviewed words for the current user
  Future<List<Word>> getLatestReviewedWords({
    int limit = 10,
  }) async {
    try {
      final response = await _supabase
          .from('user_progress')
          .select('word_id, words!inner(*)')
          .eq('user_id', _getUserId())
          .order('updated_at', ascending: false)
          .limit(limit);

      return response
          .map((json) => Word.fromJson(json['words'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load latest reviewed words: $e');
    }
  }
}
