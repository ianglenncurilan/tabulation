<template>
  <div class="min-h-screen" style="background: var(--color-background)">
    <!-- Modern Pixel Header -->
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
          <div class="flex items-center space-x-2 ml-12">
            <div class="w-32 h-20 flex items-center justify-center">
              <img
                src="/LOGO wreck.png"
                alt="Wreck-It Ralph Logo"
                class="w-36 h-24 object-contain"
              />
            </div>
            <div>
              <h1 class="text-xl font-bold" style="color: var(--color-light)">
                DAUG 2026
              </h1>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- Page Title -->
    <div
      class="border-b-2"
      style="
        background: linear-gradient(
          135deg,
          var(--color-primary) 0%,
          var(--color-accent) 100%
        );
        border-color: var(--color-primary-dark);
      "
    ></div>

    <!-- Main Content -->
    <div class="px-8 py-12">
      <div class="flex gap-8">
        <!-- Sidebar (Integrated) -->
        <aside class="w-64 flex-shrink-0">
          <div class="space-y-4">
            <!-- Events Section -->
            <div class="card card-hover p-4">
              <h3
                class="text-sm font-semibold mb-3 flex items-center"
                style="color: var(--color-light)"
              >
                <svg
                  class="w-4 h-4 mr-2"
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
                Events
              </h3>
              <div class="space-y-2">
                <!-- Debug info -->
                <div class="text-xs" style="color: var(--color-secondary)">
                  Debug: {{ allEvents.length }} events total
                </div>
                <div
                  v-for="event in allEvents.slice(0, 5)"
                  :key="event.id"
                  class="flex items-center justify-between p-2 border rounded transition-all duration-200 cursor-pointer"
                  style="border-color: var(--color-border)"
                  @mouseover="
                    $event.target.style.borderColor = 'var(--color-primary)'
                  "
                  @mouseout="
                    $event.target.style.borderColor = 'var(--color-border)'
                  "
                >
                  <div class="flex items-center space-x-2">
                    <span class="text-lg">
                      {{ event.category === "sports" ? "🏆" : "🎮" }}
                    </span>
                    <div class="flex-1">
                      <div
                        class="text-xs font-medium"
                        style="color: var(--color-light)"
                      >
                        {{ event.event_name }}
                      </div>
                      <div
                        class="text-xs"
                        style="color: var(--color-secondary)"
                      >
                        {{ formatDate(event.event_date) }}
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center space-x-1">
                    <div v-if="event.is_live" class="flex items-center">
                      <div
                        class="w-1.5 h-1.5 rounded-full animate-pulse mr-1"
                        style="background: var(--color-primary-dark)"
                      ></div>
                      <span class="badge badge-success text-xs">LIVE</span>
                    </div>
                    <span
                      v-else
                      class="text-xs"
                      style="color: var(--color-secondary)"
                    >
                      {{ formatTime(event.start_time) }}
                    </span>
                  </div>
                </div>
                <div v-if="allEvents.length === 0" class="text-center py-2">
                  <span class="text-xs" style="color: var(--color-secondary)">
                    No events scheduled
                  </span>
                </div>
              </div>
            </div>

            <!-- Active Matches -->
            <div class="card card-hover p-4">
              <h3
                class="text-sm font-semibold mb-3 flex items-center"
                style="color: var(--color-light)"
              >
                <svg
                  class="w-4 h-4 mr-2"
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
              <div v-if="activeMatches.length > 0" class="space-y-2">
                <div
                  v-for="match in activeMatches"
                  :key="match.id"
                  class="p-3 border-2 rounded"
                  style="
                    background: var(--color-dark);
                    border-color: var(--color-border);
                  "
                >
                  <div class="flex items-center justify-between mb-2">
                    <div class="flex items-center space-x-2">
                      <div
                        class="w-2 h-2 rounded-full animate-pulse pixel-glow"
                        style="background: var(--color-primary-dark)"
                      ></div>
                      <span class="badge badge-success text-xs">LIVE</span>
                    </div>
                    <span
                      class="text-xs"
                      style="color: var(--color-secondary)"
                      >{{ match.sport }}</span
                    >
                  </div>
                  <div class="space-y-1">
                    <div class="flex justify-between items-center">
                      <span
                        class="text-xs font-medium"
                        style="color: var(--color-light)"
                        >{{ match.teams.split(" vs ")[0] }}</span
                      >
                      <span
                        class="text-sm font-bold"
                        style="color: var(--color-primary)"
                        >{{ match.score.split("-")[0] }}</span
                      >
                    </div>
                    <div class="flex justify-between items-center">
                      <span
                        class="text-xs font-medium"
                        style="color: var(--color-light)"
                        >{{ match.teams.split(" vs ")[1] }}</span
                      >
                      <span
                        class="text-sm font-bold"
                        style="color: var(--color-primary)"
                        >{{ match.score.split("-")[1] }}</span
                      >
                    </div>
                    <!-- Event Date and Time -->
                    <div
                      class="flex items-center text-xs"
                      style="color: var(--color-secondary)"
                    >
                      <svg
                        class="w-3 h-3 mr-1"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                        ></path>
                      </svg>
                      {{ formatDate(match.event_date) }} at
                      {{ formatTime(match.start_time) }}
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center py-4">
                <span class="text-xs" style="color: var(--color-secondary)">
                  No live events currently
                </span>
              </div>
            </div>

            <!-- Quick Stats -->
            <div
              class="card p-4 pixel-glow"
              style="
                background: linear-gradient(
                  135deg,
                  var(--color-dark) 0%,
                  var(--color-surface) 100%
                );
              "
            >
              <div class="text-center">
                <div
                  class="text-2xl font-bold mb-1"
                  style="color: var(--color-primary)"
                >
                  {{ activeMatches.length }}
                </div>
                <div
                  class="text-xs font-semibold mb-3"
                  style="color: var(--color-light)"
                >
                  Active Events
                </div>
                <div class="flex justify-between items-center">
                  <span class="text-sm" style="color: var(--color-secondary)"
                    >Live Matches</span
                  >
                  <span
                    class="font-semibold"
                    style="color: var(--color-primary)"
                    >{{ activeMatches.length }}</span
                  >
                </div>
                <div
                  class="text-xs text-center"
                  style="color: var(--color-secondary)"
                >
                  {{ totalParticipants }} Participants
                </div>
              </div>
            </div>
          </div>
        </aside>

        <!-- Main Dashboard Area -->
        <main class="flex-1 space-y-10">
          <!-- Top Rankings (Integrated) -->
          <div class="fade-in">
            <div class="grid grid-cols-3 gap-4 mb-6 items-center">
              <!-- #1 Position (Bigger and Centered) -->
              <div
                class="card card-hover p-4 relative overflow-hidden pixel-glow transform scale-105"
                :style="{
                  background: topThree[0]?.color
                    ? 'linear-gradient(135deg, ' +
                      getTeamColor(topThree[0].color) +
                      ' 0%, ' +
                      getTeamColor(topThree[0].color) +
                      'dd 100%)'
                    : 'var(--color-primary)',
                  gridRow: '1',
                  gridColumn: '2',
                }"
              >
                <!-- Winner Crown -->
                <div
                  class="absolute -top-1 -right-1 w-10 h-10 rounded-full flex items-center justify-center shadow-lg border-2"
                  style="
                    background: var(--color-light);
                    border-color: var(--color-primary-dark);
                  "
                >
                  <span class="text-xl">🥇</span>
                </div>

                <div class="text-center">
                  <div class="flex justify-center mb-3">
                    <div
                      class="w-20 h-20 rounded-full flex items-center justify-center text-2xl border-4 shadow-xl overflow-hidden"
                      :style="{
                        background: 'rgba(255, 255, 255, 0.2)',
                        backdropFilter: 'blur(4px)',
                        borderColor: getTeamColor(
                          topThree[0]?.color || '#6B7280',
                        ),
                      }"
                    >
                      <img
                        :src="topThree[0]?.avatar || '/default-avatar.png'"
                        :alt="topThree[0]?.name || 'Team'"
                        class="w-full h-full object-cover rounded-full"
                      />
                    </div>
                  </div>
                  <div class="mb-2">
                    <span
                      class="inline-block px-3 py-1 rounded-full text-sm font-bold border-2"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >1ST PLACE</span
                    >
                  </div>
                  <div class="font-bold text-lg mb-2" style="color: white">
                    {{ topThree[0]?.name || "Team" }}
                  </div>
                  <div class="text-xl font-bold mb-3" style="color: white">
                    {{ formatPoints(topThree[0]?.points || 0) }}
                  </div>
                  <div class="flex items-center justify-center space-x-2">
                    <span
                      class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥇 {{ topThree[0]?.medals?.gold || 0 }}</span
                    >
                    <span
                      class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥈 {{ topThree[0]?.medals?.silver || 0 }}</span
                    >
                    <span
                      class="inline-flex items-center px-2 py-1 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥉 {{ topThree[0]?.medals?.bronze || 0 }}</span
                    >
                  </div>
                </div>
              </div>

              <!-- #2 Position -->
              <div
                class="card card-hover p-3 relative overflow-hidden"
                :style="{
                  background: topThree[1]?.color
                    ? 'linear-gradient(135deg, ' +
                      getTeamColor(topThree[1].color) +
                      ' 0%, ' +
                      getTeamColor(topThree[1].color) +
                      'dd 100%)'
                    : 'var(--color-secondary)',
                }"
              >
                <!-- Silver Medal -->
                <div
                  class="absolute -top-1 -right-1 w-8 h-8 rounded-full flex items-center justify-center shadow-md border-2"
                  style="
                    background: var(--color-light);
                    border-color: var(--color-accent);
                  "
                >
                  <span class="text-lg">🥈</span>
                </div>

                <div class="text-center">
                  <div class="flex justify-center mb-2">
                    <div
                      class="w-16 h-16 rounded-full flex items-center justify-center text-lg border-3 shadow-lg overflow-hidden"
                      :style="{
                        background: 'rgba(255, 255, 255, 0.2)',
                        backdropFilter: 'blur(4px)',
                        borderColor: getTeamColor(
                          topThree[1]?.color || '#6B7280',
                        ),
                      }"
                    >
                      <img
                        :src="topThree[1]?.avatar || '/default-avatar.png'"
                        :alt="topThree[1]?.name || 'Team'"
                        class="w-full h-full object-cover rounded-full"
                      />
                    </div>
                  </div>
                  <div class="mb-1">
                    <span
                      class="inline-block px-2 py-1 rounded-full text-xs font-bold border-2"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >2ND PLACE</span
                    >
                  </div>
                  <div class="font-bold text-sm mb-1" style="color: white">
                    {{ topThree[1]?.name || "Team" }}
                  </div>
                  <div class="text-lg font-bold mb-2" style="color: white">
                    {{ formatPoints(topThree[1]?.points || 0) }}
                  </div>
                  <div class="flex items-center justify-center space-x-1">
                    <span
                      class="inline-flex items-center px-1 py-0.5 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥇 {{ topThree[1]?.medals?.gold || 0 }}</span
                    >
                    <span
                      class="inline-flex items-center px-1 py-0.5 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥈 {{ topThree[1]?.medals?.silver || 0 }}</span
                    >
                    <span
                      class="inline-flex items-center px-1 py-0.5 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥉 {{ topThree[1]?.medals?.bronze || 0 }}</span
                    >
                  </div>
                </div>
              </div>

              <!-- #3 Position -->
              <div
                class="card card-hover p-3 relative overflow-hidden"
                :style="{
                  background: topThree[2]?.color
                    ? 'linear-gradient(135deg, ' +
                      getTeamColor(topThree[2].color) +
                      ' 0%, ' +
                      getTeamColor(topThree[2].color) +
                      'dd 100%)'
                    : 'var(--color-primary)',
                }"
              >
                <!-- Bronze Medal -->
                <div
                  class="absolute -top-1 -right-1 w-8 h-8 rounded-full flex items-center justify-center shadow-md border-2"
                  style="
                    background: var(--color-primary);
                    border-color: var(--color-primary-dark);
                  "
                >
                  <span class="text-lg">🥉</span>
                </div>

                <div class="text-center">
                  <div class="flex justify-center mb-2">
                    <div
                      class="w-16 h-16 rounded-full flex items-center justify-center text-lg border-3 shadow-lg overflow-hidden"
                      :style="{
                        background: 'rgba(255, 255, 255, 0.2)',
                        backdropFilter: 'blur(4px)',
                        borderColor: getTeamColor(
                          topThree[2]?.color || '#6B7280',
                        ),
                      }"
                    >
                      <img
                        :src="topThree[2]?.avatar || '/default-avatar.png'"
                        :alt="topThree[2]?.name || 'Team'"
                        class="w-full h-full object-cover rounded-full"
                      />
                    </div>
                  </div>
                  <div class="mb-1">
                    <span
                      class="inline-block px-2 py-1 rounded-full text-xs font-bold border-2"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >3RD PLACE</span
                    >
                  </div>
                  <div class="font-bold text-sm mb-1" style="color: white">
                    {{ topThree[2]?.name || "Team" }}
                  </div>
                  <div class="text-lg font-bold mb-2" style="color: white">
                    {{ formatPoints(topThree[2]?.points || 0) }}
                  </div>
                  <div class="flex items-center justify-center space-x-1">
                    <span
                      class="inline-flex items-center px-1 py-0.5 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥇 {{ topThree[2]?.medals?.gold || 0 }}</span
                    >
                    <span
                      class="inline-flex items-center px-1 py-0.5 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥈 {{ topThree[2]?.medals?.silver || 0 }}</span
                    >
                    <span
                      class="inline-flex items-center px-1 py-0.5 rounded text-xs font-bold border"
                      style="
                        background: rgba(255, 255, 255, 0.2);
                        backdrop-filter: blur(4px);
                        border-color: white;
                        color: white;
                      "
                      >🥉 {{ topThree[2]?.medals?.bronze || 0 }}</span
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Full Leaderboard Table (Integrated) -->
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
                      Medals (🥇🥈🥉)
                    </th>
                    <th
                      class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
                      style="color: var(--color-secondary)"
                    >
                      Points
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
                          <span v-if="participant.rank === 1" class="text-xl"
                            >🥇</span
                          >
                          <span
                            v-else-if="participant.rank === 2"
                            class="text-xl"
                            >🥈</span
                          >
                          <span
                            v-else-if="participant.rank === 3"
                            class="text-xl"
                            >🥉</span
                          >
                        </div>
                      </div>
                    </td>

                    <!-- Player/Team -->
                    <td class="table-cell">
                      <div class="flex items-center">
                        <div
                          class="w-14 h-14 rounded-full overflow-hidden border-3 shadow-lg"
                          :style="{
                            background: participant?.color
                              ? 'linear-gradient(135deg, ' +
                                getTeamColor(participant.color) +
                                ' 0%, ' +
                                getTeamColor(participant.color) +
                                'dd 100%)'
                              : 'linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%)',
                            borderColor: participant?.color
                              ? getTeamColor(participant.color)
                              : 'var(--color-primary)',
                          }"
                        >
                          <img
                            :src="participant?.avatar || '/default-avatar.png'"
                            :alt="participant?.name || 'Team'"
                            class="w-full h-full object-cover"
                          />
                        </div>
                        <div class="ml-4">
                          <div
                            class="text-sm font-medium"
                            style="color: var(--color-light)"
                          >
                            {{ participant.name }}
                          </div>
                          <div
                            class="text-xs"
                            style="color: var(--color-secondary)"
                          >
                            ID: {{ participant.id }}
                          </div>
                        </div>
                      </div>
                    </td>

                    <!-- Medals -->
                    <td class="table-cell text-center">
                      <div class="flex items-center justify-center space-x-1">
                        <span class="text-yellow-500 font-bold"
                          >🥇 {{ participant.medals?.gold || 0 }}</span
                        >
                        <span class="text-gray-400 font-bold"
                          >🥈 {{ participant.medals?.silver || 0 }}</span
                        >
                        <span class="text-orange-600 font-bold"
                          >🥉 {{ participant.medals?.bronze || 0 }}</span
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
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </main>
      </div>
    </div>
  </div>
