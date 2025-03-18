import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordstock/model/models.dart';

class QuizRepository {
  QuizRepository()
      : _supabase = Supabase.instance.client,
        _userId = Supabase.instance.client.auth.currentUser?.id ?? '';

  final SupabaseClient _supabase;
  final String _userId;
  final logger = Logger();

  Future<List<PracticeQuizQuestion>> getQuiz() async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'generate_practice_quiz',
        params: {
          'user_id_param': _userId,
          'total_questions': 10,
        },
      );

      // The response should be a List<dynamic> that we can
      // cast to List<Map<String, dynamic>>
      final questions = (response as List<dynamic>).map(
        (item) {
          final question =
              PracticeQuizQuestion.fromJson(item as Map<String, dynamic>);
          question.options.shuffle();
          return question;
        },
      ).toList();

      return questions;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
