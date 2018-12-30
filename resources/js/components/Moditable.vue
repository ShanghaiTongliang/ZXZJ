<script>
import {clone} from './merge'
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
      if(!p.tbl.actions)
        p.tbl.actions = []
      const condition = function(d, i) {
        let h
        return (p.tbl.editingIndex === undefined || p.tbl.editingIndex < 0) && ((h = ctx.listeners.editable) === undefined || (h instanceof Function ? h.call(ctx.parent, d, i) : h))
      }
      p.tbl.actions.splice(p.tbl.actions.length, 0, ...[{
        caption: '编辑',
        condition,
        onclick(d, i) {
          Vue.set(p.tbl, '__tmp', clone(p.tbl.data[i]))
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
          const save = function() {
            p.tbl.editingIndex = -1
            Vue.set(p.tbl.data, i, p.tbl.__tmp)
            p.tbl.__tmp = null
          }
          if(ctx.listeners.save)
            ctx.listeners.save(p.tbl.__tmp, i, save)
          else
            save()
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
        condition,
        onclick(d, i) {
          const del = () => p.tbl.data.splice(i, 1)
          if(ctx.listeners.delete)
            ctx.listeners.delete(d, i, del)
          else
            del()
        }
      }])
    }
    return h('datable', {...ctx.data, props: {tbl: p.tbl, selection: p.selection}}, ctx.children)
  }
}
</script>
