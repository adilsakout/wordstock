import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/gen/assets.gen.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/progress_bar.dart';

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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  Timer? _timer;
  int _currentStep = 0;
  bool _isComplete = false;

  late List<String> _customizationSteps;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startCustomization();
  }

  void _startCustomization() {
    // Start the animation
    _animationController.forward();

    // Set up a timer to cycle through the customization steps
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_currentStep < _customizationSteps.length - 1) {
        setState(() {
          _currentStep++;
          _animationController
            ..reset()
            ..forward();
        });
      } else if (!_isComplete) {
        setState(() {
          _isComplete = true;
          timer.cancel();
          _timer = null;
        });

        // Save the onboarding data
        context.read<OnboardingCubit>().saveOnboardingData();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _getTitle(bool isComplete, String userName) {
    final l10n = context.l10n;
    if (isComplete) {
      // Complete state
      if (userName.isNotEmpty) {
        return l10n.customizationCompleteTitleWithName(userName);
      } else {
        return l10n.customizationCompleteTitle;
      }
    } else {
      // Loading state
      if (userName.isNotEmpty) {
        return l10n.customizationLoadingTitleWithName(userName);
      } else {
        return l10n.customizationLoadingTitle;
      }
    }
  }

  // Calculate the overall progress based on current step and animation
  double _calculateOverallProgress() {
    if (_isComplete) return 1;

    // Each step represents 1/5 of the total progress
    final stepProgress = _currentStep / (_customizationSteps.length - 1);
    // The animation represents progress within the current step
    final animationContribution =
        _progressAnimation.value / _customizationSteps.length;

    // Start at 30% progress
    return 0.3 + stepProgress * 0.7 + animationContribution * 0.7;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.read<OnboardingCubit>().state;
    final title = _getTitle(_isComplete, state.userName);

    // Initialize the steps with localized strings
    _customizationSteps = [
      l10n.analyzingPreferences,
      l10n.selectingWords,
      l10n.personalizingPath,
      l10n.creatingWordList,
      l10n.finalizingExperience,
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              Assets.images.onb5.path,
              width: 300,
              height: 300,
            ).animate(controller: _animationController).moveY(
                  begin: 0.9,
                  end: 1.1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    title,
                    key: ValueKey<String>(title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedOpacity(
                  opacity: _isComplete ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child:
                            ProgressBar(progress: _calculateOverallProgress()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: _isComplete ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _customizationSteps[_currentStep],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedOpacity(
                  opacity: _isComplete ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: _isComplete
                      ? PushableButton(
                          text: l10n.startLearning,
                          onTap: widget.onComplete,
                          width: 200,
                          height: 50,
                          buttonColor: const Color(0xff1CB0F6),
                          shadowColor: const Color(0xff1899D6),
                        )
                      : const SizedBox.shrink(),
                ),
                const SafeArea(
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
