import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/l10n/l10n.dart';
import 'package:wordstock/widgets/button.dart';
import 'package:wordstock/widgets/quiz_button.dart';

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

  // Sample quiz questions for onboarding assessment
  final List<Map<String, dynamic>> _questions = [
    // Intermediate Level Questions
    {
      'question': "The professor's ___ lecture kept students engaged "
          'throughout the entire class.',
      'options': ['eloquent', 'mundane', 'chaotic'],
      'correct': 'eloquent',
    },
    {
      'question': "After years of practice, the musician's performance "
          'was absolutely ___.',
      'options': ['mediocre', 'flawless', 'adequate'],
      'correct': 'flawless',
    },
    {
      'question': 'The ancient ruins were ___ by centuries of weathering '
          'and neglect.',
      'options': ['preserved', 'deteriorated', 'enhanced'],
      'correct': 'deteriorated',
    },

    // Upper-Intermediate Level Questions
    {
      'question': 'Her ___ approach to problem-solving impressed the '
          'entire team.',
      'options': ['haphazard', 'methodical', 'reluctant'],
      'correct': 'methodical',
    },
    {
      'question': "The CEO's decision to expand globally was quite ___.",
      'options': ['cautious', 'audacious', 'typical'],
      'correct': 'audacious',
    },
    {
      'question': 'The scientist made a ___ discovery that changed our '
          'understanding of physics.',
      'options': ['mundane', 'groundbreaking', 'questionable'],
      'correct': 'groundbreaking',
    },

    // Advanced Level Questions
    {
      'question': 'The politician was known for his ___ speeches that '
          'could sway even the most skeptical audiences.',
      'options': ['verbose', 'persuasive', 'tedious'],
      'correct': 'persuasive',
    },
    {
      'question': "The artist's work was praised for its ___ blend of "
          'traditional and modern techniques.',
      'options': ['jarring', 'seamless', 'obvious'],
      'correct': 'seamless',
    },
    {
      'question': "The committee's decision was met with ___ criticism "
          'from environmental groups.',
      'options': ['mild', 'vehement', 'occasional'],
      'correct': 'vehement',
    },

    // Expert Level Questions
    {
      'question': "The philosopher's ___ arguments left his opponents "
          'unable to respond effectively.',
      'options': ['fallacious', 'cogent', 'superficial'],
      'correct': 'cogent',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController.forward();
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

    // Auto-advance after a brief delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
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
    context.read<OnboardingCubit>().nextPage();
  }

  /// Builds the introduction screen
  Widget _buildIntroScreen() {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Test icon with animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1CB0F6).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.quiz_outlined,
              size: 60,
              color: const Color(0xFF1CB0F6),
              semanticLabel: l10n.onboardingEnglishTestIcon,
            ),
          ).animate(controller: _animationController).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: const Duration(milliseconds: 600),
              ),

          const SizedBox(height: 40),

          // Title
          Semantics(
            label: l10n.onboardingEnglishTestTitle,
            child: Text(
              l10n.onboardingEnglishTestTitle,
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

          // Subtitle
          Semantics(
            label: l10n.onboardingEnglishTestSubtitle,
            child: Text(
              l10n.onboardingEnglishTestSubtitle,
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

          // Start test button
          Semantics(
            label: l10n.onboardingEnglishTestStart,
            child: PushableButton(
              width: 280,
              height: 60,
              borderRadius: 25,
              text: l10n.onboardingEnglishTestStart,
              buttonColor: const Color(0xFF1CB0F6),
              shadowColor: const Color(0xFF1899D6),
              onTap: _startTest,
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

          // Skip option
          const SizedBox(height: 16),

          Semantics(
            label: l10n.onboardingEnglishTestSkip,
            child: GestureDetector(
              onTap: _continueOnboarding,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  l10n.onboardingEnglishTestSkip,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ).animate(controller: _animationController).fadeIn(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
              ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Builds a question screen
  Widget _buildQuestionScreen(int questionIndex) {
    final question = _questions[questionIndex];
    final questionText = question['question'] as String;
    final options = question['options'] as List<String>;
    final correctAnswer = question['correct'] as String;
    final selectedAnswer = _selectedAnswers[questionIndex];
    final isAnswered = selectedAnswer != null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Progress indicator
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (questionIndex + 1) / _questions.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF1CB0F6)),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${questionIndex + 1}/${_questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1CB0F6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Question text
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Answer options
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: options.map((option) {
                final isSelected = selectedAnswer == option;
                final isCorrect = option == correctAnswer;

                var buttonColor = const Color(0xffF1F1F1);
                var backgroundColor = const Color(0xffF1F1F1);
                var shadowColor = Colors.grey.shade300;
                const textColor = Colors.black87;

                if (isAnswered) {
                  if (isCorrect) {
                    // Correct answer - always green
                    buttonColor = const Color(0xff58CC02);
                    shadowColor = const Color(0xff58A700);
                    backgroundColor = const Color(0xffBCFFC8);
                  } else if (isSelected) {
                    // Selected wrong answer - red
                    buttonColor = const Color(0xffFF4B4B);
                    shadowColor = const Color(0xffE94E77);
                    backgroundColor = const Color(0xffFFCCDA);
                  }
                } else if (isSelected) {
                  // Selected but not yet submitted
                  buttonColor = const Color(0xFF1CB0F6);
                  shadowColor = const Color(0xFF1899D6);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: QuizButton(
                    width: double.infinity,
                    height: 56,
                    buttonColor: buttonColor,
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    textColor: textColor,
                    text: option,
                    onTap: isAnswered ? () {} : () => _selectAnswer(option),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Builds the results screen
  Widget _buildResultsScreen() {
    final l10n = context.l10n;
    final correctCount = _answerResults.values.where((result) => result).length;
    final totalQuestions = _questions.length;
    final percentage = (correctCount / totalQuestions * 100).round();

    String resultMessage;
    Color resultColor;
    IconData resultIcon;

    if (percentage >= 80) {
      resultMessage = l10n.onboardingEnglishTestExcellent;
      resultColor = const Color(0xff58CC02);
      resultIcon = Icons.star;
    } else if (percentage >= 60) {
      resultMessage = l10n.onboardingEnglishTestGood;
      resultColor = const Color(0xFF1CB0F6);
      resultIcon = Icons.thumb_up;
    } else {
      resultMessage = l10n.onboardingEnglishTestOkay;
      resultColor = const Color(0xffFFC800);
      resultIcon = Icons.lightbulb;
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Result icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: resultColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              resultIcon,
              size: 60,
              color: resultColor,
            ),
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                curve: Curves.elasticOut,
                duration: const Duration(milliseconds: 600),
              ),

          const SizedBox(height: 30),

          // Result message
          Text(
            resultMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
          ),

          const SizedBox(height: 20),

          // Score display
          Text(
            l10n.onboardingEnglishTestScore(correctCount, totalQuestions),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

          // Percentage display
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
          ),

          const Spacer(flex: 3),

          // Continue button
          PushableButton(
            width: 280,
            height: 60,
            borderRadius: 25,
            text: l10n.continueText,
            buttonColor: resultColor,
            shadowColor: resultColor.withValues(alpha: 0.7),
            onTap: _continueOnboarding,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Introduction screen
        _buildIntroScreen(),

        // Question screens
        ..._questions.asMap().entries.map(
              (entry) => _buildQuestionScreen(entry.key),
            ),

        // Results screen
        _buildResultsScreen(),
      ],
    );
  }
}
