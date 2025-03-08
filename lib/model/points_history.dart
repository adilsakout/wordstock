import 'package:freezed_annotation/freezed_annotation.dart';

part 'points_history.freezed.dart';
part 'points_history.g.dart';

@freezed
sealed class UserPoints with _$UserPoints {
  const factory UserPoints({
    required int id,
    required String userId,
    required int points,
    required PointSource source,
    required DateTime createdAt,
  }) = _UserPoints;

  factory UserPoints.fromJson(Map<String, dynamic> json) =>
      _$UserPointsFromJson(json);
}

enum PointSource { dailyLogin, learnedWord, purchase, other }
