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

  /// Deserialises a message from a JSON map (e.g. from Supabase JSONB).
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: MessageRole.values.firstWhere(
        (e) => e.name == json['role'] as String,
        orElse: () => MessageRole.user,
      ),
      content: json['content'] as String,
    );
  }

  /// The role of the entity that sent this message
  final MessageRole role;

  /// The text content of the message
  final String content;

  /// Serialises this message to a JSON map for persistence.
  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
      };

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
/// - [errorMessage]: An inline error (e.g. network failure) that does
///   NOT destroy the conversation — user can retry
class AIChatLoaded extends AIChatState {
  /// Creates a loaded state with conversation data
  const AIChatLoaded({
    required this.word,
    required this.messages,
    required this.isLoading,
    this.errorMessage,
    this.isRetrying = false,
    this.retryAttempt = 0,
    this.isStreaming = false,
    this.streamingContent,
  });

  /// The vocabulary word that is the focus of this conversation
  final Word word;

  /// Complete list of messages in the conversation
  final List<ChatMessage> messages;

  /// Whether the AI is currently generating a response
  final bool isLoading;

  /// Non-null when the last request failed. Shown inline with a
  /// retry button so the user does not lose their conversation.
  final String? errorMessage;

  /// Whether an automatic retry is currently in progress.
  final bool isRetrying;

  /// The current retry attempt number (1-based). Zero when not retrying.
  final int retryAttempt;

  /// Whether tokens are actively arriving from the SSE stream.
  final bool isStreaming;

  /// Accumulated content from the stream so far. Null when not streaming.
  final String? streamingContent;

  /// Whether there is a recoverable error to display
  bool get hasError => errorMessage != null;

  AIChatLoaded copyWith({
    Word? word,
    List<ChatMessage>? messages,
    bool? isLoading,
    String? Function()? errorMessage,
    bool? isRetrying,
    int? retryAttempt,
    bool? isStreaming,
    String? Function()? streamingContent,
  }) {
    return AIChatLoaded(
      word: word ?? this.word,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
      isRetrying: isRetrying ?? this.isRetrying,
      retryAttempt: retryAttempt ?? this.retryAttempt,
      isStreaming: isStreaming ?? this.isStreaming,
      streamingContent: streamingContent != null
          ? streamingContent()
          : this.streamingContent,
    );
  }

  @override
  List<Object?> get props => [
        word,
        messages,
        isLoading,
        errorMessage,
        isRetrying,
        retryAttempt,
        isStreaming,
        streamingContent,
      ];
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
