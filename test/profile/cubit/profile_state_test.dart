// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/features/profile/cubit/cubit.dart';

void main() {
  group('ProfileState', () {
    test('supports value equality', () {
      expect(
        ProfileState(),
        equals(
          const ProfileState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const ProfileState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const profileState = ProfileState(
            customProperty: 'My property',
          );
          expect(
            profileState.copyWith(),
            equals(profileState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const profileState = ProfileState(
            customProperty: 'My property',
          );
          final otherProfileState = ProfileState(
            customProperty: 'My property 2',
          );
          expect(profileState, isNot(equals(otherProfileState)));

          expect(
            profileState.copyWith(
              customProperty: otherProfileState.customProperty,
            ),
            equals(otherProfileState),
          );
        },
      );
    });
  });
}
