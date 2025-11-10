import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/home/view/home_page.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/features/practice/widgets/loading_quiz.dart';
import 'package:wordstock/features/practice/widgets/question.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

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
  bool _showNextButton = false;

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

  void _goToNextQuestion(BuildContext context, PracticeQuizLoaded state) {
    if (state.isLastQuestion) {
      widget.onTap(); // Go to results page
      return;
    }

    // Reset next button visibility
    setState(() {
      _showNextButton = false;
    });

    // Animate to next page in PageView
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Update cubit state to next question
    context.read<PracticeCubit>().nextQuestion();
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    final l10n = context.l10n;
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: Color(0xffE94E77),
                ).animate().scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                      duration: 300.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 16),
                Text(
                  l10n.exitConfirmationTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffE94E77),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.exitConfirmationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PushableButton(
                      width: 100,
                      height: 50,
                      textColor: Colors.grey.shade600,
                      buttonColor: Colors.grey.shade200,
                      shadowColor: Colors.grey.shade400,
                      text: l10n.exit,
                      onTap: () {
                        Navigator.of(dialogContext).pop(true);
                      },
                    ),
                    const SizedBox(width: 16),
                    PushableButton(
                      width: 120,
                      height: 50,
                      buttonColor: const Color(0xffE94E77),
                      shadowColor: const Color(0xff963E00),
                      text: l10n.continueAction,
                      onTap: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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

          // Check if answer was just submitted
          // Show next button immediately after answer is submitted
          if (state.hasSubmittedAnswer && !_showNextButton) {
            setState(() {
              _showNextButton = true;
            });
          }

          // Setup auto-navigation to results on last question
          // Removed auto-navigation delay - user must click finish button
          // Auto-navigation removed to give user control
        }
      },
      builder: (context, state) {
        if (state is PracticeLoading) {
          return const LoadingQuiz();
        }

        if (state is PracticeError) {
          return Center(
            child: Text(
              l10n.errorWithMessage(state.message),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is PracticeQuizLoaded && state.questions.isNotEmpty) {
          final questions = state.questions;
          final currentIndex = state.currentQuestionIndex;
          final hasSubmittedAnswer = state.hasSubmittedAnswer;

          return Column(
            children: [
              // Top Bar
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      PushableButton(
                        width: 56,
                        height: 56,
                        buttonColor: const Color(0xffE94E77),
                        shadowColor: const Color(0xff963E00),
                        text: '',
                        prefixIcon: Icons.close_rounded,
                        onTap: () async {
                          final result =
                              await _showExitConfirmationDialog(context);
                          if ((result ?? false) && context.mounted) {
                            context.replace(HomePage.name);
                          }
                        },
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
                              Text(
                                l10n.vocabularyQuiz,
                                style: const TextStyle(
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
                                    l10n.questionCounter(
                                      currentIndex + 1,
                                      questions.length,
                                    ),
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
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.selectCorrectWord,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Expanded area for PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    // Only update state if needed
                    if (index != currentIndex) {
                      context.read<PracticeCubit>().jumpToQuestion(index);
                    }
                  },
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final isCurrentQuestion = index == currentIndex;

                    return Question(
                      question: question,
                      isAnswered: isCurrentQuestion && hasSubmittedAnswer,
                      selectedOption: state.selectedAnswers[index],
                      onTap: (option) {
                        // Only process selection for current question
                        if (isCurrentQuestion && !hasSubmittedAnswer) {
                          context.read<PracticeCubit>().selectAnswer(option);
                        }
                      },
                    );
                  },
                ),
              ),

              // Feedback container - slides up from bottom when answer is submitted
              // Provides visual feedback about correct/incorrect answer
              AnimatedSlide(
                offset: (hasSubmittedAnswer && _showNextButton)
                    ? Offset.zero
                    : const Offset(0, 1),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  // Determine if the current answer was correct
                  // Use ?? false to handle case where result might not be set yet
                  decoration: BoxDecoration(
                    color: (state.answerResults[currentIndex] ?? false)
                        ? const Color(0xff58CC02).withValues(alpha: 0.1)
                        : const Color(0xffFF4B4B).withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Feedback icon and message
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon with animation
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: (state.answerResults[currentIndex] ??
                                          false)
                                      ? const Color(0xff58CC02)
                                      : const Color(0xffFF4B4B),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  (state.answerResults[currentIndex] ?? false)
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              )
                                  .animate()
                                  .scale(
                                    begin: Offset.zero,
                                    end: const Offset(1, 1),
                                    duration: 400.ms,
                                    curve: Curves.elasticOut,
                                  )
                                  .fadeIn(duration: 300.ms),
                              const SizedBox(width: 16),
                              // Feedback message
                              Expanded(
                                child: Text(
                                  (state.answerResults[currentIndex] ?? false)
                                      ? 'Correct!'
                                      : 'Incorrect',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: (state.answerResults[currentIndex] ??
                                            false)
                                        ? const Color(0xff58CC02)
                                        : const Color(0xffFF4B4B),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 300.ms, delay: 100.ms)
                                    .slideX(
                                      begin: -0.2,
                                      end: 0,
                                      duration: 400.ms,
                                      curve: Curves.easeOut,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Next/Finish button
                          PushableButton(
                            width: double.infinity,
                            height: 56,
                            buttonColor:
                                (state.answerResults[currentIndex] ?? false)
                                    ? const Color(0xff58CC02)
                                    : const Color(0xffFF4B4B),
                            shadowColor:
                                (state.answerResults[currentIndex] ?? false)
                                    ? const Color(0xff58A700)
                                    : const Color(0xffE94E77),
                            text:
                                state.isLastQuestion ? l10n.finish : l10n.next,
                            onTap: (hasSubmittedAnswer && _showNextButton)
                                ? () => _goToNextQuestion(context, state)
                                : () {}, // Empty function as fallback
                          )
                              .animate()
                              .fadeIn(duration: 300.ms, delay: 200.ms)
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                                duration: 400.ms,
                                delay: 200.ms,
                                curve: Curves.easeOut,
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // Fallback empty state
        return Center(
          child: Text(l10n.noQuizQuestions),
        );
      },
    );
  }
}
