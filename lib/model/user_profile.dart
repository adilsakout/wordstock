import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'vocabulary_level') required VocabularyLevel level,
    @JsonKey(name: 'daily_streak') required int dailyStreak,
    @JsonKey(name: 'last_active_date') required DateTime lastActiveDate,
    @JsonKey(name: 'longest_streak') required int longestStreak,
    @JsonKey(name: 'streak_goal') int? streakGoal,
    @JsonKey(name: 'total_points') int? totalPoints,
    @JsonKey(name: 'onesignal_id') String? onesignalId,
    @JsonKey(name: 'time_zone') String? timeZone,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

enum VocabularyLevel { beginner, intermediate, advanced }
