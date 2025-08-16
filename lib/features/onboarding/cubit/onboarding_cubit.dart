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
          const OnboardingState(currentPage: 0, progress: 0),
        ) {
    //_initializePageController();
  }
  // Define totalPages here or pass it as a parameter

  static const int totalPages = 3;
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
}
