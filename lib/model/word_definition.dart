import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_definition.freezed.dart';
part 'word_definition.g.dart';

/// {@template word_definition}
/// A single word definition entry containing the word and its definition.
///
/// This model represents individual vocabulary word definitions loaded
/// from JSON asset files, used primarily for English test feedback
/// and vocabulary learning features.
/// {@endtemplate}
@freezed
sealed class WordDefinition with _$WordDefinition {
  /// {@macro word_definition}
  const factory WordDefinition({
    /// The vocabulary word
    required String word,

    /// The definition or meaning of the word
    required String definition,
  }) = _WordDefinition;

  /// Creates a [WordDefinition] from a JSON map
  factory WordDefinition.fromJson(Map<String, dynamic> json) =>
      _$WordDefinitionFromJson(json);
}

/// {@template word_definition_set}
/// A collection of word definitions for a specific vocabulary level.
///
/// This model represents a complete set of word definitions loaded
/// from a JSON asset file, organized by vocabulary level
/// (beginner, intermediate, advanced).
/// {@endtemplate}
@freezed
sealed class WordDefinitionSet with _$WordDefinitionSet {
  /// {@macro word_definition_set}
  const factory WordDefinitionSet({
    /// The vocabulary level (beginner, intermediate, advanced)
    required String level,

    /// List of word definitions for this level
    required List<WordDefinition> definitions,
  }) = _WordDefinitionSet;

  /// Creates a [WordDefinitionSet] from a JSON map
  factory WordDefinitionSet.fromJson(Map<String, dynamic> json) =>
      _$WordDefinitionSetFromJson(json);
}
