import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';

/// Screen 2: Level Selection Page
///
/// Asks the user "What's your current level?" with 3 options:
/// Beginner, Intermediate, and Advanced.
/// The CTA is disabled until the user makes a selection.
class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  // Level options with their identifiers
  static const List<String> _levelIds = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  /// Get localized level text for a level id
  String _getLevelText(BuildContext context, String levelId) {
    final l10n = context.l10n;
    switch (levelId) {
      case 'beginner':
        return l10n.onboardingLevelBeginner;
      case 'intermediate':
        return l10n.onboardingLevelIntermediate;
      case 'advanced':
        return l10n.onboardingLevelAdvanced;
      default:
        return levelId;
    }
  }

  /// Handles level selection with visual feedback and state update
  void _selectLevel(BuildContext context, String levelId) {
    // Provide soft haptic feedback
    Gaimon.soft();

    final cubit = context.read<OnboardingCubit>()
      ..setTempOnboardingLevel(levelId);

    // Add slight delay for UX - allows user to see selection before transition
    Future.delayed(const Duration(milliseconds: 300), () {
      cubit.selectOnboardingLevel(levelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;

        return ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.04,
            ),
            child: Column(
              children: [
                // Title with entrance animation
                Text(
                  context.l10n.onboardingLevelTitle,
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
                  context.l10n.onboardingLevelSubtitle,
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

                const SizedBox(height: 48),

                // Level options with staggered animations
                ...List.generate(
                  _levelIds.length,
                  (index) {
                    final levelId = _levelIds[index];
                    final levelText = _getLevelText(context, levelId);

                    // Check if this level is selected
                    //(either confirmed or temp)
                    final isSelected = state.onboardingLevel == levelId ||
                        state.tempSelectedLevel == levelId;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _levelIds.length - 1 ? 16 : 0,
                      ),
                      child: AnimatedScale(
                        scale: isSelected ? 1.02 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutQuad,
                        child: Selector(
                          text: levelText,
                          selected: isSelected,
                          onTap: () => _selectLevel(context, levelId),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
