import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/quiz_button.dart';

class EnglishTestQuestion extends StatefulWidget {
  /// {@macro english_test_question}
  const EnglishTestQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onSelectAnswer,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.onNext,
    super.key,
  });

  /// The question text to display
  final String question;

  /// List of answer options
  final List<String> options;

  /// The correct answer
  final String correctAnswer;

  /// Currently selected answer (null if not answered)
  final String? selectedAnswer;

  /// Callback when an answer is selected
  final ValueChanged<String> onSelectAnswer;

  /// Callback when user taps the next button
  final VoidCallback? onNext;

  /// Current question number (0-based)
  final int currentQuestionIndex;

  /// Total number of questions
  final int totalQuestions;

  @override
  State<EnglishTestQuestion> createState() => _EnglishTestQuestionState();
}

class _EnglishTestQuestionState extends State<EnglishTestQuestion>
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
  void didUpdateWidget(EnglishTestQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only restart animations when question changes
    if (oldWidget.question != widget.question) {
      _animationController
        ..reset()
        ..forward();
      _justSelectedWrong = false;
    }

    // Detect if a wrong answer was just selected
    final wasAnswered = oldWidget.selectedAnswer != null;
    final isNowAnswered = widget.selectedAnswer != null;

    if (!wasAnswered && isNowAnswered && widget.selectedAnswer != null) {
      // Check if the selection was correct or wrong and provide
      // appropriate feedback
      if (widget.selectedAnswer == widget.correctAnswer) {
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

  /// Get definition and encouraging message for a word
  Map<String, String> _getWordInfo(String word) {
    // Simple word definitions for common vocabulary test words
    final definitions = {
      // Beginner words
      'happy': 'feeling joy or pleasure',
      'heavy': 'having great weight; difficult to lift',
      'open': 'not closed; to make accessible',
      'big': 'large in size or amount',
      'cook': 'to prepare food by heating',
      'hot': 'having high temperature',
      'study': 'to learn about something carefully',
      'small': 'little in size',
      'live': 'to have life; to reside somewhere',
      'quiet': 'making little or no noise',

      // Intermediate words
      'eloquent': 'fluent and persuasive in speaking',
      'flawless': 'without any imperfections',
      'deteriorated': 'became worse in quality',
      'methodical': 'done according to a systematic plan',
      'audacious': 'showing willingness to take bold risks',
      'groundbreaking': 'pioneering; innovative',
      'persuasive': 'good at convincing others',
      'seamless': 'smooth and continuous',
      'vehement': 'showing strong feeling; forceful',
      'cogent': 'clear, logical, and convincing',

      // Advanced words
      'opaque': 'not transparent; difficult to understand',
      'trenchant': 'vigorous and incisive in expression',
      'nuanced': 'characterized by subtle distinctions',
      'gratuitous': 'uncalled for; lacking good reason',
      'quixotic': 'unrealistic and impractical',
      'ironic': 'using words to convey opposite meaning',
      'withering': 'intended to make someone feel ashamed',
      'vituperative': 'bitter and abusive in language',
      'granular': 'existing in great detail',
      'specious': 'superficially plausible but actually wrong',
    };

    final encouragingMessages = [
      'Every expert was once a beginner! 🌟',
      'Learning is a journey, not a destination! 🚀',
      "You're expanding your vocabulary universe! 🌌",
      'Knowledge is power - keep building yours! 💪',
      'Every new word is a new superpower! ⚡',
      "You're one step closer to mastery! 🎯",
      'Great minds learn from every experience! 🧠',
      'Your curiosity is your greatest strength! 🔍',
      'Building vocabulary, building confidence! 💎',
      'Learning never stops, and neither do you! 🌊',
    ];

    return {
      'definition':
          definitions[word.toLowerCase()] ?? 'a valuable word to learn',
      'message':
          encouragingMessages[word.hashCode % encouragingMessages.length],
    };
  }

  @override
  Widget build(BuildContext context) {
    final isAnswered = widget.selectedAnswer != null;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (widget.currentQuestionIndex + 1) /
                        widget.totalQuestions,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF1CB0F6)),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${widget.currentQuestionIndex + 1}/${widget.totalQuestions}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1CB0F6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Question text
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              widget.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          )
              .animate(controller: _animationController)
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.2, end: 0, duration: 300.ms),

          const SizedBox(height: 40),

          // Answer options
          Expanded(
            child: ListView.builder(
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = widget.selectedAnswer == option;
                final isCorrect = widget.correctAnswer == option;
                final isWrongSelection = isSelected && !isCorrect;

                var buttonColor = const Color(0xffF1F1F1);
                var backgroundColor = const Color(0xffF1F1F1);
                var shadowColor = Colors.grey.shade300;
                var textColor = Colors.black87;

                if (isAnswered) {
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
                  width: MediaQuery.of(context).size.width - 100,
                  height: 56,
                  buttonColor: buttonColor,
                  backgroundColor: backgroundColor,
                  shadowColor: shadowColor,
                  textColor: textColor,
                  text: option,
                  onTap: isAnswered
                      ? () {} // Disabled when answered
                      : () {
                          // Standard haptic feedback when selecting an option
                          Gaimon.light();
                          widget.onSelectAnswer(option);
                        },
                );

                // Apply animations based on answer state
                if (isAnswered) {
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
                    button = button.animate().shake(
                          delay: 10.ms,
                          duration: 500.ms,
                          hz: 5,
                          rotation: 0.03,
                          curve: Curves.easeInOut,
                        );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: button),
                );
              },
            ),
          ),

          // Feedback section - shows when answer is selected
          if (isAnswered) ...[
            _buildFeedbackSection(context),
          ] else ...[
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  /// Builds the feedback section with encouragement and next button
  Widget _buildFeedbackSection(BuildContext context) {
    final isCorrect = widget.selectedAnswer == widget.correctAnswer;
    final wordInfo = _getWordInfo(widget.correctAnswer);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        color: isCorrect
            ? const Color(0xff58CC02).withValues(alpha: 0.1)
            : const Color(0xffFF4B4B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? const Color(0xff58CC02).withValues(alpha: 0.3)
              : const Color(0xffFF4B4B).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Feedback icon and message
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xff58CC02)
                      : const Color(0xffFF4B4B),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCorrect
                      ? 'Perfect! You nailed it! 🎉'
                      : wordInfo['message']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCorrect
                        ? const Color(0xff58CC02)
                        : const Color(0xffFF4B4B),
                  ),
                ),
              ),
            ],
          ),

          // Word definition and encouragement for wrong answers
          if (!isCorrect) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '💡 ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '"${widget.correctAnswer}"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1CB0F6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    wordInfo['definition']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Next button
          PushableButton(
            width: double.infinity,
            height: 50,
            borderRadius: 25,
            text: widget.currentQuestionIndex == widget.totalQuestions - 1
                ? 'See Results'
                : 'Next Question',
            buttonColor:
                isCorrect ? const Color(0xff58CC02) : const Color(0xff1CB0F6),
            shadowColor:
                isCorrect ? const Color(0xff58A700) : const Color(0xff1899D6),
            onTap: widget.onNext ?? () {},
          ),
        ],
      ),
    )
        .animate()
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(
          duration: 400.ms,
        );
  }
}
