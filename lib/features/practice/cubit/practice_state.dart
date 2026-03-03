part of 'practice_cubit.dart';

/// The mode for the quiz.
enum PracticeMode { multipleChoice, typing }

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
    this.mode = PracticeMode.multipleChoice,
    this.isLoadingMore = false,
  });

  final List<PracticeQuizQuestion> questions;
  final int currentQuestionIndex;
  final Map<int, String> selectedAnswers;
  final Map<int, bool> answerResults;
  final bool hasSubmittedAnswer;
  final bool isTransitioning;
  final PracticeMode mode;

  /// True while more questions are still streaming in from the AI.
  final bool isLoadingMore;

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
    PracticeMode? mode,
    bool? isLoadingMore,
  }) {
    return PracticeQuizLoaded(
      questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      answerResults: answerResults ?? this.answerResults,
      hasSubmittedAnswer: hasSubmittedAnswer ?? this.hasSubmittedAnswer,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      mode: mode ?? this.mode,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
        mode,
        isLoadingMore,
      ];
}

/// {@template practice_flashcard_loaded}
/// State when flashcard words are loaded and a session is active.
/// {@endtemplate}
class PracticeFlashcardLoaded extends PracticeState {
  /// {@macro practice_flashcard_loaded}
  const PracticeFlashcardLoaded(
    this.words, {
    this.currentIndex = 0,
    this.isFlipped = false,
    this.results = const {},
  });

  final List<Word> words;
  final int currentIndex;

  /// Whether the current card is showing its back (definition) side.
  final bool isFlipped;

  /// Maps word index → whether the user knew it.
  final Map<int, bool> results;

  Word get currentWord => words[currentIndex];
  bool get isLastCard => currentIndex >= words.length - 1;
  bool get isComplete => results.length >= words.length;

  PracticeFlashcardLoaded copyWith({
    List<Word>? words,
    int? currentIndex,
    bool? isFlipped,
    Map<int, bool>? results,
  }) {
    return PracticeFlashcardLoaded(
      words ?? this.words,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [words, currentIndex, isFlipped, results];
}
