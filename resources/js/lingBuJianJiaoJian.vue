<style>
.page2 {background-color: lightblue}
</style>
<template>
  <div class="page2">
    Page2
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
