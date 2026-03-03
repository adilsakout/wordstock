import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:wordstock/features/ai_chat/widgets/ai_chat_bottom_sheet.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/model/word.dart';
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
    super.key,
  });

  /// The vocabulary word that will be the focus of the AI conversation
  ///
  /// This word's definition, example, and context will be used to:
  /// - Generate initial conversation prompts
  /// - Maintain conversation scope and relevance
  /// - Provide educational context for the AI assistant
  final Word word;

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
        create: (_) => AIChatCubit(creditCubit: creditCubit),
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
    // Modern, minimal button design following Apple guidelines
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, _) => PushableButton(
        width: 50,
        height: 50,
        text: '',
        iconSize: 25,
        buttonColor: const Color(0xff1CB0F6),
        shadowColor: const Color(0xff1899D6),
        suffixIcon: Icons.auto_awesome_rounded, // AI/magic wand icon
        onTap: () => _handleTap(context),
      ),
    );
  }
}
