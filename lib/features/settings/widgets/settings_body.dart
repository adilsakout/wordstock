import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/repositories/settings_repository.dart';

/// {@template settings_body}
/// Body of the SettingsPage.
///
/// Displays notification settings and preferences in a modern,
///  animated interface
/// that follows Apple's Human Interface Guidelines.
/// The interface provides intuitive
/// toggles for various notification types with smooth spring animations.
/// {@endtemplate}
class SettingsBody extends StatelessWidget {
  /// {@macro settings_body}
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              // Header with title and back button
              _buildHeader(context),

              // Settings content
              Expanded(
                child: _buildContent(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the header section with navigation and title
  ///
  /// The header includes a back button and the page title
  ///  with smooth animations
  /// that follow the app's established design patterns.
  Widget _buildHeader(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Back button with haptic feedback
          IconButton(
            onPressed: () {
              Gaimon.soft(); // Haptic feedback for better user experience
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            ),
          ).animate().fadeIn().slideX(
                begin: -1,
                duration: 400.milliseconds,
              ),

          const SizedBox(width: 16),

          // Page title with modern typography
          Text(
            l10n.settingsTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
          ).animate().fadeIn().slideY(
                begin: 1,
                duration: 400.milliseconds,
              ),
        ],
      ),
    );
  }

  /// Builds the main content area based on the current state
  ///
  /// This method handles different states (loading, loaded, error) and provides
  /// appropriate UI feedback for each state.
  Widget _buildContent(BuildContext context, SettingsState state) {
    return state.when(
      initial: _buildInitialState,
      loading: _buildLoadingState,
      loaded: (settings, {required updatingSetting}) =>
          _buildLoadedState(context, settings, updatingSetting),
      error: (message, previousSettings) =>
          _buildErrorState(context, message, previousSettings),
    );
  }

  /// Builds the initial state UI
  ///
  /// Shows a minimal loading indicator while
  ///  the settings are being initialized.
  Widget _buildInitialState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Builds the loading state UI
  ///
  /// Displays a loading indicator with a message to inform the user that
  /// settings are being loaded.
  Widget _buildLoadingState() {
    return Builder(
      builder: (context) {
        final l10n = context.l10n;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                l10n.settingsLoadingMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the loaded state UI with notification settings
  ///
  /// This is the main UI that displays all notification settings with toggles.
  /// It includes smooth animations and follows the app's design patterns.
  /// Now shows loading only on the specific toggle being updated.
  Widget _buildLoadedState(
    BuildContext context,
    NotificationSettings settings,
    UpdatingSettingType? updatingSetting,
  ) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications section header
          _buildSectionHeader(
            context,
            l10n.settingsNotifications,
            l10n.settingsNotificationsDescription,
          ).animate().fadeIn().slideY(
                begin: 1,
                delay: 100.milliseconds,
                duration: 400.milliseconds,
              ),

          const SizedBox(height: 24),

          // Master notifications toggle
          _buildNotificationToggle(
            context,
            icon: Icons.notifications,
            title: l10n.settingsEnableNotifications,
            subtitle: l10n.settingsEnableNotificationsDescription,
            value: settings.notificationsEnabled,
            onChanged: (value) {
              Gaimon.soft(); // Haptic feedback
              context.read<SettingsCubit>().toggleNotifications(enabled: value);
            },
            isUpdating: updatingSetting == UpdatingSettingType.notifications,
          ).animate().fadeIn().slideY(
                begin: 1,
                delay: 200.milliseconds,
                duration: 400.milliseconds,
              ),

          const SizedBox(height: 16),

          // Individual notification toggles (disabled if master is off)
          _buildNotificationToggle(
            context,
            icon: Icons.schedule,
            title: l10n.settingsDailyReminders,
            subtitle: l10n.settingsDailyRemindersDescription,
            value: settings.dailyReminderEnabled,
            onChanged: settings.notificationsEnabled
                ? (value) {
                    Gaimon.soft();
                    context
                        .read<SettingsCubit>()
                        .toggleDailyReminder(enabled: value);
                  }
                : null,
            isUpdating: updatingSetting == UpdatingSettingType.dailyReminder,
          ).animate().fadeIn().slideY(
                begin: 1,
                delay: 300.milliseconds,
                duration: 400.milliseconds,
              ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            context,
            icon: Icons.fitness_center,
            title: l10n.settingsPracticeReminders,
            subtitle: l10n.settingsPracticeRemindersDescription,
            value: settings.practiceReminderEnabled,
            onChanged: settings.notificationsEnabled
                ? (value) {
                    Gaimon.soft();
                    context
                        .read<SettingsCubit>()
                        .togglePracticeReminder(enabled: value);
                  }
                : null,
            isUpdating: updatingSetting == UpdatingSettingType.practiceReminder,
          ).animate().fadeIn().slideY(
                begin: 1,
                delay: 400.milliseconds,
                duration: 400.milliseconds,
              ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            context,
            icon: Icons.library_books,
            title: l10n.settingsNewWords,
            subtitle: l10n.settingsNewWordsDescription,
            value: settings.newWordNotificationEnabled,
            onChanged: settings.notificationsEnabled
                ? (value) {
                    Gaimon.soft();
                    context
                        .read<SettingsCubit>()
                        .toggleNewWordNotification(enabled: value);
                  }
                : null,
            isUpdating: updatingSetting == UpdatingSettingType.newWord,
          ).animate().fadeIn().slideY(
                begin: 1,
                delay: 500.milliseconds,
                duration: 400.milliseconds,
              ),

          const SizedBox(height: 16),

          _buildNotificationToggle(
            context,
            icon: Icons.local_fire_department,
            title: l10n.settingsStreakReminders,
            subtitle: l10n.settingsStreakRemindersDescription,
            value: settings.streakReminderEnabled,
            onChanged: settings.notificationsEnabled
                ? (value) {
                    Gaimon.soft();
                    context
                        .read<SettingsCubit>()
                        .toggleStreakReminder(enabled: value);
                  }
                : null,
            isUpdating: updatingSetting == UpdatingSettingType.streakReminder,
          ).animate().fadeIn().slideY(
                begin: 1,
                delay: 600.milliseconds,
                duration: 400.milliseconds,
              ),

          const SizedBox(height: 40),

          // Reset button
          if (settings.notificationsEnabled ||
              settings.dailyReminderEnabled ||
              settings.practiceReminderEnabled ||
              settings.newWordNotificationEnabled ||
              settings.streakReminderEnabled)
            _buildResetButton(context, updatingSetting != null)
                .animate()
                .fadeIn()
                .slideY(
                  begin: 1,
                  delay: 700.milliseconds,
                  duration: 400.milliseconds,
                ),
        ],
      ),
    );
  }

  /// Builds the error state UI
  ///
  /// Shows an error message with options to retry or recover from the error.
  Widget _buildErrorState(
    BuildContext context,
    String message,
    NotificationSettings? previousSettings,
  ) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.settingsError,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Gaimon.soft();
                    context.read<SettingsCubit>().loadSettings();
                  },
                  child: Text(l10n.settingsRetry),
                ),
                if (previousSettings != null)
                  TextButton(
                    onPressed: () {
                      Gaimon.soft();
                      context.read<SettingsCubit>().recoverFromError();
                    },
                    child: Text(l10n.settingsRecover),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a section header with title and description
  ///
  /// This creates a consistent header style for different sections of settings.
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Builds a notification toggle with icon, title, and switch
  ///
  /// This creates a consistent toggle UI that follows the app's design patterns
  /// with smooth animations and haptic feedback.
  Widget _buildNotificationToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    required bool isUpdating,
  }) {
    final isEnabled = onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Icon with consistent styling
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xff1CB0F6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xff1CB0F6),
              ),
            ),

            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Switch with loading indicator
            if (isUpdating)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            else
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: const Color(0xff1CB0F6),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade200,
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the reset button for restoring default settings
  ///
  /// This button allows users to reset all settings to their default values.
  Widget _buildResetButton(BuildContext context, bool isUpdating) {
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isUpdating
            ? null
            : () {
                Gaimon.soft();
                _showResetDialog(context);
              },
        icon: const Icon(Icons.restore),
        label: Text(l10n.settingsResetToDefaults),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog for resetting settings
  ///
  /// This dialog confirms the user's intent to reset all settings to defaults.
  void _showResetDialog(BuildContext context) {
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsResetTitle),
        content: Text(l10n.settingsResetMessage),
        actions: [
          TextButton(
            onPressed: () {
              Gaimon.soft();
              Navigator.of(context).pop();
            },
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Gaimon.soft();
              Navigator.of(context).pop();
              context.read<SettingsCubit>().resetToDefaults();
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}

/// Extension to add a `when` method to SettingsState
///
/// This extension provides a more convenient way to handle different states
/// in the UI, similar to pattern matching in other languages.
/// Updated to track which specific setting is being updated.
extension SettingsStateExtension on SettingsState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(
      NotificationSettings settings, {
      required UpdatingSettingType? updatingSetting,
    }) loaded,
    required T Function(String message, NotificationSettings? previousSettings)
        error,
  }) {
    if (this is SettingsInitial) {
      return initial();
    } else if (this is SettingsLoading) {
      return loading();
    } else if (this is SettingsLoaded) {
      final state = this as SettingsLoaded;
      return loaded(
        state.notificationSettings,
        updatingSetting: state.updatingSetting,
      );
    } else if (this is SettingsError) {
      final state = this as SettingsError;
      return error(state.errorMessage, state.previousSettings);
    }
    throw Exception('Unknown state: $this');
  }
}
