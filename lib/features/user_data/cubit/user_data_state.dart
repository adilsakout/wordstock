// streak_state.dart
part of 'user_data_cubit.dart';

class StreakState extends Equatable {
  const StreakState({
    this.status = StreakStatus.initial,
    this.profile,
    this.errorMessage = '',
  });

  final StreakStatus status;
  final UserProfile? profile;
  final String errorMessage;

  @override
  List<Object?> get props => [status, profile, errorMessage];

  /// Creates a copy of the current StreakState with property changes
  StreakState copyWith({
    StreakStatus? status,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return StreakState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isInitial => status == StreakStatus.initial;
  bool get isLoading => status == StreakStatus.loading;
  bool get isLoaded => status == StreakStatus.loaded;
  bool get isError => status == StreakStatus.error;
}

enum StreakStatus { initial, loading, loaded, error }
