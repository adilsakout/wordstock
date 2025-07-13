import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing user settings and preferences
///
/// This repository provides a clean interface
///  for managing all user preferences,
/// including notification settings, using SharedPreferences as the underlying
/// storage mechanism.
class SettingsRepository {
  /// Creates a new instance of [SettingsRepository]
  SettingsRepository();

  // Keys for SharedPreferences storage
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _dailyReminderEnabledKey = 'daily_reminder_enabled';
  static const String _practiceReminderEnabledKey = 'practice_reminder_enabled';
  static const String _newWordNotificationEnabledKey =
      'new_word_notification_enabled';
  static const String _streakReminderEnabledKey = 'streak_reminder_enabled';

  /// Get SharedPreferences instance
  ///
  /// This method provides a safe way to access SharedPreferences
  /// and ensures proper error handling.
  Future<SharedPreferences> _getPrefs() async {
    try {
      return await SharedPreferences.getInstance();
    } catch (e) {
      throw Exception('Failed to access SharedPreferences: $e');
    }
  }

  // ================== Notification Settings ================== //

  /// Get the current notification settings
  ///
  /// Returns a [NotificationSettings] object containing all notification
  /// preferences with their current values.
  Future<NotificationSettings> getNotificationSettings() async {
    try {
      final prefs = await _getPrefs();

      return NotificationSettings(
        notificationsEnabled: prefs.getBool(_notificationsEnabledKey) ?? true,
        dailyReminderEnabled: prefs.getBool(_dailyReminderEnabledKey) ?? true,
        practiceReminderEnabled:
            prefs.getBool(_practiceReminderEnabledKey) ?? true,
        newWordNotificationEnabled:
            prefs.getBool(_newWordNotificationEnabledKey) ?? true,
        streakReminderEnabled: prefs.getBool(_streakReminderEnabledKey) ?? true,
      );
    } catch (e) {
      throw Exception('Failed to load notification settings: $e');
    }
  }

  /// Update notification settings
  ///
  /// Saves the provided [NotificationSettings] to SharedPreferences.
  /// This method handles all notification preferences at once.
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    try {
      final prefs = await _getPrefs();

      await Future.wait([
        prefs.setBool(_notificationsEnabledKey, settings.notificationsEnabled),
        prefs.setBool(_dailyReminderEnabledKey, settings.dailyReminderEnabled),
        prefs.setBool(
          _practiceReminderEnabledKey,
          settings.practiceReminderEnabled,
        ),
        prefs.setBool(
          _newWordNotificationEnabledKey,
          settings.newWordNotificationEnabled,
        ),
        prefs.setBool(
          _streakReminderEnabledKey,
          settings.streakReminderEnabled,
        ),
      ]);
    } catch (e) {
      throw Exception('Failed to save notification settings: $e');
    }
  }

  /// Toggle notifications enabled/disabled
  ///
  /// This is a convenience method for the master notification toggle.
  /// When disabled, all notifications should be turned off.
  Future<void> toggleNotifications({required bool enabled}) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_notificationsEnabledKey, enabled);
    } catch (e) {
      throw Exception('Failed to toggle notifications: $e');
    }
  }

  /// Toggle daily reminder notifications
  ///
  /// Daily reminders help users maintain their learning streak
  /// by reminding them to practice at a consistent time.
  Future<void> toggleDailyReminder({required bool enabled}) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_dailyReminderEnabledKey, enabled);
    } catch (e) {
      throw Exception('Failed to toggle daily reminder: $e');
    }
  }

  /// Toggle practice reminder notifications
  ///
  /// Practice reminders are shown when users haven't practiced
  /// for a certain period to encourage regular use.
  Future<void> togglePracticeReminder({required bool enabled}) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_practiceReminderEnabledKey, enabled);
    } catch (e) {
      throw Exception('Failed to toggle practice reminder: $e');
    }
  }

  /// Toggle new word notifications
  ///
  /// New word notifications inform users when fresh vocabulary
  /// is available for learning.
  Future<void> toggleNewWordNotification({required bool enabled}) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_newWordNotificationEnabledKey, enabled);
    } catch (e) {
      throw Exception('Failed to toggle new word notification: $e');
    }
  }

  /// Toggle streak reminder notifications
  ///
  /// Streak reminders help users maintain their learning consistency
  /// by alerting them when their streak is at risk.
  Future<void> toggleStreakReminder({required bool enabled}) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_streakReminderEnabledKey, enabled);
    } catch (e) {
      throw Exception('Failed to toggle streak reminder: $e');
    }
  }

  // ================== Future Settings Extensions ================== //

  /// Clear all settings
  ///
  /// This method removes all stored settings from SharedPreferences.
  /// Use with caution as this will reset all user preferences.
  Future<void> clearAllSettings() async {
    try {
      final prefs = await _getPrefs();
      await Future.wait([
        prefs.remove(_notificationsEnabledKey),
        prefs.remove(_dailyReminderEnabledKey),
        prefs.remove(_practiceReminderEnabledKey),
        prefs.remove(_newWordNotificationEnabledKey),
        prefs.remove(_streakReminderEnabledKey),
      ]);
    } catch (e) {
      throw Exception('Failed to clear settings: $e');
    }
  }

  /// Check if notifications are enabled
  ///
  /// Quick check method to determine if notifications are globally enabled.
  /// This is useful for other parts of the app
  ///  that need to check notification status.
  Future<bool> areNotificationsEnabled() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getBool(_notificationsEnabledKey) ?? true;
    } catch (e) {
      return true; // Default to enabled if there's an error
    }
  }
}

