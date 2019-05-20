<style>
.side-menu {
  flex-grow: 1;
  overflow: auto;
}
.side-menu>li>span, .side-menu>li>a {padding: .5em}
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
        ca.class = {select: this.sel == mi}
        if(!(mi.onclick || mi.href))
          if(mi.caption === undefined)
            ca.class.split = true
          else
            ca.class.deny = true
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
