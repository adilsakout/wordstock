part of 'chat_ai_cubit.dart';

enum MessageRole { system, user, assistant }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.role,
    required this.content,
  });

  final MessageRole role;
  final String content;

  @override
  List<Object> get props => [role, content];
}

abstract class ChatAIState extends Equatable {
  const ChatAIState();

  @override
  List<Object?> get props => [];
}

class ChatAIInitial extends ChatAIState {
  const ChatAIInitial();
}

class ChatAILoading extends ChatAIState {
  const ChatAILoading();
}

class ChatAILoaded extends ChatAIState {
  const ChatAILoaded({
    required this.word,
    required this.messages,
    required this.isLoading,
  });

  final Word word;
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatAILoaded copyWith({
    Word? word,
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatAILoaded(
      word: word ?? this.word,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [word, messages, isLoading];
}

class ChatAIError extends ChatAIState {
  const ChatAIError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
