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
  props: ['table', 'selection'],
  /*
  table: {
    caption: 标题
    columns: {  表头列表
      caption:  列名
      head: {
        class: 表头类
        style: 表头样式
      },
      class: 表格类
      style: 表格样式
      items: { 选项列表
        key1: value1
        key2: value2
        ...
      }
    }
    actions: 按钮列表
    keyName: string = id,       排序
    sortable: 是否可排序
    orderby: 排序字段
    options: {
      cascade: {
        itemName: string = items  级联选项名
        keyName: string = id      级联键名
        valueName: string = name  级联值名
      }
    }
  },
  data: 数据*/

  //TableCell为functional, 父组件需引入其需要的子组件
  components: {Edit, ComboBox, Pinyin, TableCell},
  render(h) {
    let tbl = [], head = [], body = [], th = [], bth = [], atd= [], hide = {}, c = this.table.caption instanceof Function ? this.table.caption.call(this.$parent) : this.table.caption, cols = this.table.columns
    if(c !== undefined || this.$slots.default)
      head.push(h('caption', [c ? h('span', {domProps: {innerHTML: c}}) : null, this.$slots.default]))
    if(cols) {
      let e
      for(let i in cols) {
        let c = cols[i], u, v
        [u, v] = !(c instanceof Object) ?
          [h('div', {domProps: {innerHTML: c}}), h('div', {domProps: {innerHTML: c}})] :
          c.condition === undefined || !(hide[i] = !(c.condition instanceof Function ? c.condition.call(this.$parent, i) : c.condition)) ?
            [h('div', {domProps: {innerHTML: c.caption}, class: c.head && c.head.class, style: c.head && c.head.style}), h('div', {domProps: {innerHTML: c.caption}, class: c.head && c.head.class, style: c.head && c.head.style})] :
            [null, null]
        if(v) { //th: 浮动表头，可点击, bth: 隐藏的真表头
          th.push(h('th', {on: (this.table.sortable === undefined || this.table.sortable) && {
            click: () => this.colClick(i)
          }, key: i}, [u, h('div', {style: {display: this.table.orderby != i ? 'none' : ''}, class: [this.table.desc ? 'desc' : 'asc']})]))
          bth.push(h('th', {key: i}, [v, h('div', {style: {display: this.table.orderby != i ? 'none' : ''}, class: [this.table.desc ? 'desc' : 'asc']})]))
        }
      }
      if(this.table.data && this.table.data.length) {
        for(let i = 0; i < this.table.data.length; i++) {
          let row = this.table.editingIndex !== undefined && this.table.editingIndex == i ? this.table.__tmp : this.table.data[i], td = []
          for(let j in cols) {
            let c = cols[j]
            if(!(c instanceof Object))
              td.push(h('td', {domProps: {innerHTML: row[j] instanceof Array ? row[j].join(', ') : row[j] === undefined ? null : row[j]}, /*class: c.class, style: c.style,*/ key: j}))
            else if(!hide[j]) {
              let p = {/*class: c.class, style: c.style,*/ key: j}, l = c.master ? cols[c.master[0]] && cols[c.master[0]].items : c.items, t
              if(l instanceof Function)
                l = l.call(this.$parent, row, j)
              let keyName = c.keyName || this.options.cascade.keyName, valueName = c.valueName || this.options.cascade.valueName
              const f = (c, l, d) => {
                for(let k = 0; k < c.master.length; k++) {
                  let cc = cols[c.master[k]], itemName = cc.itemName || this.options.itemName
                  l = l.find(v => v[keyName] == d[c.master[k]])
                  if(!l || !(l = l[itemName]))
                    break
                }
                return l
              }
              //render函数
              if(c.render instanceof Function) {
                let d
                if(this.table.editingIndex == i) {
                  if(c.master && l)
                    l = f(c, l, row)
                  d = c.render.call(this.$parent, h, row, j, i, l)
                } else
                  d = c.render.call(this.$parent, h, row, j, i, l)
                td.push(h('td', p, d instanceof Object ? [d] : d))
              } else if(!c.type || this.table.editingIndex != i || c.editable !== undefined && !(c.editable instanceof Function ? c.editable.call(this.$parent) : c.editable)) {
                //文字状态单元格
                l = c.items || c.master && l && f(c, l, row)
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
              } else {  //编辑状态单元格
                if(c.master && l)
                  l = f(c, l, row)
                td.push(h('table-cell', {
                  props: {
                    column: cols[j], value: row[j], items: l, options: this.options
                  }, /*class: c.class, style: c.style,*/
                  on: {
                    input: d => {
                      let r = row
                      row[j] = d
                      if(c.type == 'select' && this.slaves && this.slaves[j])
                        for(let s of this.slaves[j]) {
                          let sl = l.find(v => v[keyName] == r[j])
                          r[s] = sl && (sl = sl[s]) && sl.length ? sl[0][keyName] : null
                        }
                      c.onchange && c.onchange.call(this.$parent, d, i, r)
                    }
                  }
                }))
              }
            }
          }
          if(this.table.actions) {
            let a = this.table.actions.filter(a => a.condition === undefined || (a.condition instanceof Function
              ? a.condition.call(this.$parent, row, i) : a.condition))
            if(a.length)
              atd[i] = h('td', a.map((a, j) => a.href && row[a.href]
              ? h('a', {domProps: {href: row[a.href]}, key: j}, a.caption)
              : h('button', {
                domProps: {innerHTML: a.caption},
                on: {
                  click: e => a.onclick && a.onclick.call(this.$parent, row, i)
                }})
              )
            )
          }
          /*body.push(h('tr', {
            class: row == this.selection ? ['selection'] : null,
            on: {
              click: () => row != this.selection && this.$emit('rowSelect', row, i)
            },
            key: i
          }, td))*/
          body.push(td)
        }
        if(atd.length) {
          th.push(h('th', [h('div', '操作')]))
          bth.push(h('th', [h('div', '操作')]))
          for(let i = 0; i < body.length; i++)
            if(atd[i])
              body[i].push(atd[i])
            else
              body[i].push(h('td'))
        }
      } else {
        e = true
        body.push(h('tr', {key: 0}, [h('td', {attrs: {colspan: th.length}}, '无数据')]))
      }
      head.push(h('thead', [h('tr', {ref: 'th'}, th)]))
      tbl.push(h('thead', [h('tr', {ref: 'bth'}, bth)]))
      tbl.push(h('tbody', e ? body : body.map((td, j) => {
        let row = this.table.data[j]
        return h('tr', {
          class: row == this.selection ? ['selection'] : null,
          on: {
            click: () => row != this.selection && this.$emit('rowSelect', row, j)
          },
          key: row[this.options.keyName]
        }, td)
      })))
      this.$nextTick(this.onScroll) //对齐表头
    } else
      tbl.push(h('tbody', this.table.data && this.table.data.map(
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
      h('table', {staticClass: 'datable dt-body'}, tbl)
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
      return merge({
        keyName: 'id',
        cascade: {
          itemName: 'items',
          keyName: 'id',
          valueName: 'name'
        }
      }, this.table.options)
    },
    keys() {
      let c = this.table.columns
      return Object.keys(c).filter(k => c[k] instanceof Object && c[k].type)
    },
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
  },
  methods: {
    colClick(k) {
      if(this.table.orderby == k)
        Vue.set(this.table, 'desc', !this.table.desc)
      else {
        Vue.set(this.table, 'orderby', k)
        Vue.set(this.table, 'desc', false)
      }
      this.sort()
    },
    sort: function() {
      let k = this.table.orderby, desc = this.table.desc
      if(this.table.data)
        this.table.data.sort((a, b) => {
          a = a[k]
          b = b[k]
          if(a === null || a === undefined)
            a = ''
          if(b === null || b === undefined)
            b = ''
          if(isNaN(parseFloat(a)) != isNaN(parseFloat(b))) {
            a = a.toString()
            b = b.toString()
          }
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
            this.$refs.th.children[i].children[0].style.width = (!h.children[1] || h.children[1].style.display == 'none' ? h.clientWidth : h.clientWidth - h.children[1].clientWidth) - 2.8 + 'px'
        }
      }
    }
  },
  mounted() {
    this.$refs.r1.scrollLeft = this.$refs.r2.scrollLeft = 10000
  }
}
</script>
