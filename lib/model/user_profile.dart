import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(
      name: 'vocabulary_level',
      fromJson: _vocabularyLevelFromJson,
      toJson: _vocabularyLevelToJson,
    )
    required VocabularyLevel level,
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

/// Vocabulary level enum with integer-based database storage
enum VocabularyLevel {
  beginner, // 0 in database
  intermediate, // 1 in database
  advanced // 2 in database
}

/// Convert integer from database to VocabularyLevel enum
/// Provides safe fallback to beginner for invalid values
VocabularyLevel _vocabularyLevelFromJson(dynamic value) {
  if (value is int) {
    // Handle integer values from new database schema
    switch (value) {
      case 0:
        return VocabularyLevel.beginner;
      case 1:
        return VocabularyLevel.intermediate;
      case 2:
        return VocabularyLevel.advanced;
      default:
        // Invalid integer, fallback to beginner
        return VocabularyLevel.beginner;
    }
  } else if (value is String) {
    // Handle legacy string values during migration period
    switch (value.toLowerCase()) {
      case 'beginner':
        return VocabularyLevel.beginner;
      case 'intermediate':
        return VocabularyLevel.intermediate;
      case 'advanced':
        return VocabularyLevel.advanced;
      default:
        // Invalid string, fallback to beginner
        return VocabularyLevel.beginner;
    }
  }

  // Invalid type, fallback to beginner
  return VocabularyLevel.beginner;
}

/// Convert VocabularyLevel enum to integer for database storage
int _vocabularyLevelToJson(VocabularyLevel level) {
  switch (level) {
    case VocabularyLevel.beginner:
      return 0;
    case VocabularyLevel.intermediate:
      return 1;
    case VocabularyLevel.advanced:
      return 2;
  }
}
