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
  <div v-show="msg" class="msg-wrap" style="display: none">
    <div :class="err ? ['msg-error'] : null" class="msg" v-html="msg"></div>
  </div>
</template>
<script>
export default {
  props: ['timeout'],
  data() {
    return {
      msg: null,
      err: false
    }
  },
  methods: {
    message(v) {
      this.msg = v
      if(v) {
        if(this.tmr)
          clearTimeout(this.tmr)
        this.tmr = setTimeout(this.hide, this.timeout | 5000)
      }
    },
    error(v) {
      this.err = v
      this.message(v)
    },
    hide() {
      if(this.tmr) {
        clearTimeout(this.tmr)
        this.tmr = null
      }
      this.msg = null
      this.err = false
    }
  }
}
</script>
