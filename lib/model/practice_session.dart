import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_session.freezed.dart';
part 'practice_session.g.dart';

@freezed
class PracticeSession with _$PracticeSession {
  const factory PracticeSession({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'completed_at') required DateTime completedAt,
    @JsonKey(name: 'total_questions') required int totalQuestions,
    @JsonKey(name: 'correct_answers') required int correctAnswers,
    @JsonKey(name: 'score_percent') required double scorePercent,
    @Default('multiple_choice') String mode,
  }) = _PracticeSession;

  factory PracticeSession.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionFromJson(json);
}
