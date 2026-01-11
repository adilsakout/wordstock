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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
