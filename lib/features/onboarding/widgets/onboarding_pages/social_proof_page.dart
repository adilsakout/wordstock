import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/core/theme/app_theme.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// Screen 7: Social Proof Page
///
/// Shows social proof with learner count and ratings to encourage the user.
/// The CTA "Continue" navigates to the paywall/subscription screen.
class SocialProofPage extends StatelessWidget {
  const SocialProofPage({super.key});

  /// Handles the continue action - marks onboarding complete and shows paywall
  Future<void> _onContinue(BuildContext context) async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    // Save onboarding data
    if (context.mounted) {
      await context.read<OnboardingCubit>().saveOnboardingData();

      // Navigate to paywall and show it
      if (context.mounted) {
        // First navigate to home
        context.go('/home');

        // Then show the paywall
        await Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            context.read<SubscriptionCubit>().showPaywall();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.04,
          ),
          child: Column(
            children: [
              // Title with entrance animation
              Text(
                context.l10n.onboardingProofTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  height: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms),

              // Stats container
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surface : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Learner count stat
                    _SocialProofStat(
                      icon: Icons.people_alt,
                      iconColor: AppColors.primaryBlue,
                      value: '42,000+',
                      label: context.l10n.onboardingProofLearnerLabel,
                      delay: 800,
                    ),

                    const SizedBox(height: 28),

                    // Divider with decoration
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.primaryYellow,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 1000.ms),

                    const SizedBox(height: 28),

                    // Rating stat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stars
                        ...List.generate(
                          5,
                          (index) => const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.star,
                              size: 28,
                              color: AppColors.primaryYellow,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 600.ms, delay: 1100.ms).scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: 600.ms,
                          delay: 1100.ms,
                        ),

                    const SizedBox(height: 12),

                    // Rating text
                    Text(
                      context.l10n.onboardingProofRating,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 1300.ms),

                    const SizedBox(height: 4),

                    Text(
                      context.l10n.onboardingProofAppStore,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 1400.ms),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 700.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    delay: 700.ms,
                  ),

              const Spacer(flex: 2),

              // CTA Button
              PushableButton(
                height: 56,
                borderRadius: 16,
                text: 'Continue',
                onTap: () => _onContinue(context),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1600.ms)
                  .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 1600.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// A social proof statistic widget
class _SocialProofStat extends StatelessWidget {
  const _SocialProofStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.delay,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),

        const SizedBox(height: 16),

        // Value
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),

        const SizedBox(height: 8),

        // Label
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: delay.ms)
        .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: delay.ms);
  }
}
