import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wordstock/features/favorite_words/cubit/cubit.dart';
import 'package:wordstock/features/favorite_words/widgets/word_card.dart';
import 'package:wordstock/features/home/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
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
    final l10n = context.l10n;
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
                        l10n.favoriteWordsTitle,
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
                                                    left: 8,
                                                  ),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            color: const Color(0xff1CB0F6),
                            strokeWidth: 3,
                            displacement: 20,
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
                                          text: l10n.tryAgain,
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              color: const Color(0xff1CB0F6),
                              strokeWidth: 3,
                              displacement: 20,
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
                                            l10n.noFavoritesTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            l10n.noFavoritesDescription,
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            color: const Color(0xff1CB0F6),
                            strokeWidth: 3,
                            displacement: 20,
                            child: ListView.builder(
                              itemCount: state.words.length,
                              itemBuilder: (context, index) {
                                final word = state.words[index];
                                return AnimatedSlide(
                                  duration: const Duration(milliseconds: 200),
                                  offset: Offset.zero,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: FavoriteWordCard(
                                        key: Key(word.word),
                                        word: word,
                                        onToggleFavorite: () async {
                                          final homeCubit =
                                              context.read<HomeCubit>();
                                          final favoritesCubit = context
                                              .read<FavoriteWordsCubit>();

                                          await homeCubit
                                              .toggleFavorite(word.id);
                                          await favoritesCubit
                                              .toggleFavorite(word.id);
                                        },
                                      ),
                                    ),
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
