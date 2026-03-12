<template>
  <div class="min-h-screen" style="background: var(--color-background)">
    <!-- Header -->
    <header
      class="border-b-2"
      style="
        background: var(--color-surface);
        border-color: var(--color-border);
      "
    >
      <div class="px-6 py-4">
        <div class="flex items-center justify-between">
          <!-- Logo and Title -->
          <div class="flex items-center space-x-4">
            <div
              class="w-12 h-12 flex items-center justify-center shadow-lg border-2 pixel-glow"
              style="
                background: linear-gradient(
                  135deg,
                  var(--color-primary) 0%,
                  var(--color-primary-dark) 100%
                );
                border-color: var(--color-primary-dark);
              "
            >
              <span class="text-white text-2xl font-bold">🏆</span>
            </div>
            <div>
              <h1 class="text-xl font-bold" style="color: var(--color-light)">
                Manager Dashboard
              </h1>
              <p class="text-sm" style="color: var(--color-secondary)">
                DAUG 2026 Tabulation System
              </p>
            </div>
          </div>

          <!-- User Menu -->
          <div class="flex items-center space-x-4">
            <div class="text-right">
              <p class="text-sm font-medium" style="color: var(--color-light)">
                {{ authStore.fullName }}
              </p>
              <p class="text-xs" style="color: var(--color-secondary)">
                {{ authStore.userRole.toUpperCase() }}
              </p>
            </div>
            <button @click="handleLogout" class="btn-secondary">
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
                  d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
                ></path>
              </svg>
              Logout
            </button>
          </div>
        </div>
      </div>
    </header>

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
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore.js";
import ManageAccounts from "./tabs/ManageAccounts.vue";
import LiveEvents from "./tabs/LiveEvents.vue";
import TabulationControl from "./tabs/TabulationControl.vue";

const router = useRouter();
const authStore = useAuthStore();

// State
const activeTab = ref("accounts");

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
