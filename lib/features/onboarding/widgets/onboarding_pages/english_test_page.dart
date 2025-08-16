import 'package:flutter/material.dart';

import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_intro.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_question.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_result.dart';
import 'package:wordstock/model/english_test_question.dart' as model;

/// {@template english_test_page}
/// Onboarding page that provides a small English vocabulary test.
///
/// This page follows Apple's Human Interface Guidelines with:
/// - Clean, modern layout with proper spacing
/// - Engaging quiz interface with immediate feedback
/// - Smooth animations and transitions
/// - Accessibility support with semantic labels
/// - Progress tracking through the mini test
/// {@endtemplate}
class EnglishTestPage extends StatefulWidget {
  /// {@macro english_test_page}
  const EnglishTestPage({super.key});

  @override
  State<EnglishTestPage> createState() => _EnglishTestPageState();
}

class _EnglishTestPageState extends State<EnglishTestPage>
    with TickerProviderStateMixin {
  // Animation controller for smooth transitions
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  // Page controller for test flow
  late final PageController _pageController = PageController();

  // Test state management
  int _currentQuestionIndex = 0;
  final Map<int, String> _selectedAnswers = {};
  final Map<int, bool> _answerResults = {};

  // Questions loaded from the cubit/repository
  List<model.EnglishTestQuestion> _questions = [];

  // Loading and error states
  bool _isLoadingQuestions = false;
  String? _loadingError;

  @override
  void initState() {
    super.initState();
    _animationController.forward();

    // Initialize test state
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _answerResults.clear();

    // Load questions from cubit
    _loadQuestions();
  }

  /// Loads English test questions from the cubit/repository
  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoadingQuestions = true;
        _loadingError = null;
      });

      // Load questions through the cubit which uses the repository
      final questions =
          await context.read<OnboardingCubit>().loadEnglishTestQuestions();

      setState(() {
        _questions = questions;
        _isLoadingQuestions = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingQuestions = false;
        _loadingError = e.toString();
      });

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load test questions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Starts the mini English test
  void _startTest() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Handles answer selection for the current question
  void _selectAnswer(String selectedOption) {
    if (_selectedAnswers.containsKey(_currentQuestionIndex)) {
      return; // Already answered this question
    }

    final correctAnswer = _questions[_currentQuestionIndex].correct;
    final isCorrect = selectedOption == correctAnswer;

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedOption;
      _answerResults[_currentQuestionIndex] = isCorrect;
    });

    // Provide haptic feedback
    if (isCorrect) {
      Gaimon.success();
    } else {
      Gaimon.error();
    }

    // Feedback will be shown, user will manually advance
  }

  /// Advances to the next question or completes the test
  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _pageController.animateToPage(
        _currentQuestionIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTest();
    }
  }

  /// Completes the test and shows results
  void _completeTest() {
    final correctCount = _answerResults.values.where((result) => result).length;
    final totalQuestions = _questions.length;
    final percentage = (correctCount / totalQuestions * 100).round();

    // Store the test result in the onboarding state
    context.read<OnboardingCubit>().setEnglishTestResult(percentage);

    _pageController.animateToPage(
      _questions.length + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Continues to the next onboarding page
  void _continueOnboarding() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while questions are being loaded
    if (_isLoadingQuestions) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading test questions...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Show error screen if questions failed to load
    if (_loadingError != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load test questions',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _loadingError!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadQuestions,
                child: const Text('Retry'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _continueOnboarding,
                child: const Text('Skip Test'),
              ),
            ],
          ),
        ),
      );
    }

    // Show normal test flow once questions are loaded
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Introduction screen
        EnglishTestIntro(
          onStartTest: _startTest,
          onSkip: _continueOnboarding,
        ),

        // Question screens - only show if questions are loaded
        if (_questions.isNotEmpty)
          ..._questions.asMap().entries.map(
                (entry) => EnglishTestQuestion(
                  question: _questions[entry.key].question,
                  options: _questions[entry.key].options,
                  correctAnswer: _questions[entry.key].correct,
                  selectedAnswer: _selectedAnswers[entry.key],
                  onSelectAnswer: _selectAnswer,
                  onNext: _nextQuestion,
                  currentQuestionIndex: entry.key,
                  totalQuestions: _questions.length,
                ),
              ),

        // Results screen
        EnglishTestResult(
          correctCount: _answerResults.values.where((result) => result).length,
          totalQuestions: _questions.length,
          onContinue: _continueOnboarding,
        ),
      ],
    );
  }
}
