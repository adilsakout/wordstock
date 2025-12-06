import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';
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

  // Track which AI messages have completed their typing animation
  final Set<String> _completedAnimations = {};

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
      // Send message with localized vocabulary
      // system message for user's language
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
        // Auto-scroll when new messages arrive or loading state changes
        if (state is AIChatLoaded) {
          // Scroll to show new messages or typing indicator
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
                    if (state is AIChatLoaded)
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
                      )
                    else
                      // Initial state - show empty space while initialization
                      Expanded(
                        child: Container(),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

  /// Builds the scrollable chat message list with loading indicators
  ///
  /// Features:
  /// - Smooth scrolling with proper controller management
  /// - Hides system messages from user (they're for AI context only)
  /// - Shows typing indicator when AI is responding
  /// - Staggered animation entrance for visual polish
  /// - Proper padding and spacing for comfortable reading
  Widget _buildChatList(BuildContext context, AIChatLoaded state) {
    // Calculate visible messages (excluding system messages)
    final visibleMessages = state.messages
        .where((message) => message.role != MessageRole.system)
        .toList();

    // Add 1 to item count if AI is loading (for typing indicator)
    final itemCount = visibleMessages.length + (state.isLoading ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Show typing indicator as last item when AI is loading
        if (state.isLoading && index == visibleMessages.length) {
          return _buildTypingIndicator(context);
        }

        final message = visibleMessages[index];
        final isUser = message.role == MessageRole.user;

        return _buildChatBubble(
          context,
          message: message.content,
          isUser: isUser,
          animationDelay: (50 * index).ms, // Staggered entrance animations
          isLatestAIMessage: !isUser && index == visibleMessages.length - 1,
        );
      },
    );
  }

  /// Creates an elegant typing indicator for AI responses
  ///
  /// Features:
  /// - Three animated dots that pulse in sequence
  /// - Matches AI message bubble styling for consistency
  /// - Smooth spring animations following Apple design patterns
  /// - Proper positioning aligned with AI messages
  Widget _buildTypingIndicator(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Three animated dots with staggered timing
            for (int i = 0; i < 3; i++)
              Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(
                    delay: (i * 200).ms,
                    duration: 600.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .fadeOut(duration: 600.ms, curve: Curves.easeInOut),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOut);
  }

  /// Creates individual chat bubbles with modern iMessage-style design
  ///
  /// Features:
  /// - Adaptive bubble colors (primary for user, gray for AI)
  /// - Progressive typing animation for AI responses
  /// - Proper text contrast and readability
  /// - Responsive width based on screen size
  /// - Smooth entrance animations with subtle slide effect
  /// - Proper alignment (user right, AI left)
  Widget _buildChatBubble(
    BuildContext context, {
    required String message,
    required bool isUser,
    required Duration animationDelay,
    bool isLatestAIMessage = false,
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
        child: isUser
            ? Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              )
            : _shouldAnimateMessage(message, isLatestAIMessage)
                ? _MarkdownTypingAnimationText(
                    key: ValueKey(message.hashCode),
                    text: message,
                    onCharacterAdded: _scrollToBottom,
                    onAnimationComplete: () {
                      setState(() {
                        _completedAnimations.add(message);
                      });
                    },
                  )
                : MarkdownWidget(
                    data: message,
                    shrinkWrap: true,
                    config: MarkdownConfig(
                      configs: [
                        const PConfig(
                          textStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        CodeConfig(
                          style: TextStyle(
                            backgroundColor: Colors.grey.shade300,
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                        // BlockquoteConfig - will configure later
                      ],
                    ),
                  ),
      ),
    ).animate(delay: animationDelay).fadeIn().slideY(begin: 0.2, end: 0);
  }

  /// Determines if an AI message should animate or show as static text
  ///
  /// Only animates the latest AI message that hasn't been animated yet.
  /// This prevents re-animation when scrolling or rebuilding.
  bool _shouldAnimateMessage(String message, bool isLatestAIMessage) {
    return isLatestAIMessage && !_completedAnimations.contains(message);
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

/// A widget that animates markdown text appearing character by character
///
/// This creates a natural, engaging typing animation for markdown content.
/// Features include:
/// - Smooth character-by-character reveal at natural typing speed
/// - Full markdown rendering with proper formatting
/// - Blinking cursor at the end while typing
/// - Callback for each character to enable auto-scrolling
/// - Apple-style smooth timing that feels organic
class _MarkdownTypingAnimationText extends StatefulWidget {
  /// Creates a markdown typing animation text widget
  ///
  /// [text] - The full markdown text to animate
  /// [typingSpeed] - Duration between each character (default: 30ms)
  /// [onCharacterAdded] - Called each time a character is revealed
  /// [onAnimationComplete] - Called when animation completes
  const _MarkdownTypingAnimationText({
    required this.text,
    super.key,
    // ignore: unused_element_parameter
    this.typingSpeed = const Duration(milliseconds: 30),
    this.onCharacterAdded,
    this.onAnimationComplete,
  });

  /// The complete markdown text that will be animated character by character
  final String text;

  /// Speed of typing animation - time between each character
  /// Default 30ms provides natural, readable typing speed
  final Duration typingSpeed;

  /// Callback triggered each time a new character appears
  /// Used for triggering scroll updates during animation
  final VoidCallback? onCharacterAdded;

  /// Callback triggered when the entire animation completes
  /// Used to mark the message as animated to prevent re-animation
  final VoidCallback? onAnimationComplete;

  @override
  State<_MarkdownTypingAnimationText> createState() =>
      _MarkdownTypingAnimationTextState();
}

class _MarkdownTypingAnimationTextState
    extends State<_MarkdownTypingAnimationText> with TickerProviderStateMixin {
  // Animation controller for the blinking cursor
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;

  // Timer for character reveal animation
  Timer? _typingTimer;

  // Current number of characters visible
  int _currentCharCount = 0;

  // Whether typing animation is complete
  bool _isTypingComplete = false;

  @override
  void initState() {
    super.initState();

    // Set up simple cursor blinking for markdown
    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 530), // Natural blink rate
      vsync: this,
    );
    _cursorAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _cursorController,
        curve: Curves.easeInOut,
      ),
    );

    // Start cursor blinking
    _cursorController.repeat(reverse: true);

    // Start typing animation with a small delay for entrance effect
    Future.delayed(const Duration(milliseconds: 200), _startTypingAnimation);
  }

  /// Initiates the character-by-character typing animation
  ///
  /// Uses a Timer to progressively reveal characters at a natural pace.
  /// Includes special handling for spaces and punctuation for more
  /// realistic typing rhythm.
  ///
  /// All setState calls are guarded with mounted checks to prevent
  /// errors when the widget is disposed during animation.
  void _startTypingAnimation() {
    _typingTimer = Timer.periodic(widget.typingSpeed, (timer) {
      // Guard against setState after dispose
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentCharCount < widget.text.length) {
        // Only update state if widget is still mounted
        if (mounted) {
          setState(() {
            _currentCharCount++;
          });
        }

        // Trigger callback for scroll updates (safe to call even if disposed)
        widget.onCharacterAdded?.call();

        // Add slight variation in typing speed for more natural feel
        final currentChar = widget.text[_currentCharCount - 1];
        if (currentChar == ' ') {
          // Slightly slower after spaces (more natural)
          timer.cancel();
          Future.delayed(
            Duration(milliseconds: widget.typingSpeed.inMilliseconds + 15),
            () {
              // Double-check mounted before restarting animation
              if (mounted) _startTypingAnimation();
            },
          );
        } else if (currentChar == '.' ||
            currentChar == '!' ||
            currentChar == '?') {
          // Pause slightly longer after sentence endings
          timer.cancel();
          Future.delayed(
            Duration(milliseconds: widget.typingSpeed.inMilliseconds + 100),
            () {
              // Double-check mounted before restarting animation
              if (mounted) _startTypingAnimation();
            },
          );
        }
      } else {
        // Typing complete - stop cursor after a brief pause
        timer.cancel();

        // Only update state if widget is still mounted
        if (mounted) {
          setState(() {
            _isTypingComplete = true;
          });
        }

        Future.delayed(const Duration(milliseconds: 800), () {
          // Guard all operations with mounted check
          if (mounted) {
            _cursorController.stop();
            if (mounted) {
              setState(() {}); // Remove cursor
            }
            // Notify that animation is complete (safe to call)
            widget.onAnimationComplete?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the visible portion of the markdown text
    final visibleText = widget.text.substring(0, _currentCharCount);

    return AnimatedBuilder(
      animation: _cursorAnimation,
      builder: (context, child) {
        // Add blinking cursor if still typing
        final textWithCursor = !_isTypingComplete
            ? '$visibleText${_cursorAnimation.value > 0.5 ? '|' : ''}'
            : visibleText;

        return MarkdownWidget(
          data: textWithCursor,
          shrinkWrap: true,
          config: MarkdownConfig(
            configs: [
              const PConfig(
                textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              CodeConfig(
                style: TextStyle(
                  backgroundColor: Colors.grey.shade300,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
              // BlockquoteConfig - will configure later
              const H1Config(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const H2Config(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const H3Config(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
