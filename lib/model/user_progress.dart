import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_progress.freezed.dart';
part 'user_progress.g.dart';

@freezed
sealed class UserProgress with _$UserProgress {
  const factory UserProgress({
    required String userId,
    required int wordId,
    required DateTime nextReviewDate,
    required DateTime lastReviewed,
    @Default(false) bool mastered,
    @Default(0) int timesReviewed,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}
