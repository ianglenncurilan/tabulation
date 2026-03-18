<template>
  <div class="min-h-screen" style="background: var(--color-background)">
    <!-- Tournament Overview -->
    <div class="px-6 py-4">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <!-- Total Points -->
        <div class="card p-4">
          <div class="flex items-center justify-between">
            <div>
              <p
                class="text-sm font-medium"
                style="color: var(--color-secondary)"
              >
                Total Points Awarded
              </p>
              <p class="text-2xl font-bold" style="color: var(--color-light)">
                {{ totalPointsAwarded.toLocaleString() }}
              </p>
            </div>
            <div
              class="w-12 h-12 rounded-full flex items-center justify-center"
              style="background: var(--color-primary)"
            >
              <svg
                class="w-6 h-6 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                ></path>
              </svg>
            </div>
          </div>
        </div>

        <!-- Total Medals -->
        <div class="card p-4">
          <div class="flex items-center justify-between">
            <div>
              <p
                class="text-sm font-medium"
                style="color: var(--color-secondary)"
              >
                Total Medals Awarded
              </p>
              <div class="flex items-center space-x-2 mt-2">
                <div class="text-center">
                  <div
                    class="text-2xl font-bold"
                    style="color: var(--color-light)"
                  >
                    {{ totalMedals.gold }}
                  </div>
                  <div class="text-xs" style="color: var(--color-secondary)">
                    Gold
                  </div>
                </div>
                <div class="text-center">
                  <div
                    class="text-2xl font-bold"
                    style="color: var(--color-light)"
                  >
                    {{ totalMedals.silver }}
                  </div>
                  <div class="text-xs" style="color: var(--color-secondary)">
                    Silver
                  </div>
                </div>
                <div class="text-center">
                  <div
                    class="text-2xl font-bold"
                    style="color: var(--color-light)"
                  >
                    {{ totalMedals.bronze }}
                  </div>
                  <div class="text-xs" style="color: var(--color-secondary)">
                    Bronze
                  </div>
                </div>
              </div>
            </div>
            <div
              class="w-12 h-12 rounded-full flex items-center justify-center"
              style="background: var(--color-accent)"
            >
              <svg
                class="w-6 h-6 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12l2 2 4-4m6 2a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v5a2 2 0 002 2h2a2 2 0 002-2M9 19a3 3 0 100-6 3 3 0 000 6z"
                ></path>
              </svg>
            </div>
          </div>
        </div>

        <!-- Active Events -->
        <div class="card p-4">
          <div class="flex items-center justify-between">
            <div>
              <p
                class="text-sm font-medium"
                style="color: var(--color-secondary)"
              >
                Active Events
              </p>
              <p class="text-2xl font-bold" style="color: var(--color-light)">
                {{ activeEventsCount }}
              </p>
            </div>
            <div
              class="w-12 h-12 rounded-full flex items-center justify-center"
              style="background: var(--color-primary-dark)"
            >
              <svg
                class="w-6 h-6 text-white"
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
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="px-6 py-8">
      <!-- Tab Navigation -->
      <div class="mb-8">
        <nav
          class="flex space-x-1 border-2 rounded-lg p-1"
          style="
            background: var(--color-dark);
            border-color: var(--color-border);
          "
        >
          <button
            v-for="tab in tabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            :class="[
              'px-4 py-2 rounded-md text-sm font-medium transition-all duration-200',
              activeTab === tab.id
                ? 'text-white shadow-lg'
                : 'text-secondary hover:text-light',
            ]"
            :style="
              activeTab === tab.id
                ? 'background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);'
                : ''
            "
          >
            <svg
              class="w-4 h-4 mr-2 inline"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                :d="tab.icon"
              ></path>
            </svg>
            {{ tab.name }}
          </button>
        </nav>
      </div>

      <!-- Tab Content -->
      <div class="fade-in">
        <!-- Manage Accounts Tab -->
        <div v-if="activeTab === 'accounts'">
          <ManageAccounts />
        </div>

        <!-- Live Events Tab -->
        <div v-if="activeTab === 'events'">
          <LiveEvents />
        </div>

        <!-- Tabulation Tab -->
        <div v-if="activeTab === 'tabulation'">
          <TabulationControl />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore.js";
import { useTournamentStore } from "@/stores/useTournamentStore.js";
import ManageAccounts from "./tabs/ManageAccounts.vue";
import LiveEvents from "./tabs/LiveEvents.vue";
import TabulationControl from "./tabs/TabulationControl.vue";

const router = useRouter();
const authStore = useAuthStore();
const tournamentStore = useTournamentStore();

// State
const activeTab = ref("tabulation");

// Computed Properties
const totalPointsAwarded = computed(() => {
  return tournamentStore.teams.reduce(
    (total, team) => total + (team.total_points || 0),
    0,
  );
});

const totalMedals = computed(() => {
  return tournamentStore.teams.reduce(
    (total, team) => {
      total.gold += team.gold_medals || 0;
      total.silver += team.silver_medals || 0;
      total.bronze += team.bronze_medals || 0;
      return total;
    },
    { gold: 0, silver: 0, bronze: 0 },
  );
});

const activeEventsCount = computed(() => {
  return tournamentStore.events.filter((event) => event.is_live).length;
});

const tabs = [
  {
    id: "accounts",
    name: "Manage Accounts",
    icon: "M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z",
  },
  {
    id: "events",
    name: "Live Events",
    icon: "M13 10V3L4 14h7v7l9-11h-7z",
  },
  {
    id: "tabulation",
    name: "Tabulation",
    icon: "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z",
  },
];

// Methods
const handleLogout = async () => {
  await authStore.logout();
  router.push("/manager/auth");
};

// Lifecycle
onMounted(() => {
  // Check if user is authenticated and is a manager
  if (!authStore.isAuthenticated || !authStore.isManager) {
    router.push("/manager/auth");
  }
});
</script>
