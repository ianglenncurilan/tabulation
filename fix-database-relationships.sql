-- Fix database relationships for scores and participants
-- This script updates the existing schema to properly link scores with participants

-- First, let's update the scores table to ensure proper foreign key relationships
-- Drop existing scores table if it exists and recreate with proper relationships

DROP TABLE IF EXISTS scores CASCADE;

-- Recreate scores table with proper foreign key relationships
CREATE TABLE IF NOT EXISTS scores (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  participant_id UUID REFERENCES participants(id) ON DELETE SET NULL,
  team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
  team_name TEXT, -- Keep for backward compatibility
  score_value INTEGER NOT NULL DEFAULT 0,
  medal_type TEXT CHECK (medal_type IN ('gold', 'silver', 'bronze')),
  position INTEGER,
  notes TEXT,
  updated_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT check_participant_or_team CHECK (
    (participant_id IS NOT NULL AND team_id IS NULL AND team_name IS NULL) OR 
    (participant_id IS NULL AND team_id IS NOT NULL) OR
    (participant_id IS NULL AND team_id IS NULL AND team_name IS NOT NULL) OR
    (participant_id IS NULL AND team_id IS NULL AND team_name IS NULL)
  )
);

-- Enable Row Level Security
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Scores RLS policies (recreate them)
CREATE POLICY "Managers can manage all scores" ON scores
  FOR ALL USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'manager');

CREATE POLICY "Staff can view scores" ON scores
  FOR SELECT USING (auth.role() = 'authenticated' AND 
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'staff');

CREATE POLICY "Public can view scores" ON scores
  FOR SELECT USING (true);

-- Create indexes for better performance
CREATE INDEX idx_scores_event_id ON scores(event_id);
CREATE INDEX idx_scores_participant_id ON scores(participant_id);
CREATE INDEX idx_scores_team_id ON scores(team_id);
CREATE INDEX idx_scores_medal_type ON scores(medal_type);

-- Enable Realtime for scores table
ALTER PUBLICATION supabase_realtime ADD TABLE scores;

-- Create trigger for updated_at column
CREATE TRIGGER update_scores_updated_at BEFORE UPDATE ON scores
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
DROP TRIGGER IF EXISTS update_participant_stats_trigger ON scores;
CREATE TRIGGER update_participant_stats_trigger
    AFTER INSERT OR UPDATE OR DELETE ON scores
    FOR EACH ROW EXECUTE FUNCTION update_participant_stats();

-- Insert some sample data if tables are empty
INSERT INTO participants (name, avatar_url) VALUES
('Information Technology', '/felix.jpg'),
('Information System', '/vanellope.jpg'),
('Computer Science', '/sgt.calhoun.jpg')
ON CONFLICT (name) DO NOTHING;

-- Create a simple view for scores with participant info
CREATE OR REPLACE VIEW scores_with_participants AS
SELECT 
    s.*,
    p.name as participant_name,
    p.avatar_url,
    t.team_name,
    t.color as team_color,
    e.event_name,
    e.category
FROM scores s
LEFT JOIN participants p ON s.participant_id = p.id
LEFT JOIN teams t ON s.team_id = t.id OR p.team_id = t.id
LEFT JOIN events e ON s.event_id = e.id;
