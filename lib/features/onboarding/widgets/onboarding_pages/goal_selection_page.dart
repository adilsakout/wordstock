import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';

class GoalSelectionPage extends StatelessWidget {
  const GoalSelectionPage({super.key});

  List<String> _getLocalizedGoals(AppLocalizations l10n) {
    return [
      l10n.goalMasteringWords,
      l10n.goalImprovingMemory,
      l10n.goalSpeakingConfidence,
      l10n.goalWritingClearly,
      l10n.goalUnderstandingContent,
      l10n.goalReachingLanguageGoals,
    ];
  }

  void _selectGoal(BuildContext context, String goal) {
    context.read<OnboardingCubit>()
      ..selectGoal(goal)
      ..nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final goals = _getLocalizedGoals(l10n);

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                l10n.goalSelectionTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.goalSelectionDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              ...goals.map(
                (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Selector(
                    text: goal,
                    selected: state.selectedGoals.isNotEmpty &&
                        state.selectedGoals.contains(goal),
                    onTap: () {
                      _selectGoal(context, goal);
                    },
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
