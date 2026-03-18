<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-2xl font-bold" style="color: var(--color-light)">
          Tabulation Control
        </h2>
        <p class="text-sm mt-1" style="color: var(--color-secondary)">
          Manage scores and tabulation data
        </p>
      </div>
      <div class="flex items-center space-x-4 mb-6">
        <button
          @click="toggleDashboardVisibility"
          class="btn-secondary"
          :class="{ 'btn-primary': !uiStore.showDashboardInfo }"
        >
          <svg
            class="w-4 h-4 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              v-if="!uiStore.showDashboardInfo"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
            />
            <path
              v-if="!uiStore.showDashboardInfo"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
            />
            <path
              v-if="uiStore.showDashboardInfo"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"
            />
          </svg>
          {{ uiStore.showDashboardInfo ? "Hide" : "Show" }} Dashboard Info
        </button>
        <select
          v-model="selectedEventId"
          @change="fetchPoints"
          class="input-modern w-64"
        >
          <option value="">Select Event</option>
          <option v-for="event in events" :key="event.id" :value="event.id">
            {{ event.event_name }} ({{ event.category }})
          </option>
        </select>
        <button
          v-if="selectedEventId"
          @click="showAddPointModal = true"
          class="btn-primary"
        >
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
              d="M12 6v6m0 0v6m0-6h6m-6 0H6"
            ></path>
          </svg>
          Add Result
        </button>
      </div>
    </div>

    <!-- Event Info -->
    <div v-if="selectedEvent" class="card p-6">
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-4">
          <div
            class="w-12 h-12 rounded-full flex items-center justify-center text-2xl border-4 shadow-lg"
            :style="
              selectedEvent.category === 'sports'
                ? 'background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%); border-color: var(--color-primary);'
                : 'background: linear-gradient(135deg, var(--color-accent) 0%, var(--color-primary) 100%); border-color: var(--color-accent);'
            "
          >
            {{ selectedEvent.category === "sports" ? "🏆" : "🎮" }}
          </div>
          <div>
            <h3 class="text-xl font-bold" style="color: var(--color-light)">
              {{ selectedEvent.event_name }}
            </h3>
            <div class="flex items-center space-x-2 mt-1">
              <span
                :class="[
                  'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                  selectedEvent.category === 'sports'
                    ? 'badge badge-primary'
                    : 'badge badge-secondary',
                ]"
              >
                {{ selectedEvent.category.toUpperCase() }}
              </span>
              <span v-if="selectedEvent.is_live" class="flex items-center">
                <div
                  class="w-2 h-2 rounded-full animate-pulse pixel-glow mr-1"
                  style="background: var(--color-primary-dark)"
                ></div>
                <span class="badge badge-success">LIVE</span>
              </span>
            </div>
          </div>
        </div>
        <div class="text-right">
          <p class="text-sm" style="color: var(--color-secondary)">
            Total Teams
          </p>
          <p class="text-2xl font-bold" style="color: var(--color-light)">
            {{ points.length }}
          </p>
        </div>
      </div>
    </div>

    <!-- Scores Table -->
    <div v-if="selectedEventId" class="card p-6">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-8">
        <div class="inline-flex items-center">
          <svg
            class="animate-spin -ml-1 mr-3 h-8 w-8"
            style="color: var(--color-primary)"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              class="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              stroke-width="4"
            ></circle>
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            ></path>
          </svg>
          <span style="color: var(--color-secondary)">Loading scores...</span>
        </div>
      </div>

      <!-- Scores Table -->
      <div v-else class="table-modern">
        <table class="w-full">
          <thead class="table-header">
            <tr>
              <th
                class="px-6 py-4 text-left text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Team Name
              </th>
              <th
                class="px-6 py-3 text-center text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                POINTS
              </th>
              <th
                class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Last Updated
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
              v-for="(point, index) in sortedPoints"
              :key="point.id"
              class="table-row"
            >
              <!-- Team Name -->
              <td class="table-cell">
                <div class="flex items-center">
                  <div class="flex items-center">
                    <span v-if="index < 3" class="mr-2 text-xl">
                      <span v-if="index === 0"></span>
                      <span v-else-if="index === 1"></span>
                      <span v-else-if="index === 2"></span>
                    </span>
                    <span class="font-medium" style="color: var(--color-light)">
                      {{ point.team_name }}
                    </span>
                  </div>
                </div>
              </td>

              <!-- POINTS -->
              <td class="table-cell text-center">
                <div class="flex items-center justify-center">
                  <div v-if="point.medal_type" class="text-center">
                    <div class="text-2xl mb-1">
                      <span
                        v-if="point.medal_type === 'gold'"
                        class="text-yellow-500"
                        >🥇</span
                      >
                      <span
                        v-else-if="point.medal_type === 'silver'"
                        class="text-gray-400"
                        >🥈</span
                      >
                      <span
                        v-else-if="point.medal_type === 'bronze'"
                        class="text-orange-600"
                        >🥉</span
                      >
                    </div>
                    <div
                      class="text-lg font-bold"
                      style="color: var(--color-light)"
                    >
                      {{ getMedalPoints(point.medal_type) }} pts
                    </div>
                  </div>
                  <div
                    v-else
                    class="text-lg font-bold"
                    style="color: var(--color-light)"
                  >
                    {{ point.points_value }}
                  </div>
                </div>
              </td>

              <!-- Last Updated -->
              <td class="table-cell text-center">
                <span class="text-sm" style="color: var(--color-secondary)">
                  {{ formatDateTime(point.updated_at) }}
                </span>
              </td>

              <!-- Actions -->
              <td class="table-cell text-center">
                <div class="flex justify-center space-x-2">
                  <button
                    @click="deletePoint(point)"
                    class="btn-danger text-sm"
                  >
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Empty State -->
      <div v-if="!loading && points.length === 0" class="text-center py-12">
        <svg
          class="mx-auto h-12 w-12"
          style="color: var(--color-secondary)"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
          ></path>
        </svg>
        <h3 class="mt-2 text-sm font-medium" style="color: var(--color-light)">
          No points found
        </h3>
        <p class="mt-1 text-sm" style="color: var(--color-secondary)">
          Get started by adding a team point.
        </p>
        <div class="mt-6">
          <button @click="showAddPointModal = true" class="btn-primary">
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
                d="M12 6v6m0 0v6m0-6h6m-6 0H6"
              ></path>
            </svg>
            Add Score
          </button>
        </div>
      </div>
    </div>

    <!-- No Event Selected -->
    <div v-else class="card p-12 text-center">
      <svg
        class="mx-auto h-12 w-12"
        style="color: var(--color-secondary)"
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
      <h3 class="mt-2 text-sm font-medium" style="color: var(--color-light)">
        Add the Result
      </h3>
      <p class="mt-1 text-sm" style="color: var(--color-secondary)">
        Choose an event to manage its scores.
      </p>
    </div>

    <!-- Add/Edit Result Modal -->
    <div
      v-if="showAddPointModal"
      class="fixed inset-0 z-50 flex items-center justify-center p-4"
      style="backdrop-filter: blur(12px); background: rgba(255, 255, 255, 0.1)"
    >
      <div class="w-full max-w-md transform transition-all">
        <div
          class="bg-gray-900 rounded-2xl shadow-2xl border border-white/20 backdrop-blur-xl"
        >
          <!-- Modal Header -->
          <div class="px-6 py-4 border-b border-gray-100">
            <h3 class="text-xl font-bold text-gray-900">
              {{ editingPoint ? "Edit Result" : "Add Result" }}
            </h3>
            <p class="text-sm text-gray-500 mt-1">
              {{ selectedEventName || "Select an event" }}
            </p>
          </div>

          <!-- Modal Body -->
          <div class="px-6 py-4 space-y-4">
            <!-- Team Selection -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Team
                <span
                  v-if="getTeamMedalStatus()"
                  class="ml-2 text-xs text-orange-500"
                >
                  🏆 Team already awarded in this event
                </span>
              </label>
              <select
                v-model="pointForm.teamName"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Select team</option>
                <option
                  v-for="team in getAvailableTeams()"
                  :key="team.id"
                  :value="team.team_name"
                >
                  {{ team.team_name }}
                </option>
              </select>
              <div
                v-if="getAvailableTeams().length === 0"
                class="mt-1 text-xs text-red-500"
              >
                All teams have already been awarded medals in this event.
              </div>
            </div>

            <!-- Medal Type -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Medal Type
              </label>
              <select
                v-model="pointForm.medalType"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Select medal</option>
                <option
                  v-for="medal in getAvailableMedals()"
                  :key="medal.type"
                  :value="medal.type"
                >
                  {{ medal.label }}
                </option>
              </select>
              <div
                v-if="getAvailableMedals().length === 0"
                class="mt-1 text-xs text-red-500"
              >
                All medals have already been awarded for this event.
              </div>
            </div>
          </div>

          <!-- Modal Actions -->
          <div
            class="px-6 py-4 border-t border-gray-100 flex justify-end space-x-3"
          >
            <button
              @click="closePointModal"
              class="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
            >
              Cancel
            </button>
            <button
              @click="handlePointSubmit"
              :disabled="submitting || !pointForm.teamName || !selectedEventId"
              class="px-4 py-2 text-white bg-blue-600 hover:bg-blue-700 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ submitting ? "Saving..." : "Save Result" }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div
      v-if="showDeleteModal"
      class="fixed inset-0 z-50 flex items-center justify-center p-4"
      style="backdrop-filter: blur(12px); background: rgba(255, 255, 255, 0.1)"
    >
      <div class="w-full max-w-sm transform transition-all">
        <div
          class="bg-gray-900 rounded-2xl shadow-2xl border border-white/20 backdrop-blur-xl p-6"
        >
          <div class="text-center">
            <svg
              class="mx-auto h-12 w-12 text-red-500"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"
              ></path>
            </svg>
            <h3 class="mt-2 text-lg font-bold text-gray-900">Delete Point</h3>
            <p class="mt-2 text-sm text-gray-500">
              Are you sure you want to delete the point for "{{
                deletingPoint?.team_name
              }}"? This action cannot be undone.
            </p>
          </div>
          <div class="flex justify-center space-x-3 mt-6">
            <button
              @click="showDeleteModal = false"
              class="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors"
            >
              Cancel
            </button>
            <button
              @click="confirmDeletePoint"
              :disabled="deleting"
              class="px-4 py-2 text-white bg-red-600 hover:bg-red-700 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span v-if="deleting" class="flex items-center">
                <svg
                  class="animate-spin -ml-1 mr-2 h-4 w-4 text-white"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                  ></circle>
                  <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                  ></path>
                </svg>
                Deleting...
              </span>
              <span v-else>Delete</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useAuthStore } from "@/stores/useAuthStore.js";
