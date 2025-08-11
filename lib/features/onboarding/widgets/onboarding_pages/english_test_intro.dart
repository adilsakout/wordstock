import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template english_test_intro}
/// Introduction screen for the English test onboarding page.
/// {@endtemplate}
class EnglishTestIntro extends StatelessWidget {
  /// {@macro english_test_intro}
  const EnglishTestIntro({
    required this.onStartTest,
    required this.onSkip,
    super.key,
  });

  /// Callback when user wants to start the test
  final VoidCallback onStartTest;

  /// Callback when user wants to skip the test
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 2),
          // Enhanced Lottie animation with sophisticated entrance
          Semantics(
            label: l10n.onboardingEnglishTestIcon,
            child: Lottie.asset(
              'assets/lottie/experiment.json',
              repeat: true,
              fit: BoxFit.contain,
            ),
          )
              .animate()
              .fadeIn(
                duration: 800.ms,
                delay: 200.ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 800.ms,
                delay: 200.ms,
                curve: Curves.easeOut,
              )
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 800.ms,
                delay: 200.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 20),

          // Title with sophisticated fade-in animation
          Text(
            l10n.onboardingEnglishTestTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: 600.ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 600.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 20),

          // Subtitle with gentle fade-in animation
          Semantics(
            label: l10n.onboardingEnglishTestSubtitle,
            child: Text(
              l10n.onboardingEnglishTestSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: 900.ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.15,
                end: 0,
                duration: 600.ms,
                delay: 900.ms,
                curve: Curves.easeOut,
              ),

          const Spacer(flex: 3),

          // Start test button with sophisticated entrance animation
          Semantics(
            label: l10n.onboardingEnglishTestStart,
            child: PushableButton(
              width: 280,
              height: 60,
              borderRadius: 25,
              text: l10n.onboardingEnglishTestStart,
              buttonColor: const Color(0xFF1CB0F6),
              shadowColor: const Color(0xFF1899D6),
              onTap: onStartTest,
            ),
          )
              .animate()
              .fadeIn(
                duration: 600.ms,
                delay: 1200.ms,
                curve: Curves.easeOut,
              )
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 1200.ms,
                curve: Curves.easeOut,
              )
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: 600.ms,
                delay: 1200.ms,
                curve: Curves.easeOut,
              ),

          // Skip option with subtle fade-in animation
          Semantics(
            label: l10n.onboardingEnglishTestSkip,
            child: GestureDetector(
              onTap: onSkip,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.onboardingEnglishTestSkip,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(
                duration: 600.ms,
                delay: 1500.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