</template>

<script>
import { defineStore } from "pinia";
import { ref, computed, onMounted, onUnmounted } from "vue";
import { useTournamentStore } from "@/stores/useTournamentStore.js";

export default {
  name: "Dashboard",
  setup() {
    const tournamentStore = useTournamentStore();
    const searchQuery = ref("");

    // Initialize data on mount
    onMounted(() => {
      console.log("DashboardView mounted - initializing data");
      tournamentStore.initializeData();
      tournamentStore.setupRealtime();

      // Debug: Log events after initialization
      setTimeout(() => {
        console.log("Events after init:", tournamentStore.events);
        console.log("Active matches:", tournamentStore.activeMatches);
        console.log("All events count:", tournamentStore.events.length);
      }, 2000);
    });

    onUnmounted(() => {
      // Cleanup if needed
    });

    // Sidebar data
    const sports = computed(() => tournamentStore.sports);
    const activeMatches = computed(() => tournamentStore.activeMatches);
    const allEvents = computed(() => tournamentStore.events);
    const totalParticipants = computed(() => tournamentStore.totalParticipants);
    const activeSportsCount = computed(
      () => sports.value.filter((s) => s.active).length,
    );

    // Top Rankings data
    const topThree = computed(() => {
      const participants = tournamentStore.participants || [];
      return participants.slice(0, 3);
    });

    // Full Leaderboard data
    const leaderboardData = computed(() => tournamentStore.fullLeaderboard);
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
      // Search
      searchQuery,

      // Sidebar
      sports,
      activeMatches,
      allEvents,
      totalParticipants,
      activeSportsCount,

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
