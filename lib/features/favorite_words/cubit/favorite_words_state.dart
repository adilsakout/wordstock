part of 'favorite_words_cubit.dart';

/// {@template favorite_words}
/// FavoriteWordsState description
/// {@endtemplate}
abstract class FavoriteWordsState extends Equatable {
  const FavoriteWordsState();

  @override
  List<Object?> get props => [];
}

/// {@template favorite_words_initial}
/// The initial state of FavoriteWordsState
/// {@endtemplate}
class FavoriteWordsInitial extends FavoriteWordsState {
  /// {@macro favorite_words_initial}
  const FavoriteWordsInitial();
}

class FavoriteWordsLoading extends FavoriteWordsState {
  const FavoriteWordsLoading();
}

class FavoriteWordsLoaded extends FavoriteWordsState {
  const FavoriteWordsLoaded({required this.words});

  final List<Word> words;

  @override
  List<Object?> get props => [words];
}

class FavoriteWordsError extends FavoriteWordsState {
  const FavoriteWordsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
