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
import Vue from 'vue'
import Edit from './Edit'
import Pinyin from './Pinyin'
import TableCell from './TableCell'
import merge from './merge'

export default {
  components: {Edit, Pinyin, TableCell},
  props: ['table', 'vertical'],
  render(h) {
    let tbl = this.table, r = [], th = [], td = [], cols = tbl.columns, row = tbl.data, ne
      , c = tbl.caption instanceof Function ? tbl.caption.call(this.$parent) : tbl.caption
    if(c || this.$slots.default)
      r.push(h('caption', [c ? h('span', {domProps: {innerHTML: c}}) : null, this.$slots.default]))
    if(cols) {
      if(tbl.editing)
        ne = true
      else if(row)
        for(let k in row) {
          ne = true
          break
        }
      for(let i in cols) {
        c = cols[i]
        if(c instanceof Object) {
          if((c.condition === undefined || (c.condition instanceof Function ? c.condition.call(this.$parent, i) : c.condition)) && (!tbl.editing || c.type || c.show)) {
            th.push({domProps: {innerHTML: c.caption}})
            if(ne) {
              let self = this
              let l = c.master ? cols[c.master[0]] && cols[c.master[0]].items : c.items
              if(l instanceof Function)
                l = l.call(this.$parent, row, i)
              let keyName = c.keyName || this.options.keyName
              if(c.master && l)
                for(let k = 0; k < c.master.length; k++) {
                  let cc = cols[c.master[k]], itemName = cc.itemName || this.options.itemName
                  l = l.find(v => v[keyName] == row[c.master[k]])
                  if(!l || !(l = l[itemName]))
                    break
                }
              if(c.render instanceof Function) {
                //if(c.master && l)
                //  l = f(c, l, row)
                let d = c.render.call(this.$parent, h, row, i, l)
                td.push(h('td', {key: i}, d instanceof Object ? [d] : d))
              } else if(this.table.editing && c.type && (c.editable === undefined || (c.editable instanceof Function ? c.editable.call(this.$parent) : c.editable))) {
                //if(c.master && l)
                //  l = f(c, l, row)
                td.push(h('table-cell', {props: {column: cols[i], value: row[i], items: l, options: this.options}, on: {
                  input: d => {
                    let c = cols[i]
                    row[i] = d
                    if(c.type == 'select' && this.slaves && this.slaves[i])
                      for(let s of this.slaves[i]) {
                        let sl = l.find(v => v[keyName] == row[i])
                        if(sl && (sl = sl[s]) && sl.length)
                          Vue.set(row, s, sl[0][keyName])
                        else
                          Vue.set(row, s, null)
                      }
                    c.onchange && c.onchange.call(this.$parent, d, i)
                  }
                }}))
              } else {
                let t
                if(l)
                  t = c.filter ? c.filter.call(this.$parent, l, i, row) : row[i] instanceof Array ?
                    row[i].map(i => l[i]).join(', ') : l[row[i]]
                else
                  t = c.filter ? c.filter.call(this.$parent, row[i], i, row) : row[i]
                if(c.href && row[c.href])
                  td.push(h('td', [h('a', {domProps: {href: row[c.href]}, key: i}, t)]))
                else
                  td.push(h('td', {domProps: t !== undefined && {innerHTML: t}, key: i}))
              }
            }
          }
        } else if(!tbl.editing) {
          th.push({domProps: {innerHTML: c}})
          if(ne)
            td.push(h('td', {domProps: {innerHTML: row[i]}, key: i}))
        }
      }
      if(tbl.actions && ne) {
        let a = tbl.actions.filter(a => a.condition === undefined || (a.condition instanceof Function ? a.condition.call(this.$parent) : a.condition))
        if(a.length) {
          th.push('操作')
          td.push(h('td', a.map((a, j) => a.href && row[a.href] ? h('a', {domProps: {href: row[a.href]}, key: j}, a.caption) : h('button', {
            on: {
            click: () => a.onclick && a.onclick.call(this.$parent, row)
          }, key: j, domProps: {innerHTML: a.caption}}))))
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
  },
  data() {
    return {
      s: null,
      options: merge({
        keyName: 'id',
        cascade: {
          itemName: 'items',
          keyName: 'id',
          valueName: 'name'
        }
      }, this.table.options)
    }
  },
  computed: {
    slaves() {
      if(!this.s) {
        this.s = {}
        for(let k in this.table.columns) {
          let c = this.table.columns[k]
          if(c.master) {
            c = c.master[c.master.length - 1]
            if(!this.s[c])
              this.s[c] = []
            this.s[c].push(k)
          }
        }
      }
      return this.s
    }
  }
}
</script>
