// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/practice/practice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PracticePage', () {
    group('route', () {
      test('is routable', () {
        expect(PracticePage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders PracticeView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: PracticePage()));
      expect(find.byType(PracticeView), findsOneWidget);
    });
  });
}
