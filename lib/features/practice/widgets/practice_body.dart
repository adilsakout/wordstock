import 'package:flutter/material.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/features/practice/widgets/flashcard.dart';
import 'package:wordstock/features/practice/widgets/quiz.dart';
import 'package:wordstock/features/practice/widgets/quiz_initial.dart';
import 'package:wordstock/features/practice/widgets/quiz_result.dart';

/// Page indices for the practice flow.
const _kPageInitial = 0;
const _kPageQuiz = 1;
const _kPageResult = 2;
const _kPageFlashcard = 3;

/// {@template practice_body}
/// Body of the PracticePage.
/// {@endtemplate}
class PracticeBody extends StatefulWidget {
  /// {@macro practice_body}
  const PracticeBody({super.key});

  @override
  State<PracticeBody> createState() => _PracticeBodyState();
}

class _PracticeBodyState extends State<PracticeBody> {
  final PageController _pageController = PageController();

  void _goTo(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PracticeCubit, PracticeState>(
      // Automatically navigate to flashcard page when flashcard state is
      // emitted (e.g. from QuizInitial "Flashcard Mode" button).
      listener: (context, state) {
        if (state is PracticeFlashcardLoaded) {
          _goTo(_kPageFlashcard);
        }
        // Return to initial when resetQuiz() is called from flashcard complete
        if (state is PracticeInitial) {
          _goTo(_kPageInitial);
        }
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Page 0 — Start screen
          QuizInitial(
            onTap: () => _goTo(_kPageQuiz),
          ),

          // Page 1 — Quiz questions
          VocabularyQuiz(
            onTap: () => _goTo(_kPageResult),
          ),

          // Page 2 — Quiz results
          QuizResult(
            onPlayAgain: () {
              _goTo(_kPageInitial);
              context.read<PracticeCubit>().resetQuiz();
            },
          ),

          // Page 3 — Flashcard mode
          const FlashcardView(),
        ],
      ),
    );
  }
}
