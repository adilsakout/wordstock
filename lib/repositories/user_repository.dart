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
