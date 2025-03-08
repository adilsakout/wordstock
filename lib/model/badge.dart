import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

@freezed
sealed class Badge with _$Badge {
  const factory Badge({
    required int id,
    required String name,
    required String description,
    required String iconUrl,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}
