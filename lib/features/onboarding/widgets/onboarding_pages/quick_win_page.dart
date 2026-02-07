import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/core/theme/app_theme.dart';
import 'package:wordstock/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:wordstock/widgets/button.dart';

/// Screen 3: Quick Win Page
///
/// Shows a word card with "Serendipity" and its definition, then presents
/// a multiple-choice quiz. The CTA is disabled until the user answers.
/// Provides immediate feedback on answer selection.
class QuickWinPage extends StatefulWidget {
  const QuickWinPage({super.key});

  @override
  State<QuickWinPage> createState() => _QuickWinPageState();
}

class _QuickWinPageState extends State<QuickWinPage> {
  // Quiz state management
  int? _selectedAnswerIndex;
  bool _showFeedback = false;

  // The word being taught
  static const String _word = 'Serendipity';
  static const String _definition =
      'Finding something good without looking for it.';

  // Quiz options - index 0 is the correct answer
  static const List<String> _quizOptions = [
    r'A) "I found $20 in my old jacket. Total serendipity."',
    'B) "I serendipity my homework every night."',
    'C) "The serendipity was very hungry."',
  ];

  // Correct answer index
  static const int _correctAnswerIndex = 0;

  /// Handles answer selection and provides feedback
  void _selectAnswer(int index) {
    // Prevent re-selection after answering
    if (_selectedAnswerIndex != null) return;

    setState(() {
      _selectedAnswerIndex = index;
      _showFeedback = true;
    });

    // Determine if answer is correct
    final isCorrect = index == _correctAnswerIndex;

    // Provide haptic feedback
    if (isCorrect) {
      Gaimon.success();
    } else {
      Gaimon.error();
    }

    // Update cubit state
    context.read<OnboardingCubit>().answerMicroWinQuiz(isCorrect: isCorrect);
  }

  /// Gets the color for an answer option based on selection state
  Color _getOptionColor(int index, ThemeData theme) {
    if (_selectedAnswerIndex == null) {
      // Not answered yet - neutral color
      return theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : Colors.white;
    }

    if (index == _correctAnswerIndex) {
      // This is the correct answer - show green
      return AppColors.primaryGreen.withValues(alpha: 0.15);
    }

    if (index == _selectedAnswerIndex && index != _correctAnswerIndex) {
      // This was selected but wrong - show red
      return Colors.red.withValues(alpha: 0.15);
    }

    // Other options - neutral
    return theme.brightness == Brightness.dark
        ? theme.colorScheme.surface
        : Colors.white;
  }

  /// Gets the border color for an answer option
  Color _getOptionBorderColor(int index, ThemeData theme) {
    if (_selectedAnswerIndex == null) {
      // Not answered yet
      return theme.brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade300;
    }

    if (index == _correctAnswerIndex) {
      // Correct answer - green border
      return AppColors.primaryGreen;
    }

    if (index == _selectedAnswerIndex && index != _correctAnswerIndex) {
      // Wrong selection - red border
      return Colors.red;
    }

    // Other options
    return theme.brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Word Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? theme.colorScheme.surface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Word
                      Text(
                        _word,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Definition
                      Text(
                        _definition,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.8),
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms).scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      delay: 500.ms,
                    ),

                const SizedBox(height: 32),

                // Quiz prompt
                Text(
                  'Which sentence uses it correctly?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 800.ms),

                const SizedBox(height: 20),

                // Quiz options with staggered animations
                ...List.generate(
                  _quizOptions.length,
                  (index) {
                    final option = _quizOptions[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < _quizOptions.length - 1 ? 12 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getOptionColor(index, theme),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getOptionBorderColor(index, theme),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: _selectedAnswerIndex == index
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              // Show check or X icon after selection
                              if (_selectedAnswerIndex != null &&
                                  (index == _correctAnswerIndex ||
                                      index == _selectedAnswerIndex))
                                Icon(
                                  index == _correctAnswerIndex
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: index == _correctAnswerIndex
                                      ? AppColors.primaryGreen
                                      : Colors.red,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (1000 + (index * 100)).ms,
                          )
                          .slideX(
                            begin: 0.1,
                            end: 0,
                            duration: 400.ms,
                            delay: (1000 + (index * 100)).ms,
                          ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Feedback message
                if (_showFeedback)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedAnswerIndex == _correctAnswerIndex
                          ? AppColors.primaryGreen.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAnswerIndex == _correctAnswerIndex
                            ? AppColors.primaryGreen.withValues(alpha: 0.3)
                            : Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedAnswerIndex == _correctAnswerIndex
                              ? Icons.celebration
                              : Icons.lightbulb_outline,
                          color: _selectedAnswerIndex == _correctAnswerIndex
                              ? AppColors.primaryGreen
                              : Colors.orange,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedAnswerIndex == _correctAnswerIndex
                                ? 'Correct! You just learned a new word.'
                                : 'Nice try. The correct answer is A.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _selectedAnswerIndex == _correctAnswerIndex
                                  ? AppColors.primaryGreen
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms),

                const SizedBox(height: 32),

                // CTA Button - only enabled after answering
                if (state.microWinAnswered)
                  PushableButton(
                    height: 56,
                    borderRadius: 16,
                    text: 'Next',
                    onTap: () => context.read<OnboardingCubit>().nextPage(),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0, duration: 500.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
