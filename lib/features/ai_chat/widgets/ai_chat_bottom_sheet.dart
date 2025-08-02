import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

/// A modern, full-featured AI chat interface presented as a bottom sheet
///
/// This widget provides a seamless conversational experience following
/// Apple's Human Interface Guidelines with:
/// - Fluid spring animations and smooth transitions
/// - Adaptive layout that works across mobile, tablet, and desktop
/// - Intelligent keyboard handling and scroll management
/// - Modern chat bubble design with proper spacing and typography
/// - Contextual loading states and error handling
///
/// The interface automatically initiates conversation about the provided
/// vocabulary word and maintains educational focus throughout the session.
class AIChatBottomSheet extends StatefulWidget {
  /// Creates a new AI chat interface for the specified word
  ///
  /// The conversation will be automatically started with context about
  /// the provided [word] including its definition and usage examples.
  const AIChatBottomSheet({
    required this.word,
    super.key,
  });

  /// The vocabulary word that serves as the conversation topic
  ///
  /// This word provides the educational context and ensures the
  /// AI conversation remains focused on vocabulary learning.
  final Word word;

  @override
  State<AIChatBottomSheet> createState() => _AIChatBottomSheetState();
}

class _AIChatBottomSheetState extends State<AIChatBottomSheet> {
  // Controllers for managing user input and chat scroll behavior
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Flag to ensure we only initialize the chat conversation once
  bool _hasInitializedChat = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize chat conversation once localization context is available
    if (!_hasInitializedChat) {
      _hasInitializedChat = true;

      // Immediately start conversation about the word when sheet opens
      // using localized prompts for user's language
      context.read<AIChatCubit>().startChatWithWord(
            widget.word,
            systemMessage: context.l10n.aiAssistantSystemMessage,
            initialPrompt: context.l10n.aiInitialPrompt(
              widget.word.word,
              widget.word.definition,
              widget.word.example ?? '',
            ),
          );
    }
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Smoothly scrolls to bottom of chat with spring animation
  ///
  /// This provides natural conversation flow by keeping the latest
  /// messages visible, especially important when keyboard appears/disappears
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut, // Smooth, natural animation curve
        );
      }
    });
  }

  /// Handles message sending with intelligent scroll management
  ///
  /// Process:
  /// 1. Validates message is not empty
  /// 2. Sends message through cubit for AI processing
  /// 3. Clears input field for next message
  /// 4. Manages scroll position during keyboard transitions
  /// 5. Auto-scrolls to show new messages
  ///
  /// The scroll management handles the tricky case where the keyboard
  /// dismisses and potentially changes the scroll position.
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Send message with localized vocabulary system message for user's language
      context.read<AIChatCubit>().sendMessage(
            message,
            vocabularySystemMessage:
                context.l10n.aiVocabularySystemMessage(widget.word.word),
          );
      _messageController.clear();

      // Preserve scroll position during keyboard transition
      final currentPosition = _scrollController.hasClients
          ? _scrollController.position.pixels
          : 0.0;

      // Wait for keyboard animation, then restore position and scroll to bottom
      Future.delayed(const Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(currentPosition);
          _scrollToBottom();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<AIChatCubit, AIChatState>(
      listener: (context, state) {
        // Auto-scroll when new messages arrive
        if (state is AIChatLoaded) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Wrap(
          children: [
            Container(
              // Modern container with subtle shadow and rounded corners
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              // Adaptive sizing for different screen sizes
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Padding(
                // Dynamic padding that adjusts for keyboard
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    const Divider(),

                    // State-dependent content area
                    if (state is AIChatLoading)
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    else if (state is AIChatLoaded)
                      Expanded(
                        child: _buildChatList(context, state),
                      )
                    else if (state is AIChatError)
                      Expanded(
                        child: Center(
                          child: Text(
                            l10n.chatWithAIError(state.errorMessage),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),

                    // Input field only shown when conversation is active
                    if (state is AIChatLoaded) _buildInputField(context, state),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the header with drag indicator, title, and close button
  ///
  /// Features:
  /// - Visual drag indicator for intuitive gesture interaction
  /// - Context-aware title showing the word being discussed
  /// - Clean close button with proper touch target
  /// - Smooth fade-in animation following Apple design patterns
  Widget _buildHeader(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Drag indicator for bottom sheet
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.chatWithAITitle(widget.word.word),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  /// Builds the scrollable chat message list
  ///
  /// Features:
  /// - Smooth scrolling with proper controller management
  /// - Hides system messages from user (they're for AI context only)
  /// - Staggered animation entrance for visual polish
  /// - Proper padding and spacing for comfortable reading
  Widget _buildChatList(BuildContext context, AIChatLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];

        // Don't show system messages to users (they're for AI context)
        if (message.role == MessageRole.system) {
          return const SizedBox.shrink();
        }

        final isUser = message.role == MessageRole.user;
        return _buildChatBubble(
          context,
          message: message.content,
          isUser: isUser,
          animationDelay: (50 * index).ms, // Staggered entrance animations
        );
      },
    );
  }

  /// Creates individual chat bubbles with modern iMessage-style design
  ///
  /// Features:
  /// - Adaptive bubble colors (primary for user, gray for AI)
  /// - Proper text contrast and readability
  /// - Responsive width based on screen size
  /// - Smooth entrance animations with subtle slide effect
  /// - Proper alignment (user right, AI left)
  Widget _buildChatBubble(
    BuildContext context, {
    required String message,
    required bool isUser,
    required Duration animationDelay,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    ).animate(delay: animationDelay).fadeIn().slideY(begin: 0.2, end: 0);
  }

  /// Builds the message input area with send button
  ///
  /// Features:
  /// - Modern rounded text field design
  /// - Context-aware placeholder text mentioning the word
  /// - Responsive send button with loading state handling
  /// - Proper keyboard integration (submit on enter)
  /// - Subtle shadow for visual separation
  /// - Safe area handling for different device layouts
  Widget _buildInputField(BuildContext context, AIChatLoaded state) {
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: l10n.chatWithAIPlaceholder(widget.word.word),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              textInputAction: TextInputAction.newline,
              onSubmitted: (_) => _sendMessage(),
              enabled: !state.isLoading, // Disable input while AI is responding
            ),
          ),
          const SizedBox(width: 8),
          PushableButton(
            width: 48,
            height: 48,
            text: '',
            iconSize: 22,
            buttonColor: Theme.of(context).primaryColor,
            shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.7),
            suffixIcon: Icons.send_rounded,
            onTap:
                state.isLoading ? () {} : _sendMessage, // Disable when loading
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
