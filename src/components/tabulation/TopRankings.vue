<template>
  <div class="fade-in">
    <div class="grid grid-cols-3 gap-6 mb-8 items-center">
      <!-- #1 Position (Bigger and Centered) -->
      <div
        class="card card-hover p-8 relative overflow-hidden pixel-glow transform scale-110"
        style="
          background: linear-gradient(
            135deg,
            var(--color-primary) 0%,
            var(--color-primary-dark) 100%
          );
          grid-row: 1;
          grid-column: 2;
        "
      >
        <!-- Winner Crown -->
        <div
          class="absolute -top-2 -right-2 w-16 h-16 rounded-full flex items-center justify-center shadow-xl border-2"
          style="
            background: var(--color-light);
            border-color: var(--color-primary-dark);
          "
        >
          <span class="text-3xl">🥇</span>
        </div>

        <div class="text-center">
          <div class="flex justify-center mb-6">
            <div
              class="w-24 h-24 rounded-full flex items-center justify-center text-4xl border-4 shadow-xl"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
              "
            >
              {{ topThree[0].avatar }}
            </div>
          </div>
          <div class="mb-3">
            <span
              class="inline-block px-4 py-2 rounded-full text-lg font-bold border-2"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
                color: white;
              "
              >1ST PLACE</span
            >
          </div>
          <div class="font-bold text-2xl mb-3" style="color: white">
            {{ topThree[0].name }}
          </div>
          <div class="text-3xl font-bold mb-6" style="color: white">
            {{ formatPoints(topThree[0].points) }}
          </div>
          <div class="flex items-center justify-center space-x-3">
            <span
              class="inline-flex items-center px-3 py-2 rounded text-lg font-bold border"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
                color: white;
              "
              >{{ topThree[0].record.wins }}W</span
            >
            <span
              class="inline-flex items-center px-3 py-2 rounded text-lg font-bold border"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
                color: white;
              "
              >{{ topThree[0].record.losses }}L</span
            >
          </div>
        </div>
      </div>

      <!-- #2 Position -->
      <div
        class="card card-hover p-6 relative overflow-hidden"
        style="
          background: linear-gradient(
            135deg,
            var(--color-secondary) 0%,
            var(--color-accent) 100%
          );
        "
      >
        <!-- Silver Medal -->
        <div
          class="absolute -top-2 -right-2 w-12 h-12 rounded-full flex items-center justify-center shadow-lg border-2"
          style="
            background: var(--color-light);
            border-color: var(--color-accent);
          "
        >
          <span class="text-2xl">🥈</span>
        </div>

        <div class="text-center">
          <div class="flex justify-center mb-4">
            <div
              class="w-16 h-16 rounded-full flex items-center justify-center text-2xl border-3 shadow-lg"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
              "
            >
              {{ topThree[1].avatar }}
            </div>
          </div>
          <div class="mb-2">
            <span
              class="inline-block px-3 py-1 rounded-full text-sm font-bold border-2"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
                color: white;
              "
              >2ND PLACE</span
            >
          </div>
          <div class="font-bold text-lg mb-2" style="color: white">
            {{ topThree[1].name }}
          </div>
          <div class="text-xl font-bold mb-4" style="color: white">
            {{ formatPoints(topThree[1].points) }}
          </div>
          <div class="flex items-center justify-center space-x-2">
            <span
              class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
                color: white;
              "
              >{{ topThree[1].record.wins }}W</span
            >
            <span
              class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-light);
                color: white;
              "
              >{{ topThree[1].record.losses }}L</span
            >
          </div>
        </div>
      </div>

      <!-- #3 Position -->
      <div
        class="card card-hover p-6 relative overflow-hidden"
        style="
          background: linear-gradient(
            135deg,
            var(--color-light) 0%,
            var(--color-primary) 100%
          );
        "
      >
        <!-- Bronze Medal -->
        <div
          class="absolute -top-2 -right-2 w-12 h-12 rounded-full flex items-center justify-center shadow-lg border-2"
          style="
            background: var(--color-primary);
            border-color: var(--color-primary-dark);
          "
        >
          <span class="text-2xl">🥉</span>
        </div>

        <div class="text-center">
          <div class="flex justify-center mb-4">
            <div
              class="w-16 h-16 rounded-full flex items-center justify-center text-2xl border-3 shadow-lg"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-primary);
              "
            >
              {{ topThree[2].avatar }}
            </div>
          </div>
          <div class="mb-2">
            <span
              class="inline-block px-3 py-1 rounded-full text-sm font-bold border-2"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-primary);
                color: white;
              "
              >3RD PLACE</span
            >
          </div>
          <div class="font-bold text-lg mb-2" style="color: white">
            {{ topThree[2].name }}
          </div>
          <div class="text-xl font-bold mb-4" style="color: white">
            {{ formatPoints(topThree[2].points) }}
          </div>
          <div class="flex items-center justify-center space-x-2">
            <span
              class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-primary);
                color: white;
              "
              >{{ topThree[2].record.wins }}W</span
            >
            <span
              class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
              style="
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(4px);
                border-color: var(--color-primary);
                color: white;
              "
              >{{ topThree[2].record.losses }}L</span
            >
          </div>
        </div>
      </div>
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
