<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-2xl font-bold" style="color: var(--color-light)">
          Live Events
        </h2>
        <p class="text-sm mt-1" style="color: var(--color-secondary)">
          Manage sports and esports events
        </p>
      </div>
      <button @click="showCreateModal = true" class="btn-primary">
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
        Create Event
      </button>
    </div>

    <!-- Events Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- Loading State -->
      <div v-if="loading" class="col-span-full text-center py-12">
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
          <span style="color: var(--color-secondary)">Loading events...</span>
        </div>
      </div>

      <!-- Event Cards -->
      <div
        v-for="event in events"
        :key="event.id"
        class="card p-6 relative overflow-hidden"
      >
        <!-- Live Indicator -->
        <div v-if="event.is_live" class="absolute top-4 right-4">
          <div class="flex items-center space-x-2">
            <div
              class="w-2 h-2 rounded-full animate-pulse pixel-glow"
              style="background: var(--color-primary-dark)"
            ></div>
            <span class="badge badge-success">LIVE</span>
          </div>
        </div>

        <!-- Event Icon -->
        <div class="mb-4">
          <div
            class="w-16 h-16 rounded-full flex items-center justify-center text-3xl border-4 shadow-lg"
            :style="
              event.category === 'sports'
                ? 'background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%); border-color: var(--color-primary);'
                : 'background: linear-gradient(135deg, var(--color-accent) 0%, var(--color-primary) 100%); border-color: var(--color-accent);'
            "
          >
            {{ event.category === "sports" ? "🏆" : "🎮" }}
          </div>
        </div>

        <!-- Event Name -->
        <h3 class="text-lg font-bold mb-2" style="color: var(--color-light)">
          {{ event.event_name }}
        </h3>

        <!-- Category Badge -->
        <div class="mb-4">
          <span
            :class="[
              'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
              event.category === 'sports'
                ? 'badge badge-primary'
                : 'badge badge-secondary',
            ]"
          >
            {{ event.category.toUpperCase() }}
          </span>
        </div>

        <!-- Actions -->
        <div class="flex space-x-2">
          <button
            @click="toggleLiveStatus(event)"
            :class="['flex-1', event.is_live ? 'btn-danger' : 'btn-success']"
          >
            {{ event.is_live ? "End Live" : "Start Live" }}
          </button>
          <button @click="editEvent(event)" class="btn-secondary">
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
                d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
              ></path>
            </svg>
          </button>
          <button @click="deleteEvent(event)" class="btn-danger">
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
                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
              ></path>
            </svg>
          </button>
        </div>

        <!-- Event Stats -->
        <div
          class="mt-4 pt-4 border-t"
          style="border-color: var(--color-border)"
        >
          <div
            class="flex justify-between text-xs"
            style="color: var(--color-secondary)"
          >
            <span>Created: {{ formatDate(event.created_at) }}</span>
            <span v-if="event.is_live" class="flex items-center">
              <svg
                class="w-3 h-3 mr-1 animate-pulse"
                style="color: var(--color-primary-dark)"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"></path>
                <path
                  fill-rule="evenodd"
                  d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"
                  clip-rule="evenodd"
                ></path>
              </svg>
              Live Now
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!loading && events.length === 0" class="text-center py-12">
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
        No events found
      </h3>
      <p class="mt-1 text-sm" style="color: var(--color-secondary)">
        Get started by creating your first event.
      </p>
      <div class="mt-6">
        <button @click="showCreateModal = true" class="btn-primary">
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
          Create Event
        </button>
      </div>
    </div>

    <!-- Create/Edit Event Modal -->
    <div
      v-if="showCreateModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
    >
      <div class="card p-6 w-full max-w-md">
        <h3 class="text-lg font-bold mb-4" style="color: var(--color-light)">
          {{ editingEvent ? "Edit Event" : "Create Event" }}
        </h3>

        <form @submit.prevent="handleSubmit" class="space-y-4">
          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Event Name</label
            >
            <input
              v-model="form.eventName"
              type="text"
              required
              class="input-modern w-full"
              placeholder="e.g., Basketball Finals"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Category</label
            >
            <select
              v-model="form.category"
              class="input-modern w-full"
              required
            >
              <option value="">Select category</option>
              <option value="sports">Sports</option>
              <option value="esports">Esports</option>
            </select>
          </div>

          <div class="flex items-center">
            <input
              v-model="form.isLive"
              type="checkbox"
              id="isLive"
              class="mr-2"
            />
            <label
              for="isLive"
              class="text-sm"
              style="color: var(--color-light)"
            >
              Start as live event
            </label>
          </div>

          <div class="flex justify-end space-x-3 pt-4">
            <button type="button" @click="closeModal" class="btn-secondary">
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
                {{ editingEvent ? "Updating..." : "Creating..." }}
              </span>
              <span v-else>{{ editingEvent ? "Update" : "Create" }}</span>
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
            Delete Event
          </h3>
          <p class="mt-2 text-sm" style="color: var(--color-secondary)">
            Are you sure you want to delete "{{ deletingEvent?.event_name }}"?
            This action cannot be undone.
          </p>
        </div>
        <div class="flex justify-center space-x-3 mt-6">
          <button @click="showDeleteModal = false" class="btn-secondary">
            Cancel
          </button>
          <button
            @click="confirmDelete"
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
import { ref, onMounted, onUnmounted } from "vue";
import { useAuthStore } from "@/stores/useAuthStore.js";
import {
  getEvents,
  createEvent,
  updateEvent,
  deleteEvent,
  subscribeToEvents,
} from "@/utils/supabase.js";

