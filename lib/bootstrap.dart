import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:home_widget/home_widget.dart';
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

  await HomeWidget.setAppGroupId('group.app.clickwiseapps.wordstock.shared');
  await HomeWidget.initiallyLaunchedFromHomeWidget();

  await FlutterBranchSdk.init(
    enableLogging: kDebugMode,
    branchAttributionLevel: BranchAttributionLevel.REDUCED,
  );

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
        ..dsn = kDebugMode ? '' : dotenv.env['SENTRY_DSN']
        ..experimental.replay.sessionSampleRate = 0.0
        ..experimental.replay.onErrorSampleRate = 0.0
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
  if (kDebugMode) {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  }
  // Initialize with your OneSignal App ID
  OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID']!);

  logger.i('App started successfully');
}
