import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/notification_permission_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/vocabulary_level_page.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/welcome_page.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/services/posthog_service.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/progress_bar.dart';

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
    // Track onboarding start
    PosthogService.instance.track('Onboarding Started');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return SafeArea(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: cubit.pageController,
            // physics: const NeverScrollableScrollPhysics(),
            children: const [
              WelcomePage(),
              VocabularyLevelPage(),
              NotificationPermissionPage(),
              EnglishTestPage(),
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
    final l10n = context.l10n;
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
              tooltip: l10n.onboardingBack,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                label: l10n.onboardingProgressLabel,
                value: '${(widget.progress * 100).round()}%',
                child: ProgressBar(progress: widget.progress),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                color: const Color(0xFF77D728),
                semanticLabel: l10n.onboardingStar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
