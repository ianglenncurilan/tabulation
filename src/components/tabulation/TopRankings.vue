<template>
  <div class="fade-in">
    <div
      v-if="topThree.length >= 3"
      class="grid grid-cols-3 gap-4 mb-6 items-center"
    >
      <!-- #1 Position (Bigger and Centered) -->
      <div
        class="card card-hover p-6 relative overflow-hidden transform scale-105 floating-card winner-card"
        style="
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.2);
          grid-row: 1;
          grid-column: 2;
          animation: float-winner 3s ease-in-out infinite;
        "
      >
        <!-- Winner Crown -->
        <div
          class="absolute -top-1 -right-1 w-10 h-10 rounded-full flex items-center justify-center shadow-xl border-2 crown-glow"
          style="
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            animation: pulse-glow 2s ease-in-out infinite;
          "
        >
          <span class="text-2xl">🥇</span>
        </div>

        <div class="text-center">
          <div class="flex justify-center mb-4">
            <div
              class="w-20 h-20 rounded-full overflow-hidden border-4 shadow-xl avatar-float"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: rgba(255, 255, 255, 0.5);
                animation: float-avatar 4s ease-in-out infinite;
              "
            >
              <img
                :src="topThree[0]?.avatar || '/default-avatar.png'"
                :alt="topThree[0]?.team_name || 'Team'"
                class="w-full h-full object-cover"
              />
            </div>
          </div>
          <div class="mb-3">
            <span
              class="inline-block px-4 py-2 rounded-full text-lg font-bold border-2"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: rgba(255, 255, 255, 0.5);
                color: white;
              "
              >1ST PLACE</span
            >
          </div>
          <div class="font-bold text-2xl mb-3" style="color: white">
            {{ topThree[0]?.team_name || "Team" }}
          </div>
          <div class="text-3xl font-bold mb-6" style="color: white">
            {{ formatPoints(topThree[0]?.total_points || 0) }}
          </div>
        </div>
      </div>

      <!-- #2 Position (Medium Size) -->
      <div
        class="card card-hover p-4 relative overflow-hidden floating-card second-card"
        style="
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.2);
          animation: float-second 3.5s ease-in-out infinite;
          animation-delay: 0.5s;
        "
      >
        <!-- Silver Medal -->
        <div
          class="absolute -top-1 -right-1 w-9 h-9 rounded-full flex items-center justify-center shadow-lg border-2 medal-glow"
          style="
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            animation: pulse-glow 2.5s ease-in-out infinite;
          "
        >
          <span class="text-xl">🥈</span>
        </div>

        <div class="text-center">
          <div class="flex justify-center mb-3">
            <div
              class="w-16 h-16 rounded-full overflow-hidden border-3 shadow-lg avatar-float"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: rgba(255, 255, 255, 0.5);
                animation: float-avatar 4.5s ease-in-out infinite;
                animation-delay: 0.3s;
              "
            >
              <img
                :src="topThree[1]?.avatar || '/default-avatar.png'"
                :alt="topThree[1]?.team_name || 'Team'"
                class="w-full h-full object-cover"
              />
            </div>
          </div>
          <div class="mb-2">
            <span
              class="inline-block px-3 py-1.5 rounded-full text-md font-bold border-2"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: rgba(255, 255, 255, 0.5);
                color: white;
              "
              >2ND PLACE</span
            >
          </div>
          <div class="font-bold text-xl mb-2" style="color: white">
            {{ topThree[1]?.team_name || "Team" }}
          </div>
          <div class="text-2xl font-bold mb-3" style="color: white">
            {{ formatPoints(topThree[1]?.total_points || 0) }}
          </div>
        </div>
      </div>

      <!-- #3 Position -->
      <div
        class="card card-hover p-2 relative overflow-hidden floating-card third-card"
        style="
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.2);
          animation: float-third 4s ease-in-out infinite;
          animation-delay: 1s;
        "
      >
        <!-- Bronze Medal -->
        <div
          class="absolute -top-1 -right-1 w-8 h-8 rounded-full flex items-center justify-center shadow-lg border-2 medal-glow"
          style="
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            animation: pulse-glow 3s ease-in-out infinite;
          "
        >
          <span class="text-lg">🥉</span>
        </div>

        <div class="text-center">
          <div class="flex justify-center mb-2">
            <div
              class="w-12 h-12 rounded-full overflow-hidden border-2 shadow-lg avatar-float"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: rgba(255, 255, 255, 0.5);
                animation: float-avatar 5s ease-in-out infinite;
                animation-delay: 0.7s;
              "
            >
              <img
                :src="topThree[2]?.avatar || '/default-avatar.png'"
                :alt="topThree[2]?.team_name || 'Team'"
                class="w-full h-full object-cover"
              />
            </div>
          </div>
          <div class="mb-1">
            <span
              class="inline-block px-2 py-1 rounded-full text-xs font-bold border-2"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: rgba(255, 255, 255, 0.5);
                color: white;
              "
              >3RD PLACE</span
            >
          </div>
          <div class="font-bold text-sm mb-1" style="color: white">
            {{ topThree[2]?.team_name || "Team" }}
          </div>
          <div class="text-lg font-bold mb-2" style="color: white">
            {{ formatPoints(topThree[2]?.total_points || 0) }}
          </div>
        </div>
      </div>
    </div>

    <!-- Fallback when no teams are available -->
    <div v-else class="text-center py-12">
      <div class="text-6xl mb-4">🏆</div>
      <h3 class="text-2xl font-bold mb-2" style="color: var(--color-light)">
        No Teams Yet
      </h3>
      <p style="color: var(--color-secondary)">
        Teams will appear here once they're added to the tournament.
      </p>
    </div>
  </div>
