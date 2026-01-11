import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';

/// {@template theme_selector}
/// A widget that allows users to select their preferred theme mode
///
/// Provides three options:
/// - System: follows device theme setting
/// - Light: always light theme
/// - Dark: always dark theme
/// {@endtemplate}
class ThemeSelector extends StatelessWidget {
  /// {@macro theme_selector}
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsTheme,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.settingsThemeDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Theme mode selector
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _ThemeOption(
                      icon: Icons.phone_android,
                      label: l10n.settingsThemeSystem,
                      isSelected: state.themeMode == ThemeMode.system,
                      onTap: () {
                        Gaimon.soft();
                        context
                            .read<ThemeCubit>()
                            .setThemeMode(ThemeMode.system);
                      },
                    ),
                    _ThemeOption(
                      icon: Icons.light_mode,
                      label: l10n.settingsThemeLight,
                      isSelected: state.themeMode == ThemeMode.light,
                      onTap: () {
                        Gaimon.soft();
                        context
                            .read<ThemeCubit>()
                            .setThemeMode(ThemeMode.light);
                      },
                    ),
                    _ThemeOption(
                      icon: Icons.dark_mode,
                      label: l10n.settingsThemeDark,
                      isSelected: state.themeMode == ThemeMode.dark,
                      onTap: () {
                        Gaimon.soft();
                        context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
