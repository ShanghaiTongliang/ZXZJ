<style>
ul.drop-menu {
  display: flex;
  align-items: center;
  border-radius: .5em;
  background-color: rgba(0, 0, 0, .5);
  margin-left: 0 !important;
}
.drop-menu>li>span, .drop-menu>li>a {
  color: white;
}
</style>
<script>
import Vue from 'vue'

export default {
  props: ['menu'],
  components: {
    mi: {
      name: 'mi',
      props: ['items', 'index', 'root'],
      /*template: `<ul class="drop" @click.stop="$emit('close', index)">
  <template v-for="(mi, i) in items">
    <li :key="i" v-if="mi.condition === undefined || mi.condition($parent)" @click="miclick(mi)" @mouseover.stop="mouseover(i)"><li v-if="mi.icon" :src="mi.icon">
      <a v-if="mi.href" :href="mi.href">{{mi.caption + (mi.items ? ' >' : '')}}</a>
      <span v-else v-html="mi.caption + (mi.items ? ' >' : '')"></span>
      <mi v-if="mi.items" v-show="mi.visible" :items="mi.items" :visible="mi.visible" :index="i" :root="root" @close="close"></mi>
    </li>
  </template>
</ul>`,*/
      render(h) {
        return h('ul', {class: 'drop', on: {
          click: e => {
            e.stopPropagation()
            this.$emit('close', this.index)
          }}},
          this.items.filter(mi => mi.condition === undefined || mi.condition instanceof Function && mi.condition.call(this.root) || mi.condition).map((mi, i) => {
            let c = []
            //if(mi.icon)
            //  c.push(h('img'))
            if(mi.href)
              c.push(h('a', {attrs: {href: mi.href}, domProps: {innerHTML: mi.caption}}))
            else
              c.push(h('span', {domProps: {innerHTML: mi.caption}}))
            if(mi.items)
              c.push(h('mi', {style: {display: mi.visible ? null : 'none'}, props: {items: mi.items, index: i, root: this.root}}))
            return h('li', {key: i, on: {
              click: () => mi.onclick && mi.onclick.call(this.root),
              mouseover: e => {
                e.stopPropagation()
                let _this = this
                if(_this.cur >= 0)
                  Vue.set(_this.items[_this.cur], 'visible', false)
                _this.cur = i
                Vue.set(_this.items[i], 'visible', true)
              },
            }}, c)
          })
        )
      },
      data() {
        return {
          cur: -1
        }
      }
    }
  },
  /*template: `<ul class="menu drop-menu">
    <template v-for="(mi, i) in menu">
      <li :key="i" v-if="mi.condition === undefined || mi.condition($parent)" @click.stop="miclick(mi, i)">
        <a v-if="mi.href" :href="mi.href"><img v-if="mi.icon" :src="mi.icon">{{mi.caption}}</a>
        <template v-else>
          <img v-if="mi.icon" :src="mi.icon"><span v-html="mi.caption"></span>
        </template>
        <mi v-if="mi.items" v-show="items && items[i].visible" :items="mi.items" :index="i" :root="$parent" @close="close"></mi>
      </li>
    </template>
  </ul>`,*/
  render(h) {
    let p = this.$parent
    return h('ul', {class: ['menu', 'drop-menu']},
    this.menu.filter(mi => mi.condition === undefined || mi.condition instanceof Function && mi.condition.call(p) || mi.condition)
    .map((mi, i) => {
      let ct = 'span', ca = {domProps: {innerHTML: mi.caption}}, c
      if(mi.icon) {
        c = [h('img', {attrs: {src: mi.icon}}), h(ct, ca)]
        ca = {}
      }
      if(mi.href) {
        if(!c)
          c = [h(ct, ca, c)]
        ct = 'a'
        ca = {attrs: {href: mi.href}}
      }
      ca.class = {deny: !(mi.onclick || mi.href), select: this.sel == mi}
      /*ca.on = {
        click: e => {
          //e.stopPropagation()
          if(mi.onclick || mi.href) {
            this.$emit('select', mi)
            this.s = mi
            if(mi.onclick)
              mi.onclick.call(p, e)
          }
        }
      }*/
      return h('li', {key: i, on: {
        click: e => {
          e.stopPropagation()
          if(mi.items) {
            this.cur = i
            this.items[i].visible = true
          }
          if(mi.onclick)
            mi.onclick.call(p)
        }
      }}, [h(ct, ca, c), mi.items && h('mi', {props: {items: mi.items, index: i, root: p},
      style: {display: this.menu[i].visible ? null : 'none'},
      on: {
        close: i => {
          this.cur = -1
          this.items[i].visible = false
        }
      }})])
    }))
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
