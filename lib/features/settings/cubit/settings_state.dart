part of 'settings_cubit.dart';

/// {@template settings_state}
/// State for managing user settings and preferences
///
/// This state manages the loading, loaded, and error states for user settings,
/// particularly focusing on notification preferences
///  but designed to be extensible
/// for future settings additions.
/// {@endtemplate}
abstract class SettingsState extends Equatable {
  /// {@macro settings_state}
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// {@template settings_initial}
/// The initial state of SettingsState
///
/// This state is shown when the settings cubit is first created
/// and before any settings have been loaded.
/// {@endtemplate}
class SettingsInitial extends SettingsState {
  /// {@macro settings_initial}
  const SettingsInitial();
}

/// {@template settings_loading}
/// The loading state of SettingsState
///
/// This state is shown while settings are being loaded from storage
/// or while settings changes are being saved.
/// {@endtemplate}
class SettingsLoading extends SettingsState {
  /// {@macro settings_loading}
  const SettingsLoading();
}

/// {@template settings_loaded}
/// The loaded state of SettingsState
///
/// This state contains the current notification settings and indicates
/// that the settings have been successfully loaded from storage.
/// {@endtemplate}
class SettingsLoaded extends SettingsState {
  /// {@macro settings_loaded}
  const SettingsLoaded({
    required this.notificationSettings,
    this.isUpdating = false,
  });

  /// The current notification settings
  ///
  /// This object contains all notification preferences including
  /// the master toggle and individual notification type settings.
  final NotificationSettings notificationSettings;

  /// Whether settings are currently being updated
  ///
  /// This flag is used to show loading indicators during settings updates
  /// while keeping the current settings visible to the user.
  final bool isUpdating;

  @override
  List<Object?> get props => [notificationSettings, isUpdating];

  /// Creates a copy of this SettingsLoaded state with the given fields replaced
  ///
  /// This method provides an immutable way to update the state while
  /// maintaining the existing values for unchanged fields.
  SettingsLoaded copyWith({
    NotificationSettings? notificationSettings,
    bool? isUpdating,
  }) {
    return SettingsLoaded(
      notificationSettings: notificationSettings ?? this.notificationSettings,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

/// {@template settings_error}
/// The error state of SettingsState
///
/// This state is shown when there's an error loading or saving settings.
/// It contains an error message that can be displayed to the user.
/// {@endtemplate}
class SettingsError extends SettingsState {
  /// {@macro settings_error}
  const SettingsError({
    required this.errorMessage,
    this.previousSettings,
  });

  /// The error message describing what went wrong
  ///
  /// This message can be displayed to the user to help them understand
  /// what happened and potentially how to resolve the issue.
  final String errorMessage;

  /// The previous settings before the error occurred
  ///
  /// This allows the app to potentially recover from errors by
  /// reverting to the last known good settings state.
  final NotificationSettings? previousSettings;

  @override
  List<Object?> get props => [errorMessage, previousSettings];
}
