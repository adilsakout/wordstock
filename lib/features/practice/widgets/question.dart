import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/practice/cubit/cubit.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/quiz_button.dart';

class Question extends StatefulWidget {
  const Question({
    required this.question,
    required this.onTap,
    required this.isAnswered,
    required this.selectedOption,
    super.key,
    this.mode = PracticeMode.multipleChoice,
  });

  final PracticeQuizQuestion question;
  final void Function(String) onTap;
  final bool isAnswered;
  final String? selectedOption;
  final PracticeMode mode;

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _justSelectedWrong = false;
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();

  // Typing mode
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  // true = correct, false = wrong, null = near-miss (edit distance == 1)
  bool? _typingResult;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    try {
      await _correctPlayer.setSource(AssetSource('sounds/correct.wav'));
      await _errorPlayer.setSource(AssetSource('sounds/error.wav'));
      await _correctPlayer.setVolume(1);
      await _errorPlayer.setVolume(0.7);
    } catch (e) {
      debugPrint('Error loading sounds: $e');
    }
  }

  @override
  void didUpdateWidget(Question oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.question.questionId != widget.question.questionId) {
      _animationController
        ..reset()
        ..forward();
      _justSelectedWrong = false;
      _textController.clear();
      _typingResult = null;
    }

    final wasAnswered = oldWidget.isAnswered;
    final isNowAnswered = widget.isAnswered;

    if (!wasAnswered && isNowAnswered && widget.selectedOption != null) {
      final isCorrect =
          widget.selectedOption == widget.question.correctAnswer;
      if (isCorrect) {
        _correctPlayer.resume();
        Gaimon.success();
      } else {
        _errorPlayer.resume();
        Gaimon.error();
        _justSelectedWrong = true;
      }

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _justSelectedWrong = false);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _correctPlayer.dispose();
    _errorPlayer.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Levenshtein edit distance between two strings.
  int _editDistance(String a, String b) {
    final m = a.length;
    final n = b.length;
    final dp = List.generate(m + 1, (i) => List.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) { dp[i][0] = i; }
    for (var j = 0; j <= n; j++) { dp[0][j] = j; }
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((x, y) => x < y ? x : y);
        }
      }
    }
    return dp[m][n];
  }

  void _submitTypingAnswer() {
    if (widget.isAnswered) return;
    final typed = _textController.text.trim().toLowerCase();
    if (typed.isEmpty) return;
    final correct = widget.question.correctAnswer.toLowerCase();
    final distance = _editDistance(typed, correct);

    if (distance == 0) {
      // Exact match
      setState(() => _typingResult = true);
      widget.onTap(widget.question.correctAnswer);
    } else if (distance == 1) {
      // Near-miss: treat as correct but show the right spelling
      setState(() => _typingResult = null); // null = near-miss
      widget.onTap(widget.question.correctAnswer);
    } else {
      // Wrong
      setState(() => _typingResult = false);
      widget.onTap(typed);
    }
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == PracticeMode.typing) {
      return _buildTypingMode(context);
    }
    return _buildMultipleChoiceMode(context);
  }

  // ── Typing Mode ────────────────────────────────────────── //

  Widget _buildTypingMode(BuildContext context) {
    final correct = widget.question.correctAnswer;
    final isAnswered = widget.isAnswered;

    Color feedbackColor;
    String feedbackLabel;
    if (!isAnswered) {
      feedbackColor = Colors.transparent;
      feedbackLabel = '';
    } else if (_typingResult ?? false) {
      feedbackColor = const Color(0xff58CC02);
      feedbackLabel = 'Correct!';
    } else if (_typingResult == null) {
      feedbackColor = const Color(0xffFFC800);
      feedbackLabel = 'Close! The answer is "$correct"';
    } else {
      feedbackColor = const Color(0xffFF4B4B);
      feedbackLabel = 'Incorrect. The answer is "$correct"';
    }

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

          // TextField input
          Column(
            children: [
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                enabled: !isAnswered,
                decoration: InputDecoration(
                  hintText: 'Type your answer…',
                  filled: true,
                  fillColor: isAnswered
                      ? feedbackColor.withAlpha(20)
                      : const Color(0xffF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xffE94E77),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: isAnswered
                      ? Icon(
                          _typingResult == false
                              ? Icons.close_rounded
                              : Icons.check_rounded,
                          color: feedbackColor,
                        )
                      : null,
                ),
                onSubmitted: (_) => _submitTypingAnswer(),
              ),

              // Feedback label (shown after answering)
              if (isAnswered && feedbackLabel.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  feedbackLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: feedbackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ],

              const SizedBox(height: 16),

              // Submit button (hidden once answered)
              if (!isAnswered)
                PushableButton(
                  width: double.infinity,
                  height: 50,
                  buttonColor: const Color(0xffE94E77),
                  shadowColor: const Color(0xff963E00),
                  text: 'Submit',
                  onTap: _submitTypingAnswer,
                )
                    .animate(controller: _animationController)
                    .fadeIn(delay: 200.ms, duration: 250.ms),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Multiple Choice Mode ───────────────────────────────── //

  Widget _buildMultipleChoiceMode(BuildContext context) {
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

                var buttonColor = const Color(0xffF1F1F1);
                var backgroundColor = const Color(0xffF1F1F1);
                var shadowColor = Colors.grey.shade300;
                var textColor = Colors.black87;

                if (widget.isAnswered) {
                  if (isSelected || isCorrect) {
                    if (isCorrect) {
                      buttonColor = const Color(0xff58CC02);
                      shadowColor = const Color(0xff58A700);
                      backgroundColor = const Color(0xffBCFFC8);
                    } else if (isSelected) {
                      buttonColor = const Color(0xffFF4B4B);
                      shadowColor = const Color(0xffE94E77);
                      backgroundColor = const Color(0xffFFCCDA);
                    }
                  }
                } else if (isSelected) {
                  buttonColor = const Color(0xff1CB0F6);
                  textColor = Colors.white;
                }

                Widget button = QuizButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 56,
                  buttonColor: buttonColor,
                  backgroundColor: backgroundColor,
                  shadowColor: shadowColor,
                  textColor: textColor,
                  text: option,
                  onTap: widget.isAnswered
                      ? () {}
                      : () {
                          Gaimon.light();
                          widget.onTap(option);
                        },
                );

                if (widget.isAnswered) {
                  if (isCorrect) {
                    button = button
                        .animate()
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
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(child: button),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
