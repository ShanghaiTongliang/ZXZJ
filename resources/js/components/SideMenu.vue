<style>
.side-menu {
  flex-grow: 1;
  overflow: auto;
}
.side-menu ul {
  overflow: hidden;
  transition: all .2s;
}
.side-menu>li>span, .side-menu>li>a {padding: .5em}
.side-menu .menu {margin: 0 0 0 1.5em}
.click {cursor: pointer}
</style>
<script>
import Vue from 'vue'

export default {
  props: ['menu', 'selection'],
  render(h) {
    let p = this.$parent, r = (menu, root, show) => {
      let ms = menu.filter(mi => mi.condition === undefined || mi.condition instanceof Function && mi.condition.call(p) || mi.condition)
      return h('ul', {class: ['menu', root && 'side-menu'], style: {height: show ? `${2.3 * ms.length}em` : 0}},
        ms.map((mi, i) => {
          let ct = 'span', ca = {domProps: {innerHTML: mi.caption}}, c

          let _this = this

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
          ca.class = {select: this.sel == mi}
          if(!(mi.onclick || mi.href))
            if(mi.caption === undefined)
              ca.class.split = true
            else
              ca.class.deny = true
          ca.on = {
            click: e => {
              mi.expand = !mi.expand
              if(mi.onclick || mi.href) {
                this.$emit('select', mi)
                if(this.sel) {
                  let m = this.sel
                  while(m.parent && m.parent != mi.parent) {
                    m.parent.expand = false
                    m = m.parent
                  }
                }
                this.sel = mi
                if(mi.onclick)
                  mi.onclick.call(p, e)
              }
            }
          }
          return h('li', {key: i}, [h(ct, ca, c), mi.items && r(mi.items, false, mi.expand)])
        }))
    }
    return r(this.menu, true, true)
  },
  data() {
    return {
      sel: null
    }
  },
  watch: {
    selection: {
      immediate: true,
      handler(v) {
        this.sel = v
      }
    }
  },
  mounted() {
    const exp = (m) => {
      m.forEach(m => {
        Vue.set(m, 'expand', m == this.selection)
        if(m.items) {
          m.items.forEach(mi => {
            mi.parent = m
            if(mi == this.selection)
              Vue.set(m, 'expand', true)
          })
          exp(m.items)
        }
      })
    }
    exp(this.menu)
  }
}
</script>
