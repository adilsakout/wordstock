import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/repositories/settings_repository.dart';

part 'settings_state.dart';

/// {@template settings_cubit}
/// Cubit for managing user settings and preferences
///
/// This cubit handles all settings-related operations including loading,
/// updating, and managing notification preferences. It follows the BLoC
/// pattern used throughout the app for consistent state management.
/// {@endtemplate}
class SettingsCubit extends Cubit<SettingsState> {
  /// {@macro settings_cubit}
  SettingsCubit({
    SettingsRepository? settingsRepository,
  })  : _settingsRepository = settingsRepository ?? SettingsRepository(),
        super(const SettingsInitial());

  final SettingsRepository _settingsRepository;

  /// Load the current settings from storage
  ///
  /// This method fetches all settings from the repository and updates
  /// the state accordingly. It handles both successful loads and errors.
  Future<void> loadSettings() async {
    try {
      emit(const SettingsLoading());

      final notificationSettings =
          await _settingsRepository.getNotificationSettings();

      emit(
        SettingsLoaded(
          notificationSettings: notificationSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to load settings: $e',
        ),
      );
    }
  }

  /// Toggle the master notification setting
  ///
  /// When notifications are disabled, this affects all notification types.
  /// The UI should reflect this by disabling individual notification toggles.
  Future<void> toggleNotifications({required bool enabled}) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      // Show updating state while preserving current settings
      emit(currentState.copyWith(isUpdating: true));

      // Update in repository
      await _settingsRepository.toggleNotifications(enabled: enabled);

      // Update the notification settings object
      final updatedSettings = currentState.notificationSettings.copyWith(
        notificationsEnabled: enabled,
      );

      emit(
        SettingsLoaded(
          notificationSettings: updatedSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to update notification settings: $e',
          previousSettings: currentState.notificationSettings,
        ),
      );
    }
  }

  /// Toggle daily reminder notifications
  ///
  /// Daily reminders help users maintain consistent learning habits.
  /// This setting only takes effect when notifications are globally enabled.
  Future<void> toggleDailyReminder({required bool enabled}) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      emit(currentState.copyWith(isUpdating: true));

      await _settingsRepository.toggleDailyReminder(enabled: enabled);

      final updatedSettings = currentState.notificationSettings.copyWith(
        dailyReminderEnabled: enabled,
      );

      emit(
        SettingsLoaded(
          notificationSettings: updatedSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to update daily reminder settings: $e',
          previousSettings: currentState.notificationSettings,
        ),
      );
    }
  }

  /// Toggle practice reminder notifications
  ///
  /// Practice reminders encourage users to return to the app when
  /// they haven't practiced for a while.
  Future<void> togglePracticeReminder({required bool enabled}) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      emit(currentState.copyWith(isUpdating: true));

      await _settingsRepository.togglePracticeReminder(enabled: enabled);

      final updatedSettings = currentState.notificationSettings.copyWith(
        practiceReminderEnabled: enabled,
      );

      emit(
        SettingsLoaded(
          notificationSettings: updatedSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to update practice reminder settings: $e',
          previousSettings: currentState.notificationSettings,
        ),
      );
    }
  }

  /// Toggle new word notifications
  ///
  /// New word notifications alert users when fresh vocabulary
  /// content is available for learning.
  Future<void> toggleNewWordNotification({required bool enabled}) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      emit(currentState.copyWith(isUpdating: true));

      await _settingsRepository.toggleNewWordNotification(enabled: enabled);

      final updatedSettings = currentState.notificationSettings.copyWith(
        newWordNotificationEnabled: enabled,
      );

      emit(
        SettingsLoaded(
          notificationSettings: updatedSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to update new word notification settings: $e',
          previousSettings: currentState.notificationSettings,
        ),
      );
    }
  }

  /// Toggle streak reminder notifications
  ///
  /// Streak reminders help users maintain their learning consistency
  /// by alerting them when their streak is at risk.
  Future<void> toggleStreakReminder({required bool enabled}) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      emit(currentState.copyWith(isUpdating: true));

      await _settingsRepository.toggleStreakReminder(enabled: enabled);

      final updatedSettings = currentState.notificationSettings.copyWith(
        streakReminderEnabled: enabled,
      );

      emit(
        SettingsLoaded(
          notificationSettings: updatedSettings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to update streak reminder settings: $e',
          previousSettings: currentState.notificationSettings,
        ),
      );
    }
  }

  /// Update all notification settings at once
  ///
  /// This method is useful when multiple settings need to be updated
  /// simultaneously, such as when restoring from a backup or applying
  /// a settings template.
  Future<void> updateAllNotificationSettings(
    NotificationSettings settings,
  ) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      emit(currentState.copyWith(isUpdating: true));

      await _settingsRepository.updateNotificationSettings(settings);

      emit(
        SettingsLoaded(
          notificationSettings: settings,
        ),
      );
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to update all notification settings: $e',
          previousSettings: currentState.notificationSettings,
        ),
      );
    }
  }

  /// Reset all settings to their default values
  ///
  /// This method clears all stored settings and loads the defaults.
  /// It's useful for troubleshooting or when users want to start fresh.
  Future<void> resetToDefaults() async {
    try {
      emit(const SettingsLoading());

      // Clear all settings from storage
      await _settingsRepository.clearAllSettings();

      // Load default settings
      await loadSettings();
    } catch (e) {
      emit(
        SettingsError(
          errorMessage: 'Failed to reset settings to defaults: $e',
        ),
      );
    }
  }

  /// Recover from error state
  ///
  /// This method attempts to recover from an error state by reloading
  /// the settings from storage. If previous settings are available,
  /// it can also attempt to restore them.
  Future<void> recoverFromError() async {
    final currentState = state;

    if (currentState is SettingsError &&
        currentState.previousSettings != null) {
      try {
        emit(const SettingsLoading());

        // Try to restore previous settings
        await _settingsRepository.updateNotificationSettings(
          currentState.previousSettings!,
        );

        emit(
          SettingsLoaded(
            notificationSettings: currentState.previousSettings!,
          ),
        );
      } catch (e) {
        // If restore fails, try to load fresh settings
        await loadSettings();
      }
    } else {
      // No previous settings available, load fresh from storage
      await loadSettings();
    }
  }

  /// Check if notifications are globally enabled
  ///
  /// This is a convenience method that provides quick access to the
  /// master notification setting without needing to access the full state.
  bool get areNotificationsEnabled {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      return currentState.notificationSettings.notificationsEnabled;
    }
    return true; // Default to enabled
  }

  /// Get current notification settings
  ///
  /// This method provides access to the current notification settings
  /// or null if settings haven't been loaded yet.
  NotificationSettings? get currentNotificationSettings {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      return currentState.notificationSettings;
    }
    return null;
  }
}
