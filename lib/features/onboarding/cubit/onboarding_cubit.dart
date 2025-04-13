import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/model/onboarding_enums.dart';
import 'package:wordstock/model/user_profile.dart';
import 'package:wordstock/repositories/user_repository.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository(),
        super(
          const OnboardingState(currentPage: 0, progress: 0),
        ) {
    _initializePageController();
  }
  // Define totalPages here or pass it as a parameter

  static const int totalPages = 14;
  final PageController pageController = PageController();
  final UserRepository _userRepository;

  Future<void> _initializePageController() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPage = prefs.getInt('onboarding_current_page') ?? 0;
    pageController.jumpToPage(savedPage);
  }

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
  String get selectedGoals => state.selectedGoals;

  int get streakGoal => state.streakGoal;

  void selectVocabularyLevel(int level) {
    emit(state.copyWith(vocabularyLevel: level));
    nextPage();
  }

  void selectLearningGoal(String goal) {
    emit(state.copyWith(selectedGoals: goal));
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
    emit(state.copyWith(selectedGoals: goal));
  }

  /// Convert gender index to string representation
  String _getGenderString(int genderIndex) {
    switch (genderIndex) {
      case 0:
        return 'male';
      case 1:
        return 'female';
      case 2:
        return 'other';
      case 3:
        return 'prefer_not_to_say';
      default:
        return 'not_specified';
    }
  }

  /// Convert topic index to string representation
  String _getTopicString(int topicIndex) {
    switch (topicIndex) {
      case 0:
        return 'society';
      case 1:
        return 'foreign_languages';
      case 2:
        return 'human_body';
      case 3:
        return 'emotions';
      case 4:
        return 'other';
      default:
        return 'not_specified';
    }
  }

  /// Save all onboarding data to the user profile
  Future<void> saveOnboardingData() async {
    try {
      // Convert vocabulary level index to enum
      final vocabularyLevel = VocabularyLevel.values[state.vocabularyLevel];

      // Convert gender index to string
      final genderString = _getGenderString(state.selectedGender);

      // Convert goal indices to strings
      final goalStrings = state.selectedGoals;

      // Convert topic indices to strings
      final topicStrings = state.selectedTopics.map(_getTopicString).toList();

      await _userRepository.saveOnboardingData(
        ageRange: state.selectedAgeRange,
        gender: genderString,
        userName: state.userName,
        timeCommitment: state.selectedTimeCommitment,
        wordsPerDay: state.wordsPerDay,
        vocabularyLevel: vocabularyLevel,
        selectedGoals: goalStrings,
        selectedTopics: topicStrings,
        streakGoal: state.streakGoal,
      );
    } catch (e) {
      // Handle error (could emit an error state if needed)
      debugPrint('Error saving onboarding data: $e');
    }
  }
}
