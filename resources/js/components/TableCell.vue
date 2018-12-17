<script>
import Edit from './Edit'

export default {
  functional: true,
  props: ['columns', 'row', 'key', 'items', 'slaves', 'options'],
  components: {Edit},
  render(h, ctx) {
    let p = ctx.props, c = p.columns[p.key], r
    if(c.type) {
      let key = c.key || p.options.key, value = c.value || p.options.value
      switch(c.type) {
      case 'radio':
        r = p.items.map((o, k) => h('label', {key: k}, [h('input', {domProps: {type: 'radio', checked: p.row[p.key] == o[key], value: o[key], on: {
          change: e => p.row[p.key] = e.target.value
        }}}), h('span', {domProps: {innerHTML: o[value]}})]))
        break
      case 'select':
        let os = []
        if(p.items && p.items.length) {
          let f
          p.items.forEach((v, i) => {
            let o = {value: v[key], innerHTML: v[value]}
            if(p.row[p.key] == v[key]) {
              o.selected = true
              f = true
            }
            os.push(h('option', {domProps: o, key: i}))
          })
          if(!f && p.items && p.items.length)
            p.row[p.key] = p.items[0][key]
        } else if(p.row[p.key] !== undefined && p.row[p.key] !== null)
          p.row[p.key] = null
        r = [h('select', {on: {
          change: e => {
            p.row[p.key] = e.target.value === '' ? null : isNaN(e.target.value) ? e.target.value : parseInt(e.target.value)
            if(p.slaves && p.slaves[p.key])
              for(let s of p.slaves[p.key]) {
                let l = p.items.find(v => v[key] == p.row[p.key])
                if(l && (l = l.items))
                  for(let i in l[p.row[p.key]]) {
                    p.row[s] = i
                    break
                  }
              }
            if(ctx.data.on.change)
              ctx.data.on.change(p.row)
          }
        }}, os)]
        break
      case 'checkbox':
        r = p.items.map((o, k) => h('label', {key: k}, [h('input', {
          domProps: {type: 'checkbox', checked: p.row[p.key].find(v => v == o[key]), value: o[key]}, on: {
            change: e => {
              let i = 0, c = p.row[p.key].length
              for(; i < c; i++)
                if(p.row[p.key][i] == e.target.value)
                  break
              if(e.target.checked) {
                if(i >= c) {
                  p.row[p.key].push(o[key])
                  p.row[p.key].sort()
                }
              } else if(i < c)
                p.row[p.key].splice(i, 1)
            }
          }}), h('span', {domProps: {innerHTML: o[value]}})]))
        return h('td', {class: 'tc-chk'}, r)
      case 'pre':
        r = [h('edit', {attrs: {value: p.row[p.key]}, on: {
          input: v => p.row[p.key] = v
        }, props: {readonly: c.readonly instanceof Function ? c.readonly.call(ctx.parent) : c.readonly}})]
        break
      case 'combo':
        let id = 'dl' + Math.floor(Math.random() * 10000)
        r = [h('input', {attrs: {type: 'text', list: id, value: p.row[p.key]}, on: {
          change: e => p.row[p.key] = e.target.value
        }}), h('datalist', {attrs: {id}}, p.items.map((o, k) => h('option', {attrs: {value: o}, key: k})))]
      default:
        r = [h('input', {attrs: {type: c.type, value: p.row[p.key]}, on: {
          change: e => p.row[p.key] = e.target.value
        }})]
      }
    }
    return h('td', r)
  }
}
</script>
