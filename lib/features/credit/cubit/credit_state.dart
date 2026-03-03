part of 'credit_cubit.dart';

enum CreditStatus { initial, loading, loaded, error }

class CreditState extends Equatable {
  const CreditState({
    this.status = CreditStatus.initial,
    this.creditsRemaining = 3,
    this.isSubscribed = false,
    this.errorMessage = '',
  });

  final CreditStatus status;
  final int creditsRemaining;
  final bool isSubscribed;
  final String errorMessage;

  /// Whether the user can perform a credit-gated action
  bool get canUseFeature => isSubscribed || creditsRemaining > 0;

  /// Whether credits should be displayed (only for non-subscribers)
  bool get shouldShowCredits => !isSubscribed;

  CreditState copyWith({
    CreditStatus? status,
    int? creditsRemaining,
    bool? isSubscribed,
    String? errorMessage,
  }) {
    return CreditState(
      status: status ?? this.status,
      creditsRemaining: creditsRemaining ?? this.creditsRemaining,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        creditsRemaining,
        isSubscribed,
        errorMessage,
      ];
}
