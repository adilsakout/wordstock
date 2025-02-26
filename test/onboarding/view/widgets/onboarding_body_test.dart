// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordstock/onboarding/onboarding.dart';

void main() {
  group('OnboardingBody', () {
    testWidgets('renders Text', (tester) async {
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => OnboardingCubit(),
          child: MaterialApp(home: OnboardingBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
