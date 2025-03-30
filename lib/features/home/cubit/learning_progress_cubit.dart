import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'learning_progress_state.dart';

class LearningProgressCubit extends Cubit<LearningProgressState> {
  LearningProgressCubit() : super(const LearningProgressState()) {
    _loadProgress();
  }

  static const _wordsLearnedKey = 'words_learned_count';
  static const _lastPracticeReminderKey = 'last_practice_reminder_count';
  static const _cumulativeWordsKey = 'cumulative_words_count';

  // Set to track which word IDs have been learned
  final Set<String> _learnedWordIds = {};

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final wordsLearned = prefs.getInt(_wordsLearnedKey) ?? 0;
    final lastPracticeReminder = prefs.getInt(_lastPracticeReminderKey) ?? 0;
    final cumulativeWords = prefs.getInt(_cumulativeWordsKey) ?? 0;

    final wordsSinceLastReminder = wordsLearned - lastPracticeReminder;
    final shouldShowReminder = wordsSinceLastReminder >= 5 && wordsLearned > 0;

    emit(
      LearningProgressState(
        wordsLearned: wordsLearned,
        lastPracticeReminder: lastPracticeReminder,
        shouldShowPracticeReminder: shouldShowReminder,
        wordsSinceLastReminder: wordsSinceLastReminder,
        cumulativeWords: cumulativeWords,
      ),
    );
  }

  Future<void> incrementWordsLearned({String? wordId}) async {
    // If a wordId is provided and it's already been marked as learned,
    // don't increment
    if (wordId != null && _learnedWordIds.contains(wordId)) {
      return;
    }

    // Add the word ID to the set of learned words if provided
    if (wordId != null) {
      _learnedWordIds.add(wordId);
    }

    final prefs = await SharedPreferences.getInstance();
    final newCount = state.wordsLearned + 1;
    final newCumulativeCount = state.cumulativeWords + 1;

    await prefs.setInt(_wordsLearnedKey, newCount);
    await prefs.setInt(_cumulativeWordsKey, newCumulativeCount);
    final wordsSinceLastReminder = newCount - state.lastPracticeReminder;
    final shouldShowReminder = wordsSinceLastReminder >= 5;

    emit(
      state.copyWith(
        wordsLearned: newCount,
        shouldShowPracticeReminder: shouldShowReminder,
        wordsSinceLastReminder: wordsSinceLastReminder,
        shouldShowSwipeUpReminder: false,
        cumulativeWords: newCumulativeCount,
      ),
    );
  }

  Future<void> markPracticeReminderShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPracticeReminderKey, state.wordsLearned);

    // We don't reset the cumulative count when marking a reminder as shown
    // This allows it to keep growing across multiple practice sessions

    emit(
      state.copyWith(
        lastPracticeReminder: state.wordsLearned,
        shouldShowPracticeReminder: false,
        wordsSinceLastReminder: 0,
        // cumulativeWords remains unchanged
      ),
    );
  }

  /// Called when the user starts a practice session
  /// Resets the cumulative words counter to 0
  Future<void> startPractice() async {
    final prefs = await SharedPreferences.getInstance();

    // Reset cumulative words counter
    await prefs.setInt(_cumulativeWordsKey, 0);

    // Also mark the practice reminder as shown
    await prefs.setInt(_lastPracticeReminderKey, state.wordsLearned);

    emit(
      state.copyWith(
        lastPracticeReminder: state.wordsLearned,
        shouldShowPracticeReminder: false,
        wordsSinceLastReminder: 0,
        cumulativeWords: 0, // Reset to 0
      ),
    );
  }

  void showPracticeReminder() {
    if (!state.shouldShowPracticeReminder) {
      emit(state.copyWith(shouldShowPracticeReminder: true));
    }
  }

  void hidePracticeReminder() {
    if (state.shouldShowPracticeReminder) {
      emit(state.copyWith(shouldShowPracticeReminder: false));
    }
  }

  // Method to reset all counters (for testing or user request)
  Future<void> resetAllCounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_wordsLearnedKey, 0);
    await prefs.setInt(_lastPracticeReminderKey, 0);
    await prefs.setInt(_cumulativeWordsKey, 0);
    _learnedWordIds.clear();

    emit(const LearningProgressState());
  }
}
