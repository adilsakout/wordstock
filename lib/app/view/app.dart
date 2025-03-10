import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordstock/features/favorite_words/favorite_words.dart';
import 'package:wordstock/features/home/cubit/home_cubit.dart';
import 'package:wordstock/features/home/view/home_page.dart';
import 'package:wordstock/features/onboarding/onboarding.dart';
import 'package:wordstock/features/practice/practice.dart';
import 'package:wordstock/features/user_data/cubit/user_data_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/repositories/user_repository.dart';
import 'package:wordstock/repositories/word_repository.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  redirect: (context, state) async {
    log('redirect: ${state.uri}', name: 'GoRouter');
    if (state.uri.path == '/') {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding = prefs.getBool('onboarding_completed') ?? false;
      if (!hasSeenOnboarding) {
        await prefs.setBool('onboarding_completed', true);
        return '/';
      }
      return '/home';
    }
    return null;
  },
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(child: Text('Error: ${state.error}')),
    ),
  ),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'favorites',
          builder: (context, state) => const FavoriteWordsPage(),
        ),
        GoRoute(
          path: 'practice',
          builder: (context, state) => const PracticePage(),
        ),
      ],
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(wordRepository: WordRepository()),
        ),
        BlocProvider<StreakCubit>(
          create: (context) => StreakCubit(userRepository: UserRepository()),
        ),
        BlocProvider<FavoriteWordsCubit>(
          create: (context) => FavoriteWordsCubit(
            wordRepository: WordRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
