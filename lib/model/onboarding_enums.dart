/// Represents the age range categories available during onboarding
enum AgeRange {
  /// 13 to 17 years old
  teen,

  /// 18 to 24 years old
  youngAdult,

  /// 25 to 34 years old
  adult,

  /// 35 to 44 years old
  midAdult,

  /// 45 and above
  senior,
}

/// Represents the gender options available during onboarding
enum Gender {
  /// Male gender option
  male,

  /// Female gender option
  female,

  /// Other gender option
  other,

  /// Prefer not to say option
  preferNotToSay,
}

/// Represents the time commitment options available during onboarding
enum TimeCommitment {
  /// 5 minutes per day
  fiveMinutes,

  /// 10 minutes per day
  tenMinutes,

  /// 15 minutes per day
  fifteenMinutes,

  /// 30 minutes per day
  thirtyMinutes,
}
