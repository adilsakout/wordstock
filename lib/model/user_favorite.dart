import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_favorite.freezed.dart';
part 'user_favorite.g.dart';

@freezed
sealed class UserFavorite with _$UserFavorite {
  const factory UserFavorite({
    required String userId,
    required int wordId,
    required DateTime createdAt,
  }) = _UserFavorite;

  factory UserFavorite.fromJson(Map<String, dynamic> json) =>
      _$UserFavoriteFromJson(json);
}
