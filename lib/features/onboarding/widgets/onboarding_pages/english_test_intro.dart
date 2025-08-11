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
    required this.animationController,
    super.key,
  });

  /// Callback when user wants to start the test
  final VoidCallback onStartTest;

  /// Callback when user wants to skip the test
  final VoidCallback onSkip;

  /// Animation controller for entrance animations
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Semantics(
            label: l10n.onboardingEnglishTestIcon,
            child: Lottie.asset(
              'assets/lottie/experiment.json',
              repeat: true,
              fit: BoxFit.contain,
            ),
          ).animate(controller: animationController).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: const Duration(milliseconds: 600),
              ),

          const SizedBox(height: 20),

          // Title
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
              .animate(controller: animationController)
              .slideY(
                begin: 0.3,
                end: 0,
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 600),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 600),
              ),

          const SizedBox(height: 20),

          // Subtitle
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
              .animate(controller: animationController)
              .slideY(
                begin: 0.3,
                end: 0,
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100),
              ),

          const Spacer(flex: 3),

          // Start test button
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
              .animate(controller: animationController)
              .slideY(
                begin: 0.5,
                end: 0,
                curve: Curves.elasticOut,
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
              )
              .fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
              ),

          // Skip option
          const SizedBox(height: 16),

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
          ).animate(controller: animationController).fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
              ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
