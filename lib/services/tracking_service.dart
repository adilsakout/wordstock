import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:logger/logger.dart';

/// Service class for handling tracking permissions
class TrackingService {
  /// Private constructor for singleton pattern
  TrackingService._();
  static final TrackingService _instance = TrackingService._();

  /// Get singleton instance
  static TrackingService get instance => _instance;

  final _logger = Logger(level: Level.debug);

  /// Request tracking authorization
  /// Returns true if tracking is authorized, false otherwise
  Future<bool> requestTrackingAuthorization() async {
    if (!Platform.isIOS) {
      _logger.i('Tracking authorization not required on this platform');
      return true;
    }

    try {
      // Get current tracking status
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      // If already authorized, return true
      if (status == TrackingStatus.authorized) {
        _logger.i('Tracking already authorized');
        return true;
      }

      // Request authorization
      final result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      _logger.i('Tracking authorization result: $result');

      return result == TrackingStatus.authorized;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to request tracking authorization',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
