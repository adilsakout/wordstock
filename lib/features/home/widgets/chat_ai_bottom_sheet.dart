import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/home/cubit/chat_ai_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/widgets/button.dart';

class ChatAIBottomSheet extends StatefulWidget {
  const ChatAIBottomSheet({
    required this.word,
    super.key,
  });

  final Word word;

  @override
  State<ChatAIBottomSheet> createState() => _ChatAIBottomSheetState();
}

class _ChatAIBottomSheetState extends State<ChatAIBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatAICubit>().startChatWithWord(widget.word);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatAICubit>().sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<ChatAICubit, ChatAIState>(
      listener: (context, state) {
        if (state is ChatAILoaded) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Wrap(
          children: [
            Container(
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const Divider(),
                  if (state is ChatAILoading)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  else if (state is ChatAILoaded)
                    Expanded(
                      child: _buildChatList(context, state),
                    )
                  else if (state is ChatAIError)
                    Expanded(
                      child: Center(
                        child: Text(
                          l10n.chatWithAIError(state.errorMessage),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  if (state is ChatAILoaded) _buildInputField(context, state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
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

  Widget _buildChatList(BuildContext context, ChatAILoaded state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        if (message.role == MessageRole.system) {
          return const SizedBox.shrink(); // Don't show system messages
        }

        final isUser = message.role == MessageRole.user;
        return _buildChatBubble(
          context,
          message: message.content,
          isUser: isUser,
          animationDelay: (50 * index).ms,
        );
      },
    );
  }

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

  Widget _buildInputField(BuildContext context, ChatAILoaded state) {
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
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              enabled: !state.isLoading,
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
            onTap: state.isLoading ? () {} : _sendMessage,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
