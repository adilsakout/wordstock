part of 'home_cubit.dart';

/// {@template home}
/// HomeState description
/// {@endtemplate}
abstract class HomeState extends Equatable {
  /// {@macro home}
  const HomeState();

  @override
  List<Object> get props => [];
}

/// {@template home_initial}
/// The initial state of HomeState
/// {@endtemplate}
class HomeInitial extends HomeState {
  /// {@macro home_initial}
  const HomeInitial();
}

/// {@template home_loading}
/// The loading state of HomeState
/// {@endtemplate}
class HomeLoading extends HomeState {
  /// {@macro home_loading}
  const HomeLoading();
}

/// {@template home_loaded}
/// The loaded state of HomeState
/// {@endtemplate}
class HomeLoaded extends HomeState {
  /// {@macro home_loaded}
  const HomeLoaded({
    required this.words,
    this.celebration = false,
    this.hasShownReview = false,
  });

  /// A description for customProperty
  final List<Word> words;
  final bool celebration;
  final bool hasShownReview;

  @override
  List<Object> get props => [words, celebration, hasShownReview];

  /// Creates a copy of the current HomeLoaded with property changes
  HomeLoaded copyWith({
    List<Word>? words,
    bool? celebration,
    bool? hasShownReview,
  }) {
    return HomeLoaded(
      words: words ?? this.words,
      celebration: celebration ?? this.celebration,
      hasShownReview: hasShownReview ?? this.hasShownReview,
    );
  }
}

/// {@template home_error}
/// The error state of HomeState
/// {@endtemplate}
class HomeError extends HomeState {
  /// {@macro home_error}
  const HomeError({
    required this.errorMessage,
  });

  /// A description for errorMessage
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
