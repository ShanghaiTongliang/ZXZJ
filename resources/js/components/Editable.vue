<style>
.editable {
  border: inset 1px;
  -webkit-user-modify: read-write-plaintext-only;
  background-color: white;
}
</style>
<template>
  <pre v-html="innerText" :contenteditable="editable && 'plaintext-only'" :class="editable ? 'editable' : null" @focus="locked = true" @blur="locked = false" @input="input"></pre>
</template>
<script>
export default {
  props: ['value', 'editable'],
  data() {
    return {
      innerText: this.value,
      locked: false
    }
  },
  watch: {
    value() {
      if(!(this.locked && this.innerText))
        this.innerText = this.value
    }
  },
  methods: {
    input() {
      this.$emit('input', this.$el.innerHTML)
    }
  }
}
</script>
