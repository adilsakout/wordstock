import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/repositories/credit_repository.dart';

part 'credit_state.dart';

/// Manages daily free credits for non-subscribed users.
///
/// Free users get 3 credits per UTC day to use AI Chat or Practice.
/// Subscribed users bypass the credit system entirely.
class CreditCubit extends Cubit<CreditState> {
  CreditCubit({
    required CreditRepository creditRepository,
    required SubscriptionCubit subscriptionCubit,
  })  : _creditRepository = creditRepository,
        _subscriptionCubit = subscriptionCubit,
        super(const CreditState()) {
    _subscriptionListener =
        _subscriptionCubit.stream.listen(_onSubscriptionChanged);
    _syncSubscriptionState(_subscriptionCubit.state);
  }

  final CreditRepository _creditRepository;
  final SubscriptionCubit _subscriptionCubit;
  StreamSubscription<SubscriptionState>? _subscriptionListener;

  void _onSubscriptionChanged(SubscriptionState subState) {
    _syncSubscriptionState(subState);
  }

  void _syncSubscriptionState(SubscriptionState subState) {
    subState.maybeWhen(
      loaded: (isSubscribed) {
        emit(state.copyWith(isSubscribed: isSubscribed));
        if (!isSubscribed) {
          loadCredits();
        }
      },
      orElse: () {},
    );
  }

  /// Load current credit count from server.
  Future<void> loadCredits() async {
    if (state.isSubscribed) return;

    try {
      emit(state.copyWith(status: CreditStatus.loading));
      final credits = await _creditRepository.getDailyCredits();
      emit(
        state.copyWith(
          status: CreditStatus.loaded,
          creditsRemaining: credits,
        ),
      );
    } catch (e) {
      log('Failed to load credits: $e', name: 'CreditCubit');
      emit(
        state.copyWith(
          status: CreditStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Attempt to consume a credit. Returns true if action is allowed.
  ///
  /// For subscribers, always returns true without consuming.
  /// For free users, atomically consumes a credit on the server.
  Future<bool> tryConsumeCredit() async {
    if (state.isSubscribed) return true;

    if (state.creditsRemaining <= 0) return false;

    try {
      final remaining = await _creditRepository.consumeCredit();
      if (remaining == -1) {
        emit(state.copyWith(creditsRemaining: 0));
        return false;
      }
      emit(state.copyWith(creditsRemaining: remaining));
      return true;
    } catch (e) {
      log('Failed to consume credit: $e', name: 'CreditCubit');
      return false;
    }
  }

  @override
  Future<void> close() {
    _subscriptionListener?.cancel();
    return super.close();
  }
}
