// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/onboarding_v2/onboarding_v2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingV2Page', () {
    group('route', () {
      test('is routable', () {
        expect(OnboardingV2Page.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders OnboardingV2View', (tester) async {
      await tester.pumpWidget(MaterialApp(home: OnboardingV2Page()));
      expect(find.byType(OnboardingV2View), findsOneWidget);
    });
  });
}
