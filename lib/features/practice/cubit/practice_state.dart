part of 'practice_cubit.dart';

/// {@template practice}
/// PracticeState description
/// {@endtemplate}
class PracticeState extends Equatable {
  /// {@macro practice}
  const PracticeState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  @override
  List<Object> get props => [customProperty];

  /// Creates a copy of the current PracticeState with property changes
  PracticeState copyWith({
    String? customProperty,
  }) {
    return PracticeState(
      customProperty: customProperty ?? this.customProperty,
    );
  }
}
/// {@template practice_initial}
/// The initial state of PracticeState
/// {@endtemplate}
class PracticeInitial extends PracticeState {
  /// {@macro practice_initial}
  const PracticeInitial() : super();
}
