// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/onboarding_v2/cubit/cubit.dart';

void main() {
  group('OnboardingV2Cubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          OnboardingV2Cubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final onboardingV2Cubit = OnboardingV2Cubit();
      expect(onboardingV2Cubit.state.customProperty, equals('Default Value'));
    });

    blocTest<OnboardingV2Cubit, OnboardingV2State>(
      'yourCustomFunction emits nothing',
      build: OnboardingV2Cubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <OnboardingV2State>[],
    );
  });
}
