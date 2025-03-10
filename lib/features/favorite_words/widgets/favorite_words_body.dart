import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wordstock/features/favorite_words/cubit/cubit.dart';
import 'package:wordstock/features/favorite_words/widgets/word_card.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template favorite_words_body}
/// Body of the FavoriteWordsPage.
///
/// Add what it does
/// {@endtemplate}
class FavoriteWordsBody extends StatelessWidget {
  /// {@macro favorite_words_body}
  const FavoriteWordsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteWordsCubit, FavoriteWordsState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PushableButton(
                        width: 50,
                        height: 50,
                        text: '',
                        suffixIcon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => context.pop(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Your Favorite Words',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                      ),
                      const SizedBox(width: 50, height: 50),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is FavoriteWordsLoading) {
                          return ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    height: 120,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 150,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(
                                                3,
                                                (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          width: double.infinity,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        if (state is FavoriteWordsError) {
                          return RefreshIndicator(
                            onRefresh: () => context
                                .read<FavoriteWordsCubit>()
                                .loadFavorites(),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          size: 48,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(state.message),
                                        const SizedBox(height: 16),
                                        PushableButton(
                                          text: 'Try Again',
                                          onTap: () {
                                            context
                                                .read<FavoriteWordsCubit>()
                                                .loadFavorites();
                                          },
                                          width: 200,
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is FavoriteWordsLoaded) {
                          if (state.words.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: () => context
                                  .read<FavoriteWordsCubit>()
                                  .loadFavorites(),
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.favorite_border,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No favorite words yet',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Start adding words to your favorites',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () => context
                                .read<FavoriteWordsCubit>()
                                .loadFavorites(),
                            child: ListView.builder(
                              itemCount: state.words.length,
                              itemBuilder: (context, index) {
                                final word = state.words[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: WordCard(
                                    word: word,
                                    onToggleFavorite: () {
                                      context
                                          .read<FavoriteWordsCubit>()
                                          .toggleFavorite(word.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
