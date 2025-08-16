import 'package:equatable/equatable.dart';

/// {@template english_test_question}
/// A single English test question with multiple choice options.
///
/// Contains:
/// - The question text with a blank to fill
/// - List of possible answer options
/// - The correct answer from the options
/// {@endtemplate}
class EnglishTestQuestion extends Equatable {
  /// {@macro english_test_question}
  const EnglishTestQuestion({
    required this.question,
    required this.options,
    required this.correct,
  });

  /// Creates an EnglishTestQuestion from a JSON map
  factory EnglishTestQuestion.fromJson(Map<String, dynamic> json) {
    return EnglishTestQuestion(
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correct: json['correct'] as String,
    );
  }

  /// The question text, typically with a blank to fill in
  final String question;

  /// List of possible answer options for this question
  final List<String> options;

  /// The correct answer (must be one of the options)
  final String correct;

  /// Converts this EnglishTestQuestion to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correct': correct,
    };
  }

  @override
  List<Object?> get props => [question, options, correct];
}

/// {@template english_test_question_set}
/// A complete set of English test questions for a specific difficulty level.
///
/// Contains:
/// - The difficulty level name (beginner, intermediate, advanced)
/// - List of all questions for this level
/// {@endtemplate}
class EnglishTestQuestionSet extends Equatable {
  /// {@macro english_test_question_set}
  const EnglishTestQuestionSet({
    required this.level,
    required this.questions,
  });

  /// Creates an EnglishTestQuestionSet from a JSON map
  factory EnglishTestQuestionSet.fromJson(Map<String, dynamic> json) {
    final questionsList = json['questions'] as List<dynamic>;
    return EnglishTestQuestionSet(
      level: json['level'] as String,
      questions: questionsList
          .map((q) => EnglishTestQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  /// The difficulty level name
  final String level;

  /// All questions available for this difficulty level
  final List<EnglishTestQuestion> questions;

  /// Converts this EnglishTestQuestionSet to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [level, questions];
}
