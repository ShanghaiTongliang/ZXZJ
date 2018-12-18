<script>
import Vue from 'vue'
import Datable from './Datable'

export default {
  functional: true,
  props: ['tbl', 'selection'],
  components: {Datable},
  render(h, ctx) {
    let p = ctx.props
    if(!p.tbl.__moditable) {
      p.tbl.__moditable = true
      if(!p.tbl.action)
        p.tbl.action = []
      p.tbl.action.splice(p.tbl.action.length, 0, ...[{
        caption: '编辑',
        condition() {
          return p.tbl.editingIndex === undefined || p.tbl.editingIndex < 0
        },
        onclick(d, i) {
          Vue.set(p.tbl, '__tmp', {...p.tbl.data[i]})
          Vue.set(p.tbl, 'editingIndex', i)
          if(ctx.listeners.edit)
            ctx.listeners.edit(p.tbl.__tmp, i)
        }
      }, {
        caption: '保存',
        condition(d, i) {
          return p.tbl.editingIndex == i
        },
        onclick(d, i) {
          p.tbl.editingIndex = -1
          if(ctx.listeners.save === undefined || ctx.listeners.save(p.tbl.__tmp, i) !== false)
            p.tbl.data[i] = p.tbl.__tmp
          p.tbl.__tmp = null
        }
      }, {
        caption: '取消',
        condition(d, i) {
          return p.tbl.editingIndex == i
        },
        onclick(d, i) {
          p.tbl.__tmp = null
          p.tbl.editingIndex = -1
        }
      }, {
        caption: '删除',
        condition() {
          return p.tbl.editingIndex === undefined || p.tbl.editingIndex < 0
        },
        onclick(d, i) {
          const del = () => p.tbl.data.splice(i, 1)
          if(ctx.listeners.delete === undefined || ctx.listeners.delete(d, i, del) !== false)
            del()
        }
      }])
    }
    return h('datable', {...ctx.data, props: {tbl: p.tbl, selection: p.selection}}, ctx.children)
  }
}
</script>
