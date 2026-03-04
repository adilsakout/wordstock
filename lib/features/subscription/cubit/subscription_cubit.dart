import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/paywall_result.dart';
import 'package:wordstock/repositories/rc_repository.dart';
import 'package:wordstock/services/facebook_service.dart';
import 'package:wordstock/services/posthog_service.dart';

part 'subscription_cubit.freezed.dart';
part 'subscription_state.dart';

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
      emit(SubscriptionState.loaded(isSubscribed: isSubscribed));
    } catch (e) {
      emit(SubscriptionState.error(message: e.toString()));
    }
  }

  /// Shows the paywall
  Future<void> showPaywall({String source = 'unknown'}) async {
    try {
      // Check status before showing paywall
      final wasSubscribed = await _rcRepository.isUserSubscribed();

      // Track Paywall Viewed
      PosthogService.instance.track(
        'Paywall Viewed',
        properties: {
          'source': source,
          'is_subscribed': wasSubscribed,
        },
      );

      final result = await _rcRepository.presentPaywall();

      // Determine paywall result string
      final String resultStr;
      if (result == PaywallResult.cancelled) {
        resultStr = 'cancelled';
        debugPrint('Paywall not presented ');
      } else if (result == PaywallResult.purchased) {
        resultStr = 'purchased';
      } else if (result == PaywallResult.restored) {
        resultStr = 'restored';
      } else {
        resultStr = 'error';
      }

      // Track Paywall Dismissed
      PosthogService.instance.track(
        'Paywall Dismissed',
        properties: {
          'source': source,
          'result': resultStr,
        },
      );

      // Check status after showing paywall
      final isSubscribed = await _rcRepository.isUserSubscribed();

      // If user wasn't subscribed but is now, log the event
      if (!wasSubscribed && isSubscribed) {
        await FacebookService.instance.logSubscription();
        // Track Subscription Started
        PosthogService.instance.track(
          'Subscription Started',
          properties: {
            'source': source,
          },
        );
      }

      // After showing paywall, recheck subscription status
      await checkSubscription();
    } catch (e) {
      emit(SubscriptionState.error(message: e.toString()));
    }
  }
}
