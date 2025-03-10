import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/user_repository.dart';

part 'user_data_state.dart';

class StreakCubit extends Cubit<StreakState> {
  StreakCubit({required this.userRepository}) : super(StreakInitial()) {
    loadProfile();
  }
  final UserRepository userRepository;

  Future<void> loadProfile() async {
    emit(StreakLoading());
    try {
      final profile = await userRepository.getProfile();
      emit(StreakLoaded(profile));
    } catch (e) {
      emit(StreakError(e.toString()));
    }
  }

  Future<void> updateStreak() async {
    try {
      if (state is StreakLoaded) {
        final profile = (state as StreakLoaded).profile;
        final now = DateTime.now();
        if (profile.lastActiveDate.year < now.year ||
            profile.lastActiveDate.month < now.month ||
            profile.lastActiveDate.day < now.day) {
          await userRepository.updateDailyStreak();
          final updatedProfile = await userRepository.getProfile();
          emit(StreakLoaded(updatedProfile));
        }
      }
    } catch (e) {
      emit(StreakError(e.toString()));
    }
  }
}
