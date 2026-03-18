import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUIStore = defineStore('ui', () => {
  const showDashboardInfo = ref(true)

  const toggleDashboardInfo = () => {
    showDashboardInfo.value = !showDashboardInfo.value
  }

  const setDashboardInfoVisibility = (visible) => {
    showDashboardInfo.value = visible
  }

  return {
    showDashboardInfo,
    toggleDashboardInfo,
    setDashboardInfoVisibility
  }
})
