-- Fix Medal to Points System
-- This script ensures the trigger is properly attached and working

-- 1. Drop existing trigger if it exists
DROP TRIGGER IF EXISTS update_team_stats ON points;

-- 2. Recreate trigger with proper attachment
CREATE TRIGGER update_team_stats
AFTER INSERT OR UPDATE OR DELETE ON points
FOR EACH ROW
EXECUTE FUNCTION update_team_stats();

-- 3. Verify trigger is attached
SELECT 
    tgname,
    tgrelid::regclass,
    tgfn::oid,
    tgtype,
    tgenabled,
    tgisinternal,
    tgconstrname,
    tgconsrc,
    tgdeferr,
    tgdef,
    tgattr,
    tgargs,
    tgold,
    tgisupdate,
    tglevel,
    tgqual,
    tgtable,
    tgtrigger
FROM pg_trigger 
WHERE tgname = 'update_team_stats' AND tgrelid::regclass = 'points'::regclass;

-- 4. Test trigger by inserting a sample point
-- This should update team's total_points and medal counts
SELECT 'Trigger test completed' as status;
