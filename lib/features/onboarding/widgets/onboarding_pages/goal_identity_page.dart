import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';

/// Screen 1: Goal Identity Page
///
/// Asks the user "What's your goal with English?" and provides 4 selectable
/// options. The CTA is disabled until the user makes a selection.
/// Follows Apple Human Interface Guidelines with clean, modern design.
class GoalIdentityPage extends StatelessWidget {
  const GoalIdentityPage({super.key});

  // Goal options with their identifiers (short text that fits one line)
  static const List<String> _goalIds = [
    'speak_confidently',
    'grow_vocabulary',
    'prepare_work_exams',
    'mix_similar_words',
    'sound_natural',
  ];

  /// Get localized goal text for a goal id
  String _getGoalText(BuildContext context, String goalId) {
    final l10n = context.l10n;
    switch (goalId) {
      case 'speak_confidently':
        return l10n.onboardingGoalSpeakConfidently;
      case 'grow_vocabulary':
        return l10n.onboardingGoalGrowVocabulary;
      case 'prepare_work_exams':
        return l10n.onboardingGoalPrepareWorkExams;
      case 'mix_similar_words':
        return l10n.onboardingGoalMixSimilarWords;
      case 'sound_natural':
        return l10n.onboardingGoalSoundNatural;
      default:
        return goalId;
    }
  }

  /// Handles goal selection with visual feedback and state update
  void _selectGoal(BuildContext context, String goalId) {
    // Provide soft haptic feedback
    Gaimon.soft();

    final cubit = context.read<OnboardingCubit>()
      ..setTempOnboardingGoal(goalId);

    // Add slight delay for UX - allows user to see selection before transition
    Future.delayed(const Duration(milliseconds: 300), () {
      cubit.selectOnboardingGoal(goalId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title with entrance animation
                Text(
                  context.l10n.onboardingGoalTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
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
                  context.l10n.onboardingGoalSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
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

                const SizedBox(height: 40),

                // Goal options with staggered animations
                ...List.generate(
                  _goalIds.length,
                  (index) {
                    final goalId = _goalIds[index];
                    final goalText = _getGoalText(context, goalId);

                    // Check if this goal is selected
                    //(either confirmed or temp)
                    final isSelected = state.onboardingGoal == goalId ||
                        state.tempSelectedGoal == goalId;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _goalIds.length - 1 ? 16 : 0,
                        left: 16,
                        right: 16,
                      ),
                      child: AnimatedScale(
                        scale: isSelected ? 1.02 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutQuad,
                        child: Selector(
                          text: goalText,
                          selected: isSelected,
                          onTap: () => _selectGoal(context, goalId),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 500.ms,
                            delay: (800 + (index * 100)).ms,
                            curve: Curves.easeOut,
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 500.ms,
                            delay: (800 + (index * 100)).ms,
                            curve: Curves.easeOut,
                          )
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                            delay: (800 + (index * 100)).ms,
                            curve: Curves.easeOut,
                          ),
                    );
                  },
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
