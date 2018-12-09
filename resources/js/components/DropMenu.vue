<style>
ul.drop-menu {
  display: flex;
  align-items: center;
  margin: 0;
}
.drop-menu>li>span, .drop-menu>li>a {
  color: white;
  background-color: rgba(0, 0, 0, .5);
}
.drop-menu>li:first-child>a, .drop-menu>li:first-child>span {
  border-top-left-radius: .5em;
  border-bottom-left-radius: .5em;
}
.drop-menu>li:last-child>a, .drop-menu>li:last-child>span {
  border-top-right-radius: .5em;
  border-bottom-right-radius: .5em;
}
.drop-menu .menu {
  color: black;
  background-color: white;
  box-shadow: 0 0 .2em .2em rgba(0, 0, 0, .2);
  min-width: 100%;
  position: absolute;
  left: 100%;
  top: 0;
}
.drop-menu .menu.right {left: -100%}
.drop-menu>li>.menu {
  left: 0 !important;
  top: 100%;
}
</style>
<script>
import Vue from 'vue'

export default {
  props: ['menu', 'right'],
  render(h) {
    let p = this.$parent, r = (menu, v) => {
      let a = {
        class: ['menu'],
        on: {
          mouseleave: () => menu.selection = null
        }
      }
      if(v === undefined)
        a.class.push('drop-menu')
      else {
        if(!v)
          a.style = {display: 'none'}
        if(this.right)
          a.class.push('right')
      }
      return h('ul', a, menu.filter(mi => mi.condition === undefined || mi.condition instanceof Function && mi.condition.call(p) || mi.condition)
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
        ca.class = !(mi.onclick || mi.href ||mi.items) && 'deny'
        ca.on = {
          click: e => {
            if(mi.onclick || mi.href) {
              function clear(ms) {
                ms.selection = null
                if(ms.items)
                  clear(ms)
              }
              clear(this.menu)
              if(mi.onclick)
                mi.onclick.call(p, e)
            }
          },
          mouseenter: () => Vue.set(menu, 'selection', mi)
        }
        return h('li', {key: i}, [h(ct, ca, c), mi.items && r(mi.items, menu.selection == mi)])
      }))
    }
    return r(this.menu)
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
