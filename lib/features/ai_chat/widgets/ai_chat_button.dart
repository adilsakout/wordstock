import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:wordstock/features/ai_chat/widgets/ai_chat_bottom_sheet.dart';
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

  /// Determines if the user has an active subscription
  ///
  /// Uses pattern matching on subscription state to safely extract
  /// subscription status, defaulting to false for any unknown states
  bool _isUserSubscribed(SubscriptionState state) => state.maybeWhen(
        loaded: (isSubscribed) => isSubscribed,
        orElse: () => false,
      );

  /// Presents the AI chat interface in a modal bottom sheet
  ///
  /// Creates a new AI chat session with:
  /// - Fresh cubit instance for isolated conversation state
  /// - Full-screen modal presentation for immersive experience
  /// - Transparent background for modern iOS-style presentation
  /// - Safe area handling for proper layout on all devices
  Future<void> _showChatBottomSheet(BuildContext context) async {
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => AIChatCubit(),
        child: AIChatBottomSheet(word: word),
      ),
    );
  }

  /// Handles button tap with subscription validation and smooth interactions
  ///
  /// Flow:
  /// 1. Provides tactile feedback using soft haptic response
  /// 2. Checks current subscription status
  /// 3. Shows paywall for non-subscribers (premium feature gating)
  /// 4. Opens AI chat for subscribers
  ///
  /// This creates a clear premium feature experience while maintaining
  /// smooth user interactions and clear value proposition.
  Future<void> _handleTap(BuildContext context) async {
    // Provide immediate tactile feedback for responsive feel
    Gaimon.soft();

    final subscriptionCubit = context.read<SubscriptionCubit>();
    final isSubscribed = _isUserSubscribed(subscriptionCubit.state);

    // Gate premium feature behind subscription
    if (!isSubscribed) {
      await subscriptionCubit.showPaywall();
      return;
    }

    // Open AI chat for premium users
    await _showChatBottomSheet(context);
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
        buttonColor: Theme.of(context).primaryColor,
        shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.7),
        suffixIcon: Icons.auto_awesome_rounded, // AI/magic wand icon
        onTap: () => _handleTap(context),
      ),
    );
  }
}
