import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
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
                'What is your gender?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your gender will be used to personalize your experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: '👦 Male',
                selected: state.selectedGender == 0,
                onTap: () {
                  cubit.selectGender(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '👩‍🦰 Female',
                selected: state.selectedGender == 1,
                onTap: () {
                  cubit.selectGender(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '👤 Other',
                selected: state.selectedGender == 2,
                onTap: () {
                  cubit.selectGender(2);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
