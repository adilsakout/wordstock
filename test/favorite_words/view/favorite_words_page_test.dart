// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/favorite_words/favorite_words.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteWordsPage', () {
    group('route', () {
      test('is routable', () {
        expect(FavoriteWordsPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders FavoriteWordsView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: FavoriteWordsPage()));
      expect(find.byType(FavoriteWordsView), findsOneWidget);
    });
  });
}
