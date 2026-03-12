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
      <div class="flex items-center space-x-4">
        <select
          v-model="selectedEventId"
          @change="fetchScores"
          class="input-modern w-64"
        >
          <option value="">Select Event</option>
          <option v-for="event in events" :key="event.id" :value="event.id">
            {{ event.event_name }} ({{ event.category }})
          </option>
        </select>
        <button
          v-if="selectedEventId"
          @click="showAddScoreModal = true"
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
          Add Score
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
            {{ scores.length }}
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
                Rank
              </th>
              <th
                class="px-6 py-4 text-left text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Team Name
              </th>
              <th
                class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Current Score
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
              v-for="(score, index) in sortedScores"
              :key="score.id"
              class="table-row"
            >
              <!-- Rank -->
              <td class="table-cell">
                <div class="flex items-center">
                  <span
                    :class="[
                      'font-bold text-lg',
                      index < 3 ? 'pixel-glow' : '',
                    ]"
                    :style="
                      index < 3
                        ? 'color: var(--color-primary);'
                        : 'color: var(--color-light);'
                    "
                  >
                    #{{ index + 1 }}
                  </span>
                  <div v-if="index < 3" class="ml-2">
                    <span v-if="index === 0" class="text-xl">🥇</span>
                    <span v-else-if="index === 1" class="text-xl">🥈</span>
                    <span v-else-if="index === 2" class="text-xl">🥉</span>
                  </div>
                </div>
              </td>

              <!-- Team Name -->
              <td class="table-cell">
                <span
                  class="text-sm font-medium"
                  style="color: var(--color-light)"
                  >{{ score.team_name }}</span
                >
              </td>

              <!-- Current Score -->
              <td class="table-cell text-center">
                <div class="flex items-center justify-center space-x-2">
                  <button
                    @click="decrementScore(score)"
                    class="w-8 h-8 rounded flex items-center justify-center border-2"
                    style="
                      background: var(--color-dark);
                      border-color: var(--color-border);
                    "
                  >
                    <svg
                      class="w-4 h-4"
                      style="color: var(--color-secondary)"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M20 12H4"
                      ></path>
                    </svg>
                  </button>
                  <input
                    v-model.number="score.score_value"
                    @change="updateScore(score)"
                    type="number"
                    class="w-20 text-center input-modern"
                    style="font-size: 1.25rem; font-weight: bold"
                  />
                  <button
                    @click="incrementScore(score)"
                    class="w-8 h-8 rounded flex items-center justify-center border-2"
                    style="
                      background: var(--color-dark);
                      border-color: var(--color-border);
                    "
                  >
                    <svg
                      class="w-4 h-4"
                      style="color: var(--color-secondary)"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 4v16m8-8H4"
                      ></path>
                    </svg>
                  </button>
                </div>
              </td>

              <!-- Last Updated -->
              <td class="table-cell text-center">
                <span class="text-sm" style="color: var(--color-secondary)">
                  {{ formatDateTime(score.updated_at) }}
                </span>
              </td>

              <!-- Actions -->
              <td class="table-cell text-center">
                <div class="flex justify-center space-x-2">
                  <button
                    @click="editScore(score)"
                    class="btn-secondary text-sm"
                  >
                    Edit
                  </button>
                  <button
                    @click="deleteScore(score)"
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
      <div v-if="!loading && scores.length === 0" class="text-center py-12">
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
          No scores found
        </h3>
        <p class="mt-1 text-sm" style="color: var(--color-secondary)">
          Get started by adding a team score.
        </p>
        <div class="mt-6">
          <button @click="showAddScoreModal = true" class="btn-primary">
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
        Select an Event
      </h3>
      <p class="mt-1 text-sm" style="color: var(--color-secondary)">
        Choose an event to manage its scores.
      </p>
    </div>

    <!-- Add/Edit Score Modal -->
    <div
      v-if="showAddScoreModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
    >
      <div class="card p-6 w-full max-w-md">
        <h3 class="text-lg font-bold mb-4" style="color: var(--color-light)">
          {{ editingScore ? "Edit Score" : "Add Team Score" }}
        </h3>

        <form @submit.prevent="handleScoreSubmit" class="space-y-4">
          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Team Name</label
            >
            <input
              v-model="scoreForm.teamName"
              type="text"
              required
              class="input-modern w-full"
              placeholder="Enter team name"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Score</label
            >
            <input
              v-model.number="scoreForm.scoreValue"
              type="number"
              required
              class="input-modern w-full"
              placeholder="Enter score"
            />
          </div>

          <div class="flex justify-end space-x-3 pt-4">
            <button
              type="button"
              @click="closeScoreModal"
              class="btn-secondary"
            >
              Cancel
            </button>
            <button type="submit" :disabled="submitting" class="btn-primary">
              <span v-if="submitting" class="flex items-center">
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
                {{ editingScore ? "Updating..." : "Adding..." }}
              </span>
              <span v-else>{{ editingScore ? "Update" : "Add" }}</span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div
      v-if="showDeleteModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
    >
      <div class="card p-6 w-full max-w-sm">
        <div class="text-center">
          <svg
            class="mx-auto h-12 w-12"
            style="color: var(--color-primary-dark)"
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
          <h3 class="mt-2 text-lg font-bold" style="color: var(--color-light)">
            Delete Score
          </h3>
          <p class="mt-2 text-sm" style="color: var(--color-secondary)">
            Are you sure you want to delete the score for "{{
              deletingScore?.team_name
            }}"? This action cannot be undone.
          </p>
        </div>
        <div class="flex justify-center space-x-3 mt-6">
          <button @click="showDeleteModal = false" class="btn-secondary">
            Cancel
          </button>
          <button
            @click="confirmDeleteScore"
            :disabled="deleting"
            class="btn-danger"
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
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useAuthStore } from "@/stores/useAuthStore.js";
import {
  getEvents,
  getScores,
  createScore,
  updateScore as updateScoreInDb,
  deleteScore as deleteScoreFromDb,
} from "@/utils/supabase.js";

