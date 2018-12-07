<style>
ul.drop-menu {
  display: flex;
  align-items: center;
  border-radius: .5em;
  background-color: rgba(0, 0, 0, .5);
}
.drop-menu>li>span, .drop-menu>li>a {
  color: white;
}
</style>
<template>
  <ul class="menu drop-menu">
    <template v-for="(mi, i) in menu">
      <li :key="i" v-if="mi.condition === undefined || mi.condition($parent)" @click.stop="miclick(mi, i)">
        <a v-if="mi.href" :href="mi.href"><img v-if="mi.icon" :src="mi.icon">{{mi.caption}}</a>
        <template v-else>
          <img v-if="mi.icon" :src="mi.icon"><span v-html="mi.caption"></span>
        </template>
        <mi v-if="mi.items" v-show="items && items[i].visible" :items="mi.items" :index="i" :root="$parent" @close="close"></mi>
      </li>
    </template>
  </ul>
</template>
<script>
import Vue from 'vue'

export default {
  props: ['menu'],
  components: {
    mi: {
      name: 'mi',
      props: ['items', 'index', 'root'],
      template: `<ul class="drop" @click.stop="$emit('close', index)">
  <template v-for="(mi, i) in items">
    <li :key="i" v-if="mi.condition === undefined || mi.condition($parent)" @click="miclick(mi)" @mouseover.stop="mouseover(i)"><li v-if="mi.icon" :src="mi.icon">
      <a v-if="mi.href" :href="mi.href">{{mi.caption + (mi.items ? ' >' : '')}}</a>
      <span v-else v-html="mi.caption + (mi.items ? ' >' : '')"></span>
      <mi v-if="mi.items" v-show="mi.visible" :items="mi.items" :visible="mi.visible" :index="i" :root="root" @close="close"></mi>
    </li>
  </template>
</ul>
`,
      data() {
        return {
          cur: -1,
        }
      },
      methods: {
        miclick(mi) {
          mi.onclick && mi.onclick.call(this.root)
        },
        mouseover(i) {
          if(this.cur >= 0)
            Vue.set(this.items[this.cur], 'visible', false)
          this.cur = i
          Vue.set(this.items[i], 'visible', true)
        },
        close(i) {
          this.cur = -1
          this.items[i].visible = false
          this.$emit('close', this.index)
        }
      }
    }
  },
  data() {
    return {
      cur: -1,
      it: null
    }
  },
  computed: {
    items() {
      if(!this.it) {
        this.it = this.menu
        this.it.forEach(e => Vue.set(e, 'visible', false))
      }
      return this.it
    }
  },
  methods: {
    miclick(mi, i) {
      if(mi.items) {
        this.cur = i
        this.items[i].visible = true
      }
      if(mi.onclick)
        mi.onclick.call(this.$parent)
    },
    close(i) {
      this.cur = -1
      this.items[i].visible = false
    }
  },
  mounted() {
    document.addEventListener('click', e => {
      if(this.cur >= 0)
        this.items[this.cur].visible = false
    })
  }
}
</script>
