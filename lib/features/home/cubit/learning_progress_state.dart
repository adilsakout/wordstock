part of 'learning_progress_cubit.dart';

class LearningProgressState extends Equatable {
  const LearningProgressState({
    this.wordsLearned = 0,
    this.lastPracticeReminder = 0,
    this.shouldShowPracticeReminder = false,
    this.shouldShowSwipeUpReminder = true,
    this.wordsSinceLastReminder = 0,
    this.cumulativeWords = 0,
  });

  final int wordsLearned;
  final int lastPracticeReminder;
  final bool shouldShowPracticeReminder;
  final bool shouldShowSwipeUpReminder;
  final int wordsSinceLastReminder;
  final int cumulativeWords;

  LearningProgressState copyWith({
    int? wordsLearned,
    int? lastPracticeReminder,
    bool? shouldShowPracticeReminder,
    bool? shouldShowSwipeUpReminder,
    int? wordsSinceLastReminder,
    int? cumulativeWords,
  }) {
    return LearningProgressState(
      wordsLearned: wordsLearned ?? this.wordsLearned,
      lastPracticeReminder: lastPracticeReminder ?? this.lastPracticeReminder,
      shouldShowPracticeReminder:
          shouldShowPracticeReminder ?? this.shouldShowPracticeReminder,
      shouldShowSwipeUpReminder:
          shouldShowSwipeUpReminder ?? this.shouldShowSwipeUpReminder,
      wordsSinceLastReminder:
          wordsSinceLastReminder ?? this.wordsSinceLastReminder,
      cumulativeWords: cumulativeWords ?? this.cumulativeWords,
    );
  }

  @override
  List<Object?> get props => [
        wordsLearned,
        lastPracticeReminder,
        shouldShowPracticeReminder,
        shouldShowSwipeUpReminder,
        wordsSinceLastReminder,
        cumulativeWords,
      ];
}
