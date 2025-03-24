import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

class AgeSelectionPage extends StatefulWidget {
  const AgeSelectionPage({super.key});

  @override
  State<AgeSelectionPage> createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
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
                'How old are you?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your age will be used to personalize your experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: '🎒 13 to 17',
                selected: state.selectedAgeRange == 0,
                onTap: () {
                  cubit.selectAgeRange(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '🎓 18 to 24',
                selected: state.selectedAgeRange == 1,
                onTap: () {
                  cubit.selectAgeRange(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '💼 25 to 34',
                selected: state.selectedAgeRange == 2,
                onTap: () {
                  cubit.selectAgeRange(2);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '🍀 35 to 44',
                selected: state.selectedAgeRange == 3,
                onTap: () {
                  cubit.selectAgeRange(3);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: '🌟 45 and above',
                selected: state.selectedAgeRange == 4,
                onTap: () {
                  cubit.selectAgeRange(4);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
