import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:wordstock/services/tracking_service.dart';

/// Service class for handling PostHog analytics
class PosthogService {
  /// Private constructor for singleton pattern
  PosthogService._();
  static final PosthogService _instance = PosthogService._();

  /// Get singleton instance
  static PosthogService get instance => _instance;

  final _logger = Logger(level: Level.debug);
  bool _isInitialized = false;

  /// Initialize PostHog with API key and host URL
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.i('PostHog already initialized');
      return;
    }

    try {
      // Request tracking authorization before initializing PostHog
      final isTrackingAuthorized =
          await TrackingService.instance.requestTrackingAuthorization();
      if (!isTrackingAuthorized) {
        _logger.w(
          'PostHog will be initialized with limited functionality',
        );
      }

      final apiKey = dotenv.env['POSTHOG_API_KEY'];
      if (apiKey == null) {
        throw Exception('PostHog API key not found in .env');
      }

      final config = PostHogConfig(apiKey)
        ..debug = kDebugMode
        ..captureApplicationLifecycleEvents = true
        ..sessionReplay = true
        ..sessionReplayConfig.maskAllTexts = false
        ..sessionReplayConfig.maskAllImages = false
        ..host = 'https://us.i.posthog.com';
      await Posthog().setup(config);

      // Enable tracking only if authorized
      if (isTrackingAuthorized) {
        await Posthog().enable();
      } else {
        await Posthog().disable();
      }

      _isInitialized = true;
      _logger.i('PostHog initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize PostHog',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Track an event with optional properties
  Future<void> track(
    String eventName, {
    Map<String, Object>? properties,
  }) async {
    if (!_isInitialized) {
      _logger.w('PostHog not initialized, skipping event: $eventName');
      return;
    }

    try {
      await Posthog().capture(
        eventName: eventName,
        properties: properties,
      );
      _logger.i('Tracked event: $eventName');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to track event: $eventName',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Track a screen view with optional properties
  Future<void> screen(
    String screenName, {
    Map<String, Object>? properties,
  }) async {
    try {
      await Posthog().screen(
        screenName: screenName,
        properties: properties,
      );
      _logger.d('Tracked screen view: $screenName');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to track screen view: $screenName',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Identify a user with optional properties
  Future<void> identify(
    String userId, {
    Map<String, Object>? properties,
  }) async {
    try {
      await Posthog().identify(
        userId: userId,
        userProperties: properties,
      );
      _logger.d('Identified user: $userId');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to identify user: $userId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Reset the user identity
  Future<void> reset() async {
    try {
      await Posthog().reset();
      _logger.d('Reset user identity');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to reset user identity',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