/// Data class representing notification settings
///
/// This class encapsulates all notification preferences in a single
/// object for easier management and type safety.
@immutable
class NotificationSettings {
  /// Creates a new [NotificationSettings] instance
  const NotificationSettings({
    required this.notificationsEnabled,
    required this.dailyReminderEnabled,
    required this.practiceReminderEnabled,
    required this.newWordNotificationEnabled,
    required this.streakReminderEnabled,
  });

  /// Creates a [NotificationSettings] from a JSON representation
  ///
  /// This factory constructor allows creating settings from a Map,
  /// which is useful for potential future extensions.
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyReminderEnabled: json['dailyReminderEnabled'] as bool? ?? true,
      practiceReminderEnabled: json['practiceReminderEnabled'] as bool? ?? true,
      newWordNotificationEnabled:
          json['newWordNotificationEnabled'] as bool? ?? true,
      streakReminderEnabled: json['streakReminderEnabled'] as bool? ?? true,
    );
  }

  /// Master toggle for all notifications
  ///
  /// When false, all other notification settings should be ignored
  /// and no notifications should be sent.
  final bool notificationsEnabled;

  /// Whether daily reminder notifications are enabled
  ///
  /// Daily reminders help users maintain consistent learning habits
  /// by reminding them at a specific time each day.
  final bool dailyReminderEnabled;

  /// Whether practice reminder notifications are enabled
  ///
  /// Practice reminders are triggered when users haven't practiced
  /// for an extended period to encourage regular engagement.
  final bool practiceReminderEnabled;

  /// Whether new word notifications are enabled
  ///
  /// New word notifications alert users when fresh vocabulary
  /// content is available for learning.
  final bool newWordNotificationEnabled;

  /// Whether streak reminder notifications are enabled
  ///
  /// Streak reminders help users maintain their learning consistency
  /// by alerting them when their streak is at risk of breaking.
  final bool streakReminderEnabled;

  /// Creates a copy of this [NotificationSettings] with
  ///  the given fields replaced
  ///
  /// This method provides an immutable way to update notification settings
  /// while maintaining the existing values for unchanged fields.
  NotificationSettings copyWith({
    bool? notificationsEnabled,
    bool? dailyReminderEnabled,
    bool? practiceReminderEnabled,
    bool? newWordNotificationEnabled,
    bool? streakReminderEnabled,
  }) {
    return NotificationSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      practiceReminderEnabled:
          practiceReminderEnabled ?? this.practiceReminderEnabled,
      newWordNotificationEnabled:
          newWordNotificationEnabled ?? this.newWordNotificationEnabled,
      streakReminderEnabled:
          streakReminderEnabled ?? this.streakReminderEnabled,
    );
  }

  /// Converts this [NotificationSettings] to a JSON representation
  ///
  /// This method is useful for debugging and potential future extensions
  /// where settings might need to be serialized.
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'dailyReminderEnabled': dailyReminderEnabled,
      'practiceReminderEnabled': practiceReminderEnabled,
      'newWordNotificationEnabled': newWordNotificationEnabled,
      'streakReminderEnabled': streakReminderEnabled,
    };
  }

  @override
  String toString() {
    return 'NotificationSettings('
        'notificationsEnabled: $notificationsEnabled, '
        'dailyReminderEnabled: $dailyReminderEnabled, '
        'practiceReminderEnabled: $practiceReminderEnabled, '
        'newWordNotificationEnabled: $newWordNotificationEnabled, '
        'streakReminderEnabled: $streakReminderEnabled'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationSettings &&
        other.notificationsEnabled == notificationsEnabled &&
        other.dailyReminderEnabled == dailyReminderEnabled &&
        other.practiceReminderEnabled == practiceReminderEnabled &&
        other.newWordNotificationEnabled == newWordNotificationEnabled &&
        other.streakReminderEnabled == streakReminderEnabled;
  }

  @override
  int get hashCode {
    return notificationsEnabled.hashCode ^
        dailyReminderEnabled.hashCode ^
        practiceReminderEnabled.hashCode ^
        newWordNotificationEnabled.hashCode ^
        streakReminderEnabled.hashCode;
  }
}
