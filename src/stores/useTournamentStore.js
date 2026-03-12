import { defineStore } from "pinia";
import { ref, computed } from "vue";
import {
  getEvents,
  getScores,
  getParticipants,
  subscribeToEvents,
} from "@/utils/supabase.js";

export const useTournamentStore = defineStore("tournament", () => {
  // Dynamic data from Supabase
  const participants = ref([]);
  const sports = ref([
    { id: 1, name: "Flag Football", icon: "🏈", active: true },
    { id: 2, name: "Basketball", icon: "🏀", active: true },
    { id: 3, name: "Volleyball", icon: "🏐", active: false },
  ]);

  // Real data from Supabase
  const events = ref([]);
  const scores = ref([]);
  const loading = ref(false);

  // Computed properties
  const topThree = computed(() => participants.value.slice(0, 3));
  const fullLeaderboard = computed(() => participants.value.slice(0, 10)); // Show first 10 for demo
  const totalParticipants = computed(() => participants.value.length);

  // Computed active matches from real events
  const activeMatches = computed(() => {
    return events.value
      .filter((event) => event.is_live)
      .map((event) => {
        // Get scores for this event
        const eventScores = scores.value.filter(
          (score) => score.event_id === event.id,
        );

        // Create score string from teams
        let scoreString = "0-0";
        if (eventScores.length > 0) {
          scoreString = eventScores
            .map((score) => `${score.team_name}: ${score.score_value}`)
            .join(" | ");
        }

        return {
          id: event.id,
          sport: event.category === "sports" ? "Sports" : "Esports",
          teams: event.event_name,
          score: scoreString,
          status: "live",
          event_date: event.event_date,
          start_time: event.start_time,
        };
      });
  });

  // Actions
  const updateScore = (participantId, newPoints) => {
    const participant = participants.value.find((p) => p.id === participantId);
    if (participant) {
      participant.points = newPoints;
      // Re-sort participants by points
      participants.value.sort((a, b) => b.points - a.points);
      // Update ranks
      participants.value.forEach((p, index) => {
        p.rank = index + 1;
      });
    }
  };

  const addRecentForm = (participantId, result) => {
    const participant = participants.value.find((p) => p.id === participantId);
    if (participant) {
      participant.recentForm.pop(); // Remove oldest
      participant.recentForm.unshift(result); // Add newest
      if (result === "W") {
        participant.record.wins++;
      } else {
        participant.record.losses++;
      }
    }
  };

  const addMedal = (participantId, medalType) => {
    const participant = participants.value.find((p) => p.id === participantId);
    if (participant) {
      // Add medal
      participant.medals[medalType]++;

      // Add points based on medal type
      const medalPoints = {
        gold: 30,
        silver: 20,
        bronze: 10,
      };
      participant.points += medalPoints[medalType];

      // Update recent form
      participant.recentForm.pop(); // Remove oldest
      participant.recentForm.unshift("W"); // Add win

      // Re-sort participants by points
      participants.value.sort((a, b) => b.points - a.points);
      // Update ranks
      participants.value.forEach((p, index) => {
        p.rank = index + 1;
      });
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

  const fetchScores = async () => {
    try {
      loading.value = true;
      const data = await getScores();
      scores.value = data;
    } catch (error) {
      console.error("Error fetching scores:", error);
    } finally {
      loading.value = false;
    }
  };

  const fetchParticipants = async () => {
    try {
      loading.value = true;
      const data = await getParticipants();
      participants.value = data;
      // Calculate points from scores and medals
      updateParticipantPoints();
    } catch (error) {
      console.error("Error fetching participants:", error);
    } finally {
      loading.value = false;
    }
  };

  const updateParticipantPoints = () => {
    participants.value.forEach((participant) => {
      // Initialize medals and points if not exists
      if (!participant.medals) {
        participant.medals = { gold: 0, silver: 0, bronze: 0 };
      }
      if (!participant.points) {
        participant.points = 0;
      }

      // Set default values for avatar and color if not exists
      if (!participant.avatar) {
        const avatarMap = {
          "Information Technology": "/felix.jpg",
          "Information System": "/vanellope.jpg",
          "Computer Science": "/sgt.calhoun.jpg",
        };
        participant.avatar = avatarMap[participant.name] || "";
      }

      if (!participant.color) {
        const colorMap = {
          "Information Technology": "blue",
          "Information System": "peach",
          "Computer Science": "red",
        };
        participant.color = colorMap[participant.name] || "gray";
      }

      // Calculate medals and points from scores
      const participantScores = scores.value.filter(
        (score) => score.team_name === participant.name,
      );
      participantScores.forEach((score) => {
        if (score.medal_type) {
          participant.medals[score.medal_type]++;
          const medalPoints = { gold: 30, silver: 20, bronze: 10 };
          participant.points += medalPoints[score.medal_type];
        }
      });
    });

    // Sort by points and update ranks
    participants.value.sort((a, b) => b.points - a.points);
    participants.value.forEach((p, index) => {
      p.rank = index + 1;
    });
  };

  const initializeData = async () => {
    await Promise.all([fetchEvents(), fetchScores(), fetchParticipants()]);
  };

  // Setup realtime updates
  const setupRealtime = () => {
    subscribeToEvents((payload) => {
      console.log("Realtime event update:", payload);
      fetchEvents();
      fetchScores();
      fetchParticipants();
    });
  };

  return {
    participants,
    sports,
    activeMatches,
    events,
    scores,
    loading,
    currentUser: ref({
      id: 214,
      name: "@User_Self",
      points: 3120,
      rank: 214,
    }),
    topThree,
    fullLeaderboard,
    totalParticipants,
    updateScore,
    addMedal,
    fetchEvents,
    fetchScores,
    initializeData,
    setupRealtime,
  };
});