const authStore = useAuthStore();

// State
const loading = ref(false);
const submitting = ref(false);
const deleting = ref(false);
const showCreateModal = ref(false);
const showDeleteModal = ref(false);
const editingEvent = ref(null);
const deletingEvent = ref(null);

const form = ref({
  eventName: "",
  category: "",
  isLive: false,
});

const events = ref([]);
let realtimeSubscription = null;

// Methods
const fetchEvents = async () => {
  try {
    loading.value = true;
    const data = await getEvents();
    events.value = data;
  } catch (error) {
    console.error("Error fetching events:", error);
  } finally {
    loading.value = false;
  }
};

const handleSubmit = async () => {
  try {
    submitting.value = true;

    const eventData = {
      event_name: form.value.eventName,
      category: form.value.category,
      is_live: form.value.isLive,
      created_by: authStore.user.id,
    };

    if (editingEvent.value) {
      await updateEvent(editingEvent.value.id, eventData);
    } else {
      await createEvent(eventData);
    }

    closeModal();
    await fetchEvents();
  } catch (error) {
    console.error("Error saving event:", error);
  } finally {
    submitting.value = false;
  }
};

const editEvent = (event) => {
  editingEvent.value = event;
  form.value = {
    eventName: event.event_name,
    category: event.category,
    isLive: event.is_live,
  };
  showCreateModal.value = true;
};

const deleteEvent = (event) => {
  deletingEvent.value = event;
  showDeleteModal.value = true;
};

const confirmDelete = async () => {
  try {
    deleting.value = true;
    await deleteEvent(deletingEvent.value.id);
    showDeleteModal.value = false;
    await fetchEvents();
  } catch (error) {
    console.error("Error deleting event:", error);
  } finally {
    deleting.value = false;
  }
};

const toggleLiveStatus = async (event) => {
  try {
    await updateEvent(event.id, { is_live: !event.is_live });
    await fetchEvents();
  } catch (error) {
    console.error("Error toggling live status:", error);
  }
};

const closeModal = () => {
  showCreateModal.value = false;
  editingEvent.value = null;
  form.value = {
    eventName: "",
    category: "",
    isLive: false,
  };
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
};

// Realtime updates
const setupRealtime = () => {
  realtimeSubscription = subscribeToEvents((payload) => {
    console.log("Realtime update received:", payload);
    fetchEvents();
  });
};

// Lifecycle
onMounted(() => {
  fetchEvents();
  setupRealtime();
});

onUnmounted(() => {
  if (realtimeSubscription) {
    realtimeSubscription.unsubscribe();
  }
});
</script>
