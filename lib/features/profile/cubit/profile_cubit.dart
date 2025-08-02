import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/user_repository.dart';

part 'profile_state.dart';

/// {@template profile_cubit}
/// Cubit responsible for managing user profile data and operations
/// Follows clean architecture principles by containing all business logic
/// {@endtemplate}
class ProfileCubit extends Cubit<ProfileState> {
  /// {@macro profile_cubit}
  ProfileCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ProfileInitial());

  final UserRepository _userRepository;

  /// Current user profile (cached after loading)
  UserProfile? _currentProfile;

  /// Load the user's profile data
  /// This method handles all business logic for profile loading
  Future<void> loadProfile() async {
    try {
      emit(const ProfileLoading());

      log('Loading user profile...', name: 'ProfileCubit');
      final profile = await _userRepository.getProfile();
      _currentProfile = profile;

      emit(ProfileLoaded(userProfile: profile));
      log('Profile loaded successfully', name: 'ProfileCubit');
    } catch (e) {
      final errorMessage = 'Failed to load profile: $e';
      log(errorMessage, name: 'ProfileCubit', error: e);
      emit(
        ProfileError(
          message: 'Unable to load your profile. Please try again.',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Show vocabulary level selection dialog
  /// This method triggers the UI to show the dialog through state change
  Future<void> showVocabularyLevelDialog() async {
    try {
      // Ensure we have current profile data
      if (_currentProfile == null) {
        await loadProfile();
      }

      if (_currentProfile != null) {
        emit(
          ProfileShowVocabularyLevelDialog(
            currentLevel: _currentProfile!.level,
          ),
        );
        log(
          'Showing vocabulary level dialog for level:'
          '${_currentProfile!.level}',
          name: 'ProfileCubit',
        );
      } else {
        emit(
          const ProfileError(
            message:
                'Unable to load current vocabulary level. Please try again.',
          ),
        );
      }
    } catch (e) {
      final errorMessage = 'Failed to show vocabulary level dialog: $e';
      log(errorMessage, name: 'ProfileCubit', error: e);
      emit(
        ProfileError(
          message: 'Unable to show vocabulary level options. Please try again.',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Update the user's vocabulary level
  /// This method handles all business logic for vocabulary level updates
  Future<void> updateVocabularyLevel(VocabularyLevel newLevel) async {
    try {
      // Validate the new level
      if (!VocabularyLevels.all.any((config) => config.level == newLevel)) {
        throw ArgumentError('Invalid vocabulary level: $newLevel');
      }

      emit(ProfileUpdatingVocabularyLevel(newLevel: newLevel));
      log('Updating vocabulary level to: $newLevel', name: 'ProfileCubit');

      // Update in repository
      await _userRepository.updateVocabularyLevel(newLevel);

      // Update local cache
      if (_currentProfile != null) {
        _currentProfile = _currentProfile!.copyWith(level: newLevel);

        emit(
          ProfileVocabularyLevelUpdated(
            userProfile: _currentProfile!,
            updatedLevel: newLevel,
          ),
        );

        log(
          'Vocabulary level updated successfully to: $newLevel',
          name: 'ProfileCubit',
        );
      } else {
        // Reload profile if cache is empty
        await loadProfile();
      }
    } catch (e) {
      final errorMessage = 'Failed to update vocabulary level: $e';
      log(errorMessage, name: 'ProfileCubit', error: e);

      // Return to previous state with error
      if (_currentProfile != null) {
        emit(ProfileLoaded(userProfile: _currentProfile!));
      }

      emit(
        ProfileError(
          message: 'Failed to update vocabulary level. Please try again.',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Clear error state and return to loaded state
  /// This allows the UI to recover from errors gracefully
  void clearError() {
    if (_currentProfile != null) {
      emit(ProfileLoaded(userProfile: _currentProfile!));
    } else {
      emit(const ProfileInitial());
    }
  }

  /// Refresh profile data
  /// Force reload the profile from the server
  Future<void> refreshProfile() async {
    _currentProfile = null; // Clear cache
    await loadProfile();
  }

  /// Get current vocabulary level safely
  /// Returns current level or beginner as fallback
  VocabularyLevel get currentVocabularyLevel {
    return _currentProfile?.level ?? VocabularyLevel.beginner;
  }

  /// Check if profile is currently loaded
  bool get hasProfile => _currentProfile != null;
}
