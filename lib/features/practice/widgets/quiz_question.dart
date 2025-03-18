import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/quiz_button.dart';

class VocabularyQuiz extends StatefulWidget {
  const VocabularyQuiz({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  State<VocabularyQuiz> createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final PageController _pageController;
  Timer? _resultPageNavigationTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pageController = PageController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultPageNavigationTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PracticeCubit, PracticeState>(
      listener: (context, state) {
        // Listen for state changes to update PageView
        if (state is PracticeQuizLoaded) {
          if (_pageController.hasClients) {
            // Only jump if the page is different to avoid unnecessary jumps
            if (_pageController.page?.round() != state.currentQuestionIndex) {
              _pageController.jumpToPage(state.currentQuestionIndex);
            }
          }
        }
      },
      builder: (context, state) {
        if (state is PracticeLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xffE94E77),
            ),
          );
        }

        if (state is PracticeError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is PracticeQuizLoaded && state.questions.isNotEmpty) {
          final questions = state.questions;
          final currentIndex = state.currentQuestionIndex;
          final hasSubmittedAnswer = state.hasSubmittedAnswer;

          // Setup auto-navigation to results on last question
          if (state.isLastQuestion && hasSubmittedAnswer) {
            _resultPageNavigationTimer?.cancel();
            _resultPageNavigationTimer =
                Timer(const Duration(milliseconds: 1500), () {
              if (mounted) {
                widget.onTap();
              }
            });
          }

          return Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    PushableButton(
                      width: 56,
                      height: 56,
                      buttonColor: const Color(0xffE94E77),
                      shadowColor: const Color(0xff963E00),
                      text: '',
                      prefixIcon: Icons.arrow_back_ios_new,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xffE94E77),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 16),
                            const Text(
                              'Vocabulary Quiz',
                              style: TextStyle(
                                color: Color(0xffE94E77),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 100,
                              height: 56,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Color(0xffE94E77),
                              ),
                              child: Center(
                                child: Text(
                                  '${currentIndex + 1}/${questions.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select the correct word to complete the sentence.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Expanded area for PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {},
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final isCurrentQuestion = index == currentIndex;

                    // Animate only if this is the current question
                    if (isCurrentQuestion) {
                      _animationController
                        ..reset()
                        ..forward();
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Question text
                            Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            )
                                .animate(controller: _animationController)
                                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                                .slideX(
                                  begin: 0.2,
                                  end: 0,
                                  duration: 300.ms,
                                  curve: Curves.easeOut,
                                ),

                            const SizedBox(height: 24),

                            // Options
                            ...List.generate(
                              question.options.length,
                              (optionIndex) {
                                final option = question.options[optionIndex];
                                final isSelected =
                                    state.selectedAnswers[index] == option;
                                final isCorrect =
                                    question.correctAnswer == option;

                                // Determine button color
                                var buttonColor = const Color(0xffF1F1F1);
                                var backgroundColor = const Color(0xffF1F1F1);
                                var shadowColor = Colors.grey.shade300;
                                var textColor = Colors.black87;

                                if (hasSubmittedAnswer && isCurrentQuestion) {
                                  // Show correctness
                                  if (isSelected || isCorrect) {
                                    if (isCorrect) {
                                      buttonColor =
                                          const Color(0xff58CC02); // Green
                                      shadowColor = const Color(0xff58A700);
                                      backgroundColor = const Color(0xffBCFFC8);
                                    } else if (isSelected) {
                                      buttonColor =
                                          const Color(0xffFF4B4B); // Red
                                      shadowColor = const Color(0xffE94E77);
                                      backgroundColor = const Color(0xffFFCCDA);
                                    }
                                  }
                                } else if (isSelected && isCurrentQuestion) {
                                  // Selected but not yet submitted
                                  buttonColor = const Color(0xff1CB0F6); // Blue
                                  textColor = Colors.white;
                                }

                                final widgetButton = QuizButton(
                                  width: 300,
                                  height: 56,
                                  buttonColor: buttonColor,
                                  backgroundColor: backgroundColor,
                                  shadowColor: shadowColor,
                                  text: option,
                                  textColor: textColor,
                                  onTap: () {},
                                );

                                Widget animatedButton = widgetButton;

                                // Only animate current question options
                                if (isCurrentQuestion) {
                                  animatedButton = widgetButton
                                      .animate(controller: _animationController)
                                      .fadeIn(
                                        delay: (50 * optionIndex).ms,
                                        duration: 300.ms,
                                        curve: Curves.easeOut,
                                      )
                                      .slideX(
                                        delay: (50 * optionIndex).ms,
                                        begin: 0.2,
                                        end: 0,
                                        duration: 300.ms,
                                        curve: Curves.easeOut,
                                      );

                                  // Add shake effect for wrong answer
                                  if (hasSubmittedAnswer &&
                                      isSelected &&
                                      !isCorrect) {
                                    animatedButton = animatedButton
                                        .animate()
                                        .shake(delay: 200.ms, duration: 300.ms);
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: animatedButton,
                                );
                              },
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Next button - only show when answer is submitted
              // but not on the last question
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AnimatedOpacity(
                  opacity: hasSubmittedAnswer ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: PushableButton(
                    width: 150,
                    height: 56,
                    buttonColor: const Color(0xff1CB0F6),
                    shadowColor: const Color(0xff1899D6),
                    text: state.isLastQuestion ? 'Finish' : 'Next',
                    onTap: () {}, // Empty function as fallback
                  ).animate().fadeIn(duration: 300.ms).scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                        duration: 300.ms,
                        curve: Curves.elasticOut,
                      ),
                ),
              ),
            ],
          );
        }

        // Fallback empty state
        return const Center(
          child: Text('No quiz questions available'),
        );
      },
    );
  }
}
