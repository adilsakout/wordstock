import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';

@freezed
class WordModel with _$WordModel {
  // The constructor uses named parameters with `required` for each field.
  const factory WordModel({
    required String word,
    required String phonetics,
    required String partOfSpeech,
    required String definition,
    required String example,
  }) = _WordModel;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
