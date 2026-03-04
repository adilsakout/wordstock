import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';
import 'package:wordstock/features/home/cubit/learning_progress_cubit.dart';
import 'package:wordstock/features/practice/practice.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/services/posthog_service.dart';
import 'package:wordstock/widgets/button.dart';

/// A button that handles practice functionality with subscription check
class PracticeButton extends StatelessWidget {
  /// Creates a new instance of [PracticeButton]
  const PracticeButton({super.key});

  Future<void> _handlePracticeClick(BuildContext context) async {
    final creditCubit = context.read<CreditCubit>();
    final navigator = context.go;

    // Subscribers bypass credit system
    if (creditCubit.state.isSubscribed) {
      await context.read<LearningProgressCubit>().startPractice();
      navigator(PracticePage.name);
      return;
    }

    // Free users: try to consume a credit
    final allowed = await creditCubit.tryConsumeCredit();
    if (!allowed) {
      // Track Credit Exhausted
      PosthogService.instance.track(
        'Credit Exhausted',
        properties: {
          'feature': 'practice',
          'credits_used_today': 3 - creditCubit.state.creditsRemaining,
        },
      );
      if (!context.mounted) return;
      await context
          .read<SubscriptionCubit>()
          .showPaywall(source: 'credit_exhausted_practice');
      return;
    }

    if (!context.mounted) return;
    await context.read<LearningProgressCubit>().startPractice();
    navigator(PracticePage.name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, subscriptionState) {
        return PushableButton(
          width: 140,
          height: 50,
          text: l10n.practiceButtonText,
          spacing: 10,
          iconSize: 25,
          prefixIcon: Icons.gamepad_rounded,
          onTap: () => _handlePracticeClick(context),
        );
      },
    );
  }
}
