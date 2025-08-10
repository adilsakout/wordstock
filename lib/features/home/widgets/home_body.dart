import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/features/home/cubit/cubit.dart';
import 'package:wordstock/features/home/cubit/learning_progress_cubit.dart';
import 'package:wordstock/features/home/widgets/paywall_button.dart';
import 'package:wordstock/features/home/widgets/practice_button.dart';
import 'package:wordstock/features/home/widgets/practice_reminder_page.dart';
import 'package:wordstock/features/home/widgets/word_card.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/features/user_data/widget/user_point_widget.dart';
import 'package:wordstock/features/user_data/widget/user_strek_widget.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
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

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  final PageController pageController = PageController();
  final InAppReview inAppReview = InAppReview.instance;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().fetchWords();
      context
          .read<SubscriptionCubit>()
          .checkSubscriptionAndShowPaywallAfterOnboarding();

      _requestReview();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<StreakCubit>().updateStreak();
  }

  Future<void> _showMotivationalDialog(BuildContext context) async {
    final l10n = context.l10n;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.letsGrowTogether,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1CB0F6),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 200),
                    ),
                const SizedBox(height: 16),
                Text(
                  l10n.reviewMotivationText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 400),
                    ),
                const SizedBox(height: 24),
                PushableButton(
                  width: double.infinity,
                  height: 50,
                  text: l10n.letsGrowTogetherButton,
                  buttonColor: const Color(0xff1CB0F6),
                  shadowColor: const Color(0xff1899D6),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ).animate().fadeIn(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 600),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _requestReview() async {
    if (await inAppReview.isAvailable() && !kDebugMode) {
      if (!mounted) return;

      final homeState = context.read<HomeCubit>().state;
      if (homeState is HomeLoaded && !homeState.hasShownReview) {
        await _showMotivationalDialog(context).then((_) async {
          await inAppReview.requestReview();
          if (!mounted) return;
          context.read<HomeCubit>().markReviewAsShown();
        });
      }
    }
  }

  void _onWordLearned(String wordId) {
    context.read<HomeCubit>().markWordAsLearned(wordId);
    context.read<StreakCubit>()
      ..updateStreak()
      ..markWordAsLearned(wordId);

    // Increment words learned count with the specific word ID
    context.read<LearningProgressCubit>().incrementWordsLearned(wordId: wordId);
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

                final shouldShowSwipeUpReminder =
                    learningState.shouldShowSwipeUpReminder;

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
                          if (shouldShowSwipeUpReminder) {
                            context
                                .read<LearningProgressCubit>()
                                .hideSwipeUpReminder();
                          }
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
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const UserStreakWidget(),
                              const UserPointWidget(),
                              const Spacer(),
                              if (kDebugMode)
                                IconButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.clear();
                                  },
                                  icon: const Icon(Icons.ice_skating),
                                ),
                              const PaywallButton(),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity: (shouldShowPracticeReminder ||
                                  shouldShowSwipeUpReminder)
                              ? 0
                              : 1,
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
                                  suffixIcon: Icons.person,
                                  buttonColor: const Color(0xffF9C835),
                                  shadowColor: const Color(0xffCDB054),
                                  onTap: () {
                                    context.push('/profile');
                                  },
                                ),
                                const Spacer(),
                                const PracticeButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (shouldShowSwipeUpReminder)
                        Animate(
                          controller: _controller,
                          onComplete: (controller) =>
                              controller.repeat(reverse: true),
                          effects: [
                            MoveEffect(
                              duration: 700.ms,
                              begin: const Offset(0, 10),
                              end: Offset.zero,
                            ),
                            FadeEffect(
                              duration: 700.ms,
                              begin: 0,
                              end: 1,
                            ),
                          ],
                          child: Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  Assets.icons.hand,
                                  width: 50,
                                  height: 50,
                                ),
                                const Text(
                                  'Swipe up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
