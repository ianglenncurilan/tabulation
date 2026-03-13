-- Enhanced Supabase Schema for Sports/Esports Tabulation System
-- Includes teams, participants, events, scores, and proper relationships

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table with role-based access (existing)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('manager', 'staff')),
  full_name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Teams table for managing teams/colleges
CREATE TABLE IF NOT EXISTS teams (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  team_name TEXT UNIQUE NOT NULL,
  team_code TEXT UNIQUE NOT NULL,
  color TEXT DEFAULT 'blue',
  logo_url TEXT,
  description TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Participants table for individual participants/players
CREATE TABLE IF NOT EXISTS participants (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
  avatar_url TEXT DEFAULT '/default-avatar.png',
  total_points INTEGER DEFAULT 0,
  gold_medals INTEGER DEFAULT 0,
  silver_medals INTEGER DEFAULT 0,
  bronze_medals INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Events table for managing sports/esports events (enhanced)
CREATE TABLE IF NOT EXISTS events (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_name TEXT NOT NULL,
  is_live BOOLEAN DEFAULT FALSE,
  category TEXT NOT NULL CHECK (category IN ('sports', 'esports')),
  event_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME,
  description TEXT,
  max_participants INTEGER,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Event Participants table for many-to-many relationship
CREATE TABLE IF NOT EXISTS event_participants (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  participant_id UUID NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(event_id, participant_id)
);

-- Scores table for tabulation (enhanced with medal tracking)
CREATE TABLE IF NOT EXISTS scores (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  participant_id UUID REFERENCES participants(id) ON DELETE SET NULL,
  team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
  score_value INTEGER NOT NULL DEFAULT 0,
  medal_type TEXT CHECK (medal_type IN ('gold', 'silver', 'bronze')),
  position INTEGER,
  notes TEXT,
  updated_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT check_participant_or_team CHECK (
    (participant_id IS NOT NULL AND team_id IS NULL) OR 
    (participant_id IS NULL AND team_id IS NOT NULL) OR
    (participant_id IS NULL AND team_id IS NULL)
  )
);

-- Points Configuration table for flexible point systems
CREATE TABLE IF NOT EXISTS points_config (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  medal_type TEXT NOT NULL CHECK (medal_type IN ('gold', 'silver', 'bronze')),
  points_value INTEGER NOT NULL,
  category TEXT CHECK (category IN ('sports', 'esports', 'general')),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default points configuration
INSERT INTO points_config (medal_type, points_value, category) VALUES
('gold', 30, 'general'),
('silver', 20, 'general'),
('bronze', 10, 'general')
ON CONFLICT DO NOTHING;

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE points_config ENABLE ROW LEVEL SECURITY;

-- Profiles RLS policies (existing)
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

-- Teams RLS policies
CREATE POLICY "Managers can manage all teams" ON teams
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view teams" ON teams
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view active teams" ON teams
  FOR SELECT USING (is_active = TRUE);

-- Participants RLS policies
CREATE POLICY "Managers can manage all participants" ON participants
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view participants" ON participants
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view active participants" ON participants
  FOR SELECT USING (is_active = TRUE);

-- Events RLS policies (existing)
CREATE POLICY "Managers can manage all events" ON events
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view events" ON events
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view events" ON events
  FOR SELECT USING (true);

-- Event Participants RLS policies
CREATE POLICY "Managers can manage event participants" ON event_participants
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view event participants" ON event_participants
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

-- Scores RLS policies (enhanced)
CREATE POLICY "Managers can manage all scores" ON scores
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view scores" ON scores
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view scores" ON scores
  FOR SELECT USING (true);

-- Points Config RLS policies
CREATE POLICY "Managers can manage points config" ON points_config
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view points config" ON points_config
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view active points config" ON points_config
  FOR SELECT USING (is_active = TRUE);

-- Create indexes for better performance
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_teams_active ON teams(is_active);
CREATE INDEX idx_teams_name ON teams(team_name);
CREATE INDEX idx_participants_active ON participants(is_active);
CREATE INDEX idx_participants_team ON participants(team_id);
CREATE INDEX idx_events_category ON events(category);
CREATE INDEX idx_events_is_live ON events(is_live);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_event_participants_event ON event_participants(event_id);
CREATE INDEX idx_event_participants_participant ON event_participants(participant_id);
CREATE INDEX idx_scores_event ON scores(event_id);
CREATE INDEX idx_scores_participant ON scores(participant_id);
CREATE INDEX idx_scores_team ON scores(team_id);
CREATE INDEX idx_scores_medal ON scores(medal_type);

-- Enable Realtime for relevant tables
ALTER PUBLICATION supabase_realtime ADD TABLE events;
ALTER PUBLICATION supabase_realtime ADD TABLE scores;
ALTER PUBLICATION supabase_realtime ADD TABLE teams;
ALTER PUBLICATION supabase_realtime ADD TABLE participants;

-- Updated timestamp trigger (existing)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_participants_updated_at BEFORE UPDATE ON participants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scores_updated_at BEFORE UPDATE ON scores
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_points_config_updated_at BEFORE UPDATE ON points_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to automatically update participant points and medals
CREATE OR REPLACE FUNCTION update_participant_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- Update participant's total points and medals when a score is added/updated
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.participant_id IS NOT NULL THEN
            UPDATE participants SET
                total_points = (
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN s.medal_type = 'gold' THEN (SELECT points_value FROM points_config WHERE medal_type = 'gold' AND is_active = TRUE LIMIT 1)
                            WHEN s.medal_type = 'silver' THEN (SELECT points_value FROM points_config WHERE medal_type = 'silver' AND is_active = TRUE LIMIT 1)
                            WHEN s.medal_type = 'bronze' THEN (SELECT points_value FROM points_config WHERE medal_type = 'bronze' AND is_active = TRUE LIMIT 1)
                            ELSE 0
                        END), 0)
                    FROM scores s 
                    WHERE s.participant_id = NEW.participant_id
                ),
                gold_medals = (
                    SELECT COUNT(*) FROM scores 
                    WHERE participant_id = NEW.participant_id AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) FROM scores 
                    WHERE participant_id = NEW.participant_id AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) FROM scores 
                    WHERE participant_id = NEW.participant_id AND medal_type = 'bronze'
                )
            WHERE id = NEW.participant_id;
        END IF;
        
        RETURN NEW;
    END IF;
    
    IF TG_OP = 'DELETE' THEN
        IF OLD.participant_id IS NOT NULL THEN
            UPDATE participants SET
                total_points = (
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN s.medal_type = 'gold' THEN (SELECT points_value FROM points_config WHERE medal_type = 'gold' AND is_active = TRUE LIMIT 1)
                            WHEN s.medal_type = 'silver' THEN (SELECT points_value FROM points_config WHERE medal_type = 'silver' AND is_active = TRUE LIMIT 1)
                            WHEN s.medal_type = 'bronze' THEN (SELECT points_value FROM points_config WHERE medal_type = 'bronze' AND is_active = TRUE LIMIT 1)
                            ELSE 0
                        END), 0)
                    FROM scores s 
                    WHERE s.participant_id = OLD.participant_id
                ),
                gold_medals = (
                    SELECT COUNT(*) FROM scores 
                    WHERE participant_id = OLD.participant_id AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) FROM scores 
                    WHERE participant_id = OLD.participant_id AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) FROM scores 
                    WHERE participant_id = OLD.participant_id AND medal_type = 'bronze'
                )
            WHERE id = OLD.participant_id;
        END IF;
        
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic participant stats update
CREATE TRIGGER update_participant_stats_trigger
    AFTER INSERT OR UPDATE OR DELETE ON scores
    FOR EACH ROW EXECUTE FUNCTION update_participant_stats();

-- Sample data insertion (optional - for testing)
INSERT INTO teams (team_name, team_code, color, description) VALUES
('Information Technology', 'IT', 'blue', 'Department of Information Technology'),
('Information System', 'IS', 'peach', 'Department of Information Systems'),
('Computer Science', 'CS', 'red', 'Department of Computer Science')
ON CONFLICT (team_name) DO NOTHING;

INSERT INTO participants (name, team_id, avatar_url) VALUES
('Information Technology', (SELECT id FROM teams WHERE team_code = 'IT'), '/felix.jpg'),
('Information System', (SELECT id FROM teams WHERE team_code = 'IS'), '/vanellope.jpg'),
('Computer Science', (SELECT id FROM teams WHERE team_code = 'CS'), '/sgt.calhoun.jpg')
ON CONFLICT (name) DO NOTHING;
