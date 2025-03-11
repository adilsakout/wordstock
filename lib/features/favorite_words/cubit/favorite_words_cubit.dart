import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/tts_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';

part 'favorite_words_state.dart';

class FavoriteWordsCubit extends Cubit<FavoriteWordsState> {
  FavoriteWordsCubit({
    required this.wordRepository,
    required this.ttsRepository,
  }) : super(const FavoriteWordsInitial()) {
    loadFavorites();
    _initializeTTS();
  }

  final WordRepository wordRepository;
  final TTSRepository ttsRepository;

  Future<void> _initializeTTS() async {
    try {
      await ttsRepository.initialize();
    } catch (e) {
      emit(FavoriteWordsError(message: e.toString()));
    }
  }

  Future<void> speakWord(String word) async {
    try {
      await ttsRepository.synthesizeAndPlay(word);
    } catch (e) {
      emit(FavoriteWordsError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    ttsRepository.dispose();
    return super.close();
  }

  Future<void> loadFavorites() async {
    emit(const FavoriteWordsLoading());
    try {
      final favorites = await wordRepository.getFavorites();
      emit(FavoriteWordsLoaded(words: favorites));
    } catch (e) {
      emit(FavoriteWordsError(message: e.toString()));
    }
  }

  Future<void> toggleFavorite(int? wordId) async {
    if (wordId == null || state is! FavoriteWordsLoaded) return;

    final currentState = state as FavoriteWordsLoaded;
    final currentWords = List<Word>.from(currentState.words);
    final updatedWords = currentWords.where((w) => w.id != wordId).toList();

    try {
      emit(FavoriteWordsLoaded(words: updatedWords));
      await wordRepository.toggleFavorite(wordId: wordId);
      await loadFavorites(); // Refresh the list after successful toggle
    } catch (e) {
      emit(FavoriteWordsLoaded(words: currentWords));
      emit(FavoriteWordsError(message: e.toString()));
    }
  }
}
