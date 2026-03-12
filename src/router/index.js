import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "@/stores/useAuthStore.js";

// Components
import ManagerAuth from "@/components/auth/ManagerAuth.vue";
import ManagerDashboard from "@/components/manager/ManagerDashboard.vue";
import DashboardView from "@/views/DashboardView.vue";

const routes = [
  {
    path: "/",
    name: "PublicDashboard",
    component: DashboardView,
    meta: { requiresAuth: false },
  },
  {
    path: "/manager/auth",
    name: "ManagerAuth",
    component: ManagerAuth,
    meta: { requiresAuth: false },
  },
  {
    path: "/manager/dashboard",
    name: "ManagerDashboard",
    component: ManagerDashboard,
    meta: { requiresAuth: true, requiresManager: true },
  },
  {
    path: "/:pathMatch(.*)*",
    redirect: "/",
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Navigation guards
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore();

  // Initialize auth if not already done
  if (!authStore.user) {
    await authStore.initAuth();
  }

  // Check if route requires authentication
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next("/manager/auth");
    return;
  }

  // Check if route requires manager role
  if (to.meta.requiresManager && !authStore.isManager) {
    next("/manager/auth");
    return;
  }

  // Redirect authenticated users away from auth pages
  if (
    to.name === "ManagerAuth" &&
    authStore.isAuthenticated &&
    authStore.isManager
  ) {
    next("/manager/dashboard");
    return;
  }

  next();
});

export default router;
