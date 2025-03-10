import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/word_repository.dart';

part 'favorite_words_state.dart';

class FavoriteWordsCubit extends Cubit<FavoriteWordsState> {
  FavoriteWordsCubit({required this.wordRepository})
      : super(const FavoriteWordsInitial()) {
    loadFavorites();
  }

  final WordRepository wordRepository;

  Future<void> loadFavorites() async {
    emit(const FavoriteWordsLoading());
    try {
      final favorites = await wordRepository.getFavorites();
      emit(FavoriteWordsLoaded(words: favorites));
    } catch (e) {
      emit(FavoriteWordsError(message: e.toString()));
    }
  }

  Future<void> toggleFavorite(int wordId) async {
    if (state is! FavoriteWordsLoaded) return;

    final currentState = state as FavoriteWordsLoaded;
    final updatedWords =
        currentState.words.where((w) => w.id != wordId).toList();

    // Immediately update UI to remove the word
    emit(FavoriteWordsLoaded(words: updatedWords));

    try {
      await wordRepository.toggleFavorite(wordId: wordId);
    } catch (e) {
      // If the API call fails, revert to the previous state
      emit(FavoriteWordsLoaded(words: currentState.words));
      emit(FavoriteWordsError(message: e.toString()));
    }
  }
}
