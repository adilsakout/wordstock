part of 'onboarding_cubit.dart';

/// {@template onboarding}
/// OnboardingState description
/// {@endtemplate}
class OnboardingState extends Equatable {
  /// {@macro onboarding}
  const OnboardingState({
    required this.currentPage,
    required this.progress,
    this.selectedAgeRange = -1,
    this.selectedGender = -1,
    this.userName = '',
    this.selectedTimeCommitment = -1,
    this.wordsPerDay = 10,
    this.vocabularyLevel = -1,
    this.selectedGoals = const [],
    this.selectedTopics = const [],
    this.streakGoal = -1,
  });

  final int currentPage;
  final double progress;
  final int selectedAgeRange;
  final int selectedGender;
  final String userName;
  final int selectedTimeCommitment;
  final int wordsPerDay;
  final int vocabularyLevel;
  final List<String> selectedGoals;
  final List<int> selectedTopics;
  final int streakGoal;

  /// Returns the selected age range as an enum value
  AgeRange? get ageRange =>
      selectedAgeRange >= 0 && selectedAgeRange < AgeRange.values.length
          ? AgeRange.values[selectedAgeRange]
          : null;

  /// Returns the selected gender as an enum value
  Gender? get gender =>
      selectedGender >= 0 && selectedGender < Gender.values.length
          ? Gender.values[selectedGender]
          : null;

  /// Returns the selected time commitment as an enum value
  TimeCommitment? get timeCommitment => selectedTimeCommitment >= 0 &&
          selectedTimeCommitment < TimeCommitment.values.length
      ? TimeCommitment.values[selectedTimeCommitment]
      : null;

  /// Returns a string representation of the age range for analytics
  String get age => ageRange?.name ?? 'not_specified';

  /// Returns a string representation of the gender for analytics
  String get genderString => gender?.name ?? 'not_specified';

  /// Returns a string representation of the time commitment for analytics
  String get timeCommitmentString => timeCommitment?.name ?? 'not_specified';

  @override
  List<Object> get props => [
        currentPage,
        progress,
        selectedAgeRange,
        selectedGender,
        userName,
        selectedTimeCommitment,
        wordsPerDay,
        vocabularyLevel,
        selectedGoals,
        selectedTopics,
        streakGoal,
      ];

  /// Creates a copy of the current OnboardingState with property changes
  OnboardingState copyWith({
    int? currentPage,
    double? progress,
    int? selectedAgeRange,
    int? selectedGender,
    String? userName,
    int? selectedTimeCommitment,
    int? wordsPerDay,
    int? vocabularyLevel,
    List<String>? selectedGoals,
    List<int>? selectedTopics,
    int? streakGoal,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      progress: progress ?? this.progress,
      selectedAgeRange: selectedAgeRange ?? this.selectedAgeRange,
      selectedGender: selectedGender ?? this.selectedGender,
      userName: userName ?? this.userName,
      selectedTimeCommitment:
          selectedTimeCommitment ?? this.selectedTimeCommitment,
      wordsPerDay: wordsPerDay ?? this.wordsPerDay,
      vocabularyLevel: vocabularyLevel ?? this.vocabularyLevel,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      streakGoal: streakGoal ?? this.streakGoal,
    );
  }
}

/// {@template onboarding_initial}
/// The initial state of OnboardingState
/// {@endtemplate}
class OnboardingInitial extends OnboardingState {
  /// {@macro onboarding_initial}
  const OnboardingInitial() : super(currentPage: 0, progress: 0);
}
