import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

class VocabularyLevelPage extends StatelessWidget {
  const VocabularyLevelPage({super.key});

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
                'What is your Vocabulary Level?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the level that best describes your current vocabulary.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Beginner',
                selected: state.vocabularyLevel == 0,
                onTap: () {
                  cubit.selectVocabularyLevel(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Intermediate',
                selected: state.vocabularyLevel == 1,
                onTap: () {
                  cubit.selectVocabularyLevel(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Advanced',
                selected: state.vocabularyLevel == 2,
                onTap: () {
                  cubit.selectVocabularyLevel(2);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
