<template>
  <div 
    :class="[
      'border-wreck-card',
      'bg-white',
      'relative',
      'overflow-hidden',
      className
    ]"
  >
    <!-- Ralph Breaking Effect for special cards -->
    <div v-if="ralphBreak" class="ralph-break">
      <div class="absolute -top-4 -right-4 w-20 h-20 bg-wreck-dark-blue transform rotate-45 z-10"></div>
      <div class="absolute -top-2 -right-2 w-16 h-16 bg-wreck-red transform rotate-45 z-20"></div>
    </div>
    
    <!-- Card Content -->
    <div class="relative z-30 p-6">
      <slot></slot>
    </div>
    
    <!-- Decorative corners -->
    <div class="absolute top-0 left-0 w-4 h-4 bg-wreck-orange border-r-2 border-b-2 border-black"></div>
    <div class="absolute top-0 right-0 w-4 h-4 bg-wreck-orange border-l-2 border-b-2 border-black"></div>
    <div class="absolute bottom-0 left-0 w-4 h-4 bg-wreck-orange border-r-2 border-t-2 border-black"></div>
    <div class="absolute bottom-0 right-0 w-4 h-4 bg-wreck-orange border-l-2 border-t-2 border-black"></div>
  </div>
</template>

<script>
export default {
  name: 'HeavyCard',
  props: {
    ralphBreak: {
      type: Boolean,
      default: false
    },
    className: {
      type: String,
      default: ''
    }
  }
}
</script>

<style scoped>
.border-wreck-card {
  border: 6px solid #2C1810;
  box-shadow: 
    0 0 0 2px #F77F00,
    0 0 0 4px #2C1810,
    3px 3px 0 3px #2C1810;
}

.ralph-break::before {
  content: '';
  position: absolute;
  top: -10%;
  right: -10%;
  width: 40%;
  height: 40%;
  background: #1D3557;
  transform: rotate(45deg);
  box-shadow: 
    0 0 20px #F77F00,
    inset 0 0 20px #E63946;
}
</style>
