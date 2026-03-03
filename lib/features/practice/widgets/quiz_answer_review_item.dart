import 'package:flutter/material.dart';
import 'package:wordstock/model/models.dart';

/// A single row in the "Review Your Answers" section of the results screen.
class QuizAnswerReviewItem extends StatefulWidget {
  const QuizAnswerReviewItem({
    required this.question,
    required this.wasCorrect,
    required this.userAnswer,
    super.key,
  });

  final PracticeQuizQuestion question;
  final bool wasCorrect;
  final String? userAnswer;

  @override
  State<QuizAnswerReviewItem> createState() => _QuizAnswerReviewItemState();
}

class _QuizAnswerReviewItemState extends State<QuizAnswerReviewItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    const correctColor = Color(0xff58CC02);
    const wrongColor = Color(0xffFF4B4B);
    final color = widget.wasCorrect ? correctColor : wrongColor;
    final bgColor =
        widget.wasCorrect ? const Color(0xffEDFAE0) : const Color(0xffFFEEEE);

    // Extract the word being tested (the correct answer)
    final word = widget.question.correctAnswer;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.wasCorrect
                ? null
                : () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.wasCorrect
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: color,
                          ),
                        ),
                        if (!widget.wasCorrect && widget.userAnswer != null)
                          Text(
                            'Your answer: ${widget.userAnswer}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!widget.wasCorrect)
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: color,
                    ),
                ],
              ),
            ),
          ),
          if (!widget.wasCorrect && _expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  // Show the sentence with correct answer filled in
                  Text(
                    widget.question.question.replaceAll('___', word),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
