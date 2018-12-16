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
    let tbl = [], head = [], bth = [], body = [], th = [], hide = {}, c = this.tbl.caption instanceof Function ? this.tbl.caption.call(this.$parent) : this.tbl.caption, cols = this.tbl.columns
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
      if(this.tbl.action) {
        th.push(h('th', [h('div', '操作')]))
        bth.push(h('th', [h('div', '操作')]))
      }
      tbl.push(h('thead', [h('tr', {ref: 'bth'}, bth)]))
      if(this.tbl.data && this.tbl.data.length) {
        for(let i in this.tbl.data) {
          let row = this.tbl.data[i], td = []
          for(let j in cols) {
            let c = cols[j]
            if(!(c instanceof Object))
              td.push(h('td', {domProps: {innerHTML: row[j] instanceof Array ? row[j].join(', ') : row[j]}, key: j}))
            else if(!hide[j]) {
              let p = {key: j}, l = c.items instanceof Function ? c.items.call(this.$parent, row, j) : c.items, t
              if(!c.type || this.tbl.editingIndex != i) {
                if(l) {
                  if(c.filter) {
                    let a = []
                    if(row[j]) {
                      for(let k of row[j])
                        a.push(c.filter.call(this.$parent, l[k], j, row))
                      t = a.join(', ')
                    }
                  } else
                    t = row[j] instanceof Array ?
                      row[j].map(i => l[i]).join(', ') :
                      l[row[j]]
                } else
                  t = c.filter ? c.filter.call(this.$parent, row[j], j, row) : row[j]
                if(row._td && row._td[j])
                  p = {...p, ...row._td[j]}
                if(c.href)
                  td.push(h('td', p, [h('a', {domProps: {href: row[c.href]}}, t)]))
                else {
                  p.domProps = {innerHTML: t}
                  if(c.type == 'pre')
                    td.push(h('td', [h('pre', p)]))
                  else
                    td.push(h('td', p))
                }
              } else
                td.push(h('table-cell', {props: {columns: this.tbl.columns, row: this.tbl.__tmp || row, key: j, items: l, slaves: this.slaves}}))
            }
          }
          if(this.tbl.action) {
            let a = []
            for(let j = 0; j < this.tbl.action.length; j++) {
              let b = this.tbl.action[j]
              if(b.condition === undefined || (b.condition instanceof Function ? b.condition.call(this.$parent, row, i) : b.condition))
                a.push(b.href ? h('a', {domProps: {href: row[b.href]}, key: j}, b.caption) : h('button', {domProps: {innerHTML: b.caption}, on: {
                  click: e => {
                    if(b.onclick)
                      b.onclick.call(this.$parent, row, i)
                    e.preventDefault()
                  }
                }}))
            }
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
      this.$nextTick(this.update)
    } else
      tbl.push(h('tbody', this.tbl.data && this.tbl.data.map((r, i) => h('tr', {key: i}, r && r.map((c, j) => h('td', {domProps: c, key: j}))))))
    return h('div', {staticClass: 'dt-out', on: {
      scroll: e => {
        e.target.children[0].style.top = e.target.scrollTop + 'px'
        this.$emit('scroll', e, e.target.clientHeight, e.target.scrollTop, e.target.children[1].clientHeight)
      }
    }}, [h('table', {staticClass: 'datable dt-head', ref: 'head'}, head), h('div', {staticClass: 'dt-body', style: head.length > 1 ? {marginTop: '1.5em'} : null}, [h('table', {staticClass: 'datable'}, tbl)])])
  },
  data: function() {
    return {
      s: null,
      hide: []
    }
  },
  computed: {
    cols() {
      return this.columns || this.tbl.columns
    },
    slaves() {
      if(!this.s) {
        this.s = {}
        for(let k in this.tbl.columns) {
          let c = this.tbl.columns[k]
          if(c.master) {
            if(!this.s[c.master])
              this.s[c.master] = []
            this.s[c.master].push(k)
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
    selectChange(row, k, c) {
      if(this.slaves[k])
        for(let s of this.slaves[k])
          for(let i in this.tbl.columns[s].items[row[k]]) {
            row[s] = i
            break
          }
      if(c.onchange)
        c.onchange(row)
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
    update() {
      if(this.$refs.th)
        for(let i = 0; i < this.$refs.th.children.length; i++) {
          let h = this.$refs.bth.children[i]
          if(h.clientWidth)
            this.$refs.th.children[i].children[0].style.width = (!h.children[1] || h.children[1].style == 'none' ? h.clientWidth : h.clientWidth - h.children[1].clientWidth) - 2 + 'px'
        }
    },
    onResize() {
      setTimeout(this.update, 0)
    }
  },
  mounted() {
    window.addEventListener(resizeEvent, this.onResize)
    this.onResize()
  },
  beforeDestroy() {
    window.removeEventListener(resizeEvent, this.onResize)
  }
}
</script>
