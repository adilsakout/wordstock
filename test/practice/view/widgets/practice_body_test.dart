// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/practice/practice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PracticeBody', () {
    testWidgets('renders Text', (tester) async {
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => PracticeCubit(),
          child: MaterialApp(home: PracticeBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
