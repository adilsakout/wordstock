import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/widgets/quiz_button.dart';

class Question extends StatefulWidget {
  const Question({
    required this.question,
    required this.onTap,
    required this.isAnswered,
    required this.selectedOption,
    super.key,
  });

  final PracticeQuizQuestion question;
  final void Function(String) onTap;
  final bool isAnswered;
  final String? selectedOption;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  // Track when a wrong answer is newly selected
  bool _justSelectedWrong = false;
  // Audio players for different sounds
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    // Preload sound assets
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    await _correctPlayer.setSource(AssetSource('sounds/correct.wav'));
    await _errorPlayer.setSource(AssetSource('sounds/error.wav'));

    // Set volume levels
    await _correctPlayer.setVolume(1);
    await _errorPlayer.setVolume(0.7);
  }

  @override
  void didUpdateWidget(Question oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only restart animations when question changes
    if (oldWidget.question.questionId != widget.question.questionId) {
      _animationController
        ..reset()
        ..forward();
      _justSelectedWrong = false;
    }

    // Detect if a wrong answer was just selected
    final wasAnswered = oldWidget.isAnswered;
    final isNowAnswered = widget.isAnswered;

    if (!wasAnswered && isNowAnswered && widget.selectedOption != null) {
      // Check if the selection was correct or wrong and provide
      // appropriate feedback
      if (widget.selectedOption == widget.question.correctAnswer) {
        // Play correct sound and haptic
        _correctPlayer.resume();
        Gaimon.success();
      } else {
        // Play error sound and haptic
        _errorPlayer.resume();
        Gaimon.error();
        // User just selected a wrong answer
        _justSelectedWrong = true;
      }

      // Reset flag after animation completes
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _justSelectedWrong = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _correctPlayer.dispose();
    _errorPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                widget.question.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              )
                  .animate(controller: _animationController)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.2, end: 0, duration: 300.ms),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.question.options.length,
              itemBuilder: (context, index) {
                final option = widget.question.options[index];
                final isSelected = widget.selectedOption == option;
                final isCorrect = widget.question.correctAnswer == option;
                final isWrongSelection = isSelected && !isCorrect;

                // Styling based on selection state
                var buttonColor = const Color(0xffF1F1F1);
                var backgroundColor = const Color(0xffF1F1F1);
                var shadowColor = Colors.grey.shade300;
                var textColor = Colors.black87;

                if (widget.isAnswered) {
                  if (isSelected || isCorrect) {
                    if (isCorrect) {
                      // Correct answer styling
                      buttonColor = const Color(0xff58CC02); // Green
                      shadowColor = const Color(0xff58A700);
                      backgroundColor = const Color(0xffBCFFC8);
                    } else if (isSelected) {
                      // Wrong answer styling
                      buttonColor = const Color(0xffFF4B4B); // Red
                      shadowColor = const Color(0xffE94E77);
                      backgroundColor = const Color(0xffFFCCDA);
                    }
                  }
                } else if (isSelected) {
                  // Selected but not yet submitted
                  buttonColor = const Color(0xff1CB0F6); // Blue
                  textColor = Colors.white;
                }

                // Create the button with base styling
                Widget button = QuizButton(
                  width: MediaQuery.of(context).size.width *
                      0.5, // Half of screen width
                  height: 56,
                  buttonColor: buttonColor,
                  backgroundColor: backgroundColor,
                  shadowColor: shadowColor,
                  textColor: textColor,
                  text: option,
                  onTap: widget.isAnswered
                      ? () {} // Disabled when answered
                      : () {
                          // Standard haptic feedback when selecting an option
                          Gaimon.light();
                          widget.onTap(option);
                        },
                );

                // Apply animations based on answer state
                if (widget.isAnswered) {
                  if (isCorrect) {
                    // Celebratory animation for correct answer
                    button = button
                        .animate()
                        // Initial pulse effect
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.05, 1.05),
                          duration: 300.ms,
                          curve: Curves.easeOut,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.05, 1.05),
                          end: const Offset(1, 1),
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        )
                        // Followed by a shimmer
                        .shimmer(
                          duration: 1000.ms,
                          color: Colors.white.withAlpha(120),
                        )
                        .then()
                        .scaleXY(
                          begin: 1,
                          end: 1.03,
                          duration: 400.ms,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .scaleXY(
                          begin: 1.03,
                          end: 1,
                          duration: 400.ms,
                          curve: Curves.easeInOut,
                        );
                  } else if (isWrongSelection && _justSelectedWrong) {
                    // Shake animation for wrong selection
                    button = button
                        .animate() // Create a new separate animation sequence
                        .shake(
                          delay: 10.ms,
                          duration: 500.ms,
                          hz: 5,
                          rotation: 0.03,
                          curve: Curves.easeInOut,
                        );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: button,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
