// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/features/profile/cubit/cubit.dart';

void main() {
  group('ProfileCubit', () {
    group('constructor', () {
      test('can be instantiated', () {
        expect(
          ProfileCubit(),
          isNotNull,
        );
      });
    });

    test('initial state has default value for customProperty', () {
      final profileCubit = ProfileCubit();
      expect(profileCubit.state.customProperty, equals('Default Value'));
    });

    blocTest<ProfileCubit, ProfileState>(
      'yourCustomFunction emits nothing',
      build: ProfileCubit.new,
      act: (cubit) => cubit.yourCustomFunction(),
      expect: () => <ProfileState>[],
    );
  });
}
