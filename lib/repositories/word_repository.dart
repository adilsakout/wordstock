import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/repositories/supabase_repository.dart';

class WordRepository {
  WordRepository() : _supabase = SupabaseRepository.client;
  final SupabaseClient _supabase;

  String _getUserId() {
    return _supabase.auth.currentUser?.id ?? '';
  }

  // ================== Core Word Operations ================== //

  /// Get words filtered by level and topics
  Future<List<Word>> getWords({
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await _supabase.from('words').select('''
      id,
      word,
      definition,
      example,
      level,
      phonetic,
      synonyms,
      user_favorites!left(user_id, word_id)
    ''').eq('user_favorites.user_id', _getUserId());

      final words = response.map((json) {
        final isFavorite =
            (json['user_favorites'] as List<dynamic>?)?.isNotEmpty ?? false;

        return Word.fromJson({...json, 'isFavorite': isFavorite});
      }).toList()
        ..shuffle();

      return words;
    } catch (e) {
      throw Exception('Failed to load words: $e');
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