const authStore = useAuthStore();

// State
const loading = ref(false);
const submitting = ref(false);
const deleting = ref(false);
const selectedEventId = ref("");
const events = ref([]);
const scores = ref([]);
const showAddScoreModal = ref(false);
const showDeleteModal = ref(false);
const editingScore = ref(null);
const deletingScore = ref(null);

const scoreForm = ref({
  teamName: "",
  scoreValue: 0,
});

// Computed
const selectedEvent = computed(() => {
  return events.value.find((event) => event.id === selectedEventId.value);
});

const sortedScores = computed(() => {
  return [...scores.value].sort((a, b) => b.score_value - a.score_value);
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

const fetchScores = async () => {
  if (!selectedEventId.value) return;

  try {
    loading.value = true;
    const data = await getScores(selectedEventId.value);
    scores.value = data;
  } catch (error) {
    console.error("Error fetching scores:", error);
  } finally {
    loading.value = false;
  }
};

const handleScoreSubmit = async () => {
  try {
    submitting.value = true;

    const scoreData = {
      event_id: selectedEventId.value,
      team_name: scoreForm.value.teamName,
      score_value: scoreForm.value.scoreValue,
      updated_by: authStore.user.id,
    };

    if (editingScore.value) {
      await updateScore(
        editingScore.value.id,
        scoreData.scoreValue,
        authStore.user.id,
      );
    } else {
      await createScore(scoreData);
    }

    closeScoreModal();
    await fetchScores();
  } catch (error) {
    console.error("Error saving score:", error);
  } finally {
    submitting.value = false;
  }
};

const editScore = (score) => {
  editingScore.value = score;
  scoreForm.value = {
    teamName: score.team_name,
    scoreValue: score.score_value,
  };
  showAddScoreModal.value = true;
};

const deleteScore = (score) => {
  deletingScore.value = score;
  showDeleteModal.value = true;
};

const confirmDeleteScore = async () => {
  try {
    deleting.value = true;
    await deleteScoreFromDb(deletingScore.value.id);
    showDeleteModal.value = false;
    await fetchScores();
  } catch (error) {
    console.error("Error deleting score:", error);
  } finally {
    deleting.value = false;
  }
};

const incrementScore = async (score) => {
  try {
    await updateScoreInDb(score.id, score.score_value + 1, authStore.user.id);
    await fetchScores();
  } catch (error) {
    console.error("Error incrementing score:", error);
  }
};

const decrementScore = async (score) => {
  try {
    const newScore = Math.max(0, score.score_value - 1);
    await updateScoreInDb(score.id, newScore, authStore.user.id);
    await fetchScores();
  } catch (error) {
    console.error("Error decrementing score:", error);
  }
};

const updateScore = async (score) => {
  try {
    await updateScoreInDb(score.id, score.score_value, authStore.user.id);
    await fetchScores();
  } catch (error) {
    console.error("Error updating score:", error);
  }
};

const closeScoreModal = () => {
  showAddScoreModal.value = false;
  editingScore.value = null;
  scoreForm.value = {
    teamName: "",
    scoreValue: 0,
  };
};

const formatDateTime = (dateString) => {
  return new Date(dateString).toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

// Lifecycle
onMounted(() => {
  fetchEvents();
});
</script>
