-- Disable email confirmation for new users
-- This allows users to sign up without email verification

-- Update the auth.users table to disable email confirmation requirement
ALTER TABLE auth.users 
ALTER COLUMN email_confirmed_at SET DEFAULT now();

-- Alternatively, you can disable email confirmation in the Supabase dashboard:
-- 1. Go to Authentication > Settings
-- 2. Under "Email confirmation", toggle off "Enable email confirmations"
-- 3. Save changes

-- Note: The SQL approach above might not work in all Supabase instances
-- The recommended way is through the dashboard settings
