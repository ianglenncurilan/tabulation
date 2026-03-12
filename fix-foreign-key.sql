-- Fix the foreign key constraint for events table
-- This will make the created_by field optional

-- First, drop the existing foreign key constraint
ALTER TABLE events DROP CONSTRAINT IF EXISTS events_created_by_fkey;

-- Then add it back with ON DELETE SET NULL
ALTER TABLE events 
ADD CONSTRAINT events_created_by_fkey 
FOREIGN KEY (created_by) REFERENCES profiles(id) ON DELETE SET NULL;
