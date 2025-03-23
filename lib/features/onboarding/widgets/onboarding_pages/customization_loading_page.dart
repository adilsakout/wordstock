import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/customization_loading_step.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

class CustomizationLoadingPage extends StatefulWidget {
  const CustomizationLoadingPage({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;

  @override
  State<CustomizationLoadingPage> createState() =>
      _CustomizationLoadingPageState();
}

class _CustomizationLoadingPageState extends State<CustomizationLoadingPage>
    with TickerProviderStateMixin {
  // Animation controllers for each step
  late AnimationController _controllerStep1;
  late AnimationController _controllerStep2;
  late AnimationController _controllerStep3;

  // Animation objects for each step
  late Animation<double> _progressStep1;
  late Animation<double> _progressStep2;
  late Animation<double> _progressStep3;

  // Tracking completion state of each step
  bool _isStep1Completed = false;
  bool _isStep2Completed = false;
  bool _isStep3Completed = false;

  // Tracking if steps are paused waiting for user input
  bool _isStep1Paused = false;
  bool _isStep2Paused = false;
  bool _isStep3Paused = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with 2 second duration
    _controllerStep1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controllerStep2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controllerStep3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Create animations with easing
    _progressStep1 = CurvedAnimation(
      parent: _controllerStep1,
      curve: Curves.easeInOut,
    );

    _progressStep2 = CurvedAnimation(
      parent: _controllerStep2,
      curve: Curves.easeInOut,
    );

    _progressStep3 = CurvedAnimation(
      parent: _controllerStep3,
      curve: Curves.easeInOut,
    );

    // Add listeners to trigger rebuilds when animation values change
    _controllerStep1.addListener(_handleAnimationChanges);
    _controllerStep2.addListener(_handleAnimationChanges);
    _controllerStep3.addListener(_handleAnimationChanges);

    // Start the first step
    _startFirstStep();
  }

  // Trigger a rebuild when animations change
  void _handleAnimationChanges() {
    setState(() {});
  }

  // First step - animate to 49% then pause
  void _startFirstStep() {
    _controllerStep1
        .animateTo(0.49, duration: 3.seconds, curve: Curves.easeInOut)
        .then((_) {
      setState(() {
        _isStep1Paused = true;
      });
    });
  }

  // Complete first step and start second
  void _completeFirstStep() {
    setState(() {
      _isStep1Paused = false;
    });

    _controllerStep1
        .animateTo(1, duration: 3.seconds, curve: Curves.easeInOut)
        .then((_) {
      setState(() {
        _isStep1Completed = true;
      });

      // Start second step
      _startSecondStep();
    });
  }

  // Second step - animate to 49% then pause
  void _startSecondStep() {
    _controllerStep2
        .animateTo(0.49, duration: 3.seconds, curve: Curves.easeInOut)
        .then((_) {
      setState(() {
        _isStep2Paused = true;
      });
    });
  }

  // Complete second step and start third
  void _completeSecondStep() {
    setState(() {
      _isStep2Paused = false;
    });

    _controllerStep2
        .animateTo(1, duration: 3.seconds, curve: Curves.easeInOut)
        .then((_) {
      setState(() {
        _isStep2Completed = true;
      });

      // Start third step
      _startThirdStep();
    });
  }

  // Third step - animate to 49% then pause
  void _startThirdStep() {
    _controllerStep3
        .animateTo(0.49, duration: 3.seconds, curve: Curves.easeInOut)
        .then((_) {
      setState(() {
        _isStep3Paused = true;
      });
    });
  }

  // Complete third step and trigger onComplete callback
  void _completeThirdStep() {
    setState(() {
      _isStep3Paused = false;
    });

    _controllerStep3
        .animateTo(1, duration: 3.seconds, curve: Curves.easeInOut)
        .then((_) {
      setState(() {
        _isStep3Completed = true;
      });
    });
  }

  // End of Selection

  @override
  void dispose() {
    // Remove listeners
    _controllerStep1.removeListener(_handleAnimationChanges);
    _controllerStep2.removeListener(_handleAnimationChanges);
    _controllerStep3.removeListener(_handleAnimationChanges);

    // Dispose controllers
    _controllerStep1.dispose();
    _controllerStep2.dispose();
    _controllerStep3.dispose();

    super.dispose();
  }

  String _getTitle(BuildContext context) {
    final l10n = context.l10n;
    final state = context.read<OnboardingCubit>().state;
    final name = state.userName;

    if (_isStep3Completed) {
      return name.isEmpty
          ? l10n.customizationCompleteTitle
          : l10n.customizationCompleteTitleWithName(name);
    } else {
      return name.isEmpty
          ? l10n.customizationLoadingTitle
          : l10n.customizationLoadingTitleWithName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title that changes based on completion and user name
          Text(
            _getTitle(context),
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Text(
            l10n.learningExperienceSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 24,
                  color: const Color(0xff58CC02),
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 40),

          // First step - always visible
          CustomizationLoadingStep(
            title: l10n.profileSetupTitle,
            question: l10n.forgetWordsQuestion,
            onTap: _isStep1Paused ? _completeFirstStep : null,
            progress: _progressStep1.value,
            isCompleted: _isStep1Completed,
          ),

          const SizedBox(height: 20),

          // Second step - visible when first is completed
          if (_isStep1Completed)
            CustomizationLoadingStep(
              title: l10n.learningPreferencesTitle,
              question: l10n.readingConversationQuestion,
              onTap: _isStep2Paused ? _completeSecondStep : null,
              progress: _progressStep2.value,
              isCompleted: _isStep2Completed,
            ),

          const SizedBox(height: 20),

          // Third step - visible when second is completed
          if (_isStep2Completed)
            CustomizationLoadingStep(
              title: l10n.growthAreasTitle,
              question: l10n.progressFrustrationQuestion,
              onTap: _isStep3Paused ? _completeThirdStep : null,
              progress: _progressStep3.value,
              isCompleted: _isStep3Completed,
            ),
          if (_isStep3Completed) ...[
            const Spacer(),
            Center(
              child: PushableButton(
                text: l10n.continueText,
                onTap: widget.onComplete,
                width: 150,
                height: 50,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }
}
