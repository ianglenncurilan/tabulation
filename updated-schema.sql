-- Updated Database Schema for Sports/Esports Tabulation System
-- Removes participants table and replaces scores with points table

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
  total_points INTEGER DEFAULT 0,
  gold_medals INTEGER DEFAULT 0,
  silver_medals INTEGER DEFAULT 0,
  bronze_medals INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
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

-- Points table (replaces scores table)
CREATE TABLE IF NOT EXISTS points (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
  team_name TEXT NOT NULL, -- Keep for direct reference
  points_value INTEGER NOT NULL DEFAULT 0,
  medal_type TEXT CHECK (medal_type IN ('gold', 'silver', 'bronze')),
  position INTEGER,
  notes TEXT,
  updated_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT check_team_reference CHECK (
    (team_id IS NOT NULL) OR (team_name IS NOT NULL)
  )
);

-- Event Teams table for many-to-many relationship between events and teams
CREATE TABLE IF NOT EXISTS event_teams (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
  registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(event_id, team_id)
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
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE points ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_teams ENABLE ROW LEVEL SECURITY;
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

-- Events RLS policies (existing)
CREATE POLICY "Managers can manage all events" ON events
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view events" ON events
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view events" ON events
  FOR SELECT USING (true);

-- Points RLS policies
CREATE POLICY "Managers can manage all points" ON points
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view points" ON points
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view points" ON points
  FOR SELECT USING (true);

-- Event Teams RLS policies
CREATE POLICY "Managers can manage event teams" ON event_teams
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view event teams" ON event_teams
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

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
CREATE INDEX idx_teams_points ON teams(total_points);
CREATE INDEX idx_events_category ON events(category);
CREATE INDEX idx_events_is_live ON events(is_live);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_event_teams_event ON event_teams(event_id);
CREATE INDEX idx_event_teams_team ON event_teams(team_id);
CREATE INDEX idx_points_event ON points(event_id);
CREATE INDEX idx_points_team ON points(team_id);
CREATE INDEX idx_points_medal ON points(medal_type);

-- Enable Realtime for relevant tables
ALTER PUBLICATION supabase_realtime ADD TABLE events;
ALTER PUBLICATION supabase_realtime ADD TABLE points;
ALTER PUBLICATION supabase_realtime ADD TABLE teams;

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

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_points_updated_at BEFORE UPDATE ON points
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_points_config_updated_at BEFORE UPDATE ON points_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to automatically update team points and medals
CREATE OR REPLACE FUNCTION update_team_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- Update team's total points and medals when a point is added/updated
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.team_id IS NOT NULL THEN
            UPDATE teams SET
                total_points = (
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN p.medal_type = 'gold' THEN (SELECT points_value FROM points_config WHERE medal_type = 'gold' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'silver' THEN (SELECT points_value FROM points_config WHERE medal_type = 'silver' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'bronze' THEN (SELECT points_value FROM points_config WHERE medal_type = 'bronze' AND is_active = TRUE LIMIT 1)
                            ELSE p.points_value
                        END), 0)
                    FROM points p 
                    WHERE p.team_id = NEW.team_id
                ),
                gold_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_id = NEW.team_id AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_id = NEW.team_id AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_id = NEW.team_id AND medal_type = 'bronze'
                )
            WHERE id = NEW.team_id;
        ELSIF NEW.team_name IS NOT NULL THEN
            -- Update by team name for cases where team_id is not available
            UPDATE teams SET
                total_points = (
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN p.medal_type = 'gold' THEN (SELECT points_value FROM points_config WHERE medal_type = 'gold' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'silver' THEN (SELECT points_value FROM points_config WHERE medal_type = 'silver' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'bronze' THEN (SELECT points_value FROM points_config WHERE medal_type = 'bronze' AND is_active = TRUE LIMIT 1)
                            ELSE p.points_value
                        END), 0)
                    FROM points p 
                    WHERE p.team_name = NEW.team_name
                ),
                gold_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_name = NEW.team_name AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_name = NEW.team_name AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_name = NEW.team_name AND medal_type = 'bronze'
                )
            WHERE team_name = NEW.team_name;
        END IF;
        
        RETURN NEW;
    END IF;
    
    IF TG_OP = 'DELETE' THEN
        IF OLD.team_id IS NOT NULL THEN
            UPDATE teams SET
                total_points = (
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN p.medal_type = 'gold' THEN (SELECT points_value FROM points_config WHERE medal_type = 'gold' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'silver' THEN (SELECT points_value FROM points_config WHERE medal_type = 'silver' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'bronze' THEN (SELECT points_value FROM points_config WHERE medal_type = 'bronze' AND is_active = TRUE LIMIT 1)
                            ELSE p.points_value
                        END), 0)
                    FROM points p 
                    WHERE p.team_id = OLD.team_id
                ),
                gold_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_id = OLD.team_id AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_id = OLD.team_id AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_id = OLD.team_id AND medal_type = 'bronze'
                )
            WHERE id = OLD.team_id;
        ELSIF OLD.team_name IS NOT NULL THEN
            UPDATE teams SET
                total_points = (
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN p.medal_type = 'gold' THEN (SELECT points_value FROM points_config WHERE medal_type = 'gold' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'silver' THEN (SELECT points_value FROM points_config WHERE medal_type = 'silver' AND is_active = TRUE LIMIT 1)
                            WHEN p.medal_type = 'bronze' THEN (SELECT points_value FROM points_config WHERE medal_type = 'bronze' AND is_active = TRUE LIMIT 1)
                            ELSE p.points_value
                        END), 0)
                    FROM points p 
                    WHERE p.team_name = OLD.team_name
                ),
                gold_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_name = OLD.team_name AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_name = OLD.team_name AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) FROM points 
                    WHERE team_name = OLD.team_name AND medal_type = 'bronze'
                )
            WHERE team_name = OLD.team_name;
        END IF;
        
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic team stats update
DROP TRIGGER IF EXISTS update_team_stats_trigger ON points;
CREATE TRIGGER update_team_stats_trigger
    AFTER INSERT OR UPDATE OR DELETE ON points
    FOR EACH ROW EXECUTE FUNCTION update_team_stats();

-- Sample data insertion (optional - for testing)
INSERT INTO teams (team_name, team_code, color, description) VALUES
('Information Technology', 'IT', 'blue', 'Department of Information Technology'),
('Information System', 'IS', 'peach', 'Department of Information Systems'),
('Computer Science', 'CS', 'red', 'Department of Computer Science')
ON CONFLICT (team_name) DO NOTHING;

-- Create a view for points with team info
CREATE OR REPLACE VIEW points_with_teams AS
SELECT 
    p.*,
    t.team_name as full_team_name,
    t.color as team_color,
    t.team_code,
    e.event_name,
    e.category
FROM points p
LEFT JOIN teams t ON p.team_id = t.id OR p.team_name = t.team_name
LEFT JOIN events e ON p.event_id = e.id;
