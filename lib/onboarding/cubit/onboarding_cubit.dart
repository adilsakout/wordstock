import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit()
      : super(
          const OnboardingState(currentPage: 0, progress: 0),
        );
  // Define totalPages here or pass it as a parameter

  static const int totalPages = 12;
  final PageController pageController = PageController();

  void disposePageController() {
    pageController.dispose();
  }

  void updatePage() {
    final currentPage = pageController.page?.round() ?? 0;
    final progress = currentPage / totalPages;
    emit(state.copyWith(currentPage: currentPage, progress: progress));
  }

  void nextPage() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      final currentPage = pageController.page?.round() ?? 0;
      if (currentPage < totalPages) {
        await pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        updatePage();
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
      updatePage();
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

  void selectVocabularyLevel(int level) {
    emit(state.copyWith(vocabularyLevel: level));
    nextPage();
  }

  void selectLearningGoal(int goal) {
    emit(state.copyWith(selectedGoals: [goal]));
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

  void toggleGoal(int goal) {
    final currentGoals = List<int>.from(state.selectedGoals);
    if (currentGoals.contains(goal)) {
      currentGoals.remove(goal);
    } else {
      currentGoals.add(goal);
    }
    emit(state.copyWith(selectedGoals: currentGoals));
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
