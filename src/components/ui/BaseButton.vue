<template>
  <button 
    :class="[
      'btn-wreck',
      variant === 'primary' && 'bg-gradient-to-b from-wreck-red to-wreck-orange',
      variant === 'secondary' && 'bg-gradient-to-b from-wreck-blue to-wreck-dark-blue',
      disabled && 'opacity-50 cursor-not-allowed',
      className
    ]"
    :disabled="disabled"
    @click="$emit('click')"
  >
    <span class="relative z-10">{{ text }}</span>
  </button>
</template>

<script>
export default {
  name: 'BaseButton',
  props: {
    text: {
      type: String,
      required: true
    },
    variant: {
      type: String,
      default: 'primary',
      validator: (value) => ['primary', 'secondary'].includes(value)
    },
    disabled: {
      type: Boolean,
      default: false
    },
    className: {
      type: String,
      default: ''
    }
  },
  emits: ['click']
}
</script>

<style scoped>
.btn-wreck {
  font-family: 'Press Start 2P', cursive;
  color: white;
  padding: 12px 24px;
  border: 4px solid black;
  position: relative;
  box-shadow: 
    0 4px 0 #2C1810,
    0 6px 8px rgba(0,0,0,0.3);
}

.btn-wreck:active:not(:disabled) {
  transform: translateY(2px);
  box-shadow: 
    0 2px 0 #2C1810,
    0 3px 4px rgba(0,0,0,0.3);
}
</style>
