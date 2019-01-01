<style>
.dt-resize {
  position: absolute;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  overflow: hidden;
  visibility: hidden;
}
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
import merge from './merge'
import Vue from 'vue'
import Edit from './Edit'
import ComboBox from './ComboBox'
import Pinyin from './Pinyin'
import TableCell from './TableCell'

export default {
  props: ['tbl', 'selection'],
  /*
  tbl: {
    caption: 标题
    columns: {  表头列表
      caption:  列名
      items: { 选项列表
        key1: value1
        key2: value2
        ...
      }
    }
    actions: 按钮列表
    data: 数据
    options: {
      itemName: string = items  级联选项名
      keyName: string = id      级联键名
      valueName: string = name  级联值名
    }
  }*/

  //TableCell为functional, 父组件需引入其需要的子组件
  components: {Edit, ComboBox, Pinyin, TableCell},
  render(h) {
    let tbl = [], head = [], body = [], th = [], bth = [], hide = {}, c = this.tbl.caption instanceof Function ? this.tbl.caption.call(this.$parent) : this.tbl.caption, cols = this.tbl.columns
    if(c || this.$slots.default)
      head.push(h('caption', [c ? h('span', {domProps: {innerHTML: c}}) : null, this.$slots.default]))
    if(cols) {
      for(let i in cols) {
        let c = cols[i], u, v
        [u, v] = !(c instanceof Object) ?
          [h('div', {domProps: {innerHTML: c}}), h('div', {domProps: {innerHTML: c}})] :
          c.condition === undefined || !(hide[i] = !(c.condition instanceof Function ? c.condition.call(this.$parent, i) : c.condition)) ?
            [h('div', {domProps: {innerHTML: c.caption}, style: c.style}), h('div', {domProps: {innerHTML: c.caption}, style: c.style})] :
            [null, null]
        if(v) {
          th.push(h('th', {on: {click: () => this.colClick(i)}, key: i}, [u, h('div', {style: {display: this.tbl.orderby != i ? 'none' : ''}, class: [this.tbl.desc ? 'desc' : 'asc']})]))
          bth.push(h('th', {key: i}, [v, h('div', {style: {display: this.tbl.orderby != i ? 'none' : ''}, class: [this.tbl.desc ? 'desc' : 'asc']})]))
        }
      }
      if(this.tbl.actions) {
        th.push(h('th', [h('div', '操作')]))
        bth.push(h('th', [h('div', '操作')]))
      }
      tbl.push(h('thead', [h('tr', {ref: 'bth'}, bth)]))
      if(this.tbl.data && this.tbl.data.length) {
        for(let i = 0; i < this.tbl.data.length; i++) {
          let row = this.tbl.data[i], td = []
          for(let j in cols) {
            let c = cols[j]
            if(!(c instanceof Object))
              td.push(h('td', {domProps: {innerHTML: row[j] instanceof Array ? row[j].join(', ') : row[j]}, key: j}))
            else if(!hide[j]) {
              let p = {key: j}, l = c.master ? cols[c.master[0]] && cols[c.master[0]].items : c.items, t
              if(l instanceof Function)
                l = l.call(this.$parent, row, j)
              let keyName = c.keyName || this.options.keyName, valueName = c.valueName || this.options.valueName
              const f = (c, l, d) => {
                for(let k = 0; k < c.master.length; k++) {
                  let cc = cols[c.master[k]], itemName = cc.itemName || this.options.itemName
                  l = l.find(v => v[keyName] == d[c.master[k]])
                  if(!l || !(l = l[itemName]))
                    break
                }
                return l
              }
              if(c.render instanceof Function) {
                if(c.master && l)
                  l = f(c, l, row)
                let d = c.render.call(this.$parent, h, this.tbl.editingIndex == i ? this.tbl.__tmp : row, j, i, l)
                td.push(h('td', p, d instanceof Object ? [d] : d))
              } else if(!c.type || this.tbl.editingIndex != i || c.editable !== undefined && !(c.editable instanceof Function ? c.editable.call(this.$parent) : c.editable)) {
                if(c.master && l)
                  l = f(c, l, row)
                if(l && c.type != 'combo' && c.type != 'pinyin') {
                  switch(c.type) {
                  case 'checkbox':
                    t = row[j].map(d => {
                      let v = l.find(i => i[keyName] == d)
                      if(v) {
                        v = v[valueName]
                        return c.filter ? c.filter.call(this.$parent, v, j, row) : v
                      }
                    }).join(', ')
                    break
                  case undefined:
                    if(c.filter)
                      t = c.filter.call(this.$parent, row[j], j, row)
                    else {
                      t = l.find(v => v[keyName] == row[j])
                      if(t)
                        t = t[valueName]
                    }
                    break
                  default:
                    t = l.find(v => v[keyName] == row[j])
                    if(t) {
                      t = t[valueName]
                      if(c.filter)
                        t = c.filter.call(this.$parent, t, j, row)
                    }
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
                td.push(h('table-cell', {
                  props: {
                    column: cols[j], value: row[j], items: l, options: this.options
                  },
                  on: {
                    input: d => {
                      let r = this.tbl.__tmp
                      r[j] = d
                      if(c.type == 'select' && this.slaves && this.slaves[j])
                        for(let s of this.slaves[j]) {
                          let sl = l.find(v => v[keyName] == r[j])
                          if(sl && (sl = sl[s]) && sl.length)
                            r[s] = sl[0][keyName]
                          else
                            r[s] = null
                        }
                      c.onchange && c.onchange.call(this.$parent, d, i)
                    }
                  }
                }))
              }
            }
          }
          if(this.tbl.actions) {
            let a = this.tbl.actions
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
      head.push(h('thead', [h('tr', {ref: 'th'}, th)]))
      tbl.push(h('tbody', body))
      this.$nextTick(this.onScroll) //对齐表头
    } else
      tbl.push(h('tbody', this.tbl.data && this.tbl.data.map(
        (r, i) => h('tr', {key: i}, r && r.map((c, j) => h('td', {domProps: c, key: j})))
      )))
    return h('div', {staticClass: 'dt-out',
      on: {
        scroll: e => this.$emit('scroll', e, e.target.clientHeight, e.target.scrollTop, e.target.clientHeight),
      }}, [h('div', {ref: 'r1', attrs: {class: 'dt-resize'}, on: {
        scroll: this.onScroll
      }}, [h('div', {style: {width: '10000px', height: '10000px'}})]),
      h('div', {ref: 'r2', attrs: {class: 'dt-resize'}, on: {
        scroll: this.onScroll
      }}, [h('div', {style: {width: '200%', height: '200%'}})]),
      h('table', {staticClass: 'datable dt-head', ref: 'head'}, head),
      h('table', {staticClass: 'datable', style: head.length > 1 ? {marginTop: '-2em'} : null}, tbl)
    ])
  },
  data: function() {
    return {
      s: null,
      hide: [],
      uc: 0
    }
  },
  computed: {
    options() {
      /*let r = {
        itemName: 'items',
        keyName: 'id',
        valueName: 'name'
      }
      for(let k in this.tbl.options)
        r[k] = this.tbl.options[k]
      */
      return merge({
        itemName: 'items',
        keyName: 'id',
        valueName: 'name'
      }, this.tbl.options)
    },
    keys() {
      let c = this.tbl.columns
      return Object.keys(c).filter(k => c[k] instanceof Object && c[k].type)
    },
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
    },
    onScroll() {
      if(this.$refs.th) {
        this.$refs.r1.scrollLeft = this.$refs.r2.scrollLeft = 10000
        for(let i = 0; i < this.$refs.th.children.length; i++) {
          let h = this.$refs.bth.children[i]
          if(h.clientWidth)
            this.$refs.th.children[i].children[0].style.width = (!h.children[1] || h.children[1].style == 'none' ? h.clientWidth : h.clientWidth - h.children[1].clientWidth) - 2 + 'px'
        }
      }
    }
  },
  mounted() {
    this.$refs.r1.scrollLeft = this.$refs.r2.scrollLeft = 10000
  }
}
</script>
