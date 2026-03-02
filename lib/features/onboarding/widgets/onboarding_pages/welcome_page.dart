import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:wordstock/core/theme/app_theme.dart';
import 'package:wordstock/features/onboarding/onboarding.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// Welcome screen — the first screen users see before the onboarding flow.
///
/// Purpose: Set value context and reduce friction before asking questions.
/// This screen does NOT count toward the 7-step progress indicator.
///
/// Layout follows Apple Human Interface Guidelines:
/// - Clean, centered content hierarchy
/// - Concise value proposition with bullet points
/// - Social proof line for credibility
/// - Primary CTA ("Build my plan") + secondary skip action
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  /// Navigates to the first onboarding step (Goal / Identity)
  void _handleBuildPlan(BuildContext context) {
    context.read<OnboardingCubit>().nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return ColoredBox(
          color: theme.colorScheme.surface,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Lottie animation - clean and simple with fade-in animation
                  SizedBox(
                    child: Lottie.asset(
                      'assets/lottie/welcome.json',
                      repeat: true,
                      animate: true,
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
                      ),

                  const SizedBox(height: 32),

                  // ──────────────────────────────────────────────
                  // Subtitle: Value proposition in one line
                  // ──────────────────────────────────────────────
                  Text(
                    l10n.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(
                        begin: 0.15,
                        end: 0,
                        duration: 600.ms,
                        delay: 700.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 40),

                  // ──────────────────────────────────────────────
                  // Three bullet points — concise value anchors
                  // ──────────────────────────────────────────────
                  _BulletItem(
                    icon: Icons.tune,
                    text: l10n.welcomeBulletPersonalized,
                    delay: 900,
                  ),
                  const SizedBox(height: 16),
                  _BulletItem(
                    icon: Icons.psychology,
                    text: l10n.welcomeBulletSmartReviews,
                    delay: 1050,
                  ),
                  const SizedBox(height: 16),
                  _BulletItem(
                    icon: Icons.speed,
                    text: l10n.welcomeBulletAssessments,
                    delay: 1200,
                  ),

                  const SizedBox(height: 32),

                  // ──────────────────────────────────────────────
                  // Social proof line — small, subtle credibility
                  // ──────────────────────────────────────────────
                  Text(
                    l10n.welcomeSocialProof,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(duration: 500.ms, delay: 1400.ms),

                  const Spacer(flex: 3),

                  // ──────────────────────────────────────────────
                  // Primary CTA: "Build my plan"
                  // ──────────────────────────────────────────────
                  PushableButton(
                    height: 56,
                    borderRadius: 16,
                    text: l10n.welcomeCta,
                    onTap: () => _handleBuildPlan(context),
                  ).animate().fadeIn(duration: 600.ms, delay: 1500.ms).slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 1500.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A single bullet item with an icon and text, used on the welcome screen.
/// Matches existing design patterns (icon + label row) with staggered
/// entrance animations.
class _BulletItem extends StatelessWidget {
  const _BulletItem({
    required this.icon,
    required this.text,
    required this.delay,
  });

  final IconData icon;
  final String text;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Icon container matching existing stat row patterns
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        // Bullet text
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: delay.ms).slideX(
          begin: 0.08,
          end: 0,
          duration: 500.ms,
          delay: delay.ms,
          curve: Curves.easeOut,
        );
  }
}
