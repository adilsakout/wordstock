import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';
import 'package:wordstock/features/home/cubit/learning_progress_cubit.dart';
import 'package:wordstock/features/practice/practice.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/services/posthog_service.dart';
import 'package:wordstock/widgets/button.dart';

class PracticeReminderPage extends StatelessWidget {
  const PracticeReminderPage({
    required this.onContinue,
    super.key,
  });

  final VoidCallback onContinue;

  Future<void> _handlePracticeButtonTap(BuildContext context) async {
    PosthogService.instance.track(
      'Practice Reminder Action',
      properties: {'action': 'start_practice'},
    );
    final creditCubit = context.read<CreditCubit>();

    // Subscribers bypass credit system
    if (creditCubit.state.isSubscribed) {
      final learningCubit = context.read<LearningProgressCubit>();
      await learningCubit.startPractice();
      if (context.mounted) {
        await context.push(PracticePage.name);
      }
      return;
    }

    // Free users: try to consume a credit
    final allowed = await creditCubit.tryConsumeCredit();
    if (!allowed) {
      if (!context.mounted) return;
      await context
          .read<SubscriptionCubit>()
          .showPaywall(source: 'credit_exhausted_practice');
      return;
    }

    if (!context.mounted) return;
    final learningCubit = context.read<LearningProgressCubit>();
    await learningCubit.startPractice();
    if (context.mounted) {
      await context.push(PracticePage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final learningState =
        context.select<LearningProgressCubit, LearningProgressState>(
      (cubit) => cubit.state,
    );

    // Use the cumulative word count instead of just words since last reminder
    final wordCount = learningState.cumulativeWords;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.practiceReminderTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xff1CB0F6),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 300),
              ),
          const SizedBox(height: 16),
          Text(
            l10n.practiceReminderDescription(wordCount),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 600),
              ),
          const SizedBox(height: 48),
          PushableButton(
            height: 50,
            text: l10n.startPractice,
            spacing: 10,
            iconSize: 25,
            prefixIcon: Icons.gamepad_rounded,
            onTap: () => _handlePracticeButtonTap(context),
          ).animate().fadeIn(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
              ),
          const SizedBox(height: 16),
          PushableButton(
            text: l10n.continueLearning,
            onTap: onContinue,
            height: 56,
            buttonColor: const Color(0xff1CB0F6),
            shadowColor: const Color(0xff1899D6),
          ).animate().fadeIn(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 800),
              ),
        ],
      ),
    );
  }
}
