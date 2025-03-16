import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/model/user_profile.dart';

class UserRepository {
  UserRepository()
      : _supabase = Supabase.instance.client,
        _userId = Supabase.instance.client.auth.currentUser?.id ?? '';
  final SupabaseClient _supabase;
  final String _userId;

  /// Update the daily streak for the user
  Future<void> updateDailyStreak() async {
    try {
      await _supabase.rpc<void>(
        'update_user_streak',
        params: {'target_user_id': _userId},
      );
    } catch (e) {
      throw Exception('Failed to update streak: $e');
    }
  }

  /// Update the total points for the user
  Future<void> updateTotalPoints(int points) async {
    try {
      await _supabase.rpc<void>(
        'update_user_total_points',
        params: {'target_user_id': _userId, 'points': points},
      );
    } catch (e) {
      throw Exception('Failed to update total points: $e');
    }
  }

  /// Save onboarding data to the user profile
  Future<void> saveOnboardingData({
    int? ageRange,
    String? gender,
    String? userName,
    int? timeCommitment,
    int? wordsPerDay,
    VocabularyLevel? vocabularyLevel,
    List<String>? selectedGoals,
    List<String>? selectedTopics,
    int? streakGoal,
  }) async {
    try {
      final data = <String, dynamic>{
        'user_id': _userId,
        'onboarding_completed': true,
      };

      // Only add fields that are not null
      if (userName != null) data['name'] = userName;
      if (ageRange != null) data['age_range'] = ageRange;
      if (gender != null) data['gender'] = gender;
      if (timeCommitment != null) data['time_commitment'] = timeCommitment;
      if (wordsPerDay != null) data['words_per_day'] = wordsPerDay;
      if (vocabularyLevel != null) {
        data['vocabulary_level'] = vocabularyLevel.name;
      }
      if (selectedGoals != null) data['goals'] = selectedGoals;
      if (selectedTopics != null) data['topics'] = selectedTopics;
      if (streakGoal != null) data['streak_goal'] = streakGoal;

      await _supabase.from('user_profiles').upsert(data);
    } catch (e) {
      throw Exception('Failed to save onboarding data: $e');
    }
  }

  /// Get the user's profile
  Future<UserProfile> getProfile() async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', _userId)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }
}
