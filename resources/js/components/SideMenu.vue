<style>
.side-menu {overflow: auto}
.side-menu .menu {margin: 0 0 0 1.5em}
.click {cursor: pointer}
</style>
<script>
export default {
  props: ['menu', 'selection'],
  render(h) {
    let p = this.$parent, r = (menu, f) => {
      return h('ul', {class: ['menu', f && 'side-menu']}, menu.filter(mi => mi.condition === undefined || mi.condition instanceof Function && mi.condition.call(p) || mi.condition)
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
        ca.on = {
          click: e => {
            if(mi.onclick || mi.href) {
              this.$emit('select', mi)
              this.s = mi
              if(mi.onclick)
                mi.onclick.call(p, e)
            }
          }
        }
        return h('li', {key: i}, [h(ct, ca, c), mi.items && r(mi.items)])
      }))
    }
    return r(this.menu, true)
  },
  data() {
    return {
      s: null
    }
  },
  computed: {
    sel() {
      if(this.selection !== undefined)
        this.s = this.selection
      return this.s
    }
  }
}
</script>
