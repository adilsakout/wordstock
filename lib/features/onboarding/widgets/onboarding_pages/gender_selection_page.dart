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
              Text(
                'What is your gender?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your gender will be used to personalize your experience.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
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
