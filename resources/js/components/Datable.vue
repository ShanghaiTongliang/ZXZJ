<style>
.asc {
  width: 16px;
  height: 16px;
  display: inline-block;
  background-image: url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGNpcmNsZSBjeD0iOCIgY3k9IjgiIHI9IjgiIGZpbGw9ImdyZWVuIi8+CiAgPHBvbHlnb24gcG9pbnRzPSI4LDIgMTQsMTEgMiwxMSIgc3R5bGU9ImZpbGw6d2hpdGUiLz4KPC9zdmc+);
}
.desc {
  width: 16px;
  height: 16px;
  display: inline-block;
  background-image: url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGNpcmNsZSBjeD0iOCIgY3k9IjgiIHI9IjgiIGZpbGw9ImdyZWVuIi8+CiAgPHBvbHlnb24gcG9pbnRzPSI4LDE0IDE0LDUgMiw1IiBzdHlsZT0iZmlsbDp3aGl0ZSIvPgo8L3N2Zz4=);
}
</style>
<script>
import Vue from 'vue'
import Edit from './Edit'
import TableCell from './TableCell'

const resizeEvent = window.onorientationchange === undefined ? 'resize' : 'orientationchange'

export default {
  props: ['tbl', 'selection'],
  //TableCell为functional, 父组件需引入其需要的子组件
  components: {Edit, TableCell},
  render(h) {
    let tbl = [], body = [], th = [], hide = {}, c = this.tbl.caption instanceof Function ? this.tbl.caption.call(this.$parent) : this.tbl.caption, cols = this.tbl.columns
    if(c || this.$slots.default)
      tbl.push(h('caption', [c ? h('span', {domProps: {innerHTML: c}}) : null, this.$slots.default]))
    if(cols) {
      for(let i in cols) {
        let c = cols[i], u
        u = !(c instanceof Object) ?
          h('div', {domProps: {innerHTML: c}}) :
          c.condition === undefined || !(hide[i] = !(c.condition instanceof Function ? c.condition.call(this.$parent, i) : c.condition)) ?
            h('div', {domProps: {innerHTML: c.caption}, style: c.style}) :
            null
        if(u)
          th.push(h('th', {on: {click: () => this.colClick(i)}, key: i}, [u, h('div', {style: {display: this.tbl.orderby != i ? 'none' : ''}, class: [this.tbl.desc ? 'desc' : 'asc']})]))
      }
      if(this.tbl.action)
        th.push(h('th', [h('div', '操作')]))
      tbl.push(h('thead', [h('tr', th)]))
      if(this.tbl.data && this.tbl.data.length) {
        for(let i = 0; i < this.tbl.data.length; i++) {
          let row = this.tbl.data[i], td = []
          for(let j in cols) {
            let c = cols[j]
            if(!(c instanceof Object) || c.type == 'combo' && this.tbl.editingIndex != i)
              td.push(h('td', {domProps: {innerHTML: row[j] instanceof Array ? row[j].join(', ') : row[j]}, key: j}))
            else if(!hide[j]) {
              let p = {key: j}, l = c.master ? cols[c.master[0]] && cols[c.master[0]].items : c.items, t
              if(l instanceof Function)
                l = l.call(this.$parent, row, j)
              const f = (c, l, d) => {
                let key = c.key || this.options.key
                for(let k = 0; k < c.master.length; k++) {
                  l = l.find(v => v[key] == d[c.master[k]])
                  if(!l || !(l = l.items))
                    break
                }
                return l
              }
              if(!c.type || c.type != 'combo' || this.tbl.editingIndex != i) {
                if(c.master && l)
                  l = f(c, l, row)
                if(l) {
                  let key = c.key || this.options.key, value = c.value || this.options.value
                  if(c.filter) {
                    let a = []
                    if(row[j]) {
                      for(let k of row[j]) {
                        let v = l.find(v => v[key] == k)
                        if(v) v = v[value]
                        a.push(c.filter.call(this.$parent, v, j, row))
                      }
                      t = a.join(', ')
                    }
                  } else if(row[j] instanceof Array)
                    t = row[j].map(i => {
                      let v = l.find(v => v[key] == i)
                      return v && v[value]
                    }).join(', ')
                  else {
                    t = l.find(v => v[key] == row[j])
                    if(t)
                      t = t[value]
                  }
                } else
                  t = c.filter ? c.filter.call(this.$parent, row[j], j, row) : row[j]
                if(row._td && row._td[j])
                  p = {...p, ...row._td[j]}
                if(c.href && row[c.href])
                  td.push(h('td', p, [h('a', {domProps: {href: row[c.href]}}, t)]))
                else {
                  p.domProps = {innerHTML: t === undefined ? null : t}
                  if(c.type == 'pre')
                    td.push(h('td', [h('pre', p)]))
                  else
                    td.push(h('td', p))
                }
              } else {
                if(c.master && l)
                  l = f(c, l, this.tbl.__tmp)
                td.push(h('table-cell', {props: {columns: cols, row: this.tbl.__tmp || row, key: j, items: l, slaves: this.slaves, options: this.options}, on: {
                  change: d => {
                    if(c.onchange)
                      c.onchange.call(this.$parent, d, i)
                  }
                }}))
              }
            }
          }
          if(this.tbl.action) {
            let a = this.tbl.action
            .filter(a => {
              return a.condition === undefined || (a.condition instanceof Function ? a.condition.call(this.$parent, row, i) : a.condition)
            })
            .map((a, j) => a.href && row[a.href] ? h('a', {domProps: {href: row[a.href]}, key: j}, a.caption) : h('button', {
              domProps: {innerHTML: a.caption},
              on: {
                click: e => a.onclick && a.onclick.call(this.$parent, row, i)
              }})
            )
            td.push(h('td', a))
          }
          body.push(h('tr', {
            class: row == this.selection ? ['selection'] : null,
            on: {
              click: () => row != this.selection && this.$emit('rowSelect', row, i)
            },
            key: i
          }, td))
        }
      } else
        body.push(h('tr', [h('td', {attrs: {colspan: th.length}}, '无数据')]))
      tbl.push(h('tbody', body))
    } else
      tbl.push(h('tbody', this.tbl.data && this.tbl.data.map((r, i) => h('tr', {key: i}, r && r.map((c, j) => h('td', {domProps: c, key: j}))))))
    return h('div', {staticClass: 'dt-out', on: {
      scroll: e => this.$emit('scroll', e, e.target.clientHeight, e.target.scrollTop, e.target.clientHeight)
    }}, [h('table', {staticClass: 'datable'}, tbl)])
  },
  data: function() {
    return {
      s: null,
      hide: [],
      options: Object.assign({
        key: 'id',
        value: 'name'
      }, this.tbl.options)
    }
  },
  computed: {
    slaves() {
      if(!this.s) {
        this.s = {}
        for(let k in this.tbl.columns) {
          let c = this.tbl.columns[k]
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
  },
  methods: {
    colClick(k) {
      if(this.tbl.orderby == k)
        Vue.set(this.tbl, 'desc', !this.tbl.desc)
      else {
        Vue.set(this.tbl, 'orderby', k)
        Vue.set(this.tbl, 'desc', false)
      }
      this.sort()
    },
    sort: function() {
      let k = this.tbl.orderby, desc = this.tbl.desc
      if(this.tbl.data)
        this.tbl.data.sort((a, b) => {
          a = a[k] || 0
          b = b[k] || 0
          let r = a > b ? 1 : (a < b ? -1 : 0)
          return desc ? -r : r
        })
    }
  }
}
</script>
