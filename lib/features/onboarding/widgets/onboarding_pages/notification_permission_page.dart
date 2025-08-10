import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/widgets/button.dart';

/// Notification permission page with Typeform-style animations
/// that creates an engaging permission request experience
class NotificationPermissionPage extends StatefulWidget {
  const NotificationPermissionPage({super.key});

  @override
  State<NotificationPermissionPage> createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState
    extends State<NotificationPermissionPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Lottie notification animation with sophisticated entrance
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      'assets/lottie/bell_notification.json',
                      repeat: true,
                      animate: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),

                  // Main title with engaging animation
                  Text(
                    'Learn words with daily reminders',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.2,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle with gentle animation
                  Text(
                    'Allow notifications to get daily reminders and never miss your learning streak.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                  ),
                  const Spacer(),
                  // Enhanced call-to-action button with sophisticated animations
                  PushableButton(
                    width: double.infinity,
                    height: 56,
                    borderRadius: 16,
                    text: state.isRequestingPermission
                        ? 'Requesting Permission...'
                        : 'Enable Notifications',
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onTap: () {
                      context
                          .read<OnboardingCubit>()
                          .requestNotificationPermission();
                    },
                  ),

                  SizedBox(height: padding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
