import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/tts_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.wordRepository,
    required this.ttsRepository,
  }) : super(const HomeInitial()) {
    _initializeTTS();
  }

  final WordRepository wordRepository;
  final TTSRepository ttsRepository;
  int wordsReadCount = 0;

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
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> toggleFavorite(int wordId) async {
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
    }
  }

  void resetCounter() {
    wordsReadCount = 0;
  }

  final List<int> _learnedWordIds = [];
  Timer? _updateTimer;

  void markWordAsLearned(int wordId) {
    log('markWordAsLearned: $wordId', name: 'HomeCubit');
    _learnedWordIds.add(wordId);
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(seconds: 5), _submitProgress);
  }

  Future<void> _submitProgress() async {
    log('submitProgress: $_learnedWordIds', name: 'HomeCubit');
    if (_learnedWordIds.isEmpty) return;

    await wordRepository.markWordAsLearned(_learnedWordIds);

    _learnedWordIds.clear();
  }
}
