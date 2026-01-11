import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

/// {@template theme_cubit}
/// Cubit for managing app theme preferences
///
/// Supports three modes:
/// - System: follows device theme setting
/// - Light: always light theme
/// - Dark: always dark theme
/// {@endtemplate}
class ThemeCubit extends Cubit<ThemeState> {
  /// {@macro theme_cubit}
  ThemeCubit() : super(const ThemeState());

  static const String _themeModeKey = 'theme_mode';

  /// Load the saved theme preference from storage
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);

      final themeMode = switch (savedMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

      emit(ThemeState(themeMode: themeMode));
    } catch (e) {
      // Default to system theme if loading fails
      emit(const ThemeState());
    }
  }

  /// Set the theme mode and persist to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    emit(ThemeState(themeMode: mode));

    try {
      final prefs = await SharedPreferences.getInstance();
      final modeString = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await prefs.setString(_themeModeKey, modeString);
    } catch (e) {
      // Silently fail - theme is already applied in memory
    }
  }
}
