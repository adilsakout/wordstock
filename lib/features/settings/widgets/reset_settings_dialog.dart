import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template reset_settings_dialog}
/// Confirmation dialog for resetting settings to defaults
///
/// Displays a modern, animated dialog that matches the app's design
/// language with colorful buttons and smooth animations.
/// {@endtemplate}
class ResetSettingsDialog extends StatelessWidget {
  /// {@macro reset_settings_dialog}
  const ResetSettingsDialog({
    required this.onConfirm,
    super.key,
  });

  /// Callback when reset is confirmed
  final VoidCallback onConfirm;

  /// Shows the reset settings confirmation dialog
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => ResetSettingsDialog(
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with animation
            const Icon(
              Icons.restore,
              size: 64,
              color: Color(0xffE94E77),
            ).animate().scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                  duration: 300.milliseconds,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 16),

            // Title
            Text(
              l10n.settingsResetTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xffE94E77),
              ),
            ).animate().fadeIn(
                  duration: 300.milliseconds,
                  delay: 100.milliseconds,
                ),

            const SizedBox(height: 16),

            // Message
            Text(
              l10n.settingsResetMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ).animate().fadeIn(
                  duration: 300.milliseconds,
                  delay: 200.milliseconds,
                ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel button
                PushableButton(
                  width: 110,
                  height: 50,
                  textColor: Colors.grey.shade600,
                  buttonColor: Colors.grey.shade200,
                  shadowColor: Colors.grey.shade400,
                  text: l10n.cancel,
                  onTap: () {
                    Gaimon.soft();
                    Navigator.of(context).pop();
                  },
                ).animate().fadeIn(
                      duration: 300.milliseconds,
                      delay: 300.milliseconds,
                    ),

                const SizedBox(width: 16),

                // Reset button
                PushableButton(
                  width: 110,
                  height: 50,
                  buttonColor: const Color(0xffE94E77),
                  shadowColor: const Color(0xffA8002C),
                  text: l10n.reset,
                  onTap: () {
                    Gaimon.soft();
                    Navigator.of(context).pop();
                    // Call the callback to reset settings
                    onConfirm();
                  },
                ).animate().fadeIn(
                      duration: 300.milliseconds,
                      delay: 400.milliseconds,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
