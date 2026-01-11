import 'package:flutter/material.dart';

/// App color constants that remain the same in both light and dark themes
class AppColors {
  AppColors._();

  // Primary button colors (stay consistent across themes)
  static const Color primaryBlue = Color(0xff1CB0F6);
  static const Color primaryBlueShadow = Color(0xff1899D6);

  // Yellow button colors
  static const Color primaryYellow = Color(0xffF9C835);
  static const Color primaryYellowShadow = Color(0xffCDB054);

  // Green button colors
  static const Color primaryGreen = Color(0xFF77D728);
  static const Color primaryGreenShadow = Color(0xFF49A100);

  // Favorite/heart color
  static const Color favoriteRed = Color(0xffE94E77);
  static const Color favoriteRedShadow = Color(0xffA8002C);

  // Light theme specific colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);

  // Dark theme specific colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
}

/// Light theme configuration
ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryYellow,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      bodySmall: TextStyle(color: AppColors.lightTextSecondary),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightSurface,
      elevation: 2,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.lightSurface,
    ),
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
  );
}

/// Dark theme configuration
ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryYellow,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
      bodySmall: TextStyle(color: AppColors.darkTextSecondary),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkSurface,
    ),
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
  );
}
