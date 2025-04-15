// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/features/profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfilePage', () {
    group('route', () {
      test('is routable', () {
        expect(ProfilePage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders ProfileView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: ProfilePage()));
      expect(find.byType(ProfileView), findsOneWidget);
    });
  });
}
