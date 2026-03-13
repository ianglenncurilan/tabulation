-- Fix RLS Policy for Points Table
-- This script updates the RLS policy to be more permissive for development

-- First, disable RLS temporarily
ALTER TABLE points DISABLE ROW LEVEL SECURITY;

-- Then enable it with a more permissive policy
ALTER TABLE points ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Managers can manage all points" ON points;
DROP POLICY IF EXISTS "Staff can view points" ON points;
DROP POLICY IF EXISTS "Public can view points" ON points;

-- Create new, more permissive policies
CREATE POLICY "Allow authenticated users to manage points" ON points
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow public to view points" ON points
  FOR SELECT USING (true);

-- Alternative: More restrictive but working policy
-- CREATE POLICY "Managers can manage all points" ON points
--   FOR ALL USING (
--     auth.role() = 'authenticated' AND 
--     EXISTS (
--       SELECT 1 FROM profiles 
--       WHERE profiles.id = auth.uid() 
--       AND profiles.role = 'manager'
--     )
--   );

-- CREATE POLICY "Staff can view points" ON points
--   FOR SELECT USING (
--     auth.role() = 'authenticated' AND 
--     EXISTS (
--       SELECT 1 FROM profiles 
--       WHERE profiles.id = auth.uid() 
--       AND profiles.role IN ('manager', 'staff')
--     )
--   );

-- CREATE POLICY "Public can view points" ON points
--   FOR SELECT USING (true);

-- Grant necessary permissions
GRANT ALL ON points TO authenticated;
GRANT SELECT ON points TO anon;
