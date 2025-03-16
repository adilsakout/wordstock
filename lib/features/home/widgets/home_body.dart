// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wordstock/features/favorite_words/favorite_words.dart';
import 'package:wordstock/features/home/cubit/cubit.dart';
import 'package:wordstock/features/home/cubit/learning_progress_cubit.dart';
import 'package:wordstock/features/home/widgets/practice_reminder_page.dart';
import 'package:wordstock/features/home/widgets/word_card.dart';
import 'package:wordstock/features/practice/practice.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/features/user_data/widget/user_point_widget.dart';
import 'package:wordstock/features/user_data/widget/user_strek_widget.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template home_body}
/// Body of the HomePage.
///
/// This widget displays a list of vocabulary words.
/// {@endtemplate}
class HomeBody extends StatefulWidget {
  /// {@macro home_body}
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PageController pageController = PageController();
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().fetchWords();
      _requestReview();
    });
    super.initState();
  }

  Future<void> _requestReview() async {
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  void _onWordLearned(String wordId) {
    context.read<HomeCubit>().markWordAsLearned(wordId);
    context.read<StreakCubit>()
      ..updateStreak()
      ..markWordAsLearned(wordId);

    // Increment words learned count
    context.read<LearningProgressCubit>().incrementWordsLearned();
  }

  void _continueLearning() {
    context.read<LearningProgressCubit>().markPracticeReminderShown();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) async {
            if (state is HomeLoaded && state.celebration) {}
          },
        ),
        BlocListener<LearningProgressCubit, LearningProgressState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, homeState) {
          if (homeState is HomeLoading || homeState is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (homeState is HomeLoaded) {
            return BlocBuilder<LearningProgressCubit, LearningProgressState>(
              builder: (context, learningState) {
                final shouldShowPracticeReminder =
                    learningState.shouldShowPracticeReminder;
                return SafeArea(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: homeState.words.length,
                        physics: shouldShowPracticeReminder
                            ? const NeverScrollableScrollPhysics()
                            : null,
                        scrollDirection: Axis.vertical,
                        onPageChanged: (index) {
                          _onWordLearned(homeState.words[index].id);
                        },
                        itemBuilder: (context, index) {
                          if (shouldShowPracticeReminder) {
                            Gaimon.medium();
                            return PracticeReminderPage(
                              onContinue: _continueLearning,
                            );
                          }
                          return WordCard(
                            word: homeState.words[index],
                            onToggleFavorite: () {
                              context
                                  .read<HomeCubit>()
                                  .toggleFavorite(homeState.words[index].id);
                            },
                          );
                        },
                      ),
                      const Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UserStreakWidget(),
                              UserPointWidget(),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: shouldShowPracticeReminder ? 0 : 1,
                          duration: const Duration(milliseconds: 700),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PushableButton(
                                  width: 50,
                                  height: 50,
                                  text: '',
                                  iconSize: 25,
                                  suffixIcon: Icons.favorite,
                                  buttonColor: const Color(0xffE94E77),
                                  shadowColor: const Color(0xffA8002C),
                                  onTap: () {
                                    context.go(FavoriteWordsPage.name);
                                  },
                                ),
                                const Spacer(),
                                PushableButton(
                                  width: 140,
                                  height: 50,
                                  text: 'Practice',
                                  spacing: 10,
                                  iconSize: 25,
                                  prefixIcon: Icons.gamepad_rounded,
                                  onTap: () async {
                                    await context
                                        .read<LearningProgressCubit>()
                                        .startPractice();

                                    if (context.mounted) {
                                      await context.push(PracticePage.name);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
