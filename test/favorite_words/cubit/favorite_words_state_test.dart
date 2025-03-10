// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/favorite_words/cubit/cubit.dart';

void main() {
  group('FavoriteWordsState', () {
    test('supports value equality', () {
      expect(
        FavoriteWordsState(),
        equals(
          const FavoriteWordsState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const FavoriteWordsState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const favoriteWordsState = FavoriteWordsState(
            customProperty: 'My property',
          );
          expect(
            favoriteWordsState.copyWith(),
            equals(favoriteWordsState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const favoriteWordsState = FavoriteWordsState(
            customProperty: 'My property',
          );
          final otherFavoriteWordsState = FavoriteWordsState(
            customProperty: 'My property 2',
          );
          expect(favoriteWordsState, isNot(equals(otherFavoriteWordsState)));

          expect(
            favoriteWordsState.copyWith(
              customProperty: otherFavoriteWordsState.customProperty,
            ),
            equals(otherFavoriteWordsState),
          );
        },
      );
    });
  });
}
