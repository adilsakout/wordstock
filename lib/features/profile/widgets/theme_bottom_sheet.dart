import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';
import 'package:wordstock/features/settings/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';

/// Shows a bottom sheet for theme selection
///
/// Displays System, Light, and Dark theme options with visual feedback
/// for the currently selected theme.
void showThemeBottomSheet(BuildContext context) {
  Gaimon.soft();
  final l10n = context.l10n;
  final theme = Theme.of(context);

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsTheme,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsThemeDescription,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Selector(
                  text: l10n.settingsThemeSystem,
                  selected: state.themeMode == ThemeMode.system,
                  onTap: () {
                    Gaimon.soft();
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                Selector(
                  text: l10n.settingsThemeLight,
                  selected: state.themeMode == ThemeMode.light,
                  onTap: () {
                    Gaimon.soft();
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                Selector(
                  text: l10n.settingsThemeDark,
                  selected: state.themeMode == ThemeMode.dark,
                  onTap: () {
                    Gaimon.soft();
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}
