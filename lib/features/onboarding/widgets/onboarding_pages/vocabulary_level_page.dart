import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

class VocabularyLevelPage extends StatelessWidget {
  const VocabularyLevelPage({super.key});

  void _selectVocabularyLevel(BuildContext context, int level) {
    context.read<OnboardingCubit>()
      ..selectVocabularyLevel(level)
      ..nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        context.read<OnboardingCubit>();
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
              ...List.generate(
                VocabularyLevels.all.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < VocabularyLevels.all.length - 1 ? 16 : 0,
                  ),
                  child: Selector(
                    text: VocabularyLevels.all[index].fullDisplayText,
                    selected: state.vocabularyLevel == index,
                    onTap: () {
                      _selectVocabularyLevel(context, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
