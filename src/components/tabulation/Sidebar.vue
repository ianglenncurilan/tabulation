<template>
  <aside class="space-y-6">
    <!-- Sports Section -->
    <div class="card card-hover p-6">
      <h3
        class="text-lg font-semibold mb-4 flex items-center"
        style="color: var(--color-light)"
      >
        <svg
          class="w-5 h-5 mr-2"
          style="color: var(--color-primary)"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M13 10V3L4 14h7v7l9-11h-7z"
          ></path>
        </svg>
        Sports
      </h3>
      <div class="space-y-3">
        <div
          v-for="sport in sports"
          :key="sport.id"
          class="flex items-center justify-between p-3 border-2 rounded transition-all duration-200 cursor-pointer"
          style="border-color: var(--color-border)"
          onmouseover="this.style.borderColor = 'var(--color-primary)'"
          onmouseout="this.style.borderColor = 'var(--color-border)'"
        >
          <div class="flex items-center space-x-3">
            <span class="text-2xl">{{ sport.icon }}</span>
            <span class="font-medium" style="color: var(--color-light)">{{
              sport.name
            }}</span>
          </div>
          <div v-if="sport.active" class="flex items-center">
            <svg
              class="w-5 h-5"
              style="color: var(--color-primary)"
              fill="currentColor"
              viewBox="0 0 20 20"
            >
              <path
                fill-rule="evenodd"
                d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                clip-rule="evenodd"
              ></path>
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Active Matches -->
    <div class="card card-hover p-6">
      <h3
        class="text-lg font-semibold mb-4 flex items-center"
        style="color: var(--color-light)"
      >
        <svg
          class="w-5 h-5 mr-2"
          style="color: var(--color-primary-dark)"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
          ></path>
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
          ></path>
        </svg>
        Active Matches
      </h3>
      <div class="space-y-3">
        <div
          v-for="match in activeMatches"
          :key="match.id"
          class="p-4 border-2 rounded"
          style="
            background: var(--color-dark);
            border-color: var(--color-border);
          "
        >
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center space-x-2">
              <div
                class="w-2 h-2 rounded-full animate-pulse pixel-glow"
                style="background: var(--color-primary-dark)"
              ></div>
              <span class="badge badge-success">LIVE</span>
            </div>
            <span class="text-xs" style="color: var(--color-secondary)">{{
              match.sport
            }}</span>
          </div>
          <div class="space-y-2">
            <div class="flex justify-between items-center">
              <span
                class="text-sm font-medium"
                style="color: var(--color-light)"
                >{{ match.teams.split(" vs ")[0] }}</span
              >
              <span
                class="text-lg font-bold"
                style="color: var(--color-primary)"
                >{{ match.score.split("-")[0] }}</span
              >
            </div>
            <div class="flex justify-between items-center">
              <span
                class="text-sm font-medium"
                style="color: var(--color-light)"
                >{{ match.teams.split(" vs ")[1] }}</span
              >
              <span
                class="text-lg font-bold"
                style="color: var(--color-primary)"
                >{{ match.score.split("-")[1] }}</span
              >
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div
      class="card p-6 pixel-glow"
      style="
        background: linear-gradient(
          135deg,
          var(--color-dark) 0%,
          var(--color-surface) 100%
        );
      "
    >
      <h3 class="text-lg font-semibold mb-4" style="color: var(--color-light)">
        Quick Stats
      </h3>
      <div class="space-y-3">
        <div class="flex justify-between items-center">
          <span class="text-sm" style="color: var(--color-secondary)"
            >Total Participants</span
          >
          <span class="font-semibold" style="color: var(--color-light)">{{
            totalParticipants
          }}</span>
        </div>
        <div class="flex justify-between items-center">
          <span class="text-sm" style="color: var(--color-secondary)"
            >Active Sports</span
          >
          <span class="font-semibold" style="color: var(--color-light)">{{
            activeSportsCount
          }}</span>
        </div>
        <div class="flex justify-between items-center">
          <span class="text-sm" style="color: var(--color-secondary)"
            >Live Matches</span
          >
          <span class="font-semibold" style="color: var(--color-primary)">{{
            activeMatches.length
          }}</span>
        </div>
      </div>
    </div>
  </aside>
</template>

<script>
import { computed } from "vue";
import { useTournamentStore } from "../../stores/useTournamentStore.js";

export default {
  name: "Sidebar",
  setup() {
    const tournamentStore = useTournamentStore();

    const sports = computed(() => tournamentStore.sports);
    const activeMatches = computed(() => tournamentStore.activeMatches);
    const totalParticipants = computed(() => tournamentStore.totalParticipants);
    const activeSportsCount = computed(
      () => sports.value.filter((s) => s.active).length,
    );

    return {
      sports,
      activeMatches,
      totalParticipants,
      activeSportsCount,
    };
  },
};
</script>
