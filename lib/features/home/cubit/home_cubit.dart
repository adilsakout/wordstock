import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/tts_repository.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.wordRepository,
    required this.ttsRepository,
    required this.userRepository,
  }) : super(const HomeInitial()) {
    _initializeTTS();
  }

  final WordRepository wordRepository;
  final UserRepository userRepository;
  final TTSRepository ttsRepository;

  Future<void> _initializeTTS() async {
    try {
      await ttsRepository.initialize();
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  Future<void> speakWord(String word) async {
    try {
      await ttsRepository.synthesizeAndPlay(word);
    } catch (e) {
      debugPrint('Error speaking word: $e');
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    ttsRepository.dispose();
    return super.close();
  }

  FutureOr<void> fetchWords() async {
    emit(const HomeLoading());
    try {
      final words = await wordRepository.getWords();
      emit(HomeLoaded(words: words));

      // Update the home widget with the first word (word of the day)
      if (words.isNotEmpty) {
        await _updateHomeWidget(words.first);
      }
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  /// Updates the iOS/Android home widget with current word data
  Future<void> _updateHomeWidget(Word word) async {
    try {
      // Save word data to shared preferences for the widget to access
      await HomeWidget.saveWidgetData<String>('word', word.word);
      await HomeWidget.saveWidgetData<String>('definition', word.definition);
      await HomeWidget.saveWidgetData<String>(
        'phonetic',
        word.phonetic ?? '',
      );
      await HomeWidget.saveWidgetData<String>(
        'example',
        word.example ?? '',
      );

      // Save favorite status as string to avoid NSNull casting issues
      await HomeWidget.saveWidgetData<String>(
        'isFavorite',
        (word.isFavorite ?? false).toString(),
      );

      // Update the widget
      await HomeWidget.updateWidget(
        iOSName: 'HomeWidget',
        androidName: 'HomeWidget',
      );
    } catch (e) {
      debugPrint('Error updating home widget: $e');
    }
  }

  void markReviewAsShown() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(hasShownReview: true));
    }
  }

  Future<void> toggleFavorite(String wordId) async {
    try {
      await wordRepository.toggleFavorite(wordId: wordId);
      if (state is HomeLoaded) {
        final words = (state as HomeLoaded).words;
        final updatedWords = words.map((word) {
          if (word.id == wordId) {
            return word.copyWith(isFavorite: !(word.isFavorite ?? false));
          }
          return word;
        }).toList();
        emit(HomeLoaded(words: updatedWords));

        // Update widget if the favorited word is the first word
        // (current word of the day)
        if (updatedWords.isNotEmpty && updatedWords.first.id == wordId) {
          await _updateHomeWidget(updatedWords.first);
        }
      }
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  final List<String> _learnedWordIds = [];
  Timer? _updateTimer;

  void markWordAsLearned(String wordId) {
    if (!_learnedWordIds.contains(wordId)) {
      _learnedWordIds.add(wordId);
    }
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(seconds: 5), _submitProgress);
  }

  Future<void> _submitProgress() async {
    if (_learnedWordIds.isEmpty) return;

    await wordRepository.markWordAsLearned(_learnedWordIds);
    _learnedWordIds.clear();
  }
}
