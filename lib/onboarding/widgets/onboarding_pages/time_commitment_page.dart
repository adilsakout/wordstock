import 'package:flutter/material.dart';
import 'package:wordstock/onboarding/cubit/cubit.dart';
import 'package:wordstock/onboarding/widgets/selector.dart';

class TimeCommitmentPage extends StatelessWidget {
  const TimeCommitmentPage({super.key});

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
                'How much time will you devote to learning?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose the amount of time you can commit to learning each day.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: '5 minute a day',
                selected: state.selectedTimeCommitment == 0,
                onTap: () {
                  cubit.selectTimeCommitment(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '10 minutes a day',
                selected: state.selectedTimeCommitment == 1,
                onTap: () {
                  cubit.selectTimeCommitment(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '15 minutes a day',
                selected: state.selectedTimeCommitment == 2,
                onTap: () {
                  cubit.selectTimeCommitment(2);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '30 minutes a day',
                selected: state.selectedTimeCommitment == 3,
                onTap: () {
                  cubit.selectTimeCommitment(3);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
