import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template english_test_result}
/// Results screen for the English test onboarding page.
/// {@endtemplate}
class EnglishTestResult extends StatelessWidget {
  /// {@macro english_test_result}
  const EnglishTestResult({
    required this.correctCount,
    required this.totalQuestions,
    required this.onContinue,
    super.key,
  });

  /// Number of correctly answered questions
  final int correctCount;

  /// Total number of questions
  final int totalQuestions;

  /// Callback when user wants to continue to next page
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final percentage = (correctCount / totalQuestions * 100).round();

    String resultMessage;
    Color resultColor;
    IconData resultIcon;

    if (percentage >= 80) {
      resultMessage = l10n.onboardingEnglishTestExcellent;
      resultColor = const Color(0xff58CC02);
      resultIcon = Icons.star;
    } else if (percentage >= 60) {
      resultMessage = l10n.onboardingEnglishTestGood;
      resultColor = const Color(0xFF1CB0F6);
      resultIcon = Icons.thumb_up;
    } else {
      resultMessage = l10n.onboardingEnglishTestOkay;
      resultColor = const Color(0xffFFC800);
      resultIcon = Icons.lightbulb;
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Result icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              resultIcon,
              size: 60,
              color: resultColor,
            ),
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: const Duration(milliseconds: 600),
              ),

          const SizedBox(height: 30),

          // Result message
          Text(
            resultMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
          ),

          const SizedBox(height: 20),

          // Score display
          Text(
            l10n.onboardingEnglishTestScore(correctCount, totalQuestions),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

          // Percentage display
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
          ),

          const Spacer(flex: 3),

          // Continue button
          PushableButton(
            width: 280,
            height: 60,
            borderRadius: 25,
            text: l10n.continueText,
            buttonColor: resultColor,
            shadowColor: resultColor.withValues(alpha: 0.7),
            onTap: onContinue,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
