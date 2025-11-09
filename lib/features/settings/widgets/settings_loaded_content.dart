import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/features/settings/widgets/reset_settings_dialog.dart';
import 'package:wordstock/features/settings/widgets/settings_section_header.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/repositories/settings_repository.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/toggle_tile.dart';

/// {@template settings_loaded_content}
/// Main content widget for settings page when loaded
///
/// Displays all notification settings with toggles and a reset button.
/// Shows loading only on the specific toggle being updated.
/// {@endtemplate}
class SettingsLoadedContent extends StatelessWidget {
  /// {@macro settings_loaded_content}
  const SettingsLoadedContent({
    required this.settings,
    required this.updatingSetting,
    super.key,
  });

  /// The current notification settings
  final NotificationSettings settings;

  /// Which setting is currently being updated
  final UpdatingSettingType? updatingSetting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        // Section header
        SettingsSectionHeader(
          title: l10n.settingsNotifications,
          description: l10n.settingsNotificationsDescription,
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
            Gaimon.soft();
            context.read<SettingsCubit>().toggleNotifications(enabled: value);
          },
          isUpdating: updatingSetting == UpdatingSettingType.notifications,
        ).animate().fadeIn(
              duration: 200.milliseconds,
              delay: 200.milliseconds,
            ),

        const SizedBox(height: 10),

        // Daily reminders toggle
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

        // Practice reminders toggle
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

        // New word notifications toggle
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

        // Streak reminders toggle
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

        // Reset button - only show if any settings are enabled
        if (_shouldShowResetButton(settings))
          PushableButton(
            height: 56,
            text: l10n.settingsResetToDefaults,
            prefixIcon: Icons.restore,
            buttonColor: const Color(0xffE94E77),
            shadowColor: const Color(0xffA8002C),
            onTap: updatingSetting != null
                ? () {} // Disabled while updating
                : () {
                    Gaimon.soft();
                    ResetSettingsDialog.show(
                      context,
                      onConfirm: () {
                        context.read<SettingsCubit>().resetToDefaults();
                      },
                    );
                  },
          ).animate().fadeIn(
                duration: 200.milliseconds,
                delay: 450.milliseconds,
              ),

        // Bottom spacing for better UX
        const SizedBox(height: 40),
      ],
    );
  }

  /// Determines if the reset button should be shown
  bool _shouldShowResetButton(NotificationSettings settings) {
    return settings.notificationsEnabled ||
        settings.dailyReminderEnabled ||
        settings.practiceReminderEnabled ||
        settings.newWordNotificationEnabled ||
        settings.streakReminderEnabled;
  }
}
