-- Add spaced-repetition columns to user_progress that were missing.
-- times_reviewed: how many times the user has reviewed this word correctly
-- last_reviewed:  timestamp of the most recent review attempt
ALTER TABLE public.user_progress
  ADD COLUMN IF NOT EXISTS times_reviewed INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS last_reviewed   TIMESTAMPTZ;

-- Ensure a unique constraint exists on (user_id, word_id) so that
-- the upsert in updateProgressAfterQuiz works correctly.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'user_progress_user_id_word_id_key'
      AND conrelid = 'public.user_progress'::regclass
  ) THEN
    ALTER TABLE public.user_progress
      ADD CONSTRAINT user_progress_user_id_word_id_key
      UNIQUE (user_id, word_id);
  END IF;
END $$;
