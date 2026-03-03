import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/features/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:wordstock/repositories/supabase_repository.dart';

/// Repository for persisting AI chat conversations.
///
/// Each user has at most one conversation per word (upsert semantics).
/// Messages are stored as a JSONB array in the `chat_conversations`
/// table.
class ChatRepository {
  /// Creates a new [ChatRepository] backed by Supabase.
  ChatRepository() : _supabase = SupabaseRepository.client;

  final SupabaseClient _supabase;

  String get _userId => _supabase.auth.currentUser?.id ?? '';

  /// Loads a previously saved conversation for [wordId].
  ///
  /// Returns `null` if no conversation exists or on error.
  Future<List<ChatMessage>?> loadConversation(String wordId) async {
    try {
      final response = await _supabase
          .from('chat_conversations')
          .select('messages')
          .eq('user_id', _userId)
          .eq('word_id', wordId)
          .maybeSingle();

      if (response == null) return null;

      final messagesJson = response['messages'] as List<dynamic>;
      return messagesJson
          .map(
            (m) => ChatMessage.fromJson(m as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      log('Failed to load conversation: $e', name: 'ChatRepository');
      return null;
    }
  }

  /// Upserts the conversation for [wordId].
  ///
  /// Uses the `(user_id, word_id)` unique constraint so a second
  /// call for the same word simply overwrites the previous messages.
  Future<void> saveConversation({
    required String wordId,
    required List<ChatMessage> messages,
  }) async {
    try {
      final messagesJson =
          messages.map((m) => m.toJson()).toList();

      await _supabase.from('chat_conversations').upsert(
        {
          'user_id': _userId,
          'word_id': wordId,
          'messages': messagesJson,
        },
        onConflict: 'user_id,word_id',
      );
    } catch (e) {
      // Non-critical — swallow so the chat is never interrupted.
      log(
        'Failed to save conversation: $e',
        name: 'ChatRepository',
      );
    }
  }

  /// Returns the set of [wordIds] that already have a saved
  /// conversation for the current user.
  ///
  /// Useful for showing a "previous chat" indicator on word cards.
  Future<Set<String>> getWordsWithConversations(
    List<String> wordIds,
  ) async {
    if (wordIds.isEmpty) return {};
    try {
      final response = await _supabase
          .from('chat_conversations')
          .select('word_id')
          .eq('user_id', _userId)
          .inFilter('word_id', wordIds);

      final rows = response as List<dynamic>;
      return rows
          .map(
            (r) =>
                (r as Map<String, dynamic>)['word_id'] as String,
          )
          .toSet();
    } catch (e) {
      log(
        'Failed to batch-check conversations: $e',
        name: 'ChatRepository',
      );
      return {};
    }
  }
}