import { useTournamentStore } from "@/stores/useTournamentStore.js";
import { useUIStore } from "@/stores/useUIStore.js";
import {
  getEvents,
  getPoints,
  createPoint,
  updatePoint as updatePointInDb,
  deletePoint as deletePointFromDb,
} from "@/utils/supabase.js";

const authStore = useAuthStore();
const tournamentStore = useTournamentStore();
const uiStore = useUIStore();

// State
const loading = ref(false);
const submitting = ref(false);
const deleting = ref(false);
const selectedEventId = ref("");
const events = ref([]);
const points = ref([]);
const showAddPointModal = ref(false);
const showDeleteModal = ref(false);
const editingPoint = ref(null);
const deletingPoint = ref(null);

const pointForm = ref({
  teamName: "",
  medalType: "",
});

// Computed
const selectedEvent = computed(() => {
  return events.value.find((event) => event.id === selectedEventId.value);
});

const sortedPoints = computed(() => {
  return [...points.value].sort((a, b) => b.points_value - a.points_value);
});

// Methods
const fetchEvents = async () => {
  try {
    const data = await getEvents();
    events.value = data;
  } catch (error) {
    console.error("Error fetching events:", error);
  }
};

const fetchPoints = async () => {
  if (!selectedEventId.value) return;

  try {
    loading.value = true;
    const data = await getPoints(selectedEventId.value);
    points.value = data;
  } catch (error) {
    console.error("Error fetching points:", error);
  } finally {
    loading.value = false;
  }
};

