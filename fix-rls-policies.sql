-- Fix RLS policies to avoid circular dependency
-- These policies use user_metadata instead of checking profiles table

-- Drop existing policies
DROP POLICY IF EXISTS "Managers can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Managers can insert profiles" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

-- Create new policies using user_metadata
CREATE POLICY "Managers can view all profiles" ON profiles
  FOR SELECT USING (
    auth.role() = 'authenticated' AND 
    auth.jwt()->>'role' = 'manager'
  );

CREATE POLICY "Managers can insert profiles" ON profiles
  FOR INSERT WITH CHECK (
    auth.role() = 'authenticated' AND 
    auth.jwt()->>'role' = 'manager'
  );

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Also fix events and scores policies
DROP POLICY IF EXISTS "Managers can manage all events" ON events;
DROP POLICY IF EXISTS "Staff can view events" ON events;

CREATE POLICY "Managers can manage all events" ON events
  FOR ALL USING (
    auth.role() = 'authenticated' AND 
    auth.jwt()->>'role' = 'manager'
  );

CREATE POLICY "Staff can view events" ON events
  FOR SELECT USING (
    auth.role() = 'authenticated' AND 
    auth.jwt()->>'role' = 'staff'
  );

DROP POLICY IF EXISTS "Managers can manage all scores" ON scores;
DROP POLICY IF EXISTS "Staff can view scores" ON scores;

CREATE POLICY "Managers can manage all scores" ON scores
  FOR ALL USING (
    auth.role() = 'authenticated' AND 
    auth.jwt()->>'role' = 'manager'
  );

CREATE POLICY "Staff can view scores" ON scores
  FOR SELECT USING (
    auth.role() = 'authenticated' AND 
    auth.jwt()->>'role' = 'staff'
  );
