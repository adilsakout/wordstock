import 'package:flutter/material.dart';

/// {@template toggle_tile}
/// A reusable, modern toggle tile widget with icon, title, subtitle, and switch
///
/// This widget provides a consistent, sleek design for toggle settings
/// throughout the app. It follows Apple's Human Interface Guidelines with:
/// - Smooth animations and opacity transitions
/// - Optional loading state indicator
/// - Customizable colors and styling
/// - Support for disabled state
///
/// Perfect for settings pages, preferences, or any on/off toggle UI.
/// {@endtemplate}
class ToggleTile extends StatelessWidget {
  /// {@macro toggle_tile}
  const ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isUpdating = false,
    this.iconColor,
    this.iconBackgroundColor,
    this.activeColor,
    this.backgroundColor,
    this.borderColor,
    super.key,
  });

  /// The icon to display on the left side of the tile
  final IconData icon;

  /// The main title text
  final String title;

  /// The subtitle/description text shown below the title
  final String subtitle;

  /// The current toggle value (on/off)
  final bool value;

  /// Callback when the toggle is changed. If null, the toggle is disabled.
  final ValueChanged<bool>? onChanged;

  /// Whether to show a loading indicator instead of the switch
  ///
  /// When true, displays a circular progress indicator to indicate
  /// that the setting is being updated.
  final bool isUpdating;

  /// The color of the icon. Defaults to app's primary color.
  final Color? iconColor;

  /// The background color of the icon container. Defaults to a light tint.
  final Color? iconBackgroundColor;

  /// The active color of the switch. Defaults to app's primary color.
  final Color? activeColor;

  /// The background color of the tile. Defaults to a light grey.
  final Color? backgroundColor;

  /// The border color of the tile. Defaults to a medium grey.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    // Determine if the tile is enabled based on whether onChanged is provided
    final isEnabled = onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    // Default colors - using app's primary color scheme
    final defaultIconColor = iconColor ?? const Color(0xff1CB0F6);
    final defaultIconBgColor =
        iconBackgroundColor ?? const Color(0xff1CB0F6).withValues(alpha: 0.1);
    final defaultActiveColor = activeColor ?? const Color(0xff1CB0F6);
    final defaultBackgroundColor = backgroundColor ?? Colors.grey.shade50;
    final defaultBorderColor = borderColor ?? Colors.grey.shade200;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: defaultBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: defaultBorderColor,
          ),
        ),
        child: Row(
          children: [
            // Icon container with rounded background
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: defaultIconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: defaultIconColor,
              ),
            ),

            const SizedBox(width: 16),

            // Title and subtitle column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with medium weight
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle in grey
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

            // Switch or loading indicator
            if (isUpdating)
              // Show loading spinner when updating
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            else
              // Show switch when not updating
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: defaultActiveColor,
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade200,
              ),
          ],
        ),
      ),
    );
  }
}
