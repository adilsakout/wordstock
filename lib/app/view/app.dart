import 'dart:developer';
import 'package:advanced_in_app_review/advanced_in_app_review.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/features/favorite_words/favorite_words.dart';
import 'package:wordstock/features/home/cubit/home_cubit.dart';
import 'package:wordstock/features/home/cubit/learning_progress_cubit.dart';
import 'package:wordstock/features/home/view/home_page.dart';
import 'package:wordstock/features/onboarding/onboarding.dart';
import 'package:wordstock/features/practice/practice.dart';
import 'package:wordstock/features/subscription/cubit/subscription_cubit.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/l10n/arb/app_localizations.dart';
import 'package:wordstock/repositories/quiz_repository.dart';
import 'package:wordstock/repositories/rc_repository.dart';
import 'package:wordstock/repositories/supabase_repository.dart';
import 'package:wordstock/repositories/tts_repository.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';
import 'package:wordstock/services/posthog_service.dart';

final _router = GoRouter(
  observers: [PosthogObserver()],
  redirect: (context, state) async {
    if (state.uri.path == '/') {
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedOnboarding =
          prefs.getBool('onboarding_completed') ?? false;

      if (!hasCompletedOnboarding) {
        return '/';
      }
      return '/home';
    }

    return null;
  },
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  ),
  routes: [
    GoRoute(
      path: '/',
      name: 'Onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'Home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'favorites',
          name: 'Favorites',
          builder: (context, state) => const FavoriteWordsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/practice',
      name: 'Practice',
      builder: (context, state) => const PracticePage(),
    ),
  ],
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    _initializeServices();
    AdvancedInAppReview()
        .setMinDaysBeforeRemind(7)
        .setMinDaysAfterInstall(2)
        .setMinLaunchTimes(2)
        .setMinSecondsBeforeShowDialog(4)
        .monitor();
    super.initState();
  }

  @override
  void dispose() {
    SupabaseRepository.instance.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      await Future.wait([
        SupabaseRepository.instance.initialize(),
        RcRepository().initPlatformState(),
        PosthogService.instance.initialize(),
      ]);
    } catch (e) {
      log('Failed to initialize services: $e', name: 'App');
    }
  }

  // Initialize repositories
  final userRepository = UserRepository();
  final wordRepository = WordRepository();
  final ttsRepository = TTSRepository();
  final quizRepository = QuizRepository();
  final rcRepository = RcRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            wordRepository: wordRepository,
            ttsRepository: ttsRepository,
            userRepository: userRepository,
          ),
        ),
        BlocProvider<StreakCubit>(
          create: (context) => StreakCubit(userRepository: userRepository),
        ),
        BlocProvider<FavoriteWordsCubit>(
          create: (context) => FavoriteWordsCubit(
            wordRepository: wordRepository,
            ttsRepository: ttsRepository,
          ),
        ),
        BlocProvider<LearningProgressCubit>(
          create: (context) => LearningProgressCubit(),
        ),
        BlocProvider<PracticeCubit>(
          create: (context) => PracticeCubit(
            quizRepository: quizRepository,
            userRepository: userRepository,
            wordRepository: wordRepository,
          ),
        ),
        BlocProvider<SubscriptionCubit>(
          create: (context) => SubscriptionCubit(rcRepository: rcRepository),
        ),
      ],
      child: PostHogWidget(
        child: MaterialApp.router(
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            useMaterial3: true,
          ),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.textScalerOf(
                context,
              ).clamp(minScaleFactor: 0.8, maxScaleFactor: 1.5),
            ),
            child: child!,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
