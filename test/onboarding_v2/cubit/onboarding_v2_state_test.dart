// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/onboarding_v2/cubit/cubit.dart';

void main() {
  group('OnboardingV2State', () {
    test('supports value equality', () {
      expect(
        OnboardingV2State(),
        equals(
          const OnboardingV2State(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const OnboardingV2State(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const onboardingV2State = OnboardingV2State(
            customProperty: 'My property',
          );
          expect(
            onboardingV2State.copyWith(),
            equals(onboardingV2State),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const onboardingV2State = OnboardingV2State(
            customProperty: 'My property',
          );
          final otherOnboardingV2State = OnboardingV2State(
            customProperty: 'My property 2',
          );
          expect(onboardingV2State, isNot(equals(otherOnboardingV2State)));

          expect(
            onboardingV2State.copyWith(
              customProperty: otherOnboardingV2State.customProperty,
            ),
            equals(otherOnboardingV2State),
          );
        },
      );
    });
  });
}
