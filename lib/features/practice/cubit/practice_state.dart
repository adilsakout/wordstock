part of 'practice_cubit.dart';

/// {@template practice}
/// PracticeState description
/// {@endtemplate}
abstract class PracticeState extends Equatable {
  /// {@macro practice}
  const PracticeState();

  @override
  List<Object?> get props => [];
}

/// {@template practice_initial}
/// The initial state of PracticeState
/// {@endtemplate}
class PracticeInitial extends PracticeState {
  /// {@macro practice_initial}
  const PracticeInitial();
}

/// {@template practice_loading}
/// Loading state while fetching quiz questions
/// {@endtemplate}
class PracticeLoading extends PracticeState {
  /// {@macro practice_loading}
  const PracticeLoading();
}

/// {@template practice_error}
/// Error state when quiz loading fails
/// {@endtemplate}
class PracticeError extends PracticeState {
  /// {@macro practice_error}
  const PracticeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// {@template practice_quiz_loaded}
/// State when quiz questions are successfully loaded
/// {@endtemplate}
class PracticeQuizLoaded extends PracticeState {
  /// {@macro practice_quiz_loaded}
  const PracticeQuizLoaded(
    this.questions, {
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.answerResults = const {},
    this.hasSubmittedAnswer = false,
    this.isTransitioning = false,
  });

  final List<PracticeQuizQuestion> questions;
  final int currentQuestionIndex;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> answerResults;
  final bool hasSubmittedAnswer;
  final bool isTransitioning;

  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;

  bool isCorrectAnswer(String selectedOption) =>
      questions[currentQuestionIndex].correctAnswer == selectedOption;

  /// Returns the number of correctly answered questions
  int getCorrectAnswersCount() {
    return answerResults.values.where((isCorrect) => isCorrect).length;
  }

  PracticeQuizLoaded copyWith({
    List<PracticeQuizQuestion>? questions,
    int? currentQuestionIndex,
    Map<int, String>? selectedAnswers,
    Map<int, bool>? answerResults,
    bool? hasSubmittedAnswer,
    bool? isTransitioning,
  }) {
    return PracticeQuizLoaded(
      questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      answerResults: answerResults ?? this.answerResults,
      hasSubmittedAnswer: hasSubmittedAnswer ?? this.hasSubmittedAnswer,
      isTransitioning: isTransitioning ?? this.isTransitioning,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        selectedAnswers,
        answerResults,
        hasSubmittedAnswer,
        isTransitioning,
      ];
}
