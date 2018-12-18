<style>
.tc-chk {text-align: left}
</style>

<script>
import Edit from './Edit'
import ComboBox from './ComboBox'
import Pinyin from './Pinyin'

export default {
  functional: true,
  props: ['columns', 'row', 'key', 'items', 'slaves', 'options'],
  components: {Edit, ComboBox, Pinyin},
  render(h, ctx) {
    let p = ctx.props, c = p.columns[p.key], r
    if(c.type) {
      let keyName = c.keyName || p.options.keyName, valueName = c.valueName || p.options.valueName
      switch(c.type) {
      case 'radio':
        r = p.items.map((o, k) => h('label', {key: k}, [h('input', {domProps: {type: 'radio', checked: p.row[p.key] == o[keyName], value: o[keyName], on: {
          change: e => p.row[p.key] = e.target.value
        }}}), h('span', {domProps: {innerHTML: o[valueName]}})]))
        break
      case 'select':
        let os = []
        if(p.items && p.items.length) {
          let f
          p.items.forEach((v, i) => {
            let o = {value: v[keyName], innerHTML: v[valueName]}
            if(p.row[p.key] == v[keyName]) {
              o.selected = true
              f = true
            }
            os.push(h('option', {domProps: o, key: i}))
          })
          if(!f && p.items && p.items.length)
            p.row[p.key] = p.items[0][keyName]
        } else if(p.row[p.key] !== undefined && p.row[p.key] !== null)
          p.row[p.key] = null
        r = [h('select', {on: {
          change: e => {
            p.row[p.key] = e.target.value === '' ? null : isNaN(e.target.value) ? e.target.value : parseInt(e.target.value)
            if(p.slaves && p.slaves[p.key])
              for(let s of p.slaves[p.key]) {
                let l = p.items.find(v => v[keyName] == p.row[p.key])
                if(l && (l = l.items))
                  for(let i in l[p.row[p.key]]) {
                    p.row[s] = i
                    break
                  }
              }
            if(ctx.data.on.input)
              ctx.data.on.input(p.row)
          }
        }}, os)]
        break
      case 'checkbox':
        r = p.items.map((o, k) => h('label', {key: k}, [h('input', {
          domProps: {type: 'checkbox', checked: p.row[p.key].find(v => v == o[keyName]), value: o[keyName]}, on: {
            change: e => {
              let i = 0, c = p.row[p.key].length
              for(; i < c; i++)
                if(p.row[p.key][i] == e.target.value)
                  break
              if(e.target.checked) {
                if(i >= c) {
                  p.row[p.key].push(o[keyName])
                  p.row[p.key].sort()
                }
              } else if(i < c)
                p.row[p.key].splice(i, 1)
            }
          }}), h('span', {domProps: {innerHTML: o[valueName]}})]))
        return h('td', {class: 'tc-chk'}, r)
      case 'pre':
        r = [h('edit', {attrs: {value: p.row[p.key]}, on: {
          input: v => p.row[p.key] = v
        }, props: {readonly: c.readonly instanceof Function ? c.readonly.call(ctx.parent) : c.readonly}})]
        break
      case 'combo':
        //console.log('combo render')
        r = [h('combo-box', {on: {
          input: v => {
            p.row[p.key] = v
            ctx.data.on.input && ctx.data.on.input(v)
          },
        }, props: {value: p.row[p.key], items: p.items}})]
        break
      case 'pinyin':
        r = [h('pinyin', {on: {
          input: v => {
            p.row[p.key] = v
            ctx.data.on.input && ctx.data.on.input(v)
          }
        }, props: {value: p.row[p.key], items: p.items}})]
        break
      default:
        r = [h('input', {attrs: {type: c.type, value: p.row[p.key]}, on: {
          input: e => p.row[p.key] = e.target.value
        }})]
      }
    }
    return h('td', r)
  }
}
</script>
