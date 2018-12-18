<style>
</style>
<template>
  <div style="display: flex; flex-direction: column">
    <div>
      <p>Using mustaches: {{ rawHtml }}</p>
      <p>Using v-html directive: <span v-html="rawHtml"></span></p>
    </div>
    <textarea v-model="rawHtml" style="flex-grow: 1"></textarea>
  </div>
</template>
<script>

export default {
  data() {
    return {
      rawHtml: `Using mustaches: <span style="color: red">This should be red.</span><br>
<img src="img/user16.png">`
    }
  },
  mounted() {
    window.test = this
  }
}
</script>
