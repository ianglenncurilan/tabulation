-- Complete Medal to Points System Fix
-- This script recreates the entire medal-to-points system

-- 1. First, check if points_config table exists and has data
SELECT 'Checking points_config table...' as status;

-- 2. Ensure points_config has correct values
INSERT INTO points_config (medal_type, points_value, category, is_active) VALUES
('gold', 10, 'general', TRUE),
('silver', 5, 'general', TRUE), 
('bronze', 3, 'general', TRUE)
ON CONFLICT (medal_type) 
DO UPDATE SET points_value = EXCLUDED.points_value, is_active = TRUE;

-- 3. Create simplified update function
CREATE OR REPLACE FUNCTION update_team_points()
RETURNS TRIGGER AS $$
BEGIN
    -- Update team stats when points are added
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE teams SET
            total_points = (
                SELECT COALESCE(SUM(points_value), 0)
                FROM points 
                WHERE team_id = NEW.team_id OR team_name = NEW.team_name
            ),
            gold_medals = (
                SELECT COUNT(*) 
                FROM points 
                WHERE (team_id = NEW.team_id OR team_name = NEW.team_name) AND medal_type = 'gold'
            ),
            silver_medals = (
                SELECT COUNT(*) 
                FROM points 
                WHERE (team_id = NEW.team_id OR team_name = NEW.team_name) AND medal_type = 'silver'
            ),
            bronze_medals = (
                SELECT COUNT(*) 
                FROM points 
                WHERE (team_id = NEW.team_id OR team_name = NEW.team_name) AND medal_type = 'bronze'
            )
        WHERE id = COALESCE(NEW.team_id, (SELECT id FROM teams WHERE team_name = NEW.team_name LIMIT 1));
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 4. Drop old trigger
DROP TRIGGER IF EXISTS update_team_points_trigger ON points;

-- 5. Create new trigger
CREATE TRIGGER update_team_points_trigger
AFTER INSERT OR UPDATE ON points
FOR EACH ROW
EXECUTE FUNCTION update_team_points();

-- 6. Test the system
SELECT 'Medal-to-points system setup completed!' as status;

-- 7. Verify trigger is working
SELECT 
    tgname as trigger_name,
    tgrelid::regclass as table_name,
    tgenabled as is_enabled
FROM pg_trigger 
WHERE tgrelid::regclass = 'points'::regclass;
