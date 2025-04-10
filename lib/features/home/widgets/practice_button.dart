import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/home/cubit/learning_progress_cubit.dart';
import 'package:wordstock/features/practice/practice.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// A button that handles practice functionality with subscription check
class PracticeButton extends StatelessWidget {
  /// Creates a new instance of [PracticeButton]
  const PracticeButton({super.key});

  Future<void> _handlePracticeClick(BuildContext context) async {
    final state = context.read<SubscriptionCubit>().state;
    final navigator = context.go;

    await state.maybeWhen(
      loaded: (isSubscribed) async {
        if (isSubscribed) {
          await context.read<LearningProgressCubit>().startPractice();
          navigator(PracticePage.name);
        } else {
          // Show paywall if not subscribed
          await context.read<SubscriptionCubit>().showPaywall();
        }
      },
      orElse: () async {
        // If state is not loaded, check subscription first
        await context.read<SubscriptionCubit>().checkSubscription();
      },
    );
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
