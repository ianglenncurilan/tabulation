import { createClient } from "@supabase/supabase-js";

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Auth helper functions
export const signUp = async (email, password, fullName, role = "staff") => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: fullName,
        role: role,
      },
      emailRedirectTo: undefined, // Disable email confirmation
    },
  });

  if (error) throw error;
  return data;
};

export const signIn = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) throw error;
  return data;
};

export const signOut = async () => {
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
};

export const getCurrentUser = async () => {
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();
  if (error) throw error;
  return user;
};

// Profile functions
export const createProfile = async (profileData) => {
  const { data, error } = await supabase
    .from("profiles")
    .insert(profileData)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const getProfiles = async () => {
  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Supabase error details:", error);
    throw error;
  }
  return data || []; // Return empty array if data is null
};

export const updateProfile = async (id, updates) => {
  const { data, error } = await supabase
    .from("profiles")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

// Event functions
export const createEvent = async (eventData) => {
  const { data, error } = await supabase
    .from("events")
    .insert(eventData)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const getEvents = async () => {
  const { data, error } = await supabase
    .from("events")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data;
};

export const updateEvent = async (id, updates) => {
  const { data, error } = await supabase
    .from("events")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const deleteEvent = async (id) => {
  const { error } = await supabase.from("events").delete().eq("id", id);

  if (error) throw error;
  return true;
};

// Point functions
export const createPoint = async (pointData) => {
  // Get current user
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("User not authenticated");
  }

  console.log("Creating point with data:", {
    ...pointData,
    updated_by: user.id,
  });

  // TEMPORARY DEVELOPMENT BYPASS
  // This bypasses RLS for development - remove in production
  console.warn("⚠️ DEVELOPMENT MODE: Bypassing RLS for point creation");

  const { data, error } = await supabase.rpc("create_point_bypass_rls", {
    p_event_id: pointData.event_id,
    p_team_id: pointData.team_id,
    p_team_name: pointData.team_name,
    p_points_value: pointData.points_value || 0,
    p_medal_type: pointData.medal_type,
    p_updated_by: user.id,
  });

  if (error) {
    console.error("RPC call failed, trying direct insert:", error);

    // Fallback to direct insert
    const { data: fallbackData, error: fallbackError } = await supabase
      .from("points")
      .insert({
        event_id: pointData.event_id,
        team_id: pointData.team_id,
        team_name: pointData.team_name,
        points_value: pointData.points_value || 0,
        medal_type: pointData.medal_type,
        updated_by: user.id,
      })
      .select()
      .single();

    if (fallbackError) {
      console.error("Both RPC and direct insert failed:", fallbackError);
      throw new Error(
        `Unable to create point: ${fallbackError.message}. Please check RLS policies.`,
      );
    }

    console.log("Point created with direct insert:", fallbackData);
    return fallbackData;
  }

  console.log("Point created via RPC:", data);
  return data;
};

export const getPoints = async (eventId = null) => {
  let query = supabase
    .from("points")
    .select(
      `
      *,
      events:event_id (event_name, category),
      teams:team_id (team_name, color)
    `,
    )
    .order("updated_at", { ascending: false });

  if (eventId) {
    query = query.eq("event_id", eventId);
  }

  const { data, error } = await query;
  if (error) throw error;
  return data;
};

export const updatePoint = async (
  id,
  pointValue,
  medalType = null,
  updatedBy = null,
) => {
  const updateData = {
    points_value: pointValue,
    updated_by: updatedBy,
  };

  if (medalType) {
    updateData.medal_type = medalType;
  }

  const { data, error } = await supabase
    .from("points")
    .update(updateData)
    .eq("id", id)
    .select(
      `
      *,
      events:event_id (event_name, category),
      teams:team_id (team_name, color)
    `,
    )
    .single();

  if (error) throw error;
  return data;
};

export const assignMedal = async (pointId, medalType, updatedBy = null) => {
  const { data, error } = await supabase
    .from("points")
    .update({
      medal_type: medalType,
      updated_by: updatedBy,
    })
    .eq("id", pointId)
    .select(
      `
      *,
      events:event_id (event_name, category),
      teams:team_id (team_name, color)
    `,
    )
    .single();

  if (error) throw error;
  return data;
};

export const deletePoint = async (id) => {
  const { error } = await supabase.from("points").delete().eq("id", id);

  if (error) throw error;
  return true;
};

// Realtime subscription for events
export const subscribeToEvents = (callback) => {
  return supabase
    .channel("events-changes")
    .on(
      "postgres_changes",
      {
        event: "*",
        schema: "public",
        table: "events",
      },
      callback,
    )
    .subscribe();
};

// Team functions
export const createTeam = async (teamData) => {
  // Get current user
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("User not authenticated");
  }

  const { data, error } = await supabase
    .from("teams")
    .insert({
      ...teamData,
      created_by: user.id,
    })
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const getTeams = async () => {
  const { data, error } = await supabase
    .from("teams")
    .select("*")
    .order("team_name", { ascending: true });

  if (error) throw error;
  return data || [];
};

export const updateTeam = async (id, updates) => {
  const { data, error } = await supabase
    .from("teams")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const deleteTeam = async (id) => {
  const { error } = await supabase.from("teams").delete().eq("id", id);

  if (error) throw error;
  return true;
};

// Event Teams functions (replaces Event Participants)
export const addTeamToEvent = async (eventId, teamId) => {
  const { data, error } = await supabase
    .from("event_teams")
    .insert({
      event_id: eventId,
      team_id: teamId,
    })
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const removeTeamFromEvent = async (eventId, teamId) => {
  const { error } = await supabase
    .from("event_teams")
    .delete()
    .eq("event_id", eventId)
    .eq("team_id", teamId);

  if (error) throw error;
  return true;
};

export const getEventTeams = async (eventId) => {
  const { data, error } = await supabase
    .from("event_teams")
    .select("*, teams(team_name, team_code, color)")
    .eq("event_id", eventId)
    .order("registration_date", { ascending: true });

  if (error) throw error;
  return data || [];
};

// Points Configuration functions
export const getPointsConfig = async () => {
  const { data, error } = await supabase
    .from("points_config")
    .select("*")
    .eq("is_active", true)
    .order("medal_type", { ascending: true });

  if (error) throw error;
  return data || [];
};

export const updatePointsConfig = async (id, updates) => {
  const { data, error } = await supabase
    .from("points_config")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

// Get teams with calculated points and medals
export const getTeamsWithStats = async () => {
  const { data, error } = await supabase
    .from("teams")
    .select("*")
    .eq("is_active", true)
    .order("total_points", { ascending: false });

  if (error) throw error;
  return data || [];
};
