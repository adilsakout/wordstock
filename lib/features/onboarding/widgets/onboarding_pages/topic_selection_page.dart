import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

class TopicSelectionPage extends StatelessWidget {
  const TopicSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                l10n.topicSelectionTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.topicSelectionDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.topicSociety,
                selected: state.selectedTopics.contains(0),
                isMultipleChoice: true,
                onTap: () {
                  cubit.toggleTopic(0);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.topicForeignLanguages,
                selected: state.selectedTopics.contains(1),
                isMultipleChoice: true,
                onTap: () {
                  cubit.toggleTopic(1);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.topicHumanBody,
                selected: state.selectedTopics.contains(2),
                isMultipleChoice: true,
                onTap: () {
                  cubit.toggleTopic(2);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.topicEmotions,
                selected: state.selectedTopics.contains(3),
                isMultipleChoice: true,
                onTap: () {
                  cubit.toggleTopic(3);
                },
              ),
              const SizedBox(height: 16),
              Selector(
                text: l10n.topicOther,
                selected: state.selectedTopics.contains(5),
                isMultipleChoice: true,
                onTap: () {
                  cubit.toggleTopic(5);
                },
              ),
              const Spacer(),
              PushableButton(
                width: 200,
                height: 56,
                text: l10n.continueText,
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
