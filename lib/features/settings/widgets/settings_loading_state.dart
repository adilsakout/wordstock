import 'package:flutter/material.dart';
import 'package:wordstock/l10n/l10n.dart';

/// {@template settings_loading_state}
/// Loading state widget for settings page
///
/// Displays a loading indicator with a message while settings are being loaded.
/// {@endtemplate}
class SettingsLoadingState extends StatelessWidget {
  /// {@macro settings_loading_state}
  const SettingsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
