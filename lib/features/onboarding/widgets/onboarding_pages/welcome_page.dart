import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordstock/features/onboarding/onboarding.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// Welcome page that provides a clean, modern onboarding experience
/// following Apple's Human Interface Guidelines
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  /// Handles button press and navigates to next page
  void _handleButtonPress(BuildContext context) {
    context.read<OnboardingCubit>().nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Lottie animation - clean and simple
                Lottie.asset(
                  'assets/lottie/welcome.json',
                  repeat: true,
                  animate: true,
                ),
                const Spacer(),
                // Welcome title with clean typography
                Text(
                  l10n.welcomeTitle,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.2,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Description with clean styling
                Text(
                  l10n.welcomeDescription,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // Call-to-action button - simple and effective
                PushableButton(
                  height: 56,
                  borderRadius: 16,
                  text: 'Start Learning',
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  onTap: () => _handleButtonPress(context),
                ),
                SizedBox(height: padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
