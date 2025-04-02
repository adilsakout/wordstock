import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class RcRepository {
  factory RcRepository() => _instance;

  RcRepository._();
  static final RcRepository _instance = RcRepository._();

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      final googleApiKey = dotenv.env['RC_GOOGLE_API_KEY'];
      configuration = PurchasesConfiguration(googleApiKey!);
    } else if (Platform.isIOS) {
      final appleApiKey = dotenv.env['RC_APPL_API_KEY'];
      configuration = PurchasesConfiguration(appleApiKey!);
    } else {
      throw UnsupportedError(
        'Unsupported platform for RevenueCat configuration',
      );
    }
    await Purchases.configure(configuration);
  }

  Future<void> presentPaywall() async {
    await RevenueCatUI.presentPaywall();
  }

  Future<bool> isUserSubscribed() async {
    log('isUserSubscribed Called', name: 'RcRepository');
    final customerInfo = await Purchases.getCustomerInfo();
    return customerInfo.entitlements.active.containsKey('pro');
  }
}
