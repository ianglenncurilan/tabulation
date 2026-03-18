<template>
  <div class="min-h-screen" style="background: var(--color-background)">
    <!-- DAUG Logo Header -->
    <div v-show="uiStore.showDashboardInfo" class="logo-header">
      <img src="/LOGO wreck.png" alt="DAUG 2026 Logo" class="daug-logo" />
    </div>

    <!-- Main Content -->
    <div class="main-content">
      <!-- Main Dashboard Area -->
      <main class="dashboard-main">
        <!-- Top Rankings (Integrated) -->
        <div v-show="uiStore.showDashboardInfo" class="fade-in">
          <TopRankings />
        </div>

        <!-- Animated Leaderboard -->
        <div class="fade-in">
          <AnimatedLeaderboard />
        </div>
      </main>
    </div>
  </div>
</template>

<script>
import { defineStore } from "pinia";
import { ref, computed, onMounted, onUnmounted } from "vue";
import { useTournamentStore } from "@/stores/useTournamentStore.js";
import { useUIStore } from "@/stores/useUIStore.js";
import AnimatedLeaderboard from "@/components/AnimatedLeaderboard.vue";
import TopRankings from "@/components/tabulation/TopRankings.vue";

export default {
  name: "Dashboard",
  components: {
    AnimatedLeaderboard,
    TopRankings,
  },
  setup() {
    const tournamentStore = useTournamentStore();
    const uiStore = useUIStore();
    const searchQuery = ref("");

    // Initialize data on mount
    onMounted(() => {
      console.log("DashboardView mounted - initializing data");
      tournamentStore.initializeData();
      tournamentStore.setupRealtime();
    });

    onUnmounted(() => {
      // Cleanup if needed
    });

    // Top Rankings data
    const topThree = computed(() => {
      const teams = tournamentStore.teams || [];
      return teams.slice(0, 3);
    });

    // Full Leaderboard data
    const leaderboardData = computed(() => {
      const teams = tournamentStore.teams || [];
      return teams.map((team, index) => ({
        ...team,
        rank: index + 1,
        name: team.team_name,
        points: team.total_points || 0,
        medals: {
          gold: team.gold_medals || 0,
          silver: team.silver_medals || 0,
          bronze: team.bronze_medals || 0,
        },
        avatar: team.logo_url || "/default-avatar.png",
        color: team.color || "blue",
      }));
    });
    const currentUser = computed(() => tournamentStore.currentUser);

    // Utility functions
    const formatPoints = (points) => {
      return points.toLocaleString();
    };

    const formatDate = (dateString) => {
      return new Date(dateString).toLocaleDateString("en-US", {
        month: "short",
        day: "numeric",
        year: "numeric",
      });
    };

    const formatTime = (timeString) => {
      return new Date(`1970-01-01T${timeString}`).toLocaleTimeString("en-US", {
        hour: "2-digit",
        minute: "2-digit",
      });
    };

    const getTeamColor = (colorName) => {
      const colors = {
        blue: "#3B82F6",
        peach: "#FFB599",
        red: "#EF4444",
        green: "#10B981",
        yellow: "#F59E0B",
        purple: "#8B5CF6",
        orange: "#F97316",
        pink: "#EC4899",
        gray: "#6B7280",
      };
      return colors[colorName] || "#6B7280";
    };

    return {
      // UI Store
      uiStore,

      // Search
      searchQuery,

      // Top Rankings
      topThree,

      // Full Leaderboard
      leaderboardData,
      currentUser,

      // Utilities
      formatPoints,
      formatDate,
      formatTime,
      getTeamColor,
    };
  },
};
</script>

<style scoped>
/* DAUG Logo Header */
.logo-header {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1.5rem 1rem;
  text-align: center;
}

.daug-logo {
  width: 250px;
  height: 120px;
  object-fit: contain;
  filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.3));
  transition: transform 0.3s ease;
}

.daug-logo:hover {
  transform: scale(1.05);
}

/* Main Content Layout */
.main-content {
  padding: 2rem 1.5rem;
  max-width: 1400px;
  margin: 0 auto;
}

/* Main Dashboard Area */
.dashboard-main {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .main-content {
    padding: 1.5rem 1rem;
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 1rem 0.75rem;
  }

  .dashboard-main {
    gap: 1rem;
  }
}

/* Animations */
@keyframes pulse {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

/* Fade-in animation */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.6s ease-out;
}
</style>
