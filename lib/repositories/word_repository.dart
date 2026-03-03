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

  /// Get user's vocabulary level from user_profiles table with level
  /// progression
  ///
  /// **Special Level Mapping for Learning Progression:**
  /// - Beginner users (level 0) → see beginner words
  /// - Intermediate users (level 1) → see **advanced** words
  ///   (level progression!)
  /// - Advanced users (level 2) → see advanced words
  ///
  /// This promotes vocabulary growth by challenging intermediate users
  /// with advanced content to accelerate their learning journey.
  Future<String> _getUserVocabularyLevel() async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('vocabulary_level')
          .eq('user_id', _getUserId())
          .maybeSingle();

      if (response != null && response['vocabulary_level'] != null) {
        final levelId = response['vocabulary_level'] as int;

        // **Level progression logic: Intermediate users get advanced words**
        if (levelId == 1) {
          // Intermediate level
          log('User has intermediate level (1), showing advanced words '
              'for progression');
          return 'advanced'; // Show advanced words to challenge
          // intermediate users
        }

        // For all other levels (beginner=0, advanced=2), use their actual
        // level
        return _vocabularyLevelToString(levelId);
      }

      // Default to intermediate level, but show advanced words (following
      // progression rule)
      log('No vocabulary level found, defaulting to intermediate user → '
          'showing advanced words');
      return 'advanced';
    } catch (e) {
      log('Error getting user vocabulary level: $e');
      // Default to intermediate level, but show advanced words (following
      // progression rule)
      return 'advanced';
    }
  }

  // ================== Core Word Operations ================== //

  /// Get words filtered by user's vocabulary level with progression
  /// logic
  ///
  /// **Learning Progression System:**
  /// - Beginner users see beginner-level words
  /// - Intermediate users see **advanced-level words** (to accelerate
  ///   learning!)
  /// - Advanced users see advanced-level words
  ///
  /// This progressive approach challenges users to grow their vocabulary
  /// by exposing intermediate learners to advanced content.
  Future<List<Word>> getWords({
    int page = 0,
    int pageSize = 200,
  }) async {
    try {
      // Get the user's vocabulary level from their profile (with progression
      // logic)
      final userVocabularyLevel = await _getUserVocabularyLevel();

      log('Filtering words for vocabulary level: $userVocabularyLevel '
          '(progression-adjusted)');

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
    int pageSize = 200,
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

  /// Returns up to [total] words prioritised for adaptive quiz:
  ///  1. Overdue (next_review_date < now, not mastered) — up to 6 slots
  ///  2. Due today (next_review_date = today, not mastered)
  ///  3. New unseen words (no user_progress row)
  Future<List<Word>> getAdaptiveQuizWords({int total = 10}) async {
    try {
      final userId = _getUserId();
      final now = DateTime.now();
      final nowIso = now.toIso8601String();

      // 1. Overdue words
      final overdueResponse = await _supabase
          .from('user_progress')
          .select('word_id, words!inner(*)')
          .eq('user_id', userId)
          .eq('mastered', false)
          .lt('next_review_date', nowIso)
          .order('next_review_date')
          .limit(6);

      final overdue = (overdueResponse as List<dynamic>)
          .map(
            (json) => Word.fromJson(
              (json as Map<String, dynamic>)['words'] as Map<String, dynamic>,
            ),
          )
          .toList();

      final seenIds = overdue.map((w) => w.id).toSet();
      final remaining = total - overdue.length;

      if (remaining <= 0) return overdue.take(total).toList();

      // 2. Due-today words (next_review_date == today, not already loaded)
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59)
          .toIso8601String();

      final dueResponse = await _supabase
          .from('user_progress')
          .select('word_id, words!inner(*)')
          .eq('user_id', userId)
          .eq('mastered', false)
          .gte('next_review_date', nowIso)
          .lte('next_review_date', todayEnd)
          .order('next_review_date')
          .limit(remaining);

      final dueToday = (dueResponse as List<dynamic>)
          .map(
            (json) => Word.fromJson(
              (json as Map<String, dynamic>)['words'] as Map<String, dynamic>,
            ),
          )
          .where((w) => !seenIds.contains(w.id))
          .toList();

      final combined = [...overdue, ...dueToday];
      seenIds.addAll(dueToday.map((w) => w.id));
      final remaining2 = total - combined.length;

      if (remaining2 <= 0) return combined.take(total).toList();

      // 3. New unseen words (fall back to RPC which handles ordering)
      final allNew = await getQuizWords();
      final newWords = allNew.where((w) => !seenIds.contains(w.id)).toList();

      return [...combined, ...newWords.take(remaining2)];
    } catch (e) {
      log('Error in getAdaptiveQuizWords, falling back to getQuizWords: $e');
      return getQuizWords();
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

  /// Get words due for review today (spaced repetition).
  /// Returns words where next_review_date <= now AND mastered = false.
  /// Falls back to new unseen words if none are due.
  Future<List<Word>> getTodaysReviewWords() async {
    try {
      final now = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('user_progress')
          .select('word_id, words!inner(*)')
          .eq('user_id', _getUserId())
          .eq('mastered', false)
          .lte('next_review_date', now)
          .order('next_review_date')
          .limit(10);

      final words = (response as List<dynamic>)
          .map(
            (json) => Word.fromJson(
              (json as Map<String, dynamic>)['words'] as Map<String, dynamic>,
            ),
          )
          .toList();

      if (words.isNotEmpty) return words;

      // Fallback: return new unseen words
      return getQuizWords();
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

  /// Returns the next review interval in days based on times reviewed.
  /// Uses a simple fixed interval table for spaced repetition.
  int _getNextIntervalDays(int timesReviewed) {
    const intervals = [1, 3, 7, 14, 30];
    final index = timesReviewed.clamp(0, intervals.length - 1);
    return intervals[index];
  }

  /// Updates user_progress after a quiz session.
  ///
  /// [wordIdToResult] maps word ID → was the answer correct.
  /// Correct answers advance the SR interval; wrong answers reset to day 1.
  Future<void> updateProgressAfterQuiz(
    Map<String, bool> wordIdToResult,
  ) async {
    if (wordIdToResult.isEmpty) return;

    try {
      final userId = _getUserId();
      final now = DateTime.now();

      // Fetch existing progress rows for these words
      final wordIds = wordIdToResult.keys.toList();
      final existing = await _supabase
          .from('user_progress')
          .select('word_id, times_reviewed, mastered')
          .eq('user_id', userId)
          .inFilter('word_id', wordIds);

      final existingMap = <String, Map<String, dynamic>>{};
      for (final row in existing as List<dynamic>) {
        final r = row as Map<String, dynamic>;
        existingMap[r['word_id'].toString()] = r;
      }

      final upsertRows = <Map<String, dynamic>>[];

      for (final entry in wordIdToResult.entries) {
        final wordId = entry.key;
        final wasCorrect = entry.value;
        final prev = existingMap[wordId];
        final prevTimesReviewed = (prev?['times_reviewed'] as int?) ?? 0;

        int newTimesReviewed;
        bool mastered;
        int intervalDays;

        if (wasCorrect) {
          newTimesReviewed = prevTimesReviewed + 1;
          intervalDays = _getNextIntervalDays(newTimesReviewed);
          mastered = newTimesReviewed >= 5;
        } else {
          newTimesReviewed = 0;
          intervalDays = 1;
          mastered = false;
        }

        upsertRows.add({
          'user_id': userId,
          'word_id': wordId,
          'times_reviewed': newTimesReviewed,
          'mastered': mastered,
          'last_reviewed': now.toIso8601String(),
          'next_review_date':
              now.add(Duration(days: intervalDays)).toIso8601String(),
        });
      }

      await _supabase
          .from('user_progress')
          .upsert(upsertRows, onConflict: 'user_id,word_id');
    } catch (e) {
      log('Error updating progress after quiz: $e');
      throw Exception('Failed to update quiz progress: $e');
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

      await updateProgressAfterQuiz(
        {for (final id in validWordIds) id: true},
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
          .order('last_reviewed', ascending: false)
          .limit(limit);

      return response
          .map((json) => Word.fromJson(json['words'] as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load latest reviewed words: $e');
    }
  }
}
