import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
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
                  )
                      .animate()
                      .fadeIn(
                        duration: 800.ms,
                        delay: 200.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 800.ms,
                        delay: 200.ms,
                        curve: Curves.easeOut,
                      )
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: 800.ms,
                        delay: 200.ms,
                        curve: Curves.elasticOut,
                      ),
                  const Spacer(),

                  // Main title with sophisticated fade-in animation
                  Text(
                    context.l10n.notificationPermissionTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.2,
                        ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 600.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 16),

                  // Subtitle with gentle fade-in animation
                  Text(
                    context.l10n.notificationPermissionDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 900.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.15,
                        end: 0,
                        duration: 600.ms,
                        delay: 900.ms,
                        curve: Curves.easeOut,
                      ),
                  const Spacer(),
                  PushableButton(
                    width: double.infinity,
                    height: 56,
                    borderRadius: 16,
                    text: state.isRequestingPermission
                        ? context.l10n.requestingPermission
                        : context.l10n.enableNotifications,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onTap: () {
                      context
                          .read<OnboardingCubit>()
                          .requestNotificationPermission();
                    },
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: 1200.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 1200.ms,
                        curve: Curves.easeOut,
                      )
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        delay: 1200.ms,
                        curve: Curves.easeOut,
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
