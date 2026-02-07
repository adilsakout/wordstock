import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/core/theme/app_theme.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// Screen 6: Plan Reveal Page
///
/// Shows a personalized summary of the user's WordStock plan based on
/// their selections: goal, level, and daily minutes.
/// Presents a bullet list of what they'll get.
class PlanRevealPage extends StatelessWidget {
  const PlanRevealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        // Get display values from state
        final goalId = state.onboardingGoal;
        final levelId = state.onboardingLevel;
        final dailyMinutes = state.dailyMinutes ?? 10;

        // Get localized goal text
        String goalText;
        switch (goalId) {
          case 'speak_confidently':
            goalText = context.l10n.onboardingGoalSpeakConfidently;
          case 'grow_vocabulary':
            goalText = context.l10n.onboardingGoalGrowVocabulary;
          case 'prepare_work_exams':
            goalText = context.l10n.onboardingGoalPrepareWorkExams;
          case 'travel_without_stress':
            goalText = context.l10n.onboardingGoalTravelWithoutStress;
          default:
            goalText = state.goalDisplayText;
        }

        // Get localized level text
        String levelText;
        switch (levelId) {
          case 'beginner':
            levelText = context.l10n.onboardingLevelBeginner;
          case 'intermediate':
            levelText = context.l10n.onboardingLevelIntermediate;
          case 'advanced':
            levelText = context.l10n.onboardingLevelAdvanced;
          default:
            levelText = state.levelDisplayText;
        }

        return ColoredBox(
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Title with entrance animation
                Text(
                  context.l10n.onboardingPlanTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    height: 1.2,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 600.ms,
                      delay: 200.ms,
                    ),
                const SizedBox(height: 16),

                // Summary card showing user selections
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? theme.colorScheme.surface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 8,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: AppColors.primaryBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.l10n.onboardingPlanYourPlan,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      // Goal row
                      _PlanDetailRow(
                        icon: Icons.flag,
                        label: context.l10n.onboardingPlanGoalLabel,
                        value: goalText,
                        delay: 600,
                      ),

                      // Level row
                      _PlanDetailRow(
                        icon: Icons.trending_up,
                        label: context.l10n.onboardingPlanLevelLabel,
                        value: levelText,
                        delay: 750,
                      ),

                      // Daily commitment row
                      _PlanDetailRow(
                        icon: Icons.schedule,
                        label: context.l10n.onboardingPlanDailyLabel,
                        value:
                            context.l10n.onboardingPlanDailyValue(dailyMinutes),
                        delay: 900,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms).scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      delay: 500.ms,
                    ),

                const SizedBox(height: 32),

                // What you'll get section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surface
                        : AppColors.primaryGreen.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.onboardingPlanWhatYouGet,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Bullet points
                      _BulletPoint(
                        text: context.l10n
                            .onboardingPlanDailyLessons(dailyMinutes),
                        delay: 1100,
                      ),
                      const SizedBox(height: 10),
                      _BulletPoint(
                        text: context.l10n.onboardingPlanWordsMatchedLevel,
                        delay: 1200,
                      ),
                      const SizedBox(height: 10),
                      _BulletPoint(
                        text: context.l10n.onboardingPlanSmartReviews,
                        delay: 1300,
                      ),
                      const SizedBox(height: 10),
                      _BulletPoint(
                        text: context.l10n.onboardingPlanProgressTracking,
                        delay: 1400,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 1000.ms).slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 600.ms,
                      delay: 1000.ms,
                    ),

                const SizedBox(height: 24),

                // CTA Button
                PushableButton(
                  height: 56,
                  width: size.width * 0.8,
                  borderRadius: 16,
                  text: 'Next',
                  onTap: () => context.read<OnboardingCubit>().nextPage(),
                ).animate().fadeIn(duration: 600.ms, delay: 1500.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      delay: 1500.ms,
                    ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A row showing a plan detail (icon, label, value)
class _PlanDetailRow extends StatelessWidget {
  const _PlanDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.delay,
  });

  final IconData icon;
  final String label;
  final String value;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms, delay: delay.ms);
  }
}

/// A bullet point item for the benefits list
class _BulletPoint extends StatelessWidget {
  const _BulletPoint({
    required this.text,
    required this.delay,
  });

  final String text;
  final int delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms, delay: delay.ms);
  }
}
