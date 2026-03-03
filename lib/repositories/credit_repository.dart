import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/repositories/supabase_repository.dart';

/// Repository for managing daily free credits.
///
/// Free users get 3 credits per UTC day to use AI Chat or Practice.
/// Credits are tracked server-side in the `user_daily_credits` table.
class CreditRepository {
  CreditRepository() : _supabase = SupabaseRepository.client;
  final SupabaseClient _supabase;

  String _getUserId() {
    return _supabase.auth.currentUser?.id ?? '';
  }

  /// Get remaining credits for today. Returns 3 if no row exists yet.
  Future<int> getDailyCredits() async {
    try {
      final result = await _supabase.rpc<int>(
        'get_daily_credits',
        params: {'target_user_id': _getUserId()},
      );
      return result;
    } catch (e) {
      log('Failed to get daily credits: $e', name: 'CreditRepository');
      return 0;
    }
  }

  /// Atomically consume one credit.
  /// Returns remaining credits, or -1 if exhausted.
  Future<int> consumeCredit() async {
    try {
      final result = await _supabase.rpc<int>(
        'consume_daily_credit',
        params: {'target_user_id': _getUserId()},
      );
      return result;
    } catch (e) {
      log('Failed to consume credit: $e', name: 'CreditRepository');
      throw Exception('Failed to consume credit: $e');
    }
  }
}
