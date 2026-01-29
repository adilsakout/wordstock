import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/daily_habit_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/goal_identity_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/level_selection_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/plan_reveal_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/progress_framing_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/quick_win_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/social_proof_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_step_indicator.dart';
import 'package:wordstock/services/posthog_service.dart';

/// The main body of the onboarding flow containing 7 screens:
///
/// 1. Goal Identity - "What's your goal with English?"
/// 2. Level Selection - "What's your current level?"
/// 3. Quick Win - Word card + mini quiz
/// 4. Progress Framing - "You're already learning"
/// 5. Daily Habit - "How often do you want to practice?"
/// 6. Plan Reveal - Personalized plan summary
/// 7. Social Proof - Community stats and CTA to paywall
///
/// Each screen follows Apple Human Interface Guidelines with:
/// - Clean, modern typography and spacing
/// - Smooth entrance animations
/// - Consistent navigation patterns
/// - Progress indicator at the top
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
            // Step indicator showing progress (1/7, 2/7, etc.)
            const OnboardingStepIndicator(),

            // PageView with the 7 onboarding screens
            Expanded(
              child: PageView(
                scrollDirection: Axis.vertical,
                controller: cubit.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  // Screen 1: Goal selection
                  // "What's your goal with English?"
                  GoalIdentityPage(),

                  // Screen 2: Level selection
                  // "What's your current level?"
                  LevelSelectionPage(),

                  // Screen 3: Quick win (word + quiz)
                  // Teaches "Serendipity" with a mini quiz
                  QuickWinPage(),

                  // Screen 4: Progress framing
                  // "You're already learning" - celebrates early progress
                  ProgressFramingPage(),

                  // Screen 5: Daily habit selection
                  // "How often do you want to practice?"
                  DailyHabitPage(),

                  // Screen 6: Plan reveal
                  // Shows personalized plan based on selections
                  PlanRevealPage(),

                  // Screen 7: Social proof
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
