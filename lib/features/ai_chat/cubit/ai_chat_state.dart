part of 'ai_chat_cubit.dart';

/// Enumeration of possible message roles in the conversation
///
/// - [system]: Messages that set context and behavior for the AI
/// - [user]: Messages sent by the human user
/// - [assistant]: Messages sent by the AI assistant
enum MessageRole { system, user, assistant }

/// Represents a single message in the AI chat conversation
///
/// Each message contains:
/// - [role]: Who sent the message (system, user, or assistant)
/// - [content]: The actual text content of the message
class ChatMessage extends Equatable {
  /// Creates a new chat message
  const ChatMessage({
    required this.role,
    required this.content,
  });

  /// The role of the entity that sent this message
  final MessageRole role;

  /// The text content of the message
  final String content;

  @override
  List<Object> get props => [role, content];
}

/// Base class for all AI chat states
///
/// Provides common structure for state management in the AI chat feature
abstract class AIChatState extends Equatable {
  const AIChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the AI chat hasn't been started yet
///
/// This is the default state before any conversation begins
class AIChatInitial extends AIChatState {
  const AIChatInitial();
}

/// Loading state while waiting for AI response or initialization
///
/// Displayed when:
/// - Starting a new conversation with a word
/// - Waiting for AI response to a user message
/// - Any API call is in progress
class AIChatLoading extends AIChatState {
  const AIChatLoading();
}

/// Active conversation state with loaded messages
///
/// This state contains:
/// - [word]: The vocabulary word being discussed
/// - [messages]: Complete conversation history
/// - [isLoading]: Whether a response is currently being generated
class AIChatLoaded extends AIChatState {
  /// Creates a loaded state with conversation data
  const AIChatLoaded({
    required this.word,
    required this.messages,
    required this.isLoading,
  });

  /// The vocabulary word that is the focus of this conversation
  final Word word;

  /// Complete list of messages in the conversation
  /// Includes system, user, and assistant messages
  final List<ChatMessage> messages;

  /// Whether the AI is currently generating a response
  /// Used to show loading indicators and disable input
  final bool isLoading;

  /// Creates a copy of this state with modified properties
  ///
  /// Allows partial updates while preserving other properties
  AIChatLoaded copyWith({
    Word? word,
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return AIChatLoaded(
      word: word ?? this.word,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [word, messages, isLoading];
}

/// Error state when something goes wrong with the AI chat
///
/// Contains error information that can be displayed to the user
/// for debugging or user feedback
class AIChatError extends AIChatState {
  /// Creates an error state with the specified error message
  const AIChatError({required this.errorMessage});

  /// Human-readable error message describing what went wrong
  /// Could be API errors, network issues, or validation failures
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
