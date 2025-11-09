import 'package:flutter/material.dart';

/// {@template settings_section_header}
/// Reusable section header widget for settings
///
/// Displays a title and description with consistent styling
/// matching the app's design system.
/// {@endtemplate}
class SettingsSectionHeader extends StatelessWidget {
  /// {@macro settings_section_header}
  const SettingsSectionHeader({
    required this.title,
    required this.description,
    super.key,
  });

  /// The section title
  final String title;

  /// The section description
  final String description;

  @override
  Widget build(BuildContext context) {
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
}
