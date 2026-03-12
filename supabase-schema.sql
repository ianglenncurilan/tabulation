-- Supabase Schema for Sports/Esports Tabulation System

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table with role-based access
CREATE TABLE IF NOT EXISTS profiles (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('manager', 'staff')),
  full_name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Events table for managing sports/esports events
CREATE TABLE IF NOT EXISTS events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_name TEXT NOT NULL,
  is_live BOOLEAN DEFAULT FALSE,
  category TEXT NOT NULL CHECK (category IN ('sports', 'esports')),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Scores table for tabulation
CREATE TABLE IF NOT EXISTS scores (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  team_name TEXT NOT NULL,
  score_value INTEGER NOT NULL DEFAULT 0,
  updated_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Profiles RLS policies
CREATE POLICY "Managers can view all profiles" ON profiles
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Managers can insert profiles" ON profiles
  FOR INSERT WITH CHECK (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Events RLS policies
CREATE POLICY "Managers can manage all events" ON events
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view events" ON events
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

-- Scores RLS policies
CREATE POLICY "Managers can manage all scores" ON scores
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view scores" ON scores
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

-- Create indexes for better performance
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_events_category ON events(category);
CREATE INDEX idx_events_is_live ON events(is_live);
CREATE INDEX idx_scores_event_id ON scores(event_id);

-- Enable Realtime for events table
ALTER PUBLICATION supabase_realtime ADD TABLE events;

-- Updated timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scores_updated_at BEFORE UPDATE ON scores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
