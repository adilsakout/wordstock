// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordstock/favorite_words/favorite_words.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteWordsBody', () {
    testWidgets('renders Text', (tester) async {
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => FavoriteWordsCubit(),
          child: MaterialApp(home: FavoriteWordsBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
