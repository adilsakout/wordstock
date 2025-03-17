import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Create a logger instance
final logger = Logger(
  level: Level.debug,
);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    logger.d('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.d('${bloc.runtimeType} -- $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.e(
      '${bloc.runtimeType} -- $error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    logger.d('onClose -- ${bloc.runtimeType}');
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  logger.i('Loaded environment variables');

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    logger.i('Supabase initialized successfully');

    // Check for existing session or log in anonymously
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      await Supabase.instance.client.auth.signInAnonymously();
      logger.i('Signed in anonymously');
    } else {
      logger.i('Using existing session for user: ${currentUser.id}');
    }
  } catch (e, stackTrace) {
    logger.e('Failed to initialize Supabase', error: e, stackTrace: stackTrace);
  }

  runApp(await builder());
  logger.i('App started successfully');
}
