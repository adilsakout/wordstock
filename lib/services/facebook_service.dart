import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Service class for handling Facebook App Events
class FacebookService {
  /// Private constructor for singleton pattern
  FacebookService._();
  static final FacebookService _instance = FacebookService._();

  /// Get singleton instance
  static FacebookService get instance => _instance;

  final _logger = Logger(level: Level.debug);
  final _facebookAppEvents = FacebookAppEvents();

  /// Log an event with optional parameters
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: name,
        parameters: parameters,
        valueToSum: valueToSum,
      );
      _logger.d('Logged Facebook event: $name');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to log Facebook event: $name',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sets the user ID for events
  Future<void> setUserID(String id) async {
    try {
      await _facebookAppEvents.setUserID(id);
      _logger.d('Set Facebook User ID: $id');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to set Facebook User ID: $id',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Clears the user ID
  Future<void> clearUserID() async {
    try {
      await _facebookAppEvents.clearUserID();
      _logger.d('Cleared Facebook User ID');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to clear Facebook User ID',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Logs the app activation event (Install/Launch)
  Future<void> logAppInit() async {
    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_activate_app',
      );
      _logger.d('Logged Facebook App Init');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to log Facebook App Init',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Logs a subscription event
  Future<void> logSubscription({
    double? price,
    String? currency,
  }) async {
    try {
      // Using standard Facebook Subscribe event
      await _facebookAppEvents.logEvent(
        name: 'Subscribe',
        parameters: {
          if (currency != null) 'fb_currency': currency,
        },
        valueToSum: price,
      );
      _logger.d('Logged Facebook Subscription');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to log Facebook Subscription',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Explicitly initialize if needed (usually handled by
  ///  native SDKs automatically)
  /// This can be used to set advertised ID collection or auto log app events
  /// if the package supports it dynamically
  Future<void> initialize() async {
    _logger.i('Facebook Service ready');
    if (kDebugMode) {
      // Enable debug logging for Facebook SDK if possible/needed
      // Note: Most verbosity is controlled via native schemes
    }
  }
}
