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

// Score functions
export const createScore = async (scoreData) => {
  const { data, error } = await supabase
    .from("scores")
    .insert(scoreData)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const getScores = async (eventId = null) => {
  let query = supabase
    .from("scores")
    .select("*, events(event_name, category)")
    .order("updated_at", { ascending: false });

  if (eventId) {
    query = query.eq("event_id", eventId);
  }

  const { data, error } = await query;
  if (error) throw error;
  return data;
};

export const updateScore = async (id, scoreValue, updatedBy) => {
  const { data, error } = await supabase
    .from("scores")
    .update({
      score_value: scoreValue,
      updated_by: updatedBy,
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const deleteScore = async (id) => {
  const { error } = await supabase.from("scores").delete().eq("id", id);

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

// Get participants with calculated points and medals
export const getParticipants = async () => {
  const { data, error } = await supabase
    .from("participants")
    .select("*")
    .order("created_at", { ascending: true });

  if (error) throw error;
  return data || [];
};
