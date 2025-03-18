import 'package:flutter/material.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/features/practice/widgets/quiz.dart';
import 'package:wordstock/features/practice/widgets/quiz_initial.dart';
import 'package:wordstock/features/practice/widgets/quiz_result.dart';

/// {@template practice_body}
/// Body of the PracticePage.
///
/// Add what it does
/// {@endtemplate}
class PracticeBody extends StatefulWidget {
  /// {@macro practice_body}
  const PracticeBody({super.key});

  @override
  State<PracticeBody> createState() => _PracticeBodyState();
}

class _PracticeBodyState extends State<PracticeBody> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeCubit, PracticeState>(
      builder: (context, state) {
        return SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              QuizInitial(
                onTap: () {
                  context.read<PracticeCubit>().getQuiz();
                  _pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              VocabularyQuiz(
                onTap: () {
                  _pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              QuizResult(
                onPlayAgain: () {
                  _pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                  );
                  context.read<PracticeCubit>().resetQuiz();
                  context.read<PracticeCubit>().getQuiz();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
