part of 'onboarding_cubit.dart';

/// {@template onboarding}
/// OnboardingState description
/// {@endtemplate}
class OnboardingState extends Equatable {
  /// {@macro onboarding}
  const OnboardingState({
    required this.currentPage,
    required this.progress,
    this.selectedAgeRange = -1, // Default to -1 indicating no selection
    this.selectedGender = -1, // Add this line
    this.userName = '', // Add this line
    this.selectedTimeCommitment = -1, // Add this line
    this.wordsPerDay = 10, // Add this line
    this.vocabularyLevel = -1, // Add this line
    this.selectedGoals = const [], // Change this line
    this.selectedTopics = const [], // Change this line
    this.streakGoal = -1, // Add this line
  });

  final int currentPage;
  final double progress;
  final int selectedAgeRange;
  final int selectedGender; // Add this line
  final String userName; // Add this line
  final int selectedTimeCommitment; // Add this line
  final int wordsPerDay; // Add this line
  final int vocabularyLevel; // Add this line
  final List<int> selectedGoals; // Change this line
  final List<int> selectedTopics; // Change this line
  final int streakGoal; // Add this line

  @override
  List<Object> get props => [
        currentPage,
        progress,
        selectedAgeRange,
        selectedGender,
        userName,
        selectedTimeCommitment, // Add this line
        wordsPerDay, // Add this line
        vocabularyLevel, // Add this line
        selectedGoals, // Change this line
        selectedTopics, // Change this line
        streakGoal, // Add this line
      ];

  /// Creates a copy of the current OnboardingState with property changes
  OnboardingState copyWith({
    int? currentPage,
    double? progress,
    int? selectedAgeRange,
    int? selectedGender, // Add this line
    String? userName, // Add this line
    int? selectedTimeCommitment, // Add this line
    int? wordsPerDay, // Add this line
    int? vocabularyLevel, // Add this line
    List<int>? selectedGoals, // Change this line
    List<int>? selectedTopics, // Change this line
    int? streakGoal, // Add this line
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      progress: progress ?? this.progress,
      selectedAgeRange: selectedAgeRange ?? this.selectedAgeRange,
      selectedGender: selectedGender ?? this.selectedGender, // Add this line
      userName: userName ?? this.userName, // Add this line
      selectedTimeCommitment: selectedTimeCommitment ??
          this.selectedTimeCommitment, // Add this line
      wordsPerDay: wordsPerDay ?? this.wordsPerDay, // Add this line
      vocabularyLevel: vocabularyLevel ?? this.vocabularyLevel, // Add this line
      selectedGoals: selectedGoals ?? this.selectedGoals, // Change this line
      selectedTopics: selectedTopics ?? this.selectedTopics, // Change this line
      streakGoal: streakGoal ?? this.streakGoal, // Add this line
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
