import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/repositories/quiz_repository.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';
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

  Future<void> getQuiz() async {
    try {
      emit(const PracticeLoading());

      final questions = await quizRepository.getQuiz();

      emit(PracticeQuizLoaded(questions));
    } catch (e) {
      emit(PracticeError(e.toString()));
    }
  }

  Future<void> getQuizFromWords({List<Word>? words}) async {
    try {
      emit(const PracticeLoading());

      // If no words provided, get from repository
      final wordsToUse = words ?? await wordRepository.getTodaysReviewWords();

      if (wordsToUse.isEmpty) {
        emit(const PracticeError('No words available for quiz'));
        return;
      }

      final questions = await quizRepository.getQuizFromOpenAI(
        words: wordsToUse,
      );

      emit(PracticeQuizLoaded(questions));
    } catch (e) {
      emit(PracticeError(e.toString()));
    }
  }

  Future<void> updateTotalPoints() async {
    try {
      await userRepository.updateTotalPoints(
        getCorrectAnswersCount() * 10,
      );
    } catch (e) {
      emit(PracticeError(e.toString()));
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
    if (state is PracticeQuizLoaded) {
      final currentState = state as PracticeQuizLoaded;
      emit(
        PracticeQuizLoaded(
          currentState.questions,
        ),
      );
    }
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
}
