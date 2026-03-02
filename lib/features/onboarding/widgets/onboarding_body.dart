import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/daily_habit_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/goal_identity_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/level_selection_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/notification_permission_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/plan_reveal_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/progress_framing_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/quick_win_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/social_proof_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/welcome_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_step_indicator.dart';
import 'package:wordstock/services/posthog_service.dart';

/// The main body of the onboarding flow containing 9 screens:
///
/// 0. Welcome — Value context, no progress indicator
/// 1. Goal Identity — "How does English hold you back today?"
/// 2. Level Selection — "What's your current level?"
/// 3. Assessment — Vocabulary assessment (word card + quiz)
/// 4. Progress Framing — "You're already learning"
/// 5. Daily Habit — "What daily practice works for you?"
/// 6. Notification Permission — "Stay on track with gentle nudges"
/// 7. Plan Reveal — Personalized plan summary
/// 8. Social Proof — Community stats and CTA to paywall
///
/// The Welcome screen (index 0) does NOT count toward the 8-step
/// progress indicator. Steps 1-8 show progress as 1/8 through 8/8.
///
/// Each screen follows Apple Human Interface Guidelines with:
/// - Clean, modern typography and spacing
/// - Smooth entrance animations
/// - Consistent navigation patterns
/// - Progress indicator at the top (hidden on welcome)
class OnboardingBody extends StatefulWidget {
  /// {@macro onboarding_body}
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  @override
  void initState() {
    super.initState();
    // Track onboarding start for analytics
    PosthogService.instance.track('Onboarding Started');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return Column(
          children: [
            // Step indicator showing progress (1/8 through 8/8)
            // Automatically hidden on the welcome screen (page 0)
            const OnboardingStepIndicator(),

            // PageView with 9 screens (welcome + 8 onboarding steps)
            Expanded(
              child: PageView(
                scrollDirection: Axis.vertical,
                controller: cubit.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  // Screen 0: Welcome (no progress indicator)
                  // Sets value context and reduces friction
                  WelcomePage(),

                  // Screen 1 (Step 1/8): Goal selection
                  // "How does English hold you back today?"
                  GoalIdentityPage(),

                  // Screen 2 (Step 2/8): Level selection
                  // "What's your current level?"
                  LevelSelectionPage(),

                  // Screen 3 (Step 3/8): Vocabulary assessment
                  // Teaches "Serendipity" with a calibration quiz
                  QuickWinPage(),

                  // Screen 4 (Step 4/8): Progress framing
                  // "You're already learning" — celebrates early progress
                  ProgressFramingPage(),

                  // Screen 5 (Step 5/8): Daily habit selection
                  // "What daily practice works for you?"
                  DailyHabitPage(),

                  // Screen 6 (Step 6/8): Notification permission
                  // "Stay on track with gentle nudges"
                  NotificationPermissionPage(),

                  // Screen 7 (Step 7/8): Plan reveal
                  // Shows personalized plan based on selections
                  PlanRevealPage(),

                  // Screen 8 (Step 8/8): Social proof
                  // Community stats and final CTA to paywall
                  SocialProofPage(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
