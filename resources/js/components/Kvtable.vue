<style>
.kv-ver td:first-child {
  font-weight: bold;
  background-color: lightblue;
  border: 1px outset white;
  white-space: nowrap;
}
.kv-ver tr:first-child td:first-child {border-top-left-radius: .5em}
.kv-ver tr:last-child td:first-child {border-bottom-left-radius: .5em}
.kvtable td label {min-width: 9em}
.kvtable input[type=text] {min-width: 4em}
</style>
<script>
import Editable from './Editable'
import TableCell from './TableCell'
import { install } from 'vuex';

export default {
  components: {Editable, TableCell},
  props: ['tbl', 'vertical'],
  render(h) {
    let tbl = this.tbl, r = [], th = [], td = [], cols = tbl.columns, row = tbl.data, ne
      , c = tbl.caption instanceof Function ? tbl.caption.call(this.$parent) : tbl.caption
    if(c || this.$slots.default)
      r.push(h('caption', [c ? h('span', {domProps: {innerHTML: c}}) : null, this.$slots.default]))
    if(cols) {
      if(row)
        for(let k in row) {
          ne = true
          break
        }
      for(let i in cols) {
        c = cols[i]
        if(c instanceof Object) {
          if(c.condition === undefined || (c.condition instanceof Function ? c.condition.call(this.$parent, i) : c.condition)) {
            th.push({domProps: {innerHTML: c.caption}})
            if(ne)
              if(c.render instanceof Function) {
                let d = c.render.call(this.$parent, h, row[i])
                td.push(h('td', {key: i}, d instanceof Object ? [d] : d))
              } else {
                let l = c.items instanceof Function ? c.items.call(this.$parent) : c.items
                if(c.type)
                  td.push(h('table-cell', {props: {columns: cols, row, key: i, items: l}}))
                else {
                  let t
                  if(l)
                    t = c.filter ? c.filter.call(this.$parent, l, i) : row[i] instanceof Array ?
                      row[i].map(i => l[i]).join(', ') : l[row[i]]
                  else
                    t = c.filter ? c.filter.call(this.$parent, row[i], i, row) : row[i]
                  if(c.href)
                    td.push(h('td', [h('a', {domProps: {href: row[c.href]}, key: i}, t)]))
                  else
                    td.push(h('td', {domProps: t !== undefined && {innerHTML: t}, key: i}))
                }
              }
          }
        } else {
          th.push({domProps: {innerHTML: c}})
          if(ne)
            td.push(h('td', {domProps: {innerHTML: row[i]}, key: i}))
        }
      }
      if(tbl.action && ne) {
        let a = tbl.action.filter(a => a.condition === undefined || (a.condition instanceof Function ? a.condition.call(this.$parent) : a.condition))
        if(a) {
          th.push('操作')
          td.push(h('td', a.map((a, i) => h('button', {on: {
            click: () => a.onclick.call(this.$parent)
          }, key: i, domProps: {innerHTML: a.caption}}))))
        }
      }
    } else {
      tbl.data.forEach((k, v) => {
        th.push({domProps: {innerHTML: v}})
        td.push(h('td', {domProps: {innerHTML: k}}))
      })
    }
    if(this.vertical)
      r.push(h('tbody', th.map((th, i) => h('tr', {key: i}, [h('td', th), td[i]]))))
    else {
      if(!ne) {
        //if(th.length)
        //  th[0].attrs = {colspan: th.length}
        td.push(h('td', {attrs: {colspan: th.length}}, '无数据'))
      }
      r.push(h('thead', [h('tr', th.map(th => h('th', th)))]))
      r.push(h('tbody', [h('tr', td)]))
    }
    return h('div', {class: {'dt-out': true}}, [h('table', {class: {datable: true, 'kv-ver': this.vertical}}, r)])
  }
}
</script>
