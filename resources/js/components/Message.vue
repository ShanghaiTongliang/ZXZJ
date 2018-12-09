<style>
.msg-wrap {
  text-align: center;
  position: fixed;
  left: 0;
  right: 0;
  top: 40px;
  z-index: 100;
  pointer-events: none;
}
.msg {
  background: white;
  padding: .2em .5em;
  border-radius: .5em;
  box-shadow: .2em .2em rgba(0, 0, 0, .5);
  display: inline-block;
}
.msg-error {
  color: red;
  background-color: yellow;
}
</style>
<template>
  <div v-show="message" class="msg-wrap" style="display: none">
    <div :class="error && 'msg-error'" class="msg" v-html="message"></div>
  </div>
</template>
<script>
export default {
  props: ['message', 'error']
}
</script>
