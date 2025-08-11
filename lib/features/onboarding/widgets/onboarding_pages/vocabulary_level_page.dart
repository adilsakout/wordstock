import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/features/onboarding/widgets/selector.dart';

/// Vocabulary level selection page with Typeform-style animations
/// that create an engaging, progressive disclosure experience
class VocabularyLevelPage extends StatefulWidget {
  const VocabularyLevelPage({super.key});

  @override
  State<VocabularyLevelPage> createState() => _VocabularyLevelPageState();
}

class _VocabularyLevelPageState extends State<VocabularyLevelPage> {
  // Track selected level for enhanced interactions
  int? _selectedLevel;

  /// Handles vocabulary level selection with enhanced animations
  void _selectVocabularyLevel(BuildContext context, int level) {
    // Update selected level for visual feedback
    setState(() {
      _selectedLevel = level;
    });

    // Add a slight delay for better UX, allowing user to see selection
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<OnboardingCubit>()
          ..selectVocabularyLevel(level)
          ..nextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final padding = MediaQuery.of(context).padding;
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
                  // Question title with sophisticated entrance animation
                  Text(
                    'What is your Vocabulary Level?',
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
                        delay: 200.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 600.ms,
                        delay: 200.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 24),

                  // Subtitle with gentle fade-in animation
                  Text(
                    'Select the level that best describes your current vocabulary.',
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
                        delay: 500.ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 600.ms,
                        delay: 500.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 40),

                  // Vocabulary level options with staggered animations
                  ...List.generate(
                    VocabularyLevels.all.length,
                    (index) {
                      final config = VocabularyLevels.all[index];
                      final isSelected = state.vocabularyLevel == index ||
                          _selectedLevel == index;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index < VocabularyLevels.all.length - 1 ? 16 : 0,
                        ),
                        child: Column(
                          children: [
                            // Enhanced selector with staggered fade-in and scale animations
                            AnimatedScale(
                              scale: isSelected ? 1.02 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutQuad,
                              child: Selector(
                                text: config.fullDisplayText,
                                selected: isSelected,
                                onTap: () {
                                  _selectVocabularyLevel(context, index);
                                },
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: 500.ms,
                                  delay: (800 + (index * 150)).ms,
                                  curve: Curves.easeOut,
                                )
                                .slideY(
                                  begin: 0.3,
                                  end: 0,
                                  duration: 500.ms,
                                  delay: (800 + (index * 150)).ms,
                                  curve: Curves.easeOut,
                                )
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1, 1),
                                  duration: 500.ms,
                                  delay: (800 + (index * 150)).ms,
                                  curve: Curves.easeOut,
                                ),
                          ],
                        ),
                      );
                    },
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
