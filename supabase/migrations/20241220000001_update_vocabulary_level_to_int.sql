-- Migration: Update vocabulary_level column to use integers instead of strings
-- This provides better data integrity, performance, and prevents encoding issues

-- Step 1: Add a new temporary column for integer vocabulary levels
ALTER TABLE user_profiles 
ADD COLUMN vocabulary_level_int INTEGER;

-- Step 2: Migrate existing string data to integers with proper mapping
UPDATE user_profiles 
SET vocabulary_level_int = CASE 
    WHEN vocabulary_level = 'beginner' THEN 0
    WHEN vocabulary_level = 'intermediate' THEN 1
    WHEN vocabulary_level = 'advanced' THEN 2
    ELSE 0  -- Default to beginner for any invalid/null values
END;

-- Step 3: Add constraint to ensure only valid values (0, 1, 2)
ALTER TABLE user_profiles 
ADD CONSTRAINT vocabulary_level_valid_range 
CHECK (vocabulary_level_int >= 0 AND vocabulary_level_int <= 2);

-- Step 4: Make the new column NOT NULL with default value
ALTER TABLE user_profiles 
ALTER COLUMN vocabulary_level_int SET NOT NULL,
ALTER COLUMN vocabulary_level_int SET DEFAULT 0;

-- Step 5: Drop the old string column
ALTER TABLE user_profiles 
DROP COLUMN vocabulary_level;

-- Step 6: Rename the new column to the original name
ALTER TABLE user_profiles 
RENAME COLUMN vocabulary_level_int TO vocabulary_level;

-- Step 7: Add index for better query performance
CREATE INDEX idx_user_profiles_vocabulary_level 
ON user_profiles (vocabulary_level);

-- Step 8: Add helpful comment for documentation
COMMENT ON COLUMN user_profiles.vocabulary_level IS 
'Vocabulary level: 0=Beginner, 1=Intermediate, 2=Advanced. Must be in range 0-2.';

-- Verify the migration worked correctly
DO $$
BEGIN
    -- Check that all values are in valid range
    IF EXISTS (
        SELECT 1 FROM user_profiles 
        WHERE vocabulary_level < 0 OR vocabulary_level > 2
    ) THEN
        RAISE EXCEPTION 'Migration failed: Invalid vocabulary_level values found';
    END IF;
    
    RAISE NOTICE 'Migration completed successfully. All vocabulary_level values are valid.';
END $$;