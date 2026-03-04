import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/repositories/quiz_repository.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';
import 'package:wordstock/services/posthog_service.dart';
part 'practice_state.dart';

class PracticeCubit extends Cubit<PracticeState> {
  PracticeCubit({
    required this.quizRepository,
    required this.userRepository,
    required this.wordRepository,
  }) : super(const PracticeInitial());

  final QuizRepository quizRepository;
  final UserRepository userRepository;
  final WordRepository wordRepository;

  StreamSubscription<PracticeQuizQuestion>? _quizStreamSubscription;

  // Local accumulator used by the stream listener callbacks
  List<PracticeQuizQuestion> _streamingQuestions = [];
  PracticeMode _streamingMode = PracticeMode.multipleChoice;

  Future<void> getQuiz() async {
    try {
      emit(const PracticeLoading());

      final questions = await quizRepository.getQuiz();

      emit(PracticeQuizLoaded(questions));
    } catch (e) {
      emit(PracticeError(e.toString()));
    }
  }

  Future<void> getQuizFromWords({
    List<Word>? words,
    PracticeMode mode = PracticeMode.multipleChoice,
  }) async {
    // Cancel any in-flight stream from a previous call
    await _quizStreamSubscription?.cancel();
    _quizStreamSubscription = null;
    _streamingQuestions = [];
    _streamingMode = mode;

    // Track Practice Session Started
    final modeStr =
        mode == PracticeMode.typing ? 'typing' : 'multiple_choice';
    PosthogService.instance.track(
      'Practice Session Started',
      properties: {'mode': modeStr},
    );

    emit(const PracticeLoading());

    try {
      final wordsToUse = words ?? await wordRepository.getAdaptiveQuizWords();

      if (wordsToUse.isEmpty) {
        emit(const PracticeError('No words available for quiz'));
        return;
      }

      _quizStreamSubscription =
          quizRepository.getQuizFromOpenAIStream(words: wordsToUse).listen(
                _onQuizQuestionReceived,
                onDone: _onQuizStreamDone,
                onError: _onQuizStreamError,
              );
    } catch (e) {
      // Track Practice Quiz Error
      PosthogService.instance.track(
        'Practice Quiz Error',
        properties: {
          'error_message': e.toString(),
          'mode': modeStr,
          'had_partial_questions': false,
        },
      );
      emit(PracticeError(e.toString()));
    }
  }

  void _onQuizQuestionReceived(PracticeQuizQuestion question) {
    _streamingQuestions.add(question);

    if (state is PracticeLoading || state is PracticeInitial) {
      // First question — navigate from the loading screen into the quiz
      emit(
        PracticeQuizLoaded(
          List.from(_streamingQuestions),
          isLoadingMore: true,
          mode: _streamingMode,
        ),
      );
    } else if (state is PracticeQuizLoaded) {
      final s = state as PracticeQuizLoaded;
      emit(
        s.copyWith(
          questions: List.from(_streamingQuestions),
          isLoadingMore: true,
        ),
      );
    }
  }

  void _onQuizStreamDone() {
    _quizStreamSubscription = null;
    if (_streamingQuestions.isEmpty) {
      emit(const PracticeError('No questions were generated'));
      return;
    }
    if (state is PracticeQuizLoaded) {
      final s = state as PracticeQuizLoaded;
      emit(s.copyWith(isLoadingMore: false));
    }
  }

  void _onQuizStreamError(Object error, StackTrace stackTrace) {
    _quizStreamSubscription = null;

    // Track Practice Quiz Error
    final modeStr = _streamingMode == PracticeMode.typing
        ? 'typing'
        : 'multiple_choice';
    PosthogService.instance.track(
      'Practice Quiz Error',
      properties: {
        'error_message': error.toString(),
        'mode': modeStr,
        'had_partial_questions': _streamingQuestions.isNotEmpty,
      },
    );

    if (_streamingQuestions.isEmpty) {
      emit(PracticeError(error.toString()));
    } else if (state is PracticeQuizLoaded) {
      // We already have some questions — just stop the loading indicator
      final s = state as PracticeQuizLoaded;
      emit(s.copyWith(isLoadingMore: false));
    }
  }

  void selectAnswer(String selectedOption) {
    if (state is PracticeQuizLoaded) {
      final currentState = state as PracticeQuizLoaded;

      if (currentState.hasSubmittedAnswer) {
        // Don't allow changing answer after submission
        return;
      }

      final currentIndex = currentState.currentQuestionIndex;
      final currentQuestion = currentState.questions[currentIndex];
      final isCorrect = currentQuestion.correctAnswer == selectedOption;

      // Create new map with the selected answer for current question
      final newSelectedAnswers =
          Map<int, String>.from(currentState.selectedAnswers);
      newSelectedAnswers[currentIndex] = selectedOption;

      // Create new map to track correct/incorrect answers
      final newAnswerResults = Map<int, bool>.from(currentState.answerResults);
      newAnswerResults[currentIndex] = isCorrect;

      // Update state with new selection
      emit(
        currentState.copyWith(
          selectedAnswers: newSelectedAnswers,
          answerResults: newAnswerResults,
          hasSubmittedAnswer: true,
        ),
      );
    }
  }

  void nextQuestion() {
    if (state is PracticeQuizLoaded) {
      final currentState = state as PracticeQuizLoaded;

      if (!currentState.hasSubmittedAnswer) {
        // Don't advance if no answer submitted
        return;
      }

      if (currentState.isLastQuestion) {
        // Don't advance beyond the last question
        return;
      }

      // Move to next question
      emit(
        currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
          hasSubmittedAnswer: false,
        ),
      );
    }
  }

  void jumpToQuestion(int index) {
    if (state is PracticeQuizLoaded) {
      final currentState = state as PracticeQuizLoaded;

      // Validate index
      if (index < 0 || index >= currentState.questions.length) {
        return;
      }

      // Check if this question has already been answered
      final hasAnswered = currentState.selectedAnswers.containsKey(index);

      // Update state with the new index
      emit(
        currentState.copyWith(
          currentQuestionIndex: index,
          hasSubmittedAnswer: hasAnswered,
        ),
      );
    }
  }

  void resetQuiz() {
    _quizStreamSubscription?.cancel();
    _quizStreamSubscription = null;
    _streamingQuestions = [];
    emit(const PracticeInitial());
  }

  @override
  Future<void> close() {
    _quizStreamSubscription?.cancel();
    return super.close();
  }

  int getCorrectAnswersCount() {
    if (state is PracticeQuizLoaded) {
      final quizState = state as PracticeQuizLoaded;
      return quizState.answerResults.values
          .where((isCorrect) => isCorrect)
          .length;
    }
    return 0;
  }

  int getTotalAnsweredQuestions() {
    if (state is PracticeQuizLoaded) {
      final quizState = state as PracticeQuizLoaded;
      return quizState.selectedAnswers.length;
    }
    return 0;
  }

  // ── Flashcard Mode ──────────────────────────────────────── //

  /// Starts a flashcard session with the given words.
  /// If no words are provided, uses the adaptive word selection.
  Future<void> startFlashcards({List<Word>? words}) async {
    // Track Practice Session Started
    PosthogService.instance.track(
      'Practice Session Started',
      properties: {'mode': 'flashcard'},
    );

    try {
      emit(const PracticeLoading());
      final wordsToUse = words ?? await wordRepository.getAdaptiveQuizWords();
      if (wordsToUse.isEmpty) {
        emit(const PracticeError('No words available for flashcards'));
        return;
      }
      emit(PracticeFlashcardLoaded(wordsToUse));
    } catch (e) {
      emit(PracticeError(e.toString()));
    }
  }

  /// Flips the current flashcard to show the other side.
  void flipCard() {
    if (state is PracticeFlashcardLoaded) {
      final s = state as PracticeFlashcardLoaded;
      emit(s.copyWith(isFlipped: !s.isFlipped));
    }
  }

  /// Records whether the user knew the current card and advances.
  Future<void> rateCard({required bool knew}) async {
    if (state is! PracticeFlashcardLoaded) return;
    final s = state as PracticeFlashcardLoaded;

    final newResults = Map<int, bool>.from(s.results)..[s.currentIndex] = knew;

    if (s.isLastCard) {
      // Session complete — write SR progress
      emit(s.copyWith(results: newResults, isFlipped: false));
      await _submitFlashcardResults(s.words, newResults);
    } else {
      emit(
        s.copyWith(
          currentIndex: s.currentIndex + 1,
          isFlipped: false,
          results: newResults,
        ),
      );
    }
  }

  Future<void> _submitFlashcardResults(
    List<Word> words,
    Map<int, bool> results,
  ) async {
    final wordIdToResult = <String, bool>{};
    for (final entry in results.entries) {
      final word = words[entry.key];
      wordIdToResult[word.id] = entry.value;
    }
    if (wordIdToResult.isEmpty) return;
    try {
      await wordRepository.updateProgressAfterQuiz(wordIdToResult);
    } catch (_) {
      // Non-fatal
    }

    // Persist session history
    try {
      final correct = results.values.where((v) => v).length;
      await quizRepository.savePracticeSession(
        totalQuestions: words.length,
        correctAnswers: correct,
        mode: 'flashcard',
      );

      await PosthogService.instance.track(
        'Practice Session Completed',
        properties: {
          'mode': 'flashcard',
          'total_questions': words.length,
          'correct_answers': correct,
          'score_percent':
              words.isNotEmpty ? (correct / words.length * 100).round() : 0,
        },
      );

      final prefs = await SharedPreferences.getInstance();
      final hasActivated = prefs.getBool('has_completed_practice') ?? false;
      if (!hasActivated) {
        await prefs.setBool('has_completed_practice', true);
        await PosthogService.instance.track(
          'User Activated',
          properties: {
            'activation_type': 'first_practice',
            'mode': 'flashcard',
          },
        );
      }
    } catch (_) {}
  }

  /// Writes quiz results back to the spaced repetition system.
  /// Maps each question's wordId to whether the answer was correct.
  /// Questions without a wordId (legacy Supabase path) are skipped.
  Future<void> submitQuizResults() async {
    if (state is! PracticeQuizLoaded) return;
    final quizState = state as PracticeQuizLoaded;

    final wordIdToResult = <String, bool>{};
    for (final entry in quizState.answerResults.entries) {
      final index = entry.key;
      final wasCorrect = entry.value;
      final question = quizState.questions[index];
      final wordId = question.wordId;
      if (wordId != null && wordId.isNotEmpty) {
        // If a word appears multiple times (unlikely), "correct" wins
        wordIdToResult[wordId] =
            wasCorrect || (wordIdToResult[wordId] ?? false);
      }
    }

    if (wordIdToResult.isEmpty) return;

    try {
      await wordRepository.updateProgressAfterQuiz(wordIdToResult);
    } catch (_) {
      // Non-fatal — don't surface SR errors to the user
    }

    // Persist session history
    try {
      final total = quizState.questions.length;
      final correct = quizState.answerResults.values.where((v) => v).length;
      final modeStr =
          quizState.mode == PracticeMode.typing ? 'typing' : 'multiple_choice';
      await quizRepository.savePracticeSession(
        totalQuestions: total,
        correctAnswers: correct,
        mode: modeStr,
      );

      await PosthogService.instance.track(
        'Practice Session Completed',
        properties: {
          'mode': modeStr,
          'total_questions': total,
          'correct_answers': correct,
          'score_percent': total > 0 ? (correct / total * 100).round() : 0,
        },
      );

      final prefs = await SharedPreferences.getInstance();
      final hasActivated = prefs.getBool('has_completed_practice') ?? false;
      if (!hasActivated) {
        await prefs.setBool('has_completed_practice', true);
        await PosthogService.instance.track(
          'User Activated',
          properties: {
            'activation_type': 'first_practice',
            'mode': modeStr,
          },
        );
      }
    } catch (_) {}
  }
}
