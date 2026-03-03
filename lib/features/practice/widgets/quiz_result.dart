import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/home/home.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/features/practice/widgets/quiz_answer_review_item.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

class QuizResult extends StatefulWidget {
  const QuizResult({
    required this.onPlayAgain,
    super.key,
  });

  final VoidCallback onPlayAgain;

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  // Audio players for result sounds
  final AudioPlayer _resultSoundPlayer = AudioPlayer();
  bool _soundLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Start forward animation automatically
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final correctAnswers =
          context.read<PracticeCubit>().getCorrectAnswersCount();
      context.read<StreakCubit>().updateTotalPoints(
            points: correctAnswers * 2,
          );
      context.read<PracticeCubit>().submitQuizResults();
    });
  }

  Future<void> _playResultSound(double percentCorrect) async {
    // Only play sound once
    if (_soundLoaded) return;

    try {
      // Always play the success sound on the result screen
      await _resultSoundPlayer.setSource(AssetSource('sounds/success.mp3'));
      await _resultSoundPlayer.setVolume(0.8);
      await _resultSoundPlayer.resume();

      // Success vibration for good performance
      Gaimon.success();

      _soundLoaded = true;
    } catch (e) {
      debugPrint('Error playing result sound: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resultSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<PracticeCubit, PracticeState>(
      builder: (context, state) {
        if (state is! PracticeQuizLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffE94E77)),
          );
        }

        final correctAnswers =
            context.read<PracticeCubit>().getCorrectAnswersCount();
        final totalAnswered =
            context.read<PracticeCubit>().getTotalAnsweredQuestions();
        final percentCorrect =
            totalAnswered > 0 ? (correctAnswers / totalAnswered) * 100 : 0.0;

        // Play the appropriate sound based on performance
        _playResultSound(percentCorrect);

        // Calculate points
        final pointsEarned = correctAnswers * 2;

        // Determine result message based on performance
        String resultMessage;
        Color resultColor;

        if (percentCorrect >= 80) {
          resultMessage = l10n.quizResultExcellent;
          resultColor = const Color(0xff58CC02);
        } else if (percentCorrect >= 60) {
          resultMessage = l10n.quizResultGoodJob;
          resultColor = const Color(0xff1CB0F6);
        } else if (percentCorrect >= 40) {
          resultMessage = l10n.quizResultNiceTry;
          resultColor = const Color(0xffFFC800);
        } else {
          resultMessage = l10n.quizResultKeepPracticing;
          resultColor = const Color(0xffFF4B4B);
        }

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),

                    // Result Message
                    Text(
                      resultMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    )
                        .animate(controller: _animationController)
                        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutQuad,
                        )
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 700.ms,
                          curve: Curves.elasticOut,
                        ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.quizCompleteMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    )
                        .animate(controller: _animationController)
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(
                          delay: 200.ms,
                          begin: 0.5,
                          end: 0,
                          duration: 500.ms,
                        ),

                    const SizedBox(height: 32),

                    // Coin container with animations
                    Center(
                      child: Container(
                        width: 140,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffFFC20E),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SvgPicture.asset(
                                Assets.icons.coin,
                                width: 80,
                                height: 80,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xffFFC20E),
                                  BlendMode.srcIn,
                                ),
                              )
                                  .animate(controller: _animationController)
                                  .fadeIn(delay: 400.ms, duration: 500.ms)
                                  .scale(
                                    delay: 400.ms,
                                    begin: const Offset(0.5, 0.5),
                                    end: const Offset(1.2, 1.2),
                                    duration: 700.ms,
                                    curve: Curves.elasticOut,
                                  )
                                  .then(delay: 200.ms)
                                  .scale(
                                    begin: const Offset(1.2, 1.2),
                                    end: const Offset(1, 1),
                                    duration: 300.ms,
                                  )
                                  .then()
                                  .rotate(
                                    begin: -0.05,
                                    end: 0.05,
                                    duration: 500.ms,
                                    curve: Curves.easeInOut,
                                  )
                                  .then()
                                  .rotate(
                                    begin: 0.05,
                                    end: -0.05,
                                    duration: 500.ms,
                                    curve: Curves.easeInOut,
                                  )
                                  .then()
                                  .rotate(
                                    begin: -0.05,
                                    end: 0,
                                    duration: 250.ms,
                                    curve: Curves.easeOut,
                                  ),
                            ),
                            Container(
                              width: 140,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Color(0xffFFC20E),
                              ),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  l10n.coinsEarned(pointsEarned),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate(controller: _animationController)
                          .fadeIn(delay: 300.ms, duration: 500.ms)
                          .slideY(
                            delay: 300.ms,
                            begin: 0.3,
                            end: 0,
                            duration: 700.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .shimmer(
                            delay: 1200.ms,
                            duration: 1500.ms,
                            color: Colors.white.withAlpha(90),
                          ),
                    ),

                    const SizedBox(height: 20),

                    // Summary text
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          l10n.quizResultSummary(correctAnswers, totalAnswered),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        )
                            .animate(controller: _animationController)
                            .fadeIn(delay: 600.ms, duration: 500.ms)
                            .slideY(
                              delay: 600.ms,
                              begin: 0.2,
                              end: 0,
                              duration: 400.ms,
                            ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Review Your Answers ──
                    _ReviewSection(state: state)
                        .animate(controller: _animationController)
                        .fadeIn(delay: 800.ms, duration: 500.ms)
                        .slideY(
                          delay: 800.ms,
                          begin: 0.2,
                          end: 0,
                          duration: 400.ms,
                        ),

                    const SizedBox(height: 24),

                    PushableButton(
                      width: double.infinity,
                      height: 56,
                      buttonColor: const Color(0xff1CB0F6),
                      shadowColor: const Color(0xff1899D6),
                      text: l10n.playAgain,
                      onTap: () {
                        Gaimon.light();
                        widget.onPlayAgain();
                      },
                    ),
                    const SizedBox(height: 10),
                    PushableButton(
                      width: double.infinity,
                      height: 56,
                      buttonColor: const Color(0xff58CC02),
                      shadowColor: const Color(0xff58A700),
                      text: l10n.home,
                      onTap: () {
                        Gaimon.light();
                        context.go(HomePage.name);
                      },
                    ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The "Review Your Answers" section showing correct/wrong rows.
class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.state});

  final PracticeQuizLoaded state;

  @override
  Widget build(BuildContext context) {
    final questions = state.questions;
    if (questions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Your Answers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(questions.length, (index) {
          final question = questions[index];
          final wasCorrect = state.answerResults[index] ?? false;
          final userAnswer = state.selectedAnswers[index];

          return QuizAnswerReviewItem(
            question: question,
            wasCorrect: wasCorrect,
            userAnswer: userAnswer,
          );
        }),
      ],
    );
  }
}
