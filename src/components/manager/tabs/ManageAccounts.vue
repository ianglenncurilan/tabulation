<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-2xl font-bold" style="color: var(--color-light)">
          Manage Accounts
        </h2>
        <p class="text-sm mt-1" style="color: var(--color-secondary)">
          Create and manage staff/judge accounts
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
        Create Staff Account
      </button>
    </div>

    <!-- Accounts List -->
    <div class="card p-6">
      <div class="mb-4">
        <div class="flex items-center space-x-4">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search accounts..."
            class="input-modern w-64"
          />
          <select v-model="roleFilter" class="input-modern w-32">
            <option value="">All Roles</option>
            <option value="manager">Managers</option>
            <option value="staff">Staff</option>
          </select>
        </div>
      </div>

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
          <span style="color: var(--color-secondary)">Loading accounts...</span>
        </div>
      </div>

      <!-- Accounts Table -->
      <div v-else class="table-modern">
        <table class="w-full">
          <thead class="table-header">
            <tr>
              <th
                class="px-6 py-4 text-left text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Profile
              </th>
              <th
                class="px-6 py-4 text-left text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Email
              </th>
              <th
                class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Role
              </th>
              <th
                class="px-6 py-4 text-center text-xs font-medium uppercase tracking-wider"
                style="color: var(--color-secondary)"
              >
                Created
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
              v-for="profile in filteredProfiles"
              :key="profile.id"
              class="table-row"
            >
              <!-- Profile -->
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
                    {{ profile.full_name.charAt(0).toUpperCase() }}
                  </div>
                  <div class="ml-4">
                    <div
                      class="text-sm font-medium"
                      style="color: var(--color-light)"
                    >
                      {{ profile.full_name }}
                    </div>
                    <div class="text-xs" style="color: var(--color-secondary)">
                      ID: {{ profile.id.slice(0, 8) }}
                    </div>
                  </div>
                </div>
              </td>

              <!-- Email -->
              <td class="table-cell">
                <span class="text-sm" style="color: var(--color-light)">{{
                  profile.email
                }}</span>
              </td>

              <!-- Role -->
              <td class="table-cell text-center">
                <span
                  :class="[
                    'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                    profile.role === 'manager'
                      ? 'badge badge-primary'
                      : 'badge badge-secondary',
                  ]"
                >
                  {{ profile.role.toUpperCase() }}
                </span>
              </td>

              <!-- Created -->
              <td class="table-cell text-center">
                <span class="text-sm" style="color: var(--color-secondary)">
                  {{ formatDate(profile.created_at) }}
                </span>
              </td>

              <!-- Actions -->
              <td class="table-cell text-center">
                <div class="flex justify-center space-x-2">
                  <button
                    @click="editProfile(profile)"
                    class="btn-secondary text-sm"
                  >
                    Edit
                  </button>
                  <button
                    v-if="
                      profile.id !== authStore.user?.id &&
                      profile.role !== 'manager'
                    "
                    @click="deleteProfile(profile)"
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
      <div
        v-if="!loading && filteredProfiles.length === 0"
        class="text-center py-12"
      >
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
            d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
          ></path>
        </svg>
        <h3 class="mt-2 text-sm font-medium" style="color: var(--color-light)">
          No accounts found
        </h3>
        <p class="mt-1 text-sm" style="color: var(--color-secondary)">
          Get started by creating a new staff account.
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
            Create Account
          </button>
        </div>
      </div>
    </div>

    <!-- Create/Edit Modal -->
    <div
      v-if="showCreateModal"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
    >
      <div class="card p-6 w-full max-w-md">
        <h3 class="text-lg font-bold mb-4" style="color: var(--color-light)">
          {{ editingProfile ? "Edit Account" : "Create Staff Account" }}
        </h3>

        <form @submit.prevent="handleSubmit" class="space-y-4">
          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Full Name</label
            >
            <input
              v-model="form.fullName"
              type="text"
              required
              class="input-modern w-full"
              placeholder="John Doe"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Email Address</label
            >
            <input
              v-model="form.email"
              type="email"
              :disabled="editingProfile"
              required
              class="input-modern w-full"
              placeholder="staff@daug2026.com"
            />
          </div>

          <div v-if="!editingProfile">
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Temporary Password</label
            >
            <input
              v-model="form.password"
              type="password"
              required
              minlength="6"
              class="input-modern w-full"
              placeholder="Min. 6 characters"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Role</label
            >
            <select v-model="form.role" class="input-modern w-full" required>
              <option value="staff">Staff/Judge</option>
              <option value="manager">Manager</option>
            </select>
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
                {{ editingProfile ? "Updating..." : "Creating..." }}
              </span>
              <span v-else>{{ editingProfile ? "Update" : "Create" }}</span>
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
            Delete Account
          </h3>
          <p class="mt-2 text-sm" style="color: var(--color-secondary)">
            Are you sure you want to delete {{ deletingProfile?.full_name }}?
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
import { ref, computed, onMounted } from "vue";
import { useAuthStore } from "@/stores/useAuthStore.js";
import {
  getProfiles,
  createProfile,
  updateProfile,
  signUp,
} from "@/utils/supabase.js";

