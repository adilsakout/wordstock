import 'package:flutter/material.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/repositories/settings_repository.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template settings_error_state}
/// Error state widget for settings page
///
/// Displays an error message with retry and recovery options
/// using the app's colorful button design.
/// {@endtemplate}
class SettingsErrorState extends StatelessWidget {
  /// {@macro settings_error_state}
  const SettingsErrorState({
    required this.message,
    this.previousSettings,
    super.key,
  });

  /// The error message to display
  final String message;

  /// Previous settings that can be recovered
  final NotificationSettings? previousSettings;

  @override
  Widget build(BuildContext context) {
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
}
