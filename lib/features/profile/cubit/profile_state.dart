part of 'profile_cubit.dart';

/// {@template profile_state}
/// Base state for ProfileCubit
/// {@endtemplate}
abstract class ProfileState extends Equatable {
  /// {@macro profile_state}
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// {@template profile_initial}
/// Initial state when ProfileCubit is first created
/// {@endtemplate}
class ProfileInitial extends ProfileState {
  /// {@macro profile_initial}
  const ProfileInitial();
}

/// {@template profile_loading}
/// State when profile data is being loaded
/// {@endtemplate}
class ProfileLoading extends ProfileState {
  /// {@macro profile_loading}
  const ProfileLoading();
}

/// {@template profile_loaded}
/// State when profile data has been successfully loaded
/// {@endtemplate}
class ProfileLoaded extends ProfileState {
  /// {@macro profile_loaded}
  const ProfileLoaded({
    required this.userProfile,
  });

  /// The user's profile data
  final UserProfile userProfile;

  @override
  List<Object> get props => [userProfile];
}

/// {@template profile_updating_vocabulary_level}
/// State when vocabulary level is being updated
/// {@endtemplate}
class ProfileUpdatingVocabularyLevel extends ProfileState {
  /// {@macro profile_updating_vocabulary_level}
  const ProfileUpdatingVocabularyLevel({
    required this.newLevel,
  });

  /// The new vocabulary level being set
  final VocabularyLevel newLevel;

  @override
  List<Object> get props => [newLevel];
}

/// {@template profile_vocabulary_level_updated}
/// State when vocabulary level has been successfully updated
/// {@endtemplate}
class ProfileVocabularyLevelUpdated extends ProfileState {
  /// {@macro profile_vocabulary_level_updated}
  const ProfileVocabularyLevelUpdated({
    required this.userProfile,
    required this.updatedLevel,
  });

  /// The updated user profile
  final UserProfile userProfile;

  /// The vocabulary level that was just updated
  final VocabularyLevel updatedLevel;

  @override
  List<Object> get props => [userProfile, updatedLevel];
}

/// {@template profile_error}
/// State when an error has occurred
/// {@endtemplate}
class ProfileError extends ProfileState {
  /// {@macro profile_error}
  const ProfileError({
    required this.message,
    this.exception,
  });

  /// Human-readable error message
  final String message;

  /// The original exception (optional)
  final Exception? exception;

  @override
  List<Object?> get props => [message, exception];
}

/// {@template profile_show_vocabulary_level_dialog}
/// State when vocabulary level dialog should be shown
/// {@endtemplate}
class ProfileShowVocabularyLevelDialog extends ProfileState {
  /// {@macro profile_show_vocabulary_level_dialog}
  const ProfileShowVocabularyLevelDialog({
    required this.currentLevel,
  });

  /// Current vocabulary level to show as selected
  final VocabularyLevel currentLevel;

  @override
  List<Object> get props => [currentLevel];
}
