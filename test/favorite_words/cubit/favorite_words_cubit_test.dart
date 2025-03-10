// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/favorite_words/cubit/cubit.dart';

void main() {
  group('FavoriteWordsCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          FavoriteWordsCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final favoriteWordsCubit = FavoriteWordsCubit();
      expect(favoriteWordsCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<FavoriteWordsCubit, FavoriteWordsState>(
      'yourCustomFunction emits nothing',
      build: FavoriteWordsCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <FavoriteWordsState>[],
    );
  });
}
