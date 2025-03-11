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
    return const Scaffold(
      body: FavoriteWordsView(),
    );
  }
}

/// {@template favorite_words_view}
/// Displays the Body of FavoriteWordsView
/// {@endtemplate}
class FavoriteWordsView extends StatefulWidget {
  /// {@macro favorite_words_view}
  const FavoriteWordsView({super.key});

  @override
  State<FavoriteWordsView> createState() => _FavoriteWordsViewState();
}

class _FavoriteWordsViewState extends State<FavoriteWordsView> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteWordsCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return const FavoriteWordsBody();
  }
}
