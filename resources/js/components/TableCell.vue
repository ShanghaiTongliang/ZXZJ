<script>
import Editable from './Editable'

export default {
  functional: true,
  props: ['columns', 'row', 'key', 'items', 'slaves'],
  components: {Editable},
  render(h, ctx) {
    let p = ctx.props, c = p.columns[p.key], r
    if(c.type)
      switch(c.type) {
      case 'radio':
        r = p.items.map((o, k) => h('label', {key: k}, [h('input', {domProps: {type: 'radio', checked: p.row[p.key] == k, value: k, on: {
          change: e => p.row[p.key] = e.target.value
        }}}), h('span', {domProps: {innerHTML: o}})]))
        break
      case 'select':
        let os = [], l = c.master ? p.items[p.row[c.master]] : p.items
        for(let k in l) {
          let o = l[k]
          os.push(h('option', {domProps: {value: k, innerHTML: o}, key: k}))
        }
        r = [h('select', {domProps: {value: p.row[p.key]}, on: {
          change: e => {
            p.row[p.key] = e.target.value
            if(p.slaves && p.slaves[p.key])
              for(let s of p.slaves[p.key]) {
                let l = p.columns[s].items
                if(l instanceof Function)
                  l = l.call(p.$parent, p.row, i)
                for(let i in l[p.row[p.key]]) {
                  p.row[s] = i
                  break
                }
              }
            if(c.onchange)
              c.onchange(p.row)
          }
        }}, os)]
        break
      case 'checkbox':
        r = []
        for(let k in p.items) {
          let i = 0; c = p.row[p.key].length
          for(; i < c; i++)
            if(p.row[p.key][i] == k)
              break
          r.push(h('label', {key: k}, [h('input', {domProps: {type: 'checkbox', checked: i < c, value: k}, on: {
            change: e => {
              let i = 0, c = p.row[p.key].length
              for(; i < c; i++)
                if(p.row[p.key][i] == e.target.value)
                  break
              if(e.target.checked) {
                if(i >= c) {
                  p.row[p.key].push(e.target.value)
                  p.row[p.key].sort()
                }
              } else if(i < c)
                p.row[p.key].splice(i, 1)
            }
          }}), h('span', {domProps: {innerHTML: p.items[k]}})]))
        }
        return h('td', {class: 'tc-chk'}, r)
      case 'pre':
        r = [h('editable', {attrs: {value: p.row[p.key]}, on: {
          input: v => p.row[p.key] = v
        }, props: {editable: c.editable instanceof Function ? c.editable.call(ctx.parent) : c.editable}})]
        break
      default:
        r = [h('input', {attrs: {type: c.type, value: p.row[p.key]}, on: {
          change: e => p.row[p.key] = e.target.value
        }})]
      }
    return h('td', r)
  }
}
</script>
