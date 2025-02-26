import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/onboarding/widgets/selector.dart';
import 'package:wordstock/widgets/button.dart';

class TopicSelectionPage extends StatelessWidget {
  const TopicSelectionPage({super.key});

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
                'Which topics are you interested in?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the topics that you are most interested in learning about.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Society',
                selected: state.selectedTopics.contains(0),
                onTap: () {
                  cubit.toggleTopic(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Words in foreign languages',
                selected: state.selectedTopics.contains(1),
                onTap: () {
                  cubit.toggleTopic(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Human body',
                selected: state.selectedTopics.contains(2),
                onTap: () {
                  cubit.toggleTopic(2);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Emotions',
                selected: state.selectedTopics.contains(3),
                onTap: () {
                  cubit.toggleTopic(3);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: 'Other',
                selected: state.selectedTopics.contains(5),
                onTap: () {
                  cubit.toggleTopic(5);
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
