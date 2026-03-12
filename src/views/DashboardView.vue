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
                  onmouseover="this.style.borderColor = 'var(--color-primary)'"
                  onmouseout="this.style.borderColor = 'var(--color-border)'"
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
                          <div
                            class="text-xs"
                            style="color: var(--color-secondary)"
                          >
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
                          onmouseout="
                            this.style.color = 'var(--color-secondary)'
                          "
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
                    <p
                      class="text-lg font-bold"
                      style="color: var(--color-light)"
                    >
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
    const topThree = computed(() => tournamentStore.topThree);

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
    };
  },
};
</script>
