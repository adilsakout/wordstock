import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/repositories/settings_repository.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/toggle_tile.dart';

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
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
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
          ),
        );
      },
    );
  }

  /// Builds the header section with navigation and title
  ///
  /// The header includes a colorful back button and page title
  /// that matches the app's playful, modern design language.
  Widget _buildHeader(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Colorful back button matching app's design
          PushableButton(
            width: 50,
            height: 50,
            buttonColor: const Color(0xffF9C835),
            shadowColor: const Color(0xffCDB054),
            text: '',
            suffixIcon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.pop(),
          ).animate().fadeIn(
                duration: 300.milliseconds,
                delay: 50.milliseconds,
              ),

          // Page title with bold typography
          Text(
            l10n.settingsTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1D1F),
            ),
          ).animate().fadeIn(
                duration: 300.milliseconds,
                delay: 100.milliseconds,
              ),

          // Spacer for centered title
          const SizedBox(width: 50),
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
  /// the settings are being initialized.
  Widget _buildInitialState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xffF9C835),
      ),
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
              const CircularProgressIndicator(
                color: Color(0xffF9C835),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.settingsLoadingMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        // Notifications section header
        _buildSectionHeader(
          context,
          l10n.settingsNotifications,
          l10n.settingsNotificationsDescription,
        ).animate().fadeIn(
              duration: 250.milliseconds,
              delay: 150.milliseconds,
            ),

        const SizedBox(height: 16),

        // Master notifications toggle
        ToggleTile(
          icon: Icons.notifications,
          title: l10n.settingsEnableNotifications,
          subtitle: l10n.settingsEnableNotificationsDescription,
          value: settings.notificationsEnabled,
          onChanged: (value) {
            Gaimon.soft(); // Haptic feedback
            context.read<SettingsCubit>().toggleNotifications(enabled: value);
          },
          isUpdating: updatingSetting == UpdatingSettingType.notifications,
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 200.milliseconds,
            ),

        const SizedBox(height: 10),

        // Individual notification toggles (disabled if master is off)
        ToggleTile(
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
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 250.milliseconds,
            ),

        const SizedBox(height: 10),

        ToggleTile(
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
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 300.milliseconds,
            ),

        const SizedBox(height: 10),

        ToggleTile(
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
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 350.milliseconds,
            ),

        const SizedBox(height: 10),

        ToggleTile(
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
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 400.milliseconds,
            ),

        const SizedBox(height: 24),

        // Reset button
        if (settings.notificationsEnabled ||
            settings.dailyReminderEnabled ||
            settings.practiceReminderEnabled ||
            settings.newWordNotificationEnabled ||
            settings.streakReminderEnabled)
          _buildResetButton(context, updatingSetting != null).animate().fadeIn(
                duration: 200.milliseconds,
                delay: 450.milliseconds,
              ),

        // Bottom spacing for better UX
        const SizedBox(height: 40),
      ],
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
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.settingsError,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            PushableButton(
              width: 120,
              height: 50,
              text: l10n.settingsRetry,
              buttonColor: const Color(0xffF9C835),
              shadowColor: const Color(0xffCDB054),
              onTap: () => context.read<SettingsCubit>().loadSettings(),
            ),
            if (previousSettings != null) ...[
              const SizedBox(height: 12),
              PushableButton(
                width: 150,
                height: 50,
                text: l10n.settingsRecover,
                buttonColor: const Color(0xff58CC02),
                shadowColor: const Color(0xff58A700),
                onTap: () => context.read<SettingsCubit>().recoverFromError(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a section header with title and description
  ///
  /// This creates a consistent header style matching the app's design system.
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1F),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Builds the reset button for restoring default settings
  ///
  /// This button allows users to reset all settings to their default values
  /// using the app's signature PushableButton design.
  Widget _buildResetButton(BuildContext context, bool isUpdating) {
    final l10n = context.l10n;

    return PushableButton(
      height: 56,
      text: l10n.settingsResetToDefaults,
      prefixIcon: Icons.restore,
      buttonColor: const Color(0xffE94E77),
      shadowColor: const Color(0xffA8002C),
      onTap: isUpdating
          ? () {}
          : () {
              Gaimon.soft();
              _showResetDialog(context);
            },
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
