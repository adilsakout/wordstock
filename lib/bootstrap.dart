import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wordstock/repositories/rc_repository.dart';
import 'package:wordstock/repositories/supabase_repository.dart';
import 'package:wordstock/services/posthog_service.dart';

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

  await RcRepository().initPlatformState();

  // Initialize Supabase and sign in anonymously
  try {
    await SupabaseRepository.instance.initialize();
  } catch (e, stackTrace) {
    logger.e(
      'Failed to initialize Supabase or sign in',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // Initialize PostHog analytics
  try {
    await PosthogService.instance.initialize();
  } catch (e, stackTrace) {
    logger.e(
      'Failed to initialize PostHog',
      error: e,
      stackTrace: stackTrace,
    );
  }

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dotenv.env['SENTRY_DSN']
        ..experimental.replay.sessionSampleRate = 1.0
        ..experimental.replay.onErrorSampleRate = 1.0
        ..sendDefaultPii = true;
    },
    appRunner: () async {
      return runApp(
        SentryWidget(
          child: await builder(),
        ),
      );
    },
  );

  // Enable verbose logging for debugging (remove in production)
  await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID']!);
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead u
  //se In-App Message
  //s to prompt for notification permission.
  await OneSignal.Notifications.requestPermission(false);

  logger.i('App started successfully');
}
