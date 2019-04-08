<style>
.side-menu {
  flex-grow: 1;
  overflow: auto;
}
.side-menu .menu {margin: 0 0 0 1.5em}
.click {cursor: pointer}
</style>
<script>
import Resizer from './Resizer'

export default {
  components: {Resizer},
  props: ['menu', 'selection', 'width', 'right'],
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
    return h('resizer', {props: {width: this.width, right: this.right}}, [this.$slots.header, r(this.menu, true), this.$slots.footer])
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
