// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/onboarding_v2/onboarding_v2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingV2Body', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => OnboardingV2Cubit(),
          child: MaterialApp(home: OnboardingV2Body()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
