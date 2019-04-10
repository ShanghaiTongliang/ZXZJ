<script>
import {clone} from './merge'
import Vue from 'vue'
import Datable from './Datable'
/**
 * 属性
 * table
 *    readonly: 是否只读
 *    其余同Datable
 * 事件
 * editable(row, i) 返回true/false决定某行是否可编辑
 * edit(row, i) 点击编辑按钮
 * cancel(row, i) 点击取消按钮
 * save(row, i, next, old) 点击保存按钮, 调用next()进行保存，可用于异步
 * delete(row, i, next) 点击删除按钮, 调用next()进行删除
 */
export default {
  functional: true,
  props: ['table', 'selection'],
  components: {Datable},
  render(h, ctx) {
    let p = ctx.props
    if(!p.table.__moditable) {
      p.table.__moditable = {}
      if(!p.table.actions)
        p.table.actions = []
      p.table.actions.splice(p.table.actions.length, 0, ...[{
        caption: '编辑',
        condition(d, i) {
          let h, r
          r = !p.table.readonly && (p.table.editingIndex === undefined || p.table.editingIndex < 0) && ((h = ctx.listeners.editable) === undefined || h(d, i))
          p.table.__moditable.editable = r
          return r
        },
        onclick(d, i) {
          event.preventDefault()
          Vue.set(p.table, '__tmp', clone(p.table.data[i]))
          Vue.set(p.table, 'editingIndex', i)
          if(ctx.listeners.edit)
            ctx.listeners.edit(p.table.__tmp, i)
        }
      }, {
        caption: '保存',
        condition(d, i) {
          return p.table.editingIndex == i
        }
      }, {
        caption: '取消',
        condition(d, i) {
          return p.table.editingIndex == i
        },
        onclick(d, i) {
          event.preventDefault()
          if(ctx.listeners.cancel)
            ctx.listeners.cancel(d, i)
          p.table.__tmp = null
          p.table.editingIndex = -1
        }
      }, {
        caption: '删除',
        condition() {
          return p.table.__moditable.editable
        },
        onclick(d, i) {
          event.preventDefault()
          const del = () => {
            p.table.data.splice(i, 1)
          }
          if(ctx.listeners.delete)
            ctx.listeners.delete(d, i, del)
          else
            del()
        }
      }])
    }
    return h('datable', {...ctx.data, props: {outer: 'form', table: p.table, selection: p.selection}, on: {
      submit: () => {
        event.preventDefault()
        let i = p.table.editingIndex
        const save = function() {
          Vue.set(p.table.data, i, p.table.__tmp)
          p.table.editingIndex = -1
          p.table.__tmp = null
        }
        if(ctx.listeners.save)
          ctx.listeners.save(p.table.__tmp, i, save, p.table.data[i])
        else
          save()
      }
    }}, ctx.children)
  }
}
</script>
