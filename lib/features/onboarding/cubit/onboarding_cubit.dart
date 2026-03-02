import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/model/english_test_question.dart';
import 'package:wordstock/model/onboarding_enums.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/english_test_repository.dart';
import 'package:wordstock/repositories/user_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    UserRepository? userRepository,
    EnglishTestRepository? englishTestRepository,
  })  : _userRepository = userRepository ?? UserRepository(),
        _englishTestRepository =
            englishTestRepository ?? const EnglishTestRepository(),
        super(
          OnboardingState(
            currentPage: 0,
            progress: 0,
            createdAt: DateTime.now(), // Set createdAt when onboarding starts
          ),
        ) {
    //_initializePageController();
  }

  // Total pages in the PageView (welcome + 8 onboarding steps)
  // Welcome screen is at index 0 and does NOT count toward progress.
  // Steps 1-8 map to PageView indices 1-8.
  static const int totalPages = 9;

  // Number of actual onboarding steps (excluding welcome)
  static const int totalSteps = 8;
  final PageController pageController = PageController();
  final UserRepository _userRepository;
  final EnglishTestRepository _englishTestRepository;

  void disposePageController() {
    pageController.dispose();
  }

  Future<void> updatePage() async {
    final currentPage = pageController.page?.round() ?? 0;
    final progress = currentPage / totalPages;
    emit(state.copyWith(currentPage: currentPage, progress: progress));

    // Save the current page index to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (currentPage == totalPages) {
      await prefs.setBool('onboarding_completed', true);
      // Save onboarding data when reaching the last page
      await saveOnboardingData();
    }
    await prefs.setInt('onboarding_current_page', currentPage);
  }

  void nextPage() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      final currentPage = pageController.page?.round() ?? 0;
      if (currentPage < totalPages) {
        await pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        await updatePage();
      }
    });
  }

  Future<void> previousPage() async {
    final currentPage = pageController.page?.round() ?? 0;
    if (currentPage > 0) {
      await pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await updatePage();
    }
  }

  void selectAgeRange(int ageRange) {
    emit(state.copyWith(selectedAgeRange: ageRange));
    nextPage();
  }

  void selectGender(int gender) {
    emit(state.copyWith(selectedGender: gender));
    nextPage();
  }

  void setUserName(String name) {
    emit(state.copyWith(userName: name));
    nextPage();
  }

  void selectTimeCommitment(int timeCommitment) {
    emit(state.copyWith(selectedTimeCommitment: timeCommitment));
    nextPage();
  }

  void setWordsPerDay(int words) {
    emit(state.copyWith(wordsPerDay: words));
  }

  int get wordsPerDay => state.wordsPerDay;
  List<String> get selectedGoals => state.selectedGoals;

  int get streakGoal => state.streakGoal;

  /// Sets temporary vocabulary level selection for visual feedback
  void setTempVocabularyLevel(int level) {
    emit(state.copyWith(tempSelectedVocabularyLevel: level));
  }

  /// Confirms vocabulary level selection and proceeds to next page
  void selectVocabularyLevel(int level) {
    emit(
      state.copyWith(
        vocabularyLevel: level,
        tempSelectedVocabularyLevel: -1, // Reset temp selection
      ),
    );
    nextPage();
  }

  /// Clears temporary vocabulary level selection
  void clearTempVocabularyLevel() {
    emit(state.copyWith(tempSelectedVocabularyLevel: -1));
  }

  void selectLearningGoal(String goal) {
    emit(state.copyWith(selectedGoals: [...state.selectedGoals, goal]));
    nextPage();
  }

  void selectTopic(int topic) {
    final currentTopics = List<int>.from(state.selectedTopics);
    if (currentTopics.contains(topic)) {
      currentTopics.remove(topic);
    } else {
      currentTopics.add(topic);
    }
    emit(state.copyWith(selectedTopics: currentTopics));
    nextPage();
  }

  void selectStreakGoal(int goal) {
    emit(state.copyWith(streakGoal: goal));
    nextPage();
  }

  void toggleTopic(int topic) {
    final currentTopics = List<int>.from(state.selectedTopics);
    if (currentTopics.contains(topic)) {
      currentTopics.remove(topic);
    } else {
      currentTopics.add(topic);
    }
    emit(state.copyWith(selectedTopics: currentTopics));
  }

  void selectGoal(String goal) {
    emit(state.copyWith(selectedGoals: [...state.selectedGoals, goal]));
  }

  /// Sets the English test result percentage
  void setEnglishTestResult(int percentage) {
    emit(state.copyWith(englishTestResult: percentage));
  }

  /// Loads English test questions based on the selected vocabulary level.
  ///
  /// Returns a list of 5 randomized questions appropriate for the user's
  /// chosen difficulty level. If no level is selected, defaults to
  /// intermediate.
  ///
  /// Emits loading state while fetching questions and error state if loading
  /// fails.
  Future<List<EnglishTestQuestion>> loadEnglishTestQuestions() async {
    try {
      // Set loading state while fetching questions
      emit(
        state.copyWith(
          isLoadingEnglishQuestions: true,
        ),
      );

      // Use the selected vocabulary level, or default to intermediate (1)
      // if not set
      final levelId = state.vocabularyLevel >= 0 ? state.vocabularyLevel : 1;

      // Load questions from repository
      final questions =
          await _englishTestRepository.getQuestionsForLevel(levelId);

      // Update state with loaded questions
      emit(
        state.copyWith(
          englishTestQuestions: questions,
          isLoadingEnglishQuestions: false,
        ),
      );

      return questions;
    } catch (e) {
      // Handle error and emit error state
      emit(
        state.copyWith(
          isLoadingEnglishQuestions: false,
          englishTestError: 'Failed to load English test questions: $e',
        ),
      );

      // Re-throw for widget handling if needed
      throw Exception('Failed to load English test questions: $e');
    }
  }

  /// Loads all available questions for a specific vocabulary level.
  ///
  /// Useful for displaying the complete question bank or analytics.
  /// Does not update the state, only returns the question set.
  Future<EnglishTestQuestionSet> loadAllQuestionsForLevel(int levelId) async {
    try {
      return await _englishTestRepository.getAllQuestionsForLevel(levelId);
    } catch (e) {
      throw Exception('Failed to load all questions for level $levelId: $e');
    }
  }

  /// Clears any English test related error states.
  void clearEnglishTestError() {
    emit(state.copyWith());
  }

  /// Resets English test data (questions, results, errors).
  ///
  /// Useful when restarting the test or navigating away from the test page.
  void resetEnglishTestData() {
    emit(
      state.copyWith(
        englishTestQuestions: [],
        englishTestResult: -1,
        isLoadingEnglishQuestions: false,
      ),
    );
  }

  /// Save only vocabulary level from onboarding data to the user profile
  Future<void> saveOnboardingData() async {
    try {
      // Convert vocabulary level index to enum
      final vocabularyLevel = VocabularyLevel.values[state.vocabularyLevel];

      // Save only vocabulary level to the user profile
      await _userRepository.saveOnboardingData(
        vocabularyLevel: vocabularyLevel,
      );
    } catch (e) {
      // Handle error (could emit an error state if needed)
      debugPrint('Error saving onboarding data: $e');
    }
  }

  /// Handles notification permission request with enhanced UX
  Future<void> requestNotificationPermission() async {
    if (state.isRequestingPermission) return;

    emit(state.copyWith(isRequestingPermission: true));
    try {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      final status = await Permission.notification.request();

      if (status.isGranted) {
        // Add a brief delay for better UX
        await Future<void>.delayed(const Duration(milliseconds: 300));
        nextPage();
      } else {
        bool? result;
        if (Platform.isIOS) {
          result = await OneSignal.Notifications.requestPermission(true);
          await Future<void>.delayed(const Duration(milliseconds: 300));
          nextPage();
        } else {
          result = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission();
        }

        if ((result ?? false) == true) {
          await Future<void>.delayed(const Duration(milliseconds: 300));
          nextPage();
        }
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    } finally {
      emit(state.copyWith(isRequestingPermission: false));
    }
  }

  // ============================================
  // Onboarding V2 Methods (8-Screen Flow)
  // ============================================

  /// Sets temporary goal selection for visual feedback before confirmation
  void setTempOnboardingGoal(String goal) {
    emit(state.copyWith(tempSelectedGoal: goal));
  }

  /// Confirms goal selection and proceeds to next page
  void selectOnboardingGoal(String goal) {
    emit(
      state.copyWith(
        onboardingGoal: goal,
      ),
    );
    nextPage();
  }

  /// Clears temporary goal selection
  void clearTempOnboardingGoal() {
    emit(state.copyWith());
  }

  /// Sets temporary level selection for visual feedback before confirmation
  void setTempOnboardingLevel(String level) {
    emit(state.copyWith(tempSelectedLevel: level));
  }

  /// Confirms level selection and proceeds to next page
  void selectOnboardingLevel(String level) {
    emit(
      state.copyWith(
        onboardingLevel: level,
      ),
    );
    nextPage();
  }

  /// Clears temporary level selection
  void clearTempOnboardingLevel() {
    emit(state.copyWith());
  }

  /// Records the micro win quiz answer
  /// Sets microWinCompleted=true regardless of correctness
  void answerMicroWinQuiz({required bool isCorrect}) {
    emit(
      state.copyWith(
        microWinAnswered: true,
        microWinCorrect: isCorrect,
        microWinCompleted: true,
      ),
    );
  }

  /// Sets temporary daily minutes selection for visual feedback
  void setTempDailyMinutes(int minutes) {
    emit(state.copyWith(tempSelectedDailyMinutes: minutes));
  }

  /// Confirms daily minutes selection and proceeds to next page
  void selectDailyMinutes(int minutes) {
    emit(
      state.copyWith(
        dailyMinutes: minutes,
      ),
    );
    nextPage();
  }

  /// Clears temporary daily minutes selection
  void clearTempDailyMinutes() {
    emit(state.copyWith());
  }

  /// Navigates to next page without any state updates
  /// Used for screens that don't require selection (progress framing, etc.)
  void goToNextPage() {
    nextPage();
  }

  /// Returns the progress value for the step indicator.
  /// Welcome screen (page 0) has 0 progress.
  /// Steps 1-8 map to progress 1/8 through 8/8.
  double get stepProgress {
    if (state.currentPage <= 0) return 0;
    return state.currentPage / totalSteps;
  }

  /// Returns the current step number (1-based for display).
  /// Welcome screen returns 0 (no step number shown).
  int get currentStep => state.currentPage;

  /// Whether the current page is the welcome screen (no progress indicator)
  bool get isOnWelcomeScreen => state.currentPage == 0;

  /// Checks if the CTA should be enabled based on current page requirements.
  /// Page indices shifted by +1 due to welcome screen at index 0.
  bool get isCtaEnabled {
    switch (state.currentPage) {
      case 0: // Welcome screen - always enabled
        return true;
      case 1: // Goal selection - requires selection
        return state.onboardingGoal != null || state.tempSelectedGoal != null;
      case 2: // Level selection - requires selection
        return state.onboardingLevel != null || state.tempSelectedLevel != null;
      case 3: // Assessment - requires answering quiz
        return state.microWinAnswered;
      case 4: // Progress framing - always enabled
        return true;
      case 5: // Daily habit - requires selection
        return state.dailyMinutes != null ||
            state.tempSelectedDailyMinutes != null;
      case 6: // Notification permission - always enabled
        return true;
      case 7: // Plan reveal - always enabled
        return true;
      case 8: // Social proof - always enabled
        return true;
      default:
        return true;
    }
  }
}
