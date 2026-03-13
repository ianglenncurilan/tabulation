-- Simple Medal to Points Fix
-- Uses hardcoded medal values instead of points_config table

-- 1. Create function to update team stats with hardcoded medal points
CREATE OR REPLACE FUNCTION update_team_points()
RETURNS TRIGGER AS $$
BEGIN
    -- Update team stats when points are added
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE teams SET
            total_points = (
                SELECT COALESCE(SUM(
                    CASE 
                        WHEN medal_type = 'gold' THEN 10
                        WHEN medal_type = 'silver' THEN 5
                        WHEN medal_type = 'bronze' THEN 3
                        ELSE points_value
                    END), 0)
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

-- 2. Drop existing trigger
DROP TRIGGER IF EXISTS update_team_points_trigger ON points;

-- 3. Create new trigger
CREATE TRIGGER update_team_points_trigger
AFTER INSERT OR UPDATE ON points
FOR EACH ROW
EXECUTE FUNCTION update_team_points();

-- 4. Test completion
SELECT 'Simple medal-to-points trigger created successfully!' as status;

-- 5. Verify trigger
SELECT 
    tgname as trigger_name,
    tgrelid::regclass as table_name,
    tgenabled as is_enabled
FROM pg_trigger 
WHERE tgrelid::regclass = 'points'::regclass;
