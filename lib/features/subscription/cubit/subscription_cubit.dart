import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wordstock/repositories/rc_repository.dart';

part 'subscription_state.dart';
part 'subscription_cubit.freezed.dart';

/// Manages the subscription state of the application
class SubscriptionCubit extends Cubit<SubscriptionState> {
  /// Creates a new instance of [SubscriptionCubit]
  SubscriptionCubit({
    required RcRepository rcRepository,
  })  : _rcRepository = rcRepository,
        super(const SubscriptionState.initial()) {
    // Initialize subscription listener
    _initSubscriptionListener();
  }

  final RcRepository _rcRepository;

  /// Initialize subscription listener
  void _initSubscriptionListener() {
    Future<void> listener(CustomerInfo customerInfo) async {
      // Check if user has pro entitlement
      final isSubscribed = customerInfo.entitlements.active.containsKey('pro');
      emit(SubscriptionState.loaded(isSubscribed: isSubscribed));
    }

    Purchases.addCustomerInfoUpdateListener(listener);
    _customerInfoListener = listener;
  }

  CustomerInfoUpdateListener? _customerInfoListener;

  @override
  Future<void> close() {
    // Remove listener when cubit is closed
    if (_customerInfoListener != null) {
      Purchases.removeCustomerInfoUpdateListener(_customerInfoListener!);
    }
    return super.close();
  }

  /// Checks if the user is subscribed
  Future<void> checkSubscription() async {
    try {
      emit(const SubscriptionState.loading());
      final isSubscribed = await _rcRepository.isUserSubscribed();
      if (kDebugMode) {
        emit(const SubscriptionState.loaded(isSubscribed: true));
      } else {
        emit(SubscriptionState.loaded(isSubscribed: isSubscribed));
      }
    } catch (e) {
      emit(SubscriptionState.error(message: e.toString()));
    }
  }

  /// Shows the paywall
  Future<void> showPaywall() async {
    try {
      await _rcRepository.presentPaywall();
      // After showing paywall, recheck subscription status
      await checkSubscription();
    } catch (e) {
      emit(SubscriptionState.error(message: e.toString()));
    }
  }
}
