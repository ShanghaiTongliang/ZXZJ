<style>
.side-menu {
  margin-left: 0 !important;
  overflow: auto;
<<<<<<< HEAD
 }
=======
}
>>>>>>> 8e4db0cb4d0fcacf96958a92188650026fece49c
.click {cursor: pointer}
</style>
<script>
export default {
  props: ['menu', 'selection'],
  render(h) {
    let p = this.$parent, r = (menu, f) => {
      return h('ul', {class: ['menu', f && 'side-menu']}, menu.filter(mi => mi.condition === undefined || mi.condition.call(p))
      .map((mi, i) => {
        let ct = 'span', ca = {domProps: {innerHTML: mi.caption}}, c
        if(mi.icon) {
          c = [h('img', {attrs: {src: mi.icon}}), h(ct, ca)]
          ca = {}
        }
        if(mi.href) {
          c = [h(ct, ca, c)]
          ct = 'a'
          ca = {attrs: {href: mi.href}}
        }
        ca.class = {deny: !(mi.onclick || mi.href), select: this.sel == mi}
        ca.on = {
          click: e => {
            //e.stopPropagation()
            this.$emit('select', mi)
            if(mi.onclick || mi.href) {
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
      s: 123
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
