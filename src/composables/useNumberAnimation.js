import { ref, watch, onUnmounted } from 'vue'

export function useNumberAnimation(initialValue = 0, duration = 1000) {
  const animatedValue = ref(initialValue)
  const currentValue = ref(initialValue)
  let animationId = null
  let startTime = null
  let startValue = 0
  let targetValue = 0

  const easeOutQuart = (t) => {
    return 1 - Math.pow(1 - t, 4)
  }

  const animate = (timestamp) => {
    if (!startTime) startTime = timestamp
    const progress = Math.min((timestamp - startTime) / duration, 1)
    
    const easedProgress = easeOutQuart(progress)
    const newValue = startValue + (targetValue - startValue) * easedProgress
    
    animatedValue.value = Math.round(newValue)

    if (progress < 1) {
      animationId = requestAnimationFrame(animate)
    } else {
      animatedValue.value = targetValue
    }
  }

  const setValue = (newValue) => {
    if (animationId) {
      cancelAnimationFrame(animationId)
    }
    
    startValue = animatedValue.value
    targetValue = newValue
    startTime = null
    
    if (startValue !== targetValue) {
      animationId = requestAnimationFrame(animate)
    }
  }

  const setInstant = (newValue) => {
    if (animationId) {
      cancelAnimationFrame(animationId)
    }
    animatedValue.value = newValue
    currentValue.value = newValue
  }

  onUnmounted(() => {
    if (animationId) {
      cancelAnimationFrame(animationId)
    }
  })

  return {
    animatedValue,
    setValue,
    setInstant
  }
}

export function useAnimatedPoints(points, duration = 800) {
  const { animatedValue, setValue } = useNumberAnimation(0, duration)

  watch(points, (newPoints) => {
    setValue(newPoints)
  }, { immediate: true })

  return animatedValue
}
