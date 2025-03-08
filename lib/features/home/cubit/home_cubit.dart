import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/word_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.wordRepository}) : super(const HomeInitial());

  final WordRepository wordRepository;
  int wordsReadCount = 0;

  FutureOr<void> fetchWords() async {
    emit(const HomeLoading());
    try {
      final words = await wordRepository.getWords();
      emit(HomeLoaded(words: words));
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  void resetCounter() {
    wordsReadCount = 0;
  }

  FutureOr<void> onWordRead() async {
    wordsReadCount++;
    if (wordsReadCount >= 5) {
      final words = await wordRepository.getWords();
      emit(HomeLoaded(words: words, celebration: true));
      wordsReadCount = 0; // Reset the counter after celebration
    }
  }
}
