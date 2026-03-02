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
    this.tempSelectedVocabularyLevel = -1,
    this.selectedGoals = const [],
    this.selectedTopics = const [],
    this.streakGoal = -1,
    this.timeZone = '',
    this.englishTestResult = -1,
    this.isRequestingPermission = false,
    this.englishTestQuestions = const [],
    this.isLoadingEnglishQuestions = false,
    this.englishTestError,
    // New onboarding V2 fields
    this.onboardingGoal,
    this.onboardingLevel,
    this.dailyMinutes,
    this.microWinCompleted = false,
    this.microWinAnswered = false,
    this.microWinCorrect = false,
    this.createdAt,
    this.tempSelectedGoal,
    this.tempSelectedLevel,
    this.tempSelectedDailyMinutes,
  });

  final int currentPage;
  final double progress;
  final int selectedAgeRange;
  final int selectedGender;
  final String userName;
  final int selectedTimeCommitment;
  final int wordsPerDay;
  final int vocabularyLevel;

  /// Temporary selected vocabulary level for visual feedback before
  /// confirmation
  final int tempSelectedVocabularyLevel;
  final List<String> selectedGoals;
  final List<int> selectedTopics;
  final int streakGoal;
  final String timeZone;
  final int englishTestResult;
  final bool isRequestingPermission;

  /// English test questions loaded from repository
  final List<EnglishTestQuestion> englishTestQuestions;

  /// Flag indicating if English test questions are currently being loaded
  final bool isLoadingEnglishQuestions;

  /// Error message if English test questions failed to load
  final String? englishTestError;

  // ============================================
  // New Onboarding V2 Fields (7-Screen Flow)
  // ============================================

  /// User's primary goal for learning English
  /// One of: 'speak_confidently', 'grow_vocabulary',
  /// 'prepare_work_exams', 'mix_similar_words', 'sound_natural'
  final String? onboardingGoal;

  /// User's current English level
  /// One of: 'beginner', 'intermediate', 'advanced'
  final String? onboardingLevel;

  /// Daily practice time commitment in minutes (5, 10, or 15)
  final int? dailyMinutes;

  /// Whether the user has completed the micro win (quick quiz)
  final bool microWinCompleted;

  /// Whether the user has answered the micro win quiz (regardless of result)
  final bool microWinAnswered;

  /// Whether the user answered the micro win quiz correctly
  final bool microWinCorrect;

  /// Timestamp when the onboarding flow was started
  final DateTime? createdAt;

  /// Temporary selected goal for visual feedback before confirmation
  final String? tempSelectedGoal;

  /// Temporary selected level for visual feedback before confirmation
  final String? tempSelectedLevel;

  /// Temporary selected daily minutes for visual feedback before confirmation
  final int? tempSelectedDailyMinutes;

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
  List<Object?> get props => [
        currentPage,
        progress,
        selectedAgeRange,
        selectedGender,
        userName,
        selectedTimeCommitment,
        wordsPerDay,
        vocabularyLevel,
        tempSelectedVocabularyLevel,
        selectedGoals,
        selectedTopics,
        streakGoal,
        timeZone,
        englishTestResult,
        isRequestingPermission,
        englishTestQuestions,
        isLoadingEnglishQuestions,
        englishTestError,
        // New V2 fields
        onboardingGoal,
        onboardingLevel,
        dailyMinutes,
        microWinCompleted,
        microWinAnswered,
        microWinCorrect,
        createdAt,
        tempSelectedGoal,
        tempSelectedLevel,
        tempSelectedDailyMinutes,
      ];

  // ============================================
  // Helper getters for onboarding V2
  // ============================================
  //
  // Goal and level display text are resolved in the UI via
  // context.localizedOnboardingGoalText(goalId) and
  // context.localizedOnboardingLevelText(levelId) so they get translated.

  /// Returns the display text for daily minutes
  String get dailyMinutesDisplayText {
    if (dailyMinutes == null) return '';
    return '$dailyMinutes min/day';
  }

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
    int? tempSelectedVocabularyLevel,
    List<String>? selectedGoals,
    List<int>? selectedTopics,
    int? streakGoal,
    String? timeZone,
    int? englishTestResult,
    bool? isRequestingPermission,
    List<EnglishTestQuestion>? englishTestQuestions,
    bool? isLoadingEnglishQuestions,
    String? englishTestError,
    // New V2 fields
    String? onboardingGoal,
    String? onboardingLevel,
    int? dailyMinutes,
    bool? microWinCompleted,
    bool? microWinAnswered,
    bool? microWinCorrect,
    DateTime? createdAt,
    String? tempSelectedGoal,
    String? tempSelectedLevel,
    int? tempSelectedDailyMinutes,
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
      tempSelectedVocabularyLevel:
          tempSelectedVocabularyLevel ?? this.tempSelectedVocabularyLevel,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      streakGoal: streakGoal ?? this.streakGoal,
      timeZone: timeZone ?? this.timeZone,
      englishTestResult: englishTestResult ?? this.englishTestResult,
      isRequestingPermission:
          isRequestingPermission ?? this.isRequestingPermission,
      englishTestQuestions: englishTestQuestions ?? this.englishTestQuestions,
      isLoadingEnglishQuestions:
          isLoadingEnglishQuestions ?? this.isLoadingEnglishQuestions,
      englishTestError: englishTestError ?? this.englishTestError,
      // New V2 fields
      onboardingGoal: onboardingGoal ?? this.onboardingGoal,
      onboardingLevel: onboardingLevel ?? this.onboardingLevel,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      microWinCompleted: microWinCompleted ?? this.microWinCompleted,
      microWinAnswered: microWinAnswered ?? this.microWinAnswered,
      microWinCorrect: microWinCorrect ?? this.microWinCorrect,
      createdAt: createdAt ?? this.createdAt,
      tempSelectedGoal: tempSelectedGoal ?? this.tempSelectedGoal,
      tempSelectedLevel: tempSelectedLevel ?? this.tempSelectedLevel,
      tempSelectedDailyMinutes:
          tempSelectedDailyMinutes ?? this.tempSelectedDailyMinutes,
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
