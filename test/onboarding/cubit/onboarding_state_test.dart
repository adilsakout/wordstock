// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/onboarding/cubit/cubit.dart';

void main() {
  group('OnboardingState', () {
    test('supports value equality', () {
      expect(
        OnboardingState(
          currentPage: 0,
          progress: 0,
        ),
        equals(
          const OnboardingState(
            currentPage: 0,
            progress: 0,
          ),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const OnboardingState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const onboardingState = OnboardingState(
            customProperty: 'My property',
          );
          expect(
            onboardingState.copyWith(),
            equals(onboardingState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const onboardingState = OnboardingState(
            customProperty: 'My property',
          );
          final otherOnboardingState = OnboardingState(
            customProperty: 'My property 2',
          );
          expect(onboardingState, isNot(equals(otherOnboardingState)));

          expect(
            onboardingState.copyWith(
              customProperty: otherOnboardingState.customProperty,
            ),
            equals(otherOnboardingState),
          );
        },
      );
    });
  });
}
