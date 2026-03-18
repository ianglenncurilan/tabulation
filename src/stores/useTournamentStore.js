import { defineStore } from "pinia";
import { ref, computed } from "vue";
import {
  getEvents,
  getTeams,
  getPoints,
  getTeamsWithStats,
  subscribeToEvents,
  createPoint,
} from "@/utils/supabase.js";

export const useTournamentStore = defineStore("tournament", () => {
  // Dynamic data from Supabase
  const teams = ref([]);
  const sports = ref([
    { id: 1, name: "Flag Football", icon: "🏈", active: true },
    { id: 2, name: "Basketball", icon: "🏀", active: true },
    { id: 3, name: "Volleyball", icon: "🏐", active: false },
  ]);

  // Real data from Supabase
  const events = ref([]);
  const points = ref([]);
  const loading = ref(false);

  // Calculate points from medals
  const calculatePointsFromMedals = (team) => {
    const goldPoints = (team.gold_medals || 0) * 10;
    const silverPoints = (team.silver_medals || 0) * 5;
    const bronzePoints = (team.bronze_medals || 0) * 3;
    return goldPoints + silverPoints + bronzePoints;
  };

  // Update team points based on medals
  const updateTeamPointsFromMedals = () => {
    teams.value.forEach((team) => {
      team.total_points = calculatePointsFromMedals(team);
    });
  };

  // Computed properties
  const topThree = computed(() => teams.value.slice(0, 3));
  const fullLeaderboard = computed(() => teams.value.slice(0, 10)); // Show first 10 for demo
  const totalParticipants = computed(() => teams.value.length);

  // Animated leaderboard - sorted by total_points
  const sortedTeams = computed(() => {
    return [...teams.value].sort(
      (a, b) => (b.total_points || 0) - (a.total_points || 0),
    );
  });

  // Computed active matches from real events
  const activeMatches = computed(() => {
    return events.value
      .filter((event) => event.is_live)
      .map((event) => {
        // Get points for this event
        const eventPoints = points.value.filter(
          (point) => point.event_id === event.id,
        );

        // Create score string from teams
        let scoreString = "0-0";
        let teamsString = event.event_name;

        if (eventPoints.length > 0) {
          const pointEntries = eventPoints.map((point) => {
            const name = point.teams?.team_name || point.team_name || "Unknown";
            return `${name}: ${point.points_value}`;
          });
          scoreString = pointEntries.join(" | ");

          // Create teams string from teams
          const teamNames = eventPoints.map(
            (point) => point.teams?.team_name || point.team_name || "Unknown",
          );
          if (teamNames.length > 0) {
            teamsString = teamNames.join(" vs ");
          }
        }

        return {
          id: event.id,
          sport: event.category === "sports" ? "Sports" : "Esports",
          teams: teamsString,
          score: scoreString,
          status: "live",
          event_date: event.event_date,
          start_time: event.start_time,
        };
      });
  });

  // Actions
  const updateScore = (teamId, newPoints) => {
    const team = teams.value.find((t) => t.id === teamId);
    if (team) {
      team.total_points = newPoints;
      // Re-sort teams by points
      teams.value.sort((a, b) => b.total_points - a.total_points);
      // Update ranks
      teams.value.forEach((t, index) => {
        t.rank = index + 1;
      });
    }
  };

  const addRecentForm = (teamId, result) => {
    const team = teams.value.find((t) => t.id === teamId);
    if (team) {
      team.recentForm.pop(); // Remove oldest
      team.recentForm.unshift(result); // Add newest
      if (result === "W") {
        team.record.wins++;
      } else {
        team.record.losses++;
      }
    }
  };

  // Helper function to get medal points
  const getMedalPoints = (medalType) => {
    switch (medalType) {
      case "gold":
        return 10;
      case "silver":
        return 5;
      case "bronze":
        return 3;
      default:
        return 0;
    }
  };

  const addMedal = async (teamName, medalType, eventId) => {
    try {
      // Create or update a point with medal and correct points
      const pointData = {
        event_id: eventId,
        team_name: teamName,
        points_value: getMedalPoints(medalType),
        medal_type: medalType,
      };

      await createPoint(pointData);

      // Refresh data to update team stats
      await fetchTeams();
      await fetchPoints();
    } catch (error) {
      console.error("Error adding medal:", error);
      throw error;
    }
  };

  // Fetch real data
  const fetchEvents = async () => {
    try {
      loading.value = true;
      const data = await getEvents();
      events.value = data;
    } catch (error) {
      console.error("Error fetching events:", error);
    } finally {
      loading.value = false;
    }
  };

  const fetchPoints = async () => {
    try {
      loading.value = true;
      const data = await getPoints();
      points.value = data;
    } catch (error) {
      console.error("Error fetching points:", error);
    } finally {
      loading.value = false;
    }
  };

  const fetchTeams = async () => {
    try {
      loading.value = true;
      const data = await getTeamsWithStats();
      teams.value = data;
      updateTeamFormatting();
    } catch (error) {
      console.error("Error fetching teams:", error);
    } finally {
      loading.value = false;
    }
  };

  const updateTeamFormatting = () => {
    // Ensure teams have proper formatting for the UI
    teams.value.forEach((team) => {
      // Ensure medals object exists
      if (!team.medals) {
        team.medals = {
          gold: team.gold_medals || 0,
          silver: team.silver_medals || 0,
          bronze: team.bronze_medals || 0,
        };
      } else {
        team.medals.gold = team.gold_medals || 0;
        team.medals.silver = team.silver_medals || 0;
        team.medals.bronze = team.bronze_medals || 0;
      }

      // Always calculate points from medals to ensure accuracy
      team.total_points = calculatePointsFromMedals(team);

      // Set points from total_points
      team.points = team.total_points || 0;

      // Set avatar based on team name if not exists
      if (!team.avatar) {
        const avatarMap = {
          "Information Technology": "/felix.jpg",
          "Information System": "/vanellope.jpg",
          "Computer Science": "/sgt.calhoun.jpg",
        };
        team.avatar = avatarMap[team.team_name] || "/default-avatar.png";
      }

      // Set color if not exists
      if (!team.color) {
        team.color = team.color || "gray";
      }
    });

    // Sort by points and update ranks
    teams.value.sort((a, b) => b.total_points - a.total_points);
    teams.value.forEach((t, index) => {
      t.rank = index + 1;
    });
  };

  const initializeData = async () => {
    await Promise.all([fetchEvents(), fetchPoints(), fetchTeams()]);
  };

  const setupRealtime = () => {
    subscribeToEvents((payload) => {
      console.log("Realtime event:", payload);
      if (payload.eventType === "INSERT") {
        events.value.unshift(payload.new);
      } else if (payload.eventType === "UPDATE") {
        const index = events.value.findIndex(
          (event) => event.id === payload.new.id,
        );
        if (index !== -1) {
          events.value[index] = payload.new;
        }
      } else if (payload.eventType === "DELETE") {
        events.value = events.value.filter(
          (event) => event.id !== payload.old.id,
        );
      }
    });
  };

  const addTeam = async (teamData) => {
    try {
      const { createTeam } = await import("@/utils/supabase.js");
      await createTeam(teamData);
      await fetchTeams();
    } catch (error) {
      console.error("Error adding team:", error);
      throw error;
    }
  };

  return {
    // State
    events,
    teams,
    points,
    loading,
    sports,

    // Computed
    topThree,
    fullLeaderboard,
    totalParticipants,
    activeMatches,
    sortedTeams,

    // Actions
    updateScore,
    addRecentForm,
    addMedal,
    fetchEvents,
    fetchPoints,
    fetchTeams,
    initializeData,
    calculatePointsFromMedals,
    updateTeamPointsFromMedals,
    setupRealtime,
    addTeam,
  };
});
