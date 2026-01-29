import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/core/theme/app_theme.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/widgets/button.dart';

/// A step indicator widget for the onboarding flow showing progress
/// through the 7-screen journey.
///
/// Displays:
/// - Back button (when not on first screen)
/// - Progress indicator showing current step (e.g., "1/7")
/// - Animated progress bar
class OnboardingStepIndicator extends StatelessWidget {
  const OnboardingStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        // Calculate progress (1-indexed for display)
        final currentStep = cubit.currentStep;
        const totalSteps = OnboardingCubit.totalPages;
        final progressValue = cubit.stepProgress;

        // Show back button only if not on first page
        final showBackButton = state.currentPage > 0;

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Back button (or placeholder for alignment)
                AnimatedOpacity(
                  opacity: showBackButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedScale(
                    scale: showBackButton ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 200),
                    child: showBackButton
                        ? PushableButton(
                            width: 45,
                            height: 50,
                            borderRadius: 50,
                            text: '',
                            buttonColor: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            shadowColor: isDark
                                ? Colors.grey.shade900
                                : Colors.grey.shade400,
                            suffixIcon: Icons.arrow_back_ios,
                            iconSize: 18,
                            textColor: theme.colorScheme.onSurface,
                            onTap: cubit.previousPage,
                          )
                        : const SizedBox(width: 45, height: 50),
                  ),
                ),

                const SizedBox(width: 12),

                // Progress bar and step indicator
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Step text indicator
                      Text(
                        '$currentStep / $totalSteps',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Animated progress bar
                      _AnimatedProgressBar(progress: progressValue),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Placeholder for alignment (matches back button width)
                const SizedBox(width: 45, height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// An animated progress bar that smoothly transitions between progress values
class _AnimatedProgressBar extends StatefulWidget {
  const _AnimatedProgressBar({required this.progress});

  final double progress;

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0;

  @override
  void initState() {
    super.initState();
    _previousProgress = widget.progress;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(
      begin: _previousProgress,
      end: widget.progress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = oldWidget.progress;
      _animation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Progress fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: constraints.maxWidth * _animation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.primaryGreen.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
