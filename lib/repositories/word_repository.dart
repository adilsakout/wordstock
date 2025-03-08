import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/model/models.dart';

class WordRepository {
  WordRepository() : _supabase = Supabase.instance.client;
  final SupabaseClient _supabase;

  // ================== Core Word Operations ================== //

  /// Get words filtered by level and topics
  Future<List<Word>> getWords({
    // required VocabularyLevel level,
    // required List<int> topicIds,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await _supabase
          .from('words')
          .select()
          // .eq('level', level.name)
          // .in_('topic_id', topicIds)
          .range(page * pageSize, (page + 1) * pageSize - 1)
          .order('id', ascending: true);

      return response.map(Word.fromJson).toList();
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

  // ================== Progress Tracking ================== //

  // Commented out for now
  /*
  /// Track word interaction (correct/incorrect answer)
  Future<void> trackWordProgress({
    required String userId,
    required int wordId,
    required bool isCorrect,
  }) async {
    try {
      // Get current progress
      final currentProgress = await _supabase
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .eq('word_id', wordId)
          .maybeSingle();

      // Calculate new values
      final timesReviewed = (currentProgress?['times_reviewed'] ?? 0) + 1;
      final nextReviewDate = _calculateNextReviewDate(isCorrect, timesReviewed);

      // Upsert progress
      await _supabase.from('user_progress').upsert({
        'user_id': userId,
        'word_id': wordId,
        'mastered': isCorrect,
        'next_review_date': nextReviewDate.toIso8601String(),
        'times_reviewed': timesReviewed,
        'last_reviewed': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to track progress: ${e.toString()}');
    }
  }

  /// Get user's progress for a specific word
  Future<UserProgress?> getWordProgress(String userId, int wordId) async {
    try {
      final response = await _supabase
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .eq('word_id', wordId)
          .maybeSingle();

      return response != null ? UserProgress.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to load progress: ${e.toString()}');
    }
  }

  // ================== Helper Methods ================== //

  DateTime _calculateNextReviewDate(bool isCorrect, int timesReviewed) {
    // TODO: Implement actual review scheduling logic
    return DateTime.now().add(const Duration(days: 1));
  }
  */
}
