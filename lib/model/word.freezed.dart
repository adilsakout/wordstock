// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WordModel {
  String get word;
  String get phonetics;
  String get partOfSpeech;
  String get definition;
  String get example;

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WordModelCopyWith<WordModel> get copyWith =>
      _$WordModelCopyWithImpl<WordModel>(this as WordModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WordModel &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.phonetics, phonetics) ||
                other.phonetics == phonetics) &&
            (identical(other.partOfSpeech, partOfSpeech) ||
                other.partOfSpeech == partOfSpeech) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.example, example) || other.example == example));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, word, phonetics, partOfSpeech, definition, example);

  @override
  String toString() {
    return 'WordModel(word: $word, phonetics: $phonetics, partOfSpeech: $partOfSpeech, definition: $definition, example: $example)';
  }
}

/// @nodoc
abstract mixin class $WordModelCopyWith<$Res> {
  factory $WordModelCopyWith(WordModel value, $Res Function(WordModel) _then) =
      _$WordModelCopyWithImpl;
  @useResult
  $Res call(
      {String word,
      String phonetics,
      String partOfSpeech,
      String definition,
      String example});
}

/// @nodoc
class _$WordModelCopyWithImpl<$Res> implements $WordModelCopyWith<$Res> {
  _$WordModelCopyWithImpl(this._self, this._then);

  final WordModel _self;
  final $Res Function(WordModel) _then;

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? word = null,
    Object? phonetics = null,
    Object? partOfSpeech = null,
    Object? definition = null,
    Object? example = null,
  }) {
    return _then(_self.copyWith(
      word: null == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      phonetics: null == phonetics
          ? _self.phonetics
          : phonetics // ignore: cast_nullable_to_non_nullable
              as String,
      partOfSpeech: null == partOfSpeech
          ? _self.partOfSpeech
          : partOfSpeech // ignore: cast_nullable_to_non_nullable
              as String,
      definition: null == definition
          ? _self.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      example: null == example
          ? _self.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _WordModel implements WordModel {
  const _WordModel(
      {required this.word,
      required this.phonetics,
      required this.partOfSpeech,
      required this.definition,
      required this.example});

  @override
  final String word;
  @override
  final String phonetics;
  @override
  final String partOfSpeech;
  @override
  final String definition;
  @override
  final String example;

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WordModelCopyWith<_WordModel> get copyWith =>
      __$WordModelCopyWithImpl<_WordModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WordModel &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.phonetics, phonetics) ||
                other.phonetics == phonetics) &&
            (identical(other.partOfSpeech, partOfSpeech) ||
                other.partOfSpeech == partOfSpeech) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.example, example) || other.example == example));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, word, phonetics, partOfSpeech, definition, example);

  @override
  String toString() {
    return 'WordModel(word: $word, phonetics: $phonetics, partOfSpeech: $partOfSpeech, definition: $definition, example: $example)';
  }
}

/// @nodoc
abstract mixin class _$WordModelCopyWith<$Res>
    implements $WordModelCopyWith<$Res> {
  factory _$WordModelCopyWith(
          _WordModel value, $Res Function(_WordModel) _then) =
      __$WordModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String word,
      String phonetics,
      String partOfSpeech,
      String definition,
      String example});
}

/// @nodoc
class __$WordModelCopyWithImpl<$Res> implements _$WordModelCopyWith<$Res> {
  __$WordModelCopyWithImpl(this._self, this._then);

  final _WordModel _self;
  final $Res Function(_WordModel) _then;

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? word = null,
    Object? phonetics = null,
    Object? partOfSpeech = null,
    Object? definition = null,
    Object? example = null,
  }) {
    return _then(_WordModel(
      word: null == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      phonetics: null == phonetics
          ? _self.phonetics
          : phonetics // ignore: cast_nullable_to_non_nullable
              as String,
      partOfSpeech: null == partOfSpeech
          ? _self.partOfSpeech
          : partOfSpeech // ignore: cast_nullable_to_non_nullable
              as String,
      definition: null == definition
          ? _self.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      example: null == example
          ? _self.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