const handlePointSubmit = async () => {
  try {
    submitting.value = true;

    // Use the selected event ID
    if (!selectedEventId.value) {
      throw new Error("No event selected");
    }

    // Check if the selected medal is already awarded
    if (
      pointForm.value.medalType &&
      getMedalAvailability(pointForm.value.medalType) === "taken"
    ) {
      throw new Error(
        `This ${pointForm.value.medalType} medal has already been awarded for this event. Please select a different medal.`,
      );
    }

    // Get team ID from team name
    const team = tournamentStore.teams.find(
      (t) => t.team_name === pointForm.value.teamName,
    );
    if (!team) {
      console.error("Team not found:", pointForm.value.teamName);
      console.error(
        "Available teams:",
        tournamentStore.teams.map((t) => t.team_name),
      );
      throw new Error(
        `Team "${pointForm.value.teamName}" not found. Available teams: ${tournamentStore.teams.map((t) => t.team_name).join(", ")}`,
      );
    }

    console.log("Found team:", team);
    console.log("Team ID:", team.id);

    const pointData = {
      event_id: selectedEventId.value, // Use selected event ID
      team_id: team.id, // Add team ID reference
      team_name: pointForm.value.teamName,
      points_value: getMedalPoints(pointForm.value.medalType) || 0, // Use correct medal points
      medal_type: pointForm.value.medalType || null,
    };

    console.log("Point data to create/update:", pointData);

    if (editingPoint.value) {
      // Update existing point
      console.log("Updating existing point:", editingPoint.value);
      await updatePoint(
        editingPoint.value.id,
        pointData.points_value,
        pointData.medal_type,
        authStore.user.id,
      );
    } else {
      // Create new point (only once)
      console.log("Creating new point");
      await createPoint(pointData);

      // Refresh data to update team stats
      await tournamentStore.fetchTeams();
      await tournamentStore.fetchPoints();
    }

    closePointModal();
    await fetchPoints();
  } catch (error) {
    console.error("Error saving result:", error);
  } finally {
    submitting.value = false;
  }
};

