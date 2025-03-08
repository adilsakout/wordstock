import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    required VocabularyLevel level,
    required int dailyStreak,
    required DateTime lastActiveDate,
    required int totalPoints,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

enum VocabularyLevel { beginner, intermediate, advanced }
