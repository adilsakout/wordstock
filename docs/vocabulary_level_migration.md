# Vocabulary Level System - Database Migration Guide

## Overview

This document outlines the migration from string-based vocabulary level storage to a robust integer-based system. This change improves data integrity, performance, and prevents UTF-16 encoding issues.

## 🔄 **What Changed**

### Before (Issues)
- ❌ Stored as strings (`"beginner"`, `"intermediate"`, `"advanced"`)
- ❌ No database constraints
- ❌ Prone to encoding issues with display emojis
- ❌ Tight coupling between display and storage

### After (Best Practices)
- ✅ Stored as integers (`0`, `1`, `2`) with database constraints
- ✅ Centralized configuration system
- ✅ Separation of data and presentation layers
- ✅ Proper validation and error handling
- ✅ UTF-16 safe simple emojis

## 🗄️ **Database Migration**

### Running the Migration

```bash
# Connect to your Supabase project
supabase db reset

# Or apply the specific migration
supabase db push
```

### Migration Details

The migration file `supabase/migrations/20241220000001_update_vocabulary_level_to_int.sql` performs:

1. **Creates temporary integer column**
2. **Migrates existing string data** with proper mapping
3. **Adds database constraints** (0-2 range)
4. **Removes old string column**
5. **Adds performance index**
6. **Includes validation checks**

### Database Schema After Migration

```sql
-- vocabulary_level column specification
vocabulary_level INTEGER NOT NULL DEFAULT 0 
CHECK (vocabulary_level >= 0 AND vocabulary_level <= 2)

-- Index for performance
CREATE INDEX idx_user_profiles_vocabulary_level 
ON user_profiles (vocabulary_level);
```

## 📱 **Application Changes**

### 1. Centralized Configuration

New file: `lib/core/constants/vocabulary_levels.dart`

```dart
// All vocabulary level logic centralized
VocabularyLevels.all          // All configurations
VocabularyLevels.getById(0)   // Get by database ID
VocabularyLevels.getByLevel() // Get by enum
```

### 2. Updated Model

`lib/model/user_profile.dart` now includes:
- Custom JSON serialization (`_vocabularyLevelFromJson`)
- Custom JSON deserialization (`_vocabularyLevelToJson`)
- Backward compatibility for migration period
- Safe fallbacks for invalid data

### 3. Repository Layer

`lib/repositories/user_repository.dart` improvements:
- Integer-based database operations
- Input validation before database calls
- Better error logging and handling
- Consistent enum ↔ integer conversion

### 4. UI Components

Both onboarding and profile pages now use:
- Centralized vocabulary level configuration
- Decoupled display strings from data storage
- UTF-16 safe emojis (`🐣`, `🚶`, `🧗`)

## 🔧 **Developer Usage**

### Adding New Vocabulary Levels

1. **Update the enum** in `user_profile.dart`:
```dart
enum VocabularyLevel { 
  beginner, intermediate, advanced, expert  // Add new level
}
```

2. **Update centralized config** in `vocabulary_levels.dart`:
```dart
static const List<VocabularyLevelConfig> all = [
  // ... existing levels
  VocabularyLevelConfig(
    id: 3,
    level: VocabularyLevel.expert,
    displayName: 'Expert',
    emoji: '🎓',
    description: 'Advanced vocabulary mastery',
  ),
];
```

3. **Update database constraints**:
```sql
ALTER TABLE user_profiles 
DROP CONSTRAINT vocabulary_level_valid_range;

ALTER TABLE user_profiles 
ADD CONSTRAINT vocabulary_level_valid_range 
CHECK (vocabulary_level >= 0 AND vocabulary_level <= 3);
```

### Usage Examples

```dart
// Get display text for UI
final displayText = VocabularyLevels.getByLevel(userLevel).fullDisplayText;

// Convert for database storage
final dbValue = VocabularyLevels.levelToId(userLevel);

// Convert from database
final level = VocabularyLevels.idToLevel(dbValue);

// Validation
if (VocabularyLevels.isValidId(levelId)) {
  // Safe to use
}
```

## 🚀 **Benefits**

1. **Data Integrity**: Database constraints prevent invalid values
2. **Performance**: Integer operations are faster than string comparisons
3. **Encoding Safety**: No UTF-16 issues with simple storage
4. **Maintainability**: Centralized configuration for all vocabulary level logic
5. **Internationalization**: Easy to add localized display strings
6. **Type Safety**: Compile-time checks with proper enum usage

## ⚠️ **Migration Checklist**

- [ ] Run database migration
- [ ] Verify existing data migrated correctly
- [ ] Test vocabulary level updates in profile
- [ ] Test vocabulary level selection in onboarding
- [ ] Verify UTF-16 errors are resolved
- [ ] Update any external integrations that reference vocabulary levels

## 🐛 **Troubleshooting**

### Common Issues

1. **Migration fails**: Check for NULL vocabulary_level values in existing data
2. **Display issues**: Verify centralized config is properly imported
3. **JSON errors**: Ensure code generation was run after model changes

### Rollback Plan

If issues arise, the migration can be rolled back by:
1. Reverting to string storage
2. Converting integers back to strings
3. Removing database constraints

## 🔗 **Related Files**

- `lib/core/constants/vocabulary_levels.dart` - Centralized configuration
- `lib/model/user_profile.dart` - Updated model with custom serialization
- `lib/repositories/user_repository.dart` - Repository layer updates
- `supabase/migrations/20241220000001_update_vocabulary_level_to_int.sql` - Database migration
- `lib/features/profile/widgets/profile_body.dart` - Profile UI updates
- `lib/features/onboarding/widgets/onboarding_pages/vocabulary_level_page.dart` - Onboarding UI updates