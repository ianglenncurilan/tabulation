<template>
  <div class="relative">
    <input
      :type="type"
      :placeholder="placeholder"
      :value="modelValue"
      :class="[
        'input-wreck',
        'w-full',
        'font-pixel',
        'bg-white',
        'border-4',
        'border-black',
        'px-4',
        'py-2',
        'focus:outline-none',
        'focus:ring-4',
        'focus:ring-wreck-orange',
        className
      ]"
      @input="$emit('update:modelValue', $event.target.value)"
      @keyup.enter="$emit('enter')"
    />
    <div class="absolute inset-0 pointer-events-none">
      <div class="absolute inset-0 border-2 border-wreck-light-blue m-1"></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseInput',
  props: {
    modelValue: {
      type: String,
      default: ''
    },
    type: {
      type: String,
      default: 'text'
    },
    placeholder: {
      type: String,
      default: ''
    },
    className: {
      type: String,
      default: ''
    }
  },
  emits: ['update:modelValue', 'enter']
}
</script>

<style scoped>
.input-wreck {
  font-family: 'Press Start 2P', cursive;
  box-shadow: 
    inset 2px 2px 0 #A8DADC,
    inset -2px -2px 0 #A8DADC;
}
</style>
