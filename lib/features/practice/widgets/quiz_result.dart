import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/home/home.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
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

    // We'll play the sound when we have the performance data
    // in the build method after loading the state

    // Start forward animation automatically
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PracticeCubit>().updateTotalPoints();
      context.read<StreakCubit>().loadProfile();
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
        // We do this here to ensure we have the performance data
        _playResultSound(percentCorrect);

        // Calculate points (10 points per correct answer)
        final pointsEarned = correctAnswers * 2;

        // Determine result message based on performance
        String resultMessage;
        Color resultColor;

        if (percentCorrect >= 80) {
          resultMessage = l10n.quizResultExcellent;
          resultColor = const Color(0xff58CC02); // Green
        } else if (percentCorrect >= 60) {
          resultMessage = l10n.quizResultGoodJob;
          resultColor = const Color(0xff1CB0F6); // Blue
        } else if (percentCorrect >= 40) {
          resultMessage = l10n.quizResultNiceTry;
          resultColor = const Color(0xffFFC800); // Yellow
        } else {
          resultMessage = l10n.quizResultKeepPracticing;
          resultColor = const Color(0xffFF4B4B); // Red
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Spacer(),
                // Result Message
                Text(
                  resultMessage,
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

                const SizedBox(height: 40),

                // Coin container with animations
                Container(
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

                const SizedBox(height: 20),

                // Summary text with animation
                SizedBox(
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

                const Spacer(),

                // Action Buttons with staggered animations
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PushableButton(
                      width: 150,
                      height: 56,
                      buttonColor: const Color(0xff1CB0F6),
                      shadowColor: const Color(0xff1899D6),
                      text: l10n.playAgain,
                      onTap: () {
                        Gaimon.light();
                        widget.onPlayAgain();
                      },
                    )
                        .animate(controller: _animationController)
                        .fadeIn(delay: 900.ms, duration: 500.ms)
                        .slideX(
                          delay: 900.ms,
                          begin: -0.5,
                          end: 0,
                          duration: 500.ms,
                        )
                        .then(delay: 200.ms)
                        .shimmer(
                          delay: 100.ms,
                          duration: 1200.ms,
                          color: Colors.white.withAlpha(80),
                        ),
                    const SizedBox(width: 20),
                    PushableButton(
                      width: 150,
                      height: 56,
                      buttonColor: const Color(0xff58CC02),
                      shadowColor: const Color(0xff58A700),
                      text: l10n.home,
                      onTap: () {
                        Gaimon.light();
                        context.go(HomePage.name);
                      },
                    )
                        .animate(controller: _animationController)
                        .fadeIn(delay: 1000.ms, duration: 500.ms)
                        .slideX(
                          delay: 1000.ms,
                          begin: 0.5,
                          end: 0,
                          duration: 500.ms,
                        )
                        .then(delay: 300.ms)
                        .shimmer(
                          delay: 100.ms,
                          duration: 1200.ms,
                          color: Colors.white.withAlpha(80),
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
}
