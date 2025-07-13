import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';

/// {@template review_request_page}
/// Onboarding page that requests users to review the app.
///
/// This page follows Apple's Human Interface Guidelines with:
/// - Clean, modern layout with proper spacing
/// - Engaging visual elements (star icons)
/// - Clear call-to-action with elegant animations
/// - Smooth spring animations for user interactions
/// - Accessibility support with semantic labels
/// {@endtemplate}
class ReviewRequestPage extends StatefulWidget {
  /// {@macro review_request_page}
  const ReviewRequestPage({super.key});

  @override
  State<ReviewRequestPage> createState() => _ReviewRequestPageState();
}

class _ReviewRequestPageState extends State<ReviewRequestPage>
    with TickerProviderStateMixin {
  // Animation controller for smooth, spring-based transitions
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  // Animation controller for the floating star effect
  late final AnimationController _starController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();
    // Start animations when page loads
    _animationController.forward();
    _starController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _starController.dispose();
    super.dispose();
  }

  /// Handles the review button tap with elegant animation feedback
  Future<void> _handleReviewTap(BuildContext context) async {
    try {
      final inAppReview = InAppReview.instance;

      // Check if in-app review is available on this platform
      if (await inAppReview.isAvailable()) {
        // Request the native app store review popup
        await inAppReview.requestReview();
      } else {
        // Fallback: Open the app store listing directly
        await inAppReview.openStoreListing(
          appStoreId: '6743778895', // WordStock's App Store ID
        );
      }

      // Animate out and continue to next onboarding page
      if (context.mounted) {
        await _animationController.reverse();
        if (context.mounted) {
          context.read<OnboardingCubit>().nextPage();
        }
      }
    } catch (e) {
      // If review fails, just continue to next page
      if (context.mounted) {
        await _animationController.reverse();
        if (context.mounted) {
          context.read<OnboardingCubit>().nextPage();
        }
      }
    }
  }

  /// Builds the floating star decoration with subtle animation
  Widget _buildFloatingStars() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _starController,
        builder: (context, child) {
          return Stack(
            children: [
              // Top-left floating star
              Positioned(
                top: 60 + (10 * _starController.value),
                left: 40 + (5 * _starController.value),
                child: Icon(
                  Icons.star,
                  color: const Color(0xFF77D728).withValues(alpha: 0.3),
                  size: 20,
                ),
              ),
              // Top-right floating star
              Positioned(
                top: 80 - (8 * _starController.value),
                right: 60 + (3 * _starController.value),
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                  size: 16,
                ),
              ),
              // Bottom-left floating star
              Positioned(
                bottom: 200 + (6 * _starController.value),
                left: 80 - (4 * _starController.value),
                child: Icon(
                  Icons.star,
                  color: const Color(0xFF1CB0F6).withValues(alpha: 0.3),
                  size: 14,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Floating stars background decoration
          _buildFloatingStars(),

          // Main content
          Column(
            children: [
              const Spacer(flex: 2),

              // Hero star icon with pulsing animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF77D728).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: 60,
                  color: const Color(0xFF77D728),
                  semanticLabel: l10n.onboardingStar,
                ),
              )
                  .animate(controller: _animationController)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut,
                    duration: const Duration(milliseconds: 600),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                  ),

              const SizedBox(height: 40),

              // Title with slide-in animation
              Semantics(
                label: l10n.onboardingReviewTitle,
                child: Text(
                  l10n.onboardingReviewTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
              )
                  .animate(controller: _animationController)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 600),
                  )
                  .fadeIn(
                    duration: const Duration(milliseconds: 600),
                  ),

              const SizedBox(height: 20),

              // Subtitle with staggered animation
              Semantics(
                label: l10n.onboardingReviewSubtitle,
                child: Text(
                  l10n.onboardingReviewSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              )
                  .animate(controller: _animationController)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutCubic,
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                  )
                  .fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 100),
                  ),

              const Spacer(flex: 3),

              // Review button with spring animation
              Semantics(
                label: l10n.onboardingReviewButton,
                child: PushableButton(
                  width: 280,
                  height: 60,
                  borderRadius: 25,
                  text: l10n.onboardingReviewButton,
                  shadowColor: const Color(0xFF5BA51F),
                  onTap: () => _handleReviewTap(context),
                ),
              )
                  .animate(controller: _animationController)
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    curve: Curves.elasticOut,
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 200),
                  )
                  .fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                  ),

              // Skip option with subtle animation (appears after 5 seconds)
              const SizedBox(height: 16),

              // Skip button appears after 5 seconds using flutter_animate
              Semantics(
                label: l10n.onboardingReviewSkip,
                child: GestureDetector(
                  onTap: () async {
                    await _animationController.reverse();
                    if (context.mounted) {
                      context.read<OnboardingCubit>().nextPage();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.onboardingReviewSkip,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(seconds: 5),
                    curve: Curves.easeInOut,
                  ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
