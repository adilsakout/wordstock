import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/age_selection_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/commitment_pact_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/customization_loading_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/gender_selection_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/goal_selection_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/info_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/name_input_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/notification_permission_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/streak_goal_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/time_commitment_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/topic_selection_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/vocabulary_level_page.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/progress_bar.dart';

/// {@template onboarding_body}
/// Body of the OnboardingPage.
///
/// Add what it does
/// {@endtemplate}
class OnboardingBody extends StatelessWidget {
  /// {@macro onboarding_body}
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return SafeArea(
          child: Column(
            children: [
              OnboardingAppBar(
                progress: state.progress,
                currentPage: state.currentPage,
                onSkip: cubit.nextPage,
                onBack: cubit.previousPage,
              ),
              Expanded(
                child: PageView(
                  controller: cubit.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InfoPage(
                      image: Assets.images.onb1Png.path,
                      title: l10n.welcomeTitle,
                      description: l10n.welcomeDescription,
                      buttonText: l10n.getStarted,
                    ),
                    InfoPage(
                      image: Assets.images.onb2Png.path,
                      title: l10n.infoTitle,
                      description: l10n.infoDescription,
                      buttonText: l10n.continueText,
                    ),
                    const AgeSelectionPage(),
                    const GenderSelectionPage(),
                    const NameInputPage(),
                    InfoPage(
                      image: Assets.images.onb3Png.path,
                      title: state.userName.isEmpty
                          ? l10n.makeYoursTitle
                          : l10n.makeYoursWithNameTitle(state.userName),
                      description: l10n.personalizeDescription,
                      buttonText: l10n.continueText,
                      imageHeight: 300,
                    ),
                    const TimeCommitmentPage(),
                    const NotificationPermissionPage(),
                    const VocabularyLevelPage(),
                    InfoPage(
                      image: Assets.images.onb4.path,
                      title: state.userName.isEmpty
                          ? l10n.makeYoursTitle
                          : l10n.makeYoursWithNameTitle(state.userName),
                      description: l10n.personalizeDescription,
                      buttonText: l10n.continueText,
                      imageWidth: 400,
                      imageHeight: 400,
                    ),
                    const GoalSelectionPage(),
                    const TopicSelectionPage(),
                    const StreakGoalPage(),
                    const CommitmentPactPage(),
                    CustomizationLoadingPage(
                      onComplete: () {
                        context.read<OnboardingCubit>().disposePageController();
                        context.replace('/home');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingAppBar extends StatefulWidget {
  const OnboardingAppBar({
    required this.progress,
    required this.currentPage,
    required this.onSkip,
    required this.onBack,
    super.key,
  });

  final VoidCallback onSkip;
  final VoidCallback onBack;
  final double progress;
  final int currentPage;

  @override
  State<OnboardingAppBar> createState() => _OnboardingAppBarState();
}

class _OnboardingAppBarState extends State<OnboardingAppBar> {
  @override
  Widget build(BuildContext context) {
    final shouldShowAppBar = widget.currentPage > 1;

    return AnimatedOpacity(
      opacity: shouldShowAppBar ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            PushableButton(
              width: 45,
              height: 50,
              borderRadius: 50,
              text: '',
              suffixIcon: Icons.arrow_back_ios,
              onTap: widget.onBack,
            ),
            const SizedBox(width: 10),
            Expanded(child: ProgressBar(progress: widget.progress)),
            const SizedBox(width: 10),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Color(0xFF77D728),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
