<style>
ul.tree {
  list-style: none;
  padding: 0;
  margin-top: 0;
  margin-bottom: 0;
  background-color: white;
  flex-grow: 1;
  overflow: auto;
}
.tree div {
  display: flex;
  align-items: center;
}
.tree img {
  max-width: 24px;
  max-height: 24px;
}
.tree span, .tree a {
  padding: .5em .2em;
  flex-grow: 1;
  display: flex;
  align-items: center;
  white-space: nowrap;
  overflow: hidden;
}
.leaf {margin-left: 1em}
.leaf li {
  background: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxIiBoZWlnaHQ9IjYiPjxsaW5lIHgxPSIwIiB5MT0iMCIgeDI9IjAiIHkyPSIzIiBzdHlsZT0ic3Ryb2tlOiBibGFjayIvPjwvc3ZnPg==) repeat-y .75em;
}
.leaf li:last-child {
  background: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIzNiI+PHBvbHlsaW5lIHBvaW50cz0iMCwwIDAsMTcgMTUsMTciCnN0eWxlPSJzdHJva2U6YmxhY2s7IHN0cm9rZS1kYXNoYXJyYXk6MyA0O2ZpbGw6dHJhbnNwYXJlbnQiLz48L3N2Zz4=) no-repeat .75em 0;
}
.leaf-btn {
  width: 1.5em;
  height: 2em;
  flex-shrink: 0;
  background-repeat: no-repeat;
  background-position: .75em;
}
.leaf .leaf-btn:not(.collapse):not(.expand) {
  background-image: url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGxpbmUgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLWRhc2hhcnJheT0iMyAzIiB4MT0iMCIgeTE9IjgiIHgyPSIxNSIgeTI9IjgiLz4KPC9zdmc+);
}
.leaf li:last-child>div>div.leaf-btn:not(.collapse):not(.expand) {
  background-image: none;
}
.collapse {
  cursor: pointer;
  background-image: url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPHJlY3Qgd2lkdGg9IjE1IiBoZWlnaHQ9IjE1IiBzdHlsZT0iZmlsbDojZmZmIi8+CiAgPGxpbmUgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIyIiB4MT0iNyIgeTE9IjEiIHgyPSI3IiB5Mj0iMTMiLz4KICA8bGluZSBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjIiIHgxPSIxIiB5MT0iNyIgeDI9IjEzIiB5Mj0iNyIvPgo8L3N2Zz4=);
  background-position: center;
}
.expand {
  cursor: pointer;
  background-image: url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTYiIGhlaWdodD0iMTYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPHJlY3Qgd2lkdGg9IjE1IiBoZWlnaHQ9IjE1IiBzdHlsZT0iZmlsbDojZmZmIi8+CiAgPGxpbmUgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIyIiB4MT0iMSIgeTE9IjciIHgyPSIxMyIgeTI9IjciLz4KPC9zdmc+);
  background-position: center;
}
.tree .select span, .tree .select a {
  color: white;
  background-color: #37f;
}
</style>
<script>
import Vue from 'vue'
import Resizer from './Resizer'

export default {
  components: {Resizer},
  props: {
    tree: Object,
    selection: Object,
    width: Number,
    right: Boolean,
    visible: {
      type: Boolean,
      default: true
    }
  },
  render(h) {
    let r = (ti, i, l) => {
      let items = this.itemNames[l] || 'items', valueName = this.valueNames[l] || 'name', on = {
        click: () => this.$emit('select', ti)
      }, icon = ti.icon || this.icons[l]
      return h('li', {key: i}, [
        h('div', {class: this.selection == ti && 'select'}, [
          h('div', {class: ['leaf-btn', ti[items] && ti[items].length && (ti._expand ? 'expand' : 'collapse')], on: {
            click() {
              ti._expand = !ti._expand
            }
          }}),
          icon && h('img', {attrs: {src: icon}}),
          ti._href ? h('a', {attrs: {href: ti._href}, on}, ti[valueName]) : h('span', {on}, ti[valueName])
        ]),
        ti[items] && ti[items].length ? h('ul', {attrs: {class: 'tree leaf'}, style: {display: ti._expand ? '' : 'none'}},
          ti[items].map((ti, i) => r(ti, i, l + 1))) : null
      ])
    }
    return h('resizer', {props: {width: this.width, right: this.right, visible: this.visible,}},
      [this.$slots.header, h('ul', {attrs: {class: 'tree'}}, this.tree.items.map((ti, i) => r(ti, i, 0))), this.$slots.footer])
  },
  computed: {
    itemNames() {
      return this.tree.itemNames || []
    },
    valueNames() {
      return this.tree.valueNames || []
    },
    icons() {
      return this.tree.icons || []
    }
  }
}
</script>
