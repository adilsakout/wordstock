import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/widgets/button.dart';

class GoalSelectionPage extends StatelessWidget {
  const GoalSelectionPage({super.key});

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
                'What are your learning goals?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the goals that best describe your learning objectives.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Enhance my lexicon',
                selected: state.selectedGoals.contains(0),
                onTap: () {
                  cubit.toggleGoal(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Get ready for a test',
                selected: state.selectedGoals.contains(1),
                onTap: () {
                  cubit.toggleGoal(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Improve my job prospects',
                selected: state.selectedGoals.contains(2),
                onTap: () {
                  cubit.toggleGoal(2);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Enjoy learning new words',
                selected: state.selectedGoals.contains(3),
                onTap: () {
                  cubit.toggleGoal(3);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Other',
                selected: state.selectedGoals.contains(4),
                onTap: () {
                  cubit.toggleGoal(4);
                },
              ),
              const Spacer(),
              PushableButton(
                width: 200,
                height: 56,
                text: 'Continue',
                onTap: cubit.nextPage,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
