import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';

/// Screen 5: Daily Habit Page
///
/// Asks the user "How often do you want to practice?" with 3 options:
/// 5 min/day, 10 min/day, and 15 min/day.
/// The CTA is disabled until the user makes a selection.
class DailyHabitPage extends StatelessWidget {
  const DailyHabitPage({super.key});

  // Time options with their values and emoji
  static const List<Map<String, dynamic>> _timeOptions = [
    {'minutes': 5, 'emoji': '⚡️'},
    {'minutes': 10, 'emoji': '⏱️'},
    {'minutes': 15, 'emoji': '🚀'},
  ];

  /// Get localized text for daily habit option
  String _getHabitText(BuildContext context, int minutes) {
    final l10n = context.l10n;
    switch (minutes) {
      case 5:
        return l10n.onboardingDailyHabit5min;
      case 10:
        return l10n.onboardingDailyHabit10min;
      case 15:
        return l10n.onboardingDailyHabit15min;
      default:
        return '$minutes min/day';
    }
  }

  /// Handles time selection with visual feedback and state update
  void _selectTime(BuildContext context, int minutes) {
    // Provide soft haptic feedback
    Gaimon.soft();

    final cubit = context.read<OnboardingCubit>()..setTempDailyMinutes(minutes);

    // Add slight delay for UX - allows user to see selection before transition
    Future.delayed(const Duration(milliseconds: 300), () {
      cubit.selectDailyMinutes(minutes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return ColoredBox(
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title with entrance animation
                Text(
                  context.l10n.onboardingDailyHabitTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    height: 1.2,
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: 600.ms,
                      delay: 200.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 600.ms,
                      delay: 200.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 16),

                // Subtitle with gentle fade-in animation
                Text(
                  context.l10n.onboardingDailyHabitSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: 600.ms,
                      delay: 500.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      delay: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 48),

                // Time options with staggered animations
                ...List.generate(
                  _timeOptions.length,
                  (index) {
                    final option = _timeOptions[index];
                    final minutes = option['minutes'] as int;
                    final text = _getHabitText(context, minutes);
                    final emoji = option['emoji'] as String;

                    // Check if this time is selected
                    //(either confirmed or temp)
                    final isSelected = state.dailyMinutes == minutes ||
                        state.tempSelectedDailyMinutes == minutes;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _timeOptions.length - 1 ? 16 : 0,
                        left: 16,
                        right: 16,
                      ),
                      child: AnimatedScale(
                        scale: isSelected ? 1.02 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutQuad,
                        child: Selector(
                          text: '$emoji $text',
                          selected: isSelected,
                          onTap: () => _selectTime(context, minutes),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 500.ms,
                            delay: (800 + (index * 120)).ms,
                            curve: Curves.easeOut,
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 500.ms,
                            delay: (800 + (index * 120)).ms,
                            curve: Curves.easeOut,
                          )
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                            delay: (800 + (index * 120)).ms,
                            curve: Curves.easeOut,
                          ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Helper text — frames notifications as coaching,
                // sets expectation for gentle reminders
                Text(
                  context.l10n.onboardingDailyHabitHelper,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ).animate().fadeIn(
                      duration: 500.ms,
                      delay: 1200.ms,
                      curve: Curves.easeOut,
                    ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
