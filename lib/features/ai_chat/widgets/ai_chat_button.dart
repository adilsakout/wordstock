import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:wordstock/features/ai_chat/widgets/ai_chat_bottom_sheet.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/chat_repository.dart';
import 'package:wordstock/widgets/button.dart';

/// A sleek, modern button that opens AI chat functionality for vocabulary words
///
/// This button follows Apple's Human Interface Guidelines with:
/// - Clean, minimal design with primary color theming
/// - Smooth haptic feedback using spring-like animations
/// - Subscription-gated access with seamless paywall integration
/// - Accessible design with proper touch targets and visual feedback
///
/// The button is only functional for subscribed users, showing a paywall
/// for non-subscribers to encourage premium feature adoption.
class AIChatButton extends StatelessWidget {
  /// Creates a new AI chat button for the specified vocabulary word
  ///
  /// The [word] parameter is required and determines the conversation context
  const AIChatButton({
    required this.word,
    this.hasPreviousChat = false,
    super.key,
  });

  /// The vocabulary word that will be the focus of the AI conversation
  final Word word;

  /// Whether a previous conversation exists for this word.
  ///
  /// When `true` a small dot indicator is shown on the button so the
  /// user knows they can resume a saved chat.
  final bool hasPreviousChat;

  /// Presents the AI chat interface in a modal bottom sheet.
  ///
  /// Passes [creditCubit] so credit is consumed only after the first
  /// successful AI response — not before the chat opens.
  Future<void> _showChatBottomSheet(
    BuildContext context, {
    CreditCubit? creditCubit,
  }) async {
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => AIChatCubit(
          creditCubit: creditCubit,
          chatRepository: ChatRepository(),
        ),
        child: AIChatBottomSheet(word: word),
      ),
    );
  }

  /// Handles button tap with credit-based access.
  ///
  /// Subscribers get unlimited access. Free users must have credits
  /// available; the actual credit consumption happens inside the cubit
  /// after the first successful AI response.
  Future<void> _handleTap(BuildContext context) async {
    Gaimon.soft();

    final creditCubit = context.read<CreditCubit>();

    // Subscribers bypass credit system
    if (creditCubit.state.isSubscribed) {
      await _showChatBottomSheet(context);
      return;
    }

    // Free users: check if credits are available (don't consume yet)
    if (!creditCubit.state.canUseFeature) {
      if (!context.mounted) return;
      await context.read<SubscriptionCubit>().showPaywall();
      return;
    }

    if (!context.mounted) return;
    // Credit will be consumed by AIChatCubit after first success
    await _showChatBottomSheet(context, creditCubit: creditCubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, _) => Stack(
        clipBehavior: Clip.none,
        children: [
          PushableButton(
            width: 50,
            height: 50,
            text: '',
            iconSize: 25,
            buttonColor: const Color(0xff1CB0F6),
            shadowColor: const Color(0xff1899D6),
            suffixIcon: Icons.auto_awesome_rounded,
            onTap: () => _handleTap(context),
          ),
          if (hasPreviousChat)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
