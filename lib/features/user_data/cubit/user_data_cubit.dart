import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/user_repository.dart';

part 'user_data_state.dart';

class StreakCubit extends Cubit<StreakState> {
  StreakCubit({required this.userRepository}) : super(const StreakState()) {
    loadProfile();
  }
  final UserRepository userRepository;

  Future<void> loadProfile() async {
    emit(state.copyWith(status: StreakStatus.loading));
    try {
      final profile = await userRepository.getProfile();
      emit(
        state.copyWith(
          status: StreakStatus.loaded,
          profile: profile,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StreakStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateStreak() async {
    try {
      if (state.isLoaded && state.profile != null) {
        final profile = state.profile!;
        final now = DateTime.now();
        if (profile.lastActiveDate.year < now.year ||
            profile.lastActiveDate.month < now.month ||
            profile.lastActiveDate.day < now.day) {
          await userRepository.updateDailyStreak();
          final updatedProfile = await userRepository.getProfile();
          emit(
            state.copyWith(
              status: StreakStatus.loaded,
              profile: updatedProfile,
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: StreakStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  final List<String> _learnedWordIds = [];
  Timer? _updateTimer;

  void markWordAsLearned(String wordId) {
    _learnedWordIds.add(wordId);
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(seconds: 5), _submitProgress);
  }

  Future<void> _submitProgress() async {
    if (_learnedWordIds.isEmpty) return;
    try {
      await userRepository.updateTotalPoints(_learnedWordIds.length);
      _learnedWordIds.clear();
      final updatedProfile = await userRepository.getProfile();
      emit(
        state.copyWith(
          status: StreakStatus.loaded,
          profile: updatedProfile,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StreakStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
