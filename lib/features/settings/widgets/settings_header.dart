import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template settings_header}
/// Header widget for the settings page
///
/// Displays a colorful back button and page title matching the app's
/// modern, playful design language.
/// {@endtemplate}
class SettingsHeader extends StatelessWidget {
  /// {@macro settings_header}
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
}
