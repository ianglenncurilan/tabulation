-- Fix Points Calculation in Medal System
-- The issue: total_points calculation is not working properly

-- 1. Drop the broken trigger
DROP TRIGGER IF EXISTS update_team_points_trigger ON points;
DROP FUNCTION IF EXISTS update_team_points();

-- 2. Create corrected function with proper points calculation
CREATE OR REPLACE FUNCTION update_team_points()
RETURNS TRIGGER AS $$
BEGIN
    -- Update team stats when points are added
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        -- Get team ID properly
        DECLARE
            target_team_id UUID;
            target_team_name TEXT;
        BEGIN
            -- Use team_id if available, otherwise find by team_name
            target_team_id := NEW.team_id;
            target_team_name := NEW.team_name;
            
            IF target_team_id IS NULL AND target_team_name IS NOT NULL THEN
                SELECT id INTO target_team_id FROM teams WHERE team_name = target_team_name LIMIT 1;
            END IF;
            
            -- Update the team with correct points calculation
            UPDATE teams SET
                total_points = (
                    -- Sum all points for this team
                    SELECT COALESCE(SUM(
                        CASE 
                            WHEN medal_type = 'gold' THEN 10
                            WHEN medal_type = 'silver' THEN 5
                            WHEN medal_type = 'bronze' THEN 3
                            ELSE COALESCE(points_value, 0)
                        END), 0)
                    FROM points 
                    WHERE team_id = target_team_id OR team_name = target_team_name
                ),
                gold_medals = (
                    SELECT COUNT(*) 
                    FROM points 
                    WHERE (team_id = target_team_id OR team_name = target_team_name) AND medal_type = 'gold'
                ),
                silver_medals = (
                    SELECT COUNT(*) 
                    FROM points 
                    WHERE (team_id = target_team_id OR team_name = target_team_name) AND medal_type = 'silver'
                ),
                bronze_medals = (
                    SELECT COUNT(*) 
                    FROM points 
                    WHERE (team_id = target_team_id OR team_name = target_team_name) AND medal_type = 'bronze'
                )
            WHERE id = target_team_id;
        END;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 3. Create the trigger
CREATE TRIGGER update_team_points_trigger
AFTER INSERT OR UPDATE ON points
FOR EACH ROW
EXECUTE FUNCTION update_team_points();

-- 4. Test the fix
SELECT 'Points calculation fix completed!' as status;

-- 5. Manual test - update a specific team's points to verify
-- This will help us verify the calculation is working
SELECT 
    team_name,
    total_points,
    gold_medals,
    silver_medals,
    bronze_medals
FROM teams 
ORDER BY total_points DESC;
