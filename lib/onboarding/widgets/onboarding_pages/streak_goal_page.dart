import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/onboarding/widgets/selector.dart';

class StreakGoalPage extends StatelessWidget {
  const StreakGoalPage({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
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
                text: '7 days',
                selected: state.streakGoal == 7,
                onTap: () {
                  cubit.selectStreakGoal(7);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '14 days',
                selected: state.streakGoal == 14,
                onTap: () {
                  cubit.selectStreakGoal(14);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '30 days',
                selected: state.streakGoal == 30,
                onTap: () {
                  cubit.selectStreakGoal(30);
                  onNext();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
