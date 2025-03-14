import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/model/models.dart';

class WordRepository {
  WordRepository()
      : _supabase = Supabase.instance.client,
        _userId = Supabase.instance.client.auth.currentUser!.id;
  final SupabaseClient _supabase;
  final String _userId;
  // ================== Core Word Operations ================== //

  /// Get words filtered by level and topics
  Future<List<Word>> getWords({
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await _supabase.from('words').select('''
    id, word, definition, example, level, topic_id, 
    user_favorites!user_favorites_word_id_fkey(user_id)
''').limit(100);

      print(response);
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

  /// Get words due for review today (spaced repetition)
  Future<List<Word>> getTodaysReviewWords(String userId) async {
    try {
      final now = DateTime.now().toIso8601String();

      final response = await _supabase
          .from('user_progress')
          .select('word_id, words!inner(*)')
          .eq('user_id', userId)
          .lte('next_review_date', now)
          .order('next_review_date');

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
          .eq('user_id', _userId)
          .eq('word_id', wordId)
          .maybeSingle();

      if (isFavorited != null) {
        await _supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', _userId)
            .eq('word_id', wordId);
      } else {
        await _supabase.from('user_favorites').insert({
          'user_id': _userId,
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
          .eq('user_id', _userId);

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
          .eq('user_id', _userId)
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

      final now = DateTime.now();
      final nextReviewDate = now.add(const Duration(days: 1));

      final uniqueWordIds = wordIds.toSet().toList();

      await _supabase.from('user_progress').upsert(
            uniqueWordIds
                .map(
                  (wordId) => {
                    'user_id': _userId,
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
}