const editPoint = (point) => {
  editingPoint.value = point;
  pointForm.value = {
    teamName: point.team_name,
    medalType: point.medal_type,
    eventName: point.event_id,
  };
  showAddPointModal.value = true;
};

const deletePoint = (point) => {
  deletingPoint.value = point;
  showDeleteModal.value = true;
};

const confirmDeletePoint = async () => {
  try {
    deleting.value = true;
    await deletePointFromDb(deletingPoint.value.id);
    showDeleteModal.value = false;
    await fetchPoints();
  } catch (error) {
    console.error("Error deleting point:", error);
  } finally {
    deleting.value = false;
  }
};

const incrementPoint = async (point) => {
  try {
    await updatePointInDb(
      point.id,
      point.points_value + 1,
      null,
      authStore.user.id,
    );
    await fetchPoints();
  } catch (error) {
    console.error("Error incrementing point:", error);
  }
};

const decrementPoint = async (point) => {
  try {
    const newPoint = Math.max(0, point.points_value - 1);
    await updatePointInDb(point.id, newPoint, null, authStore.user.id);
    await fetchPoints();
  } catch (error) {
    console.error("Error decrementing point:", error);
  }
};

const updatePoint = async (point) => {
  try {
    await updatePointInDb(
      point.id,
      point.points_value,
      point.medal_type,
      authStore.user.id,
    );
    await fetchPoints();
  } catch (error) {
    console.error("Error updating point:", error);
  }
};

const closePointModal = () => {
  showAddPointModal.value = false;
  editingPoint.value = null;
  pointForm.value = {
    teamName: "",
    medalType: "",
  };
};

const getTeamIdByName = (teamName) => {
  const team = tournamentStore.teams.find((t) => t.team_name === teamName);
  return team ? team.id : null;
};

const getMedalPoints = (medalType) => {
  switch (medalType) {
    case "gold":
      return 10;
    case "silver":
      return 5;
    case "bronze":
      return 3;
    default:
      return 0;
  }
};

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const toggleDashboardVisibility = () => {
  uiStore.toggleDashboardInfo();
};

// Check if a medal type is already awarded for the selected event
const getMedalAvailability = (medalType) => {
  if (!selectedEventId.value || !medalType) return "available";

  const existingMedals = points.value.filter(
    (point) =>
      point.event_id === selectedEventId.value &&
      point.medal_type === medalType,
  );

  return existingMedals.length > 0 ? "taken" : "available";
};

// Get existing medals for the selected event
const getEventMedals = () => {
  if (!selectedEventId.value) return { gold: [], silver: [], bronze: [] };

  const eventPoints = points.value.filter(
    (point) => point.event_id === selectedEventId.value,
  );

  return {
    gold: eventPoints.filter((p) => p.medal_type === "gold"),
    silver: eventPoints.filter((p) => p.medal_type === "silver"),
    bronze: eventPoints.filter((p) => p.medal_type === "bronze"),
  };
};

// Get teams that haven't received medals in this event yet
const getAvailableTeams = () => {
  if (!selectedEventId.value) return tournamentStore.teams;

  const awardedTeams = points.value
    .filter((point) => point.event_id === selectedEventId.value)
    .map((point) => point.team_name);

  return tournamentStore.teams.filter(
    (team) => !awardedTeams.includes(team.team_name),
  );
};

// Get medals that haven't been awarded in this event yet
const getAvailableMedals = () => {
  if (!selectedEventId.value) {
    return [
      { type: "gold", label: "🥇 Gold" },
      { type: "silver", label: "🥈 Silver" },
      { type: "bronze", label: "🥉 Bronze" },
    ];
  }

  const allMedals = [
    { type: "gold", label: "🥇 Gold" },
    { type: "silver", label: "🥈 Silver" },
    { type: "bronze", label: "🥉 Bronze" },
  ];

  const awardedMedalTypes = points.value
    .filter((point) => point.event_id === selectedEventId.value)
    .map((point) => point.medal_type);

  return allMedals.filter((medal) => !awardedMedalTypes.includes(medal.type));
};

// Check if current team has already been awarded in this event
const getTeamMedalStatus = () => {
  if (!selectedEventId.value || !pointForm.value.teamName) return false;

  return points.value.some(
    (point) =>
      point.event_id === selectedEventId.value &&
      point.team_name === pointForm.value.teamName,
  );
};

// Lifecycle
onMounted(() => {
  fetchEvents();
  tournamentStore.fetchTeams(); // Fetch teams to populate dropdown
});
</script>
