import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_quiz_question.freezed.dart';
part 'practice_quiz_question.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class PracticeQuizQuestion with _$PracticeQuizQuestion {
  @JsonSerializable(explicitToJson: true)
  const factory PracticeQuizQuestion({
    @JsonKey(name: 'question_id') required String questionId,
    required String question,
    required List<String> options,
    @JsonKey(name: 'correct_answer') required String correctAnswer,
  }) = _PracticeQuizQuestion;

  /// Factory constructor to create a [PracticeQuizQuestion] from JSON.
  factory PracticeQuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$PracticeQuizQuestionFromJson(json);
}
