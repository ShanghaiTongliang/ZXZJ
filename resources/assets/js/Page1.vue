<style>
.page1 {background-color: yellow}
</style>
<template>
  <div class="page1">
    Page1
  </div>
</template>
<script>
export default {
  beforeRouteEnter(to, from, next) {
    next(vm => {
      console.log(to.name)
    })
  }
}
</script>