const authStore = useAuthStore();

// State
const loading = ref(false);
const submitting = ref(false);
const deleting = ref(false);
const searchQuery = ref("");
const roleFilter = ref("");
const showCreateModal = ref(false);
const showDeleteModal = ref(false);
const editingProfile = ref(null);
const deletingProfile = ref(null);

const form = ref({
  fullName: "",
  email: "",
  password: "",
  role: "staff",
});

const profiles = ref([]);

// Computed
const filteredProfiles = computed(() => {
  let filtered = profiles.value;

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (profile) =>
        profile.full_name.toLowerCase().includes(query) ||
        profile.email.toLowerCase().includes(query),
    );
  }

  if (roleFilter.value) {
    filtered = filtered.filter((profile) => profile.role === roleFilter.value);
  }

  return filtered;
});

// Methods
const fetchProfiles = async () => {
  try {
    loading.value = true;
    const data = await getProfiles();
    profiles.value = data;
  } catch (error) {
    console.error("Error fetching profiles:", error);
  } finally {
    loading.value = false;
  }
};

const handleSubmit = async () => {
  try {
    submitting.value = true;

    if (editingProfile.value) {
      // Update existing profile
      await updateProfile(editingProfile.value.id, {
        full_name: form.value.fullName,
        role: form.value.role,
      });
    } else {
      // Create new staff account
      await signUp(
        form.value.email,
        form.value.password,
        form.value.fullName,
        form.value.role,
      );
    }

    closeModal();
    await fetchProfiles();
  } catch (error) {
    console.error("Error saving profile:", error);
  } finally {
    submitting.value = false;
  }
};

const editProfile = (profile) => {
  editingProfile.value = profile;
  form.value = {
    fullName: profile.full_name,
    email: profile.email,
    password: "",
    role: profile.role,
  };
  showCreateModal.value = true;
};

const deleteProfile = (profile) => {
  deletingProfile.value = profile;
  showDeleteModal.value = true;
};

const confirmDelete = async () => {
  try {
    deleting.value = true;
    // Note: In a real implementation, you'd want to soft delete or handle this more carefully
    // For now, we'll just remove from the local state
    profiles.value = profiles.value.filter(
      (p) => p.id !== deletingProfile.value.id,
    );
    showDeleteModal.value = false;
  } catch (error) {
    console.error("Error deleting profile:", error);
  } finally {
    deleting.value = false;
  }
};

const closeModal = () => {
  showCreateModal.value = false;
  editingProfile.value = null;
  form.value = {
    fullName: "",
    email: "",
    password: "",
    role: "staff",
  };
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
};

// Lifecycle
onMounted(() => {
  fetchProfiles();
});
</script>
