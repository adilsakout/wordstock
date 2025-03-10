// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/practice/cubit/cubit.dart';

void main() {
  group('PracticeState', () {
    test('supports value equality', () {
      expect(
        PracticeState(),
        equals(
          const PracticeState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const PracticeState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const practiceState = PracticeState(
            customProperty: 'My property',
          );
          expect(
            practiceState.copyWith(),
            equals(practiceState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const practiceState = PracticeState(
            customProperty: 'My property',
          );
          final otherPracticeState = PracticeState(
            customProperty: 'My property 2',
          );
          expect(practiceState, isNot(equals(otherPracticeState)));

          expect(
            practiceState.copyWith(
              customProperty: otherPracticeState.customProperty,
            ),
            equals(otherPracticeState),
          );
        },
      );
    });
  });
}
