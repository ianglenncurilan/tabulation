import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { getEvents, getScores, subscribeToEvents } from "@/utils/supabase.js";

export const useTournamentStore = defineStore("tournament", () => {
  // Sample data - in real app this would come from Supabase
  const participants = ref([
    {
      id: 1,
      name: "@CHEF_ANNA",
      points: 18240,
      rank: 1,
      record: { wins: 15, losses: 2 },
      recentForm: ["W", "W", "L", "W", "W"],
      avatar: "👨‍🍳",
    },
    {
      id: 2,
      name: "@TRAVELLER_BEN",
      points: 16110,
      rank: 2,
      record: { wins: 13, losses: 4 },
      recentForm: ["W", "L", "W", "W", "L"],
      avatar: "✈️",
    },
    {
      id: 3,
      name: "@PHOTO_SOPHIE",
      points: 14350,
      rank: 3,
      record: { wins: 12, losses: 5 },
      recentForm: ["L", "W", "W", "L", "W"],
      avatar: "📸",
    },
    {
      id: 4,
      name: "@Gamer_Alex",
      points: 12890,
      rank: 4,
      record: { wins: 11, losses: 6 },
      recentForm: ["W", "W", "W", "L", "L"],
      avatar: "🎮",
    },
    {
      id: 5,
      name: "@Urban_Art",
      points: 11560,
      rank: 5,
      record: { wins: 10, losses: 7 },
      recentForm: ["L", "W", "L", "W", "W"],
      avatar: "🎨",
    },
    {
      id: 6,
      name: "@Fit_Leo",
      points: 10230,
      rank: 6,
      record: { wins: 9, losses: 8 },
      recentForm: ["W", "L", "L", "W", "L"],
      avatar: "💪",
    },
    {
      id: 7,
      name: "@Reali_Nions",
      points: 9450,
      rank: 7,
      record: { wins: 8, losses: 9 },
      recentForm: ["L", "L", "W", "W", "L"],
      avatar: "🏆",
    },
    {
      id: 8,
      name: "@Ventoaloha",
      points: 8720,
      rank: 8,
      record: { wins: 7, losses: 10 },
      recentForm: ["W", "W", "L", "L", "W"],
      avatar: "🌺",
    },
    {
      id: 214,
      name: "@User_Self",
      points: 3120,
      rank: 214,
      record: { wins: 3, losses: 12 },
      recentForm: ["L", "L", "W", "L", "L"],
      avatar: "👤",
    },
  ]);

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

  const initializeData = async () => {
    await Promise.all([fetchEvents(), fetchScores()]);
  };

  // Setup realtime updates
  const setupRealtime = () => {
    subscribeToEvents((payload) => {
      console.log("Realtime event update:", payload);
      fetchEvents();
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
    addRecentForm,
    fetchEvents,
    fetchScores,
    initializeData,
    setupRealtime,
  };
});
