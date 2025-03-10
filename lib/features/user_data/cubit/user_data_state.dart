// streak_state.dart
part of 'user_data_cubit.dart';

abstract class StreakState extends Equatable {
  const StreakState();
}

class StreakInitial extends StreakState {
  @override
  List<Object> get props => [];
}

class StreakLoading extends StreakState {
  @override
  List<Object> get props => [];
}

class StreakLoaded extends StreakState {
  const StreakLoaded(this.profile);
  final UserProfile profile;

  @override
  List<Object> get props => [profile];
}

class StreakError extends StreakState {
  const StreakError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
