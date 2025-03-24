import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

class StreakGoalPage extends StatelessWidget {
  const StreakGoalPage({super.key});

  void _selectStreakGoal(BuildContext context, int streakGoal) {
    context.read<OnboardingCubit>()
      ..selectStreakGoal(streakGoal)
      ..nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'How many days in a row will you learn words?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the number of consecutive days you aim to learn words.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: '🌱 7 days',
                selected: state.streakGoal == 7,
                onTap: () {
                  _selectStreakGoal(context, 7);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '⏳ 14 days',
                selected: state.streakGoal == 14,
                onTap: () {
                  _selectStreakGoal(context, 14);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '🏆 30 days',
                selected: state.streakGoal == 30,
                onTap: () {
                  _selectStreakGoal(context, 30);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
