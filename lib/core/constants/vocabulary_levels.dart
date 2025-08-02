/// Centralized vocabulary level configuration
///
/// This file contains all vocabulary level definitions, display strings,
/// and utility methods. It separates data from presentation for better
/// maintainability and internationalization support.
library vocabulary_levels;

import 'package:wordstock/model/user_profile.dart';

/// Vocabulary level configuration with display strings and metadata
class VocabularyLevelConfig {
  const VocabularyLevelConfig({
    required this.id,
    required this.level,
    required this.displayName,
    required this.emoji,
    required this.description,
  });

  /// Unique integer ID for database storage (0-based)
  final int id;

  /// Enum value for type safety
  final VocabularyLevel level;

  /// Display name without emoji (for UI)
  final String displayName;

  /// Emoji icon (separate for easy replacement)
  final String emoji;

  /// Description text
  final String description;

  /// Full display text with emoji
  String get fullDisplayText => '$emoji $displayName';
}

/// Centralized vocabulary level definitions
class VocabularyLevels {
  VocabularyLevels._(); // Private constructor - static class

  /// All vocabulary levels configuration
  static const List<VocabularyLevelConfig> all = [
    VocabularyLevelConfig(
      id: 0,
      level: VocabularyLevel.beginner,
      displayName: 'Beginner',
      emoji: '🐣',
      description: 'Just starting your vocabulary journey',
    ),
    VocabularyLevelConfig(
      id: 1,
      level: VocabularyLevel.intermediate,
      displayName: 'Intermediate',
      emoji: '🚶',
      description: 'Building confidence with new words',
    ),
    VocabularyLevelConfig(
      id: 2,
      level: VocabularyLevel.advanced,
      displayName: 'Advanced',
      emoji: '🧗',
      description: 'Mastering complex vocabulary',
    ),
  ];

  /// Get configuration by ID (database value)
  static VocabularyLevelConfig? getById(int id) {
    try {
      return all.firstWhere((config) => config.id == id);
    } catch (e) {
      return null; // Return null for invalid IDs
    }
  }

  /// Get configuration by enum value
  static VocabularyLevelConfig getByLevel(VocabularyLevel level) {
    return all.firstWhere((config) => config.level == level);
  }

  /// Get configuration by display name (case-insensitive)
  static VocabularyLevelConfig? getByDisplayName(String displayName) {
    try {
      return all.firstWhere(
        (config) =>
            config.displayName.toLowerCase() == displayName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Convert enum to database ID (safe conversion)
  static int levelToId(VocabularyLevel level) {
    return getByLevel(level).id;
  }

  /// Convert database ID to enum (safe conversion with fallback)
  static VocabularyLevel idToLevel(int id) {
    final config = getById(id);
    return config?.level ?? VocabularyLevel.beginner; // Default fallback
  }

  /// Validate if ID is valid
  static bool isValidId(int id) {
    return id >= 0 && id < all.length;
  }

  /// Get all display texts for UI dropdowns/selectors
  static List<String> get displayTexts {
    return all.map((config) => config.fullDisplayText).toList();
  }

  /// Get all display names (without emoji)
  static List<String> get displayNames {
    return all.map((config) => config.displayName).toList();
  }
}
