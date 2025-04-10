part of 'subscription_cubit.dart';

/// States for the subscription feature
@freezed
class SubscriptionState with _$SubscriptionState {
  /// Initial state
  const factory SubscriptionState.initial() = _Initial;

  /// Loading state
  const factory SubscriptionState.loading() = _Loading;

  /// Loaded state with subscription status
  const factory SubscriptionState.loaded({
    required bool isSubscribed,
  }) = _Loaded;

  /// Error state
  const factory SubscriptionState.error({
    required String message,
  }) = _Error;
}
