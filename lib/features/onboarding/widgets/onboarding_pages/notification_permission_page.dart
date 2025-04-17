import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wordstock/features/home/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/wordstock_slider.dart';
import 'package:wordstock/widgets/button.dart';

class NotificationPermissionPage extends StatefulWidget {
  const NotificationPermissionPage({super.key});

  @override
  State<NotificationPermissionPage> createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState
    extends State<NotificationPermissionPage> {
  Future<void> _requestNotificationPermission(BuildContext context) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final status = await Permission.notification.request();
    if (status.isGranted) {
      // Proceed to the next page if permission is granted
      if (!context.mounted) return;
      context.read<OnboardingCubit>().nextPage();
    } else {
      bool? result;
      if (Platform.isIOS) {
        result = await OneSignal.Notifications.requestPermission(true);
        if (context.mounted) context.read<OnboardingCubit>().nextPage();
      } else {
        result = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      if ((result ?? false) == true && context.mounted) {
        context.read<OnboardingCubit>().nextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Learn words with daily reminders',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Allow notification to get daily reminder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              const Icon(
                Icons.notifications_active,
                size: 100,
                color: Color(0xff1899D6),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shake(
                    hz: 5,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeIn,
                  ),
              const Spacer(),
              WordStockSlider(
                onChanged: (value) {
                  context.read<OnboardingCubit>().setWordsPerDay(value);
                },
                currentValue: state.wordsPerDay,
              ),
              const Spacer(),
              PushableButton(
                width: 300,
                height: 60,
                text: 'Enable Notifications and Save',
                onTap: () => _requestNotificationPermission(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
