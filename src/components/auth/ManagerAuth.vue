<template>
  <div
    class="min-h-screen flex items-center justify-center"
    style="background: var(--color-background)"
  >
    <div class="max-w-md w-full space-y-8">
      <!-- Logo and Title -->
      <div class="text-center">
        <div
          class="mx-auto w-20 h-20 flex items-center justify-center rounded-full shadow-xl border-4 pixel-glow"
          style="
            background: linear-gradient(
              135deg,
              var(--color-primary) 0%,
              var(--color-primary-dark) 100%
            );
            border-color: var(--color-primary-dark);
          "
        >
          <span class="text-3xl text-white">🏆</span>
        </div>
        <h2 class="mt-6 text-3xl font-bold" style="color: var(--color-light)">
          Manager Portal
        </h2>
        <p class="mt-2 text-sm" style="color: var(--color-secondary)">
          DAUG 2026 Tabulation System
        </p>
      </div>

      <!-- Auth Forms -->
      <div class="card p-8">
        <!-- Tab Navigation -->
        <div
          class="flex mb-6 border-b-2"
          style="border-color: var(--color-border)"
        >
          <button
            @click="activeTab = 'login'"
            :class="[
              'px-4 py-2 text-sm font-medium transition-colors',
              activeTab === 'login'
                ? 'border-b-2 text-primary'
                : 'text-secondary hover:text-light',
            ]"
            :style="
              activeTab === 'login'
                ? 'border-color: var(--color-primary); color: var(--color-primary);'
                : 'color: var(--color-secondary);'
            "
          >
            Sign In
          </button>
          <button
            @click="activeTab = 'register'"
            :class="[
              'px-4 py-2 text-sm font-medium transition-colors',
              activeTab === 'register'
                ? 'border-b-2 text-primary'
                : 'text-secondary hover:text-light',
            ]"
            :style="
              activeTab === 'register'
                ? 'border-color: var(--color-primary); color: var(--color-primary);'
                : 'color: var(--color-secondary);'
            "
          >
            Register
          </button>
        </div>

        <!-- Error Message -->
        <div
          v-if="authStore.error"
          class="mb-4 p-3 border-2 rounded"
          style="
            background: rgba(249, 26, 16, 0.1);
            border-color: var(--color-primary-dark);
          "
        >
          <p class="text-sm" style="color: var(--color-primary-dark)">
            {{ authStore.error }}
          </p>
        </div>

        <!-- Login Form -->
        <form
          v-if="activeTab === 'login'"
          @submit.prevent="handleLogin"
          class="space-y-6"
        >
          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Email Address</label
            >
            <input
              v-model="loginForm.email"
              type="email"
              required
              class="input-modern w-full"
              placeholder="manager@daug2026.com"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Password</label
            >
            <input
              v-model="loginForm.password"
              type="password"
              required
              class="input-modern w-full"
              placeholder="Enter your password"
            />
          </div>

          <button
            type="submit"
            :disabled="authStore.loading"
            class="btn-primary w-full"
          >
            <span
              v-if="authStore.loading"
              class="flex items-center justify-center"
            >
              <svg
                class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
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
              Signing in...
            </span>
            <span v-else>Sign In</span>
          </button>
        </form>

        <!-- Register Form -->
        <form
          v-if="activeTab === 'register'"
          @submit.prevent="handleRegister"
          class="space-y-6"
        >
          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Full Name</label
            >
            <input
              v-model="registerForm.fullName"
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
              v-model="registerForm.email"
              type="email"
              required
              class="input-modern w-full"
              placeholder="manager@daug2026.com"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Password</label
            >
            <input
              v-model="registerForm.password"
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
              >Confirm Password</label
            >
            <input
              v-model="registerForm.confirmPassword"
              type="password"
              required
              class="input-modern w-full"
              placeholder="Confirm password"
            />
          </div>

          <div>
            <label
              class="block text-sm font-medium mb-2"
              style="color: var(--color-light)"
              >Role</label
            >
            <select
              v-model="registerForm.role"
              class="input-modern w-full"
              required
            >
              <option value="staff">Staff/Judge</option>
              <option value="manager">Manager</option>
            </select>
          </div>

          <button
            type="submit"
            :disabled="authStore.loading || !isFormValid"
            class="btn-primary w-full"
          >
            <span
              v-if="authStore.loading"
              class="flex items-center justify-center"
            >
              <svg
                class="animate-spin -ml-1 mr-3 h-5 w-5 text-white"
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
              Creating account...
            </span>
            <span v-else>Create Account</span>
          </button>
        </form>
      </div>

      <!-- Footer -->
      <div class="text-center">
        <p class="text-xs" style="color: var(--color-secondary)">
          © 2026 DAUG Tabulation System. All rights reserved.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore.js";

const router = useRouter();
const authStore = useAuthStore();

// State
const activeTab = ref("login");
const loginForm = ref({
  email: "",
  password: "",
});

const registerForm = ref({
  fullName: "",
  email: "",
  password: "",
  confirmPassword: "",
  role: "staff",
});

// Computed
const isFormValid = computed(() => {
  return (
    registerForm.value.fullName &&
    registerForm.value.email &&
    registerForm.value.password &&
    registerForm.value.confirmPassword &&
    registerForm.value.password === registerForm.value.confirmPassword &&
    registerForm.value.password.length >= 6
  );
});

// Methods
const handleLogin = async () => {
  const result = await authStore.login(
    loginForm.value.email,
    loginForm.value.password,
  );

  if (result.success) {
    if (authStore.isManager) {
      router.push("/manager/dashboard");
    } else {
      authStore.clearError();
      // Show error for non-managers trying to access manager portal
      authStore.error = "Access denied. Manager role required.";
    }
  }
};

const handleRegister = async () => {
  const result = await authStore.register(
    registerForm.value.email,
    registerForm.value.password,
    registerForm.value.fullName,
    registerForm.value.role,
  );

  if (result.success) {
    // Switch to login tab after successful registration
    activeTab.value = "login";
    loginForm.value.email = registerForm.value.email;
    // Clear register form
    registerForm.value = {
      fullName: "",
      email: "",
      password: "",
      confirmPassword: "",
      role: "staff",
    };
  }
};

// Lifecycle
onMounted(() => {
  // Check if user is already authenticated
  if (authStore.isAuthenticated && authStore.isManager) {
    router.push("/manager/dashboard");
  }
});
</script>
