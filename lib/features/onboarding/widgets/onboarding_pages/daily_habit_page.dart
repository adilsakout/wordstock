import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

/// Screen 5: Daily Habit Page
///
/// Asks the user "How often do you want to practice?" with 3 options:
/// 5 min/day, 10 min/day, and 15 min/day.
/// The CTA is disabled until the user makes a selection.
class DailyHabitPage extends StatelessWidget {
  const DailyHabitPage({super.key});

  // Time options with their values and display text
  static const List<Map<String, dynamic>> _timeOptions = [
    {'minutes': 5, 'text': '5 min/day', 'emoji': '⚡️'},
    {'minutes': 10, 'text': '10 min/day', 'emoji': '⏱️'},
    {'minutes': 15, 'text': '15 min/day', 'emoji': '🚀'},
  ];

  /// Handles time selection with visual feedback and state update
  void _selectTime(BuildContext context, int minutes) {
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
        final size = MediaQuery.of(context).size;
        final theme = Theme.of(context);

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
                  const Spacer(),

                  // Title with entrance animation
                  Text(
                    'How often do you want to practice?',
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
                    'Consistency beats intensity.',
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
                      final text = option['text'] as String;
                      final emoji = option['emoji'] as String;

                      // Check if this time is selected (either confirmed or temp)
                      final isSelected = state.dailyMinutes == minutes ||
                          state.tempSelectedDailyMinutes == minutes;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < _timeOptions.length - 1 ? 16 : 0,
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

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
