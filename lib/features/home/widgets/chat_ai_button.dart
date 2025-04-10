import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/home/cubit/chat_ai_cubit.dart';
import 'package:wordstock/features/home/widgets/chat_ai_bottom_sheet.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

/// A button that opens the chat with AI bottom sheet for a specific word
/// Only available for subscribed users
class ChatAIButton extends StatelessWidget {
  /// Creates a new instance of [ChatAIButton]
  const ChatAIButton({
    required this.word,
    super.key,
  });

  /// The word to chat about
  final Word word;

  /// Checks if the user has an active subscription.
  bool _isUserSubscribed(SubscriptionState state) => state.maybeWhen(
        loaded: (isSubscribed) => isSubscribed,
        orElse: () => false,
      );

  /// Shows the chat bottom sheet for the given word.
  Future<void> _showChatBottomSheet(BuildContext context) async {
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => ChatAICubit(),
        child: ChatAIBottomSheet(word: word),
      ),
    );
  }

  /// Handles the button tap action.
  /// Shows paywall for non-subscribers, chat for subscribers.
  Future<void> _handleTap(BuildContext context) async {
    Gaimon.soft();

    final subscriptionCubit = context.read<SubscriptionCubit>();
    final isSubscribed = _isUserSubscribed(subscriptionCubit.state);

    if (!isSubscribed) {
      await subscriptionCubit.showPaywall();
      return;
    }

    await _showChatBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, _) => PushableButton(
        width: 50,
        height: 50,
        text: '',
        iconSize: 25,
        shouldPlaySound: false,
        buttonColor: Theme.of(context).primaryColor,
        shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.7),
        suffixIcon: Icons.auto_awesome_rounded,
        onTap: () => _handleTap(context),
      ),
    );
  }
}
