import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/features/credit/cubit/credit_cubit.dart';
import 'package:wordstock/features/credit/widgets/credit_indicator_widget.dart';
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
import 'package:wordstock/services/posthog_service.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final PageController pageController = PageController();
  final InAppReview inAppReview = InAppReview.instance;
  late final AnimationController _controller;
  int _swipeCount = 0;
  bool _hasTrackedPracticeReminder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().fetchWords();
      context.read<SubscriptionCubit>().checkSubscription();
      context.read<CreditCubit>().loadCredits();

      _showPaywallOnceAfterOnboarding();
      _requestReview();
      _trackAppSessionStarted();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Fetch words again when app resumes to ensure widget is updated
      // if the user opened the app from the widget
      context.read<HomeCubit>().fetchWords();
      _trackAppSessionStarted();
    }
  }

  Future<void> _trackAppSessionStarted() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSessionMs = prefs.getInt('last_session_timestamp') ?? 0;
    final now = DateTime.now();
    final daysSinceLastSession = lastSessionMs > 0
        ? now
            .difference(DateTime.fromMillisecondsSinceEpoch(lastSessionMs))
            .inDays
        : -1;
    await prefs.setInt('last_session_timestamp', now.millisecondsSinceEpoch);

    if (!mounted) return;
    final streakState = context.read<StreakCubit>().state;
    final currentStreak = streakState.profile?.dailyStreak ?? 0;

    PosthogService.instance.track(
      'App Session Started',
      properties: {
        'days_since_last_session': daysSinceLastSession,
        'current_streak': currentStreak,
      },
    );
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

  /// Shows the paywall exactly once after onboarding completes.
  /// Uses a SharedPreferences flag to prevent showing it again.
  Future<void> _showPaywallOnceAfterOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final paywallShown =
        prefs.getBool('paywall_shown_after_onboarding') ?? false;

    if (paywallShown) return;

    final hasCompletedOnboarding =
        prefs.getBool('onboarding_completed') ?? false;
    if (!hasCompletedOnboarding) return;

    await prefs.setBool('paywall_shown_after_onboarding', true);

    if (!mounted) return;

    final isSubscribed =
        context.read<SubscriptionCubit>().state.maybeWhen(
              loaded: (isSubscribed) => isSubscribed,
              orElse: () => false,
            );

    if (!isSubscribed) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      await context.read<SubscriptionCubit>().showPaywall(
            source: 'post_onboarding',
          );
    }
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
    _hasTrackedPracticeReminder = false;
    PosthogService.instance.track(
      'Practice Reminder Action',
      properties: {'action': 'continue_learning'},
    );
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
                          // Track Word Card Swiped every 5th swipe
                          _swipeCount++;
                          if (_swipeCount % 5 == 0) {
                            PosthogService.instance.track(
                              'Word Card Swiped',
                              properties: {
                                'word_index': index,
                                'words_in_session': _swipeCount,
                              },
                            );
                          }
                        },
                        itemBuilder: (context, index) {
                          if (shouldShowPracticeReminder) {
                            Gaimon.medium();
                            // Track Practice Reminder Shown once
                            if (!_hasTrackedPracticeReminder) {
                              _hasTrackedPracticeReminder = true;
                              PosthogService.instance.track(
                                'Practice Reminder Shown',
                                properties: {
                                  'words_learned_count':
                                      learningState.cumulativeWords,
                                },
                              );
                            }
                            return PracticeReminderPage(
                              onContinue: _continueLearning,
                            );
                          }
                          final word = homeState.words[index];
                          return WordCard(
                            word: word,
                            hasPreviousChat: homeState
                                .wordsWithChats
                                .contains(word.id),
                            onToggleFavorite: () {
                              context
                                  .read<HomeCubit>()
                                  .toggleFavorite(word.id);
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
                              const CreditIndicatorWidget(),
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
                                Text(
                                  context.l10n.swipeUp,
                                  style: const TextStyle(
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
