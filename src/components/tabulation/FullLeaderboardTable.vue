<template>
  <div class="fade-in">
    <!-- Table Header -->
    <div class="mb-6 flex items-center justify-between">
      <div>
        <h3 class="text-xl font-bold" style="color: var(--color-light)">
          Full Leaderboard
        </h3>
        <p class="text-sm mt-1" style="color: var(--color-secondary)">
          {{ totalParticipants }} Participants
        </p>
      </div>
      <div class="flex items-center space-x-2">
        <button class="btn-secondary">
          <svg
            class="w-4 h-4 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
            ></path>
          </svg>
          Export
        </button>
      </div>
    </div>

    <!-- Table -->
    <div class="table-modern">
      <table class="w-full">
        <thead class="table-header">
          <tr>
            <th
              class="px-6 py-4 text-left text-xs font-medium uppercase tracking-wider"
              style="color: var(--color-secondary)"
            >
              Rank
            </th>
            <th
              class="px-6 py-4 text-left text-xs font-medium uppercase tracking-wider"
              style="color: var(--color-secondary)"
            >
              Player/Team
            </th>
            <th
              class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
              style="color: var(--color-secondary)"
            >
              Record (W-L)
            </th>
            <th
              class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
              style="color: var(--color-secondary)"
            >
              Points
            </th>
            <th
              class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
              style="color: var(--color-secondary)"
            >
              Recent Form
            </th>
            <th
              class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
              style="color: var(--color-secondary)"
            >
              Actions
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(participant, index) in leaderboardData"
            :key="participant.id"
            class="table-row"
          >
            <!-- Rank -->
            <td class="table-cell">
              <div class="flex items-center">
                <span
                  :class="[
                    'font-bold text-lg',
                    participant.rank <= 3 ? 'pixel-glow' : '',
                  ]"
                  :style="
                    participant.rank <= 3
                      ? 'color: var(--color-primary);'
                      : 'color: var(--color-light);'
                  "
                >
                  #{{ participant.rank }}
                </span>
                <div v-if="participant.rank <= 3" class="ml-2">
                  <span v-if="participant.rank === 1" class="text-xl">🥇</span>
                  <span v-else-if="participant.rank === 2" class="text-xl"
                    >🥈</span
                  >
                  <span v-else-if="participant.rank === 3" class="text-xl"
                    >🥉</span
                  >
                </div>
              </div>
            </td>

            <!-- Player/Team -->
            <td class="table-cell">
              <div class="flex items-center">
                <div
                  class="w-10 h-10 rounded-full flex items-center justify-center text-lg border-2 shadow-sm"
                  style="
                    background: linear-gradient(
                      135deg,
                      var(--color-primary) 0%,
                      var(--color-secondary) 100%
                    );
                    border-color: var(--color-primary);
                  "
                >
                  {{ participant.avatar }}
                </div>
                <div class="ml-4">
                  <div
                    class="text-sm font-medium"
                    style="color: var(--color-light)"
                  >
                    {{ participant.name }}
                  </div>
                  <div class="text-xs" style="color: var(--color-secondary)">
                    ID: {{ participant.id }}
                  </div>
                </div>
              </div>
            </td>

            <!-- Record -->
            <td class="table-cell text-center">
              <div class="flex items-center justify-center space-x-2">
                <span class="badge badge-success"
                  >{{ participant.record.wins }}W</span
                >
                <span style="color: var(--color-secondary)">-</span>
                <span class="badge badge-danger"
                  >{{ participant.record.losses }}L</span
                >
              </div>
            </td>

            <!-- Points -->
            <td class="table-cell text-center">
              <span
                class="text-lg font-bold"
                style="color: var(--color-light)"
                >{{ formatPoints(participant.points) }}</span
              >
            </td>

            <!-- Recent Form -->
            <td class="table-cell">
              <div class="flex justify-center space-x-1">
                <div
                  v-for="(result, i) in participant.recentForm"
                  :key="i"
                  :class="[
                    'w-8 h-8 flex items-center justify-center border text-xs font-bold',
                    result === 'W' ? 'badge-success' : 'badge-danger',
                  ]"
                >
                  {{ result }}
                </div>
              </div>
            </td>

            <!-- Actions -->
            <td class="table-cell text-center">
              <div class="flex justify-center space-x-2">
                <button class="btn-primary text-sm">Follow</button>
                <button
                  class="p-2 transition-colors"
                  style="color: var(--color-secondary)"
                  onmouseover="this.style.color = 'var(--color-light)'"
                  onmouseout="this.style.color = 'var(--color-secondary)'"
                >
                  <svg
                    class="w-4 h-4"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
                    ></path>
                  </svg>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- User's Rank -->
    <div
      class="mt-6 p-6 border-2 pixel-glow"
      style="
        background: linear-gradient(
          135deg,
          var(--color-dark) 0%,
          var(--color-surface) 100%
        );
        border-color: var(--color-primary);
      "
    >
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-4">
          <div
            class="w-12 h-12 rounded-full flex items-center justify-center font-bold border-2 shadow-lg"
            style="
              background: linear-gradient(
                135deg,
                var(--color-primary) 0%,
                var(--color-primary-dark) 100%
              );
              border-color: var(--color-primary-dark);
              color: white;
            "
          >
            {{ currentUser.rank }}
          </div>
          <div>
            <p class="text-sm" style="color: var(--color-secondary)">
              Your Ranking
            </p>
            <p class="text-lg font-bold" style="color: var(--color-light)">
              {{ currentUser.name }}
            </p>
            <p class="text-sm" style="color: var(--color-secondary)">
              {{ formatPoints(currentUser.points) }} points
            </p>
          </div>
        </div>
        <button class="btn-primary">
          View Full Profile
          <svg
            class="w-4 h-4 ml-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 5l7 7-7 7"
            ></path>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { computed } from "vue";
import { useTournamentStore } from "../../stores/useTournamentStore.js";

export default {
  name: "FullLeaderboardTable",
  setup() {
    const tournamentStore = useTournamentStore();

    const leaderboardData = computed(() => tournamentStore.fullLeaderboard);
    const currentUser = computed(() => tournamentStore.currentUser);
    const totalParticipants = computed(() => tournamentStore.totalParticipants);

    const formatPoints = (points) => {
      return points.toLocaleString();
    };

    return {
      leaderboardData,
      currentUser,
      totalParticipants,
      formatPoints,
    };
  },
};
</script>
