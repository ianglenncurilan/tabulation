-- Complete RLS Policy Fix
-- This will drop ALL existing policies and recreate them properly

-- First, disable RLS temporarily to avoid conflicts
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE events DISABLE ROW LEVEL SECURITY;
ALTER TABLE scores DISABLE ROW LEVEL SECURITY;

-- Drop ALL existing policies
DROP POLICY IF EXISTS "Managers can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Managers can insert profiles" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

DROP POLICY IF EXISTS "Managers can manage all events" ON events;
DROP POLICY IF EXISTS "Staff can view events" ON events;
DROP POLICY IF EXISTS "Managers can insert events" ON events;

DROP POLICY IF EXISTS "Managers can manage all scores" ON scores;
DROP POLICY IF EXISTS "Staff can view scores" ON scores;
DROP POLICY IF EXISTS "Managers can insert scores" ON scores;

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Create new simplified policies that work
-- Profiles policies
CREATE POLICY "Enable all for profiles" ON profiles
  FOR ALL USING (auth.role() = 'authenticated');

-- Events policies  
CREATE POLICY "Enable all for events" ON events
  FOR ALL USING (auth.role() = 'authenticated');

-- Scores policies
CREATE POLICY "Enable all for scores" ON scores
  FOR ALL USING (auth.role() = 'authenticated');

-- Optional: If you want stricter policies later, uncomment these:
/*
-- Profiles RLS policies
CREATE POLICY "Managers can view all profiles" ON profiles
  FOR SELECT USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Managers can insert profiles" ON profiles
  FOR INSERT WITH CHECK (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Events RLS policies
CREATE POLICY "Managers can manage all events" ON events
  FOR ALL USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Staff can view events" ON events
  FOR SELECT USING (auth.jwt()->>'role' = 'staff');

-- Scores RLS policies
CREATE POLICY "Managers can manage all scores" ON scores
  FOR ALL USING (auth.jwt()->>'role' = 'manager');

CREATE POLICY "Staff can view scores" ON scores
  FOR SELECT USING (auth.jwt()->>'role' = 'staff');
*/