</template>

<script>
import { computed } from "vue";
import { useTournamentStore } from "../../stores/useTournamentStore.js";

export default {
  name: "TopRankings",
  setup() {
    const tournamentStore = useTournamentStore();

    const topThree = computed(() => tournamentStore.topThree);

    const formatPoints = (points) => {
      return points.toLocaleString();
    };

    return {
      topThree,
      formatPoints,
    };
  },
};
</script>

<style scoped>
.floating-card {
  transition: all 0.3s ease;
  transform-style: preserve-3d;
  perspective: 1000px;
}

.floating-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

.winner-card:hover {
  transform: translateY(-12px) scale(1.05) rotateX(2deg);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
}

.second-card:hover {
  transform: translateY(-10px) scale(1.03) rotateX(1deg);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.35);
}

.third-card:hover {
  transform: translateY(-6px) scale(1.02);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
}

.avatar-float {
  transition: all 0.3s ease;
}

.avatar-float:hover {
  transform: scale(1.1) rotate(5deg);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
}

.crown-glow:hover {
  transform: scale(1.2) rotate(10deg);
  filter: brightness(1.3);
}

.medal-glow:hover {
  transform: scale(1.15) rotate(-5deg);
  filter: brightness(1.2);
}

@keyframes float-winner {
  0%,
  100% {
    transform: translateY(0px) scale(1.05);
  }
  50% {
    transform: translateY(-10px) scale(1.05);
  }
}

@keyframes float-second {
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-8px);
  }
}

@keyframes float-third {
  0%,
  100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-6px);
  }
}

@keyframes float-avatar {
  0%,
  100% {
    transform: translateY(0px) rotate(0deg);
  }
  25% {
    transform: translateY(-3px) rotate(2deg);
  }
  75% {
    transform: translateY(-3px) rotate(-2deg);
  }
}

@keyframes pulse-glow {
  0%,
  100% {
    box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
  }
  50% {
    box-shadow: 0 0 20px rgba(255, 255, 255, 0.8);
  }
}
</style>
