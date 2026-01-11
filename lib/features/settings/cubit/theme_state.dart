part of 'theme_cubit.dart';

/// {@template theme_state}
/// State for the theme cubit
/// {@endtemplate}
class ThemeState extends Equatable {
  /// {@macro theme_state}
  const ThemeState({
    this.themeMode = ThemeMode.system,
  });

  /// The current theme mode
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];

  /// Creates a copy of this state with the given fields replaced
  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
