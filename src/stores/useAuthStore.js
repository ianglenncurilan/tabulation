import { defineStore } from "pinia";
import { ref, computed } from "vue";
import {
  getCurrentUser,
  signIn,
  signUp,
  signOut,
  getProfiles,
} from "@/utils/supabase.js";

export const useAuthStore = defineStore("auth", () => {
  // State
  const user = ref(null);
  const profile = ref(null);
  const loading = ref(false);
  const error = ref(null);
  const allProfiles = ref([]);

  // Getters
  const isAuthenticated = computed(() => !!user.value);
  const isManager = computed(() => profile.value?.role === "manager");
  const isStaff = computed(() => profile.value?.role === "staff");
  const fullName = computed(() => profile.value?.full_name || "");
  const userEmail = computed(() => user.value?.email || "");
  const userRole = computed(() => profile.value?.role || "");

  // Actions
  const initAuth = async () => {
    try {
      loading.value = true;
      error.value = null;

      const currentUser = await getCurrentUser();
      if (currentUser) {
        user.value = currentUser;

        // Get profile from metadata or fetch from profiles table
        if (currentUser.user_metadata?.role) {
          profile.value = {
            id: currentUser.id,
            email: currentUser.email,
            full_name: currentUser.user_metadata.full_name,
            role: currentUser.user_metadata.role,
          };
        } else {
          // Fetch profile from database
          const { data: profiles } = await getProfiles();
          const userProfile = profiles.find((p) => p.id === currentUser.id);
          if (userProfile) {
            profile.value = userProfile;
          }
        }
      }
    } catch (err) {
      error.value = err.message;
      console.error("Auth initialization error:", err);
    } finally {
      loading.value = false;
    }
  };

  const login = async (email, password) => {
    try {
      loading.value = true;
      error.value = null;

      const { user: authUser } = await signIn(email, password);
      user.value = authUser;

      // Set profile from user metadata
      if (authUser.user_metadata) {
        profile.value = {
          id: authUser.id,
          email: authUser.email,
          full_name: authUser.user_metadata.full_name,
          role: authUser.user_metadata.role,
        };
      }

      return { success: true };
    } catch (err) {
      error.value = err.message;
      return { success: false, error: err.message };
    } finally {
      loading.value = false;
    }
  };

  const register = async (email, password, fullName, role = "staff") => {
    try {
      loading.value = true;
      error.value = null;

      const { user: authUser } = await signUp(email, password, fullName, role);

      return { success: true, user: authUser };
    } catch (err) {
      error.value = err.message;
      return { success: false, error: err.message };
    } finally {
      loading.value = false;
    }
  };

  const logout = async () => {
    try {
      await signOut();
      user.value = null;
      profile.value = null;
      error.value = null;
    } catch (err) {
      error.value = err.message;
      console.error("Logout error:", err);
    }
  };

  const fetchAllProfiles = async () => {
    try {
      loading.value = true;
      const profiles = await getProfiles();
      allProfiles.value = profiles;
    } catch (err) {
      error.value = err.message;
      console.error("Error fetching profiles:", err);
    } finally {
      loading.value = false;
    }
  };

  const clearError = () => {
    error.value = null;
  };

  return {
    // State
    user,
    profile,
    loading,
    error,
    allProfiles,

    // Getters
    isAuthenticated,
    isManager,
    isStaff,
    fullName,
    userEmail,
    userRole,

    // Actions
    initAuth,
    login,
    register,
    logout,
    fetchAllProfiles,
    clearError,
  };
});
