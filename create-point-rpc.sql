-- RPC Function to Bypass RLS for Point Creation
-- This function bypasses RLS for development purposes

CREATE OR REPLACE FUNCTION create_point_bypass_rls(
    p_event_id UUID,
    p_team_id UUID,
    p_team_name TEXT,
    p_updated_by UUID,
    p_points_value INTEGER DEFAULT 0,
    p_medal_type TEXT DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    event_id UUID,
    team_id UUID,
    team_name TEXT,
    points_value INTEGER,
    medal_type TEXT,
    updated_by UUID,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER  -- This bypasses RLS
AS $$
BEGIN
    -- Insert the point bypassing RLS
    RETURN QUERY
    INSERT INTO points (
        event_id,
        team_id,
        team_name,
        points_value,
        medal_type,
        updated_by
    )
    VALUES (
        p_event_id,
        p_team_id,
        p_team_name,
        p_points_value,
        p_medal_type,
        p_updated_by
    )
    RETURNING 
        points.id,
        points.event_id,
        points.team_id,
        points.team_name,
        points.points_value,
        points.medal_type,
        points.updated_by,
        points.created_at,
        points.updated_at;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION create_point_bypass_rls TO authenticated;
