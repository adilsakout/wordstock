import 'package:flutter/material.dart';
import 'package:wordstock/features/favorite_words/cubit/cubit.dart';
import 'package:wordstock/features/favorite_words/widgets/favorite_words_body.dart';

/// {@template favorite_words_page}
/// A description for FavoriteWordsPage
/// {@endtemplate}
class FavoriteWordsPage extends StatelessWidget {
  /// {@macro favorite_words_page}
  const FavoriteWordsPage({super.key});

  /// The static route for FavoriteWordsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const FavoriteWordsPage(),
    );
  }

  static const name = '/home/favorites';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<FavoriteWordsCubit>(),
      child: const Scaffold(
        body: FavoriteWordsView(),
      ),
    );
  }
}

/// {@template favorite_words_view}
/// Displays the Body of FavoriteWordsView
/// {@endtemplate}
class FavoriteWordsView extends StatelessWidget {
  /// {@macro favorite_words_view}
  const FavoriteWordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoriteWordsBody();
  }
}
