import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordstock/model/user_profile.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
sealed class Word with _$Word {
  const factory Word({
    required int id,
    required String word,
    required String definition,
    String? example,
    VocabularyLevel? level,
    int? topicId,
  }) = _Word;

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);
}

VocabularyLevel vocabularyLevelFromString(String level) {
  return VocabularyLevel.values.firstWhere(
    (e) => e.name == level.toLowerCase(),
    orElse: () => VocabularyLevel.beginner,
  );
}
