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
mixin _$Word {
  String get id;
  String get word;
  String get definition;
  String? get example;
  VocabularyLevel? get level;
  @JsonKey(name: 'topic_id')
  String get topicId;
  bool? get isFavorite;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WordCopyWith<Word> get copyWith =>
      _$WordCopyWithImpl<Word>(this as Word, _$identity);

  /// Serializes this Word to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Word &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.example, example) || other.example == example) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, word, definition, example, level, topicId, isFavorite);

  @override
  String toString() {
    return 'Word(id: $id, word: $word, definition: $definition, example: $example, level: $level, topicId: $topicId, isFavorite: $isFavorite)';
  }
}

/// @nodoc
abstract mixin class $WordCopyWith<$Res> {
  factory $WordCopyWith(Word value, $Res Function(Word) _then) =
      _$WordCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String word,
      String definition,
      String? example,
      VocabularyLevel? level,
      @JsonKey(name: 'topic_id') String topicId,
      bool? isFavorite});
}

/// @nodoc
class _$WordCopyWithImpl<$Res> implements $WordCopyWith<$Res> {
  _$WordCopyWithImpl(this._self, this._then);

  final Word _self;
  final $Res Function(Word) _then;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? definition = null,
    Object? example = freezed,
    Object? level = freezed,
    Object? topicId = null,
    Object? isFavorite = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      definition: null == definition
          ? _self.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      example: freezed == example
          ? _self.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as VocabularyLevel?,
      topicId: null == topicId
          ? _self.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: freezed == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Word implements Word {
  const _Word(
      {required this.id,
      required this.word,
      required this.definition,
      this.example,
      this.level,
      @JsonKey(name: 'topic_id') required this.topicId,
      this.isFavorite});
  factory _Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  @override
  final String id;
  @override
  final String word;
  @override
  final String definition;
  @override
  final String? example;
  @override
  final VocabularyLevel? level;
  @override
  @JsonKey(name: 'topic_id')
  final String topicId;
  @override
  final bool? isFavorite;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WordCopyWith<_Word> get copyWith =>
      __$WordCopyWithImpl<_Word>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Word &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.example, example) || other.example == example) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, word, definition, example, level, topicId, isFavorite);

  @override
  String toString() {
    return 'Word(id: $id, word: $word, definition: $definition, example: $example, level: $level, topicId: $topicId, isFavorite: $isFavorite)';
  }
}

/// @nodoc
abstract mixin class _$WordCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$WordCopyWith(_Word value, $Res Function(_Word) _then) =
      __$WordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String definition,
      String? example,
      VocabularyLevel? level,
      @JsonKey(name: 'topic_id') String topicId,
      bool? isFavorite});
}

/// @nodoc
class __$WordCopyWithImpl<$Res> implements _$WordCopyWith<$Res> {
  __$WordCopyWithImpl(this._self, this._then);

  final _Word _self;
  final $Res Function(_Word) _then;

  /// Create a copy of Word
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? definition = null,
    Object? example = freezed,
    Object? level = freezed,
    Object? topicId = null,
    Object? isFavorite = freezed,
  }) {
    return _then(_Word(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      definition: null == definition
          ? _self.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      example: freezed == example
          ? _self.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as VocabularyLevel?,
      topicId: null == topicId
          ? _self.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: freezed == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
