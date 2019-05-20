<style>
.iconbar {
  position: absolute;
  top: 0;
  z-index: 100;
}
nav.iconbar {
  background-color: white;
  display: flex;
  bottom: 0;
  box-shadow: 0 0 1em rgba(0, 0, 0, .5);
}
.iconbar-icon {
  width: 2em;
  height: 2em;
  border: .2em solid;
  border-radius: 20%;
  border-image: linear-gradient(to left top, orange, yellow) 1;
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  background-color: white;
  cursor: pointer;
}
.iconbar-icon div {
  color: white;
  text-align: center;
  margin-top: 1em;
}
.iconbar-icon span {
  padding: 0 .2em;
  background-color: rgba(0, 0, 0, .5);
  border-radius: .2em;
}
</style>
<template>
  <div>
    <div v-show="!s" class="iconbar iconbar-icon" :style="right ? {right: 0, backgroundImage: `url(${icon})`} : {backgroundImage: `url(${icon})`}" @click.stop="toggle">
      <div v-if="text">
        <span>{{text}}</span>
      </div>
    </div>
    <nav v-show="s" class="iconbar" :style="right ? {right: 0, width: width || '140px'} : {width: width || '140px'}" @click.stop>
      <slot></slot>
    </nav>
  </div>
</template>
<script>
import SideMenu from './SideMenu'

export default {
  props: ['icon', 'text', 'width', 'right', 'show'],
  data() {
    return {
      s: this.show
    }
  },
  watch: {
    show(v) {
      this.s = v
    }
  },
  methods: {
    toggle() {
      this.s = !this.s
      this.$emit('show', this.s)
    }
  },
  created() {
    document.addEventListener('click', e => {
      if(this.s)
        this.toggle()
    })
  }
}
</script>
