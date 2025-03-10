// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/practice/cubit/cubit.dart';

void main() {
  group('PracticeCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          PracticeCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final practiceCubit = PracticeCubit();
      expect(practiceCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<PracticeCubit, PracticeState>(
      'yourCustomFunction emits nothing',
      build: PracticeCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <PracticeState>[],
    );
  });
}
