import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:go_router/go_router.dart';
import 'package:wordstock/core/constants/vocabulary_levels.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_intro.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_question.dart';
import 'package:wordstock/features/onboarding/widgets/onboarding_pages/english_test_result.dart';

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

  // We will lazily set this based on the user's chosen vocabulary level.
  // Keeping the same data shape to avoid changing any downstream UI logic.
  late List<Map<String, dynamic>> _questions;

  // Beginner level question bank — short, concrete, high-frequency words.
  // Keeping 10 items to maintain parity with other levels and pagination.
  final List<Map<String, dynamic>> _beginnerQuestions = [
    {
      'question': 'I am ___ today.',
      'options': ['sad', 'happy', 'late'],
      'correct': 'happy',
    },
    {
      'question': 'This bag is very ___.',
      'options': ['heavy', 'light', 'empty'],
      'correct': 'heavy',
    },
    {
      'question': 'Please ___ the door.',
      'options': ['open', 'eat', 'run'],
      'correct': 'open',
    },
    {
      'question': 'The opposite of small is ___.',
      'options': ['short', 'big', 'thin'],
      'correct': 'big',
    },
    {
      'question': 'We ___ dinner at 7 pm.',
      'options': ['sleep', 'cook', 'read'],
      'correct': 'cook',
    },
    {
      'question': 'This coffee is too ___.',
      'options': ['hot', 'late', 'short'],
      'correct': 'hot',
    },
    {
      'question': 'I ___ English every day.',
      'options': ['study', 'drive', 'wash'],
      'correct': 'study',
    },
    {
      'question': 'She has a ___ cat.',
      'options': ['blue', 'small', 'slow'],
      'correct': 'small',
    },
    {
      'question': 'They ___ in a big city.',
      'options': ['live', 'eat', 'learn'],
      'correct': 'live',
    },
    {
      'question': 'He is very ___ in class.',
      'options': ['quiet', 'fast', 'late'],
      'correct': 'quiet',
    },
  ];

  // Intermediate level question bank — similar difficulty to the previous
  // implementation, mixing synonyms and collocations.
  final List<Map<String, dynamic>> _intermediateQuestions = [
    {
      'question':
          "The professor's ___ lecture kept students engaged throughout the entire class.",
      'options': ['eloquent', 'mundane', 'chaotic'],
      'correct': 'eloquent',
    },
    {
      'question':
          "After years of practice, the musician's performance was absolutely ___.",
      'options': ['mediocre', 'flawless', 'adequate'],
      'correct': 'flawless',
    },
    {
      'question':
          'The ancient ruins were ___ by centuries of weathering and neglect.',
      'options': ['preserved', 'deteriorated', 'enhanced'],
      'correct': 'deteriorated',
    },
    {
      'question':
          'Her ___ approach to problem-solving impressed the entire team.',
      'options': ['haphazard', 'methodical', 'reluctant'],
      'correct': 'methodical',
    },
    {
      'question': "The CEO's decision to expand globally was quite ___.",
      'options': ['cautious', 'audacious', 'typical'],
      'correct': 'audacious',
    },
    {
      'question':
          'The scientist made a ___ discovery that changed our understanding of physics.',
      'options': ['mundane', 'groundbreaking', 'questionable'],
      'correct': 'groundbreaking',
    },
    {
      'question':
          'The politician was known for his ___ speeches that could sway even skeptical audiences.',
      'options': ['verbose', 'persuasive', 'tedious'],
      'correct': 'persuasive',
    },
    {
      'question':
          "The artist's work was praised for its ___ blend of traditional and modern techniques.",
      'options': ['jarring', 'seamless', 'obvious'],
      'correct': 'seamless',
    },
    {
      'question':
          "The committee's decision was met with ___ criticism from environmental groups.",
      'options': ['mild', 'vehement', 'occasional'],
      'correct': 'vehement',
    },
    {
      'question':
          "The philosopher's ___ arguments left his opponents unable to respond effectively.",
      'options': ['fallacious', 'cogent', 'superficial'],
      'correct': 'cogent',
    },
  ];

  // Advanced level question bank — higher-register vocabulary and nuance.
  final List<Map<String, dynamic>> _advancedQuestions = [
    {
      'question':
          'Her explanation was so ___ that even experts struggled to follow.',
      'options': ['lucid', 'opaque', 'banal'],
      'correct': 'opaque',
    },
    {
      'question':
          'The researcher offered a ___ critique of the prevailing theory.',
      'options': ['trenchant', 'diffuse', 'facile'],
      'correct': 'trenchant',
    },
    {
      'question':
          'The novel is celebrated for its ___ portrayal of human frailty.',
      'options': ['cursory', 'nuanced', 'didactic'],
      'correct': 'nuanced',
    },
    {
      'question':
          'Their argument relies on a ___ assumption that is never justified.',
      'options': ['tenable', 'gratuitous', 'axiomatic'],
      'correct': 'gratuitous',
    },
    {
      'question': 'The solution is elegant but ultimately ___.',
      'options': ['pragmatic', 'quixotic', 'pedestrian'],
      'correct': 'quixotic',
    },
    {
      'question': 'His tone was ___, masking a deeper frustration.',
      'options': ['ironic', 'sanguine', 'phlegmatic'],
      'correct': 'ironic',
    },
    {
      'question': 'The committee issued a ___ rebuke after the breach.',
      'options': ['perfunctory', 'withering', 'timorous'],
      'correct': 'withering',
    },
    {
      'question': 'Her remarks were dismissed as ___ rather than constructive.',
      'options': ['vituperative', 'pellucid', 'salutary'],
      'correct': 'vituperative',
    },
    {
      'question': 'A ___ analysis is needed to resolve the discrepancy.',
      'options': ['prosaic', 'granular', 'jejune'],
      'correct': 'granular',
    },
    {
      'question': 'The proposal remains ___ without empirical support.',
      'options': ['specious', 'probative', 'fecund'],
      'correct': 'specious',
    },
  ];

  /// Select 5 random questions according to user's chosen vocabulary level.
  /// Falls back to intermediate if the level is not set/invalid.
  List<Map<String, dynamic>> _questionsForLevel(int levelId) {
    List<Map<String, dynamic>> fullQuestionBank;

    if (VocabularyLevels.isValidId(levelId)) {
      switch (levelId) {
        case 0: // Beginner
          fullQuestionBank = _beginnerQuestions;
        case 1: // Intermediate
          fullQuestionBank = _intermediateQuestions;
        case 2: // Advanced
          fullQuestionBank = _advancedQuestions;
        default:
          fullQuestionBank = _intermediateQuestions;
      }
    } else {
      // Default to intermediate for invalid levels
      fullQuestionBank = _intermediateQuestions;
    }

    // Randomly select 5 questions from the bank
    final random = math.Random();
    final shuffledQuestions = List<Map<String, dynamic>>.from(fullQuestionBank);
    shuffledQuestions.shuffle(random);

    // Return first 5 questions (or all if less than 5 available)
    return shuffledQuestions.take(5).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController.forward();

    // Determine vocabulary level chosen earlier in onboarding and
    // hydrate the appropriate question set. Keep state consistent.
    final levelId = context.read<OnboardingCubit>().state.vocabularyLevel;
    _questions = _questionsForLevel(levelId);
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _answerResults.clear();
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

    final correctAnswer =
        _questions[_currentQuestionIndex]['correct'] as String;
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
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Introduction screen
        EnglishTestIntro(
          onStartTest: _startTest,
          onSkip: _continueOnboarding,
        ),

        // Question screens
        ..._questions.asMap().entries.map(
              (entry) => EnglishTestQuestion(
                question: _questions[entry.key]['question'] as String,
                options: (_questions[entry.key]['options'] as List<dynamic>)
                    .cast<String>(),
                correctAnswer: _questions[entry.key]['correct'] as String,
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
