<style>
.tc-chk label {min-width: 6em}
</style>

<template>
  <moditable :tbl="tbl" @edit="edit" @save="save" @delete="del" class="grp"></moditable>
</template>
<script>
import axios from 'axios'
import Vue from 'vue'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import { mapState, mapMutations } from 'vuex'

const items = [{
  id: 1,
  name: '啊啊啊'
}, {
  id: 2,
  name: '不不不'
}, {
  id: 3,
  name: '啊啊啊啊啊啊'
}, {
  id: 4,
  name: 'aaa'
}, {
  id: 5,
  name: 'bbb'
}, {
  id: 6,
  name: 'ccc'
}]

export default {
  components: {Datable, Moditable},
  data() {
    return {
      tbl: {
        caption: '用户',
        columns: {
          id: 'id',
          name: {
            caption: '用户名',
            type: 'text'
          },
          groups: {
            caption: '用户组',
            type: 'checkbox',
            items: this.$store.state.groups
          },
          danWei: {
            caption: '单位',
            type: 'select',
            itemName: 'cheJian',
            items: this.$store.state.danWei
          },
          cheJian: {
            caption: '车间',
            type: 'select',
            itemName: 'banZu',
            master: ['danWei']
          },
          banZu: {
            caption: '班组',
            type: 'select',
            master: ['danWei', 'cheJian']
          },
          test: {
            caption: 'test',
            type: 'combo',
            items,
            filter(v, k, d) {
              let t = items.find(i => i.id == v)
              if(t)
                return t.name
            },
            onchange(d, i) {
              console.log(d, i)
            }
          },
          pinyin: {
            caption: '拼音',
            type: 'pinyin',
            items,
            filter(v, k, d) {
              let t = items.find(i => i.id == v)
              if(t)
                return t.name
            },
            onchange(d, i) {
              console.log(d, i)
            }
          }
        },
        data: this.$store.state.users
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    edit(d, i) {
      let v = items.find(i => i.id == d.test)
      if(v)
        d.test = v.name
      v = items.find(i => i.id == d.pinyin)
      if(v)
        d.pinyin = v.name
    },
    save(d, i) {
      /*this.loading(true)
      axios.put(`api/user/${d.id}`, d).then(res => {
        this.loading(false)
        this.message('保存成功')
      }).catch(res => {
        this.loading(false)
        this.error(res.response.data)
      })*/
      let v = items.find(i => i.name == d.test)
      if(v)
        d.test = v.id
      else {
        let id = items.length + 1
        items.push({id, name: d.test})
        d.test = id
      }
      v = items.find(i => i.name == d.pinyin)
      if(v)
        d.pinyin = v.id
      else {
        let id = items.length + 1
        items.push({id, name: d.pinyin})
        d.pinyin = id
      }

      /*let f
      for(let i = 0; i < items.length; i++)
        if(items[i].name == d.test) {
          f = true
          d.test = items[i].id
          break
        }
      if(!f) {
        let id = items.length + 1
        items.push({id, name: d.test})
        d.test = id
      }*/
    },
    del(d, i, del) {
      if(confirm(`确定要删除用户 ${d.name} ?`)) {
        this.loading(true)
        axios.delete(`api/user/${d.id}`).then(res => {
          del()
          this.loading(false)
          this.message('删除成功')
        }).catch(res => {
          this.loading(false)
          this.error(res.response.data)
        })
      }
      return false
    }
  },
  mounted() {
    this.$store.state.users.forEach(u => {
      Vue.set(u, 'test', 1)
      Vue.set(u, 'pinyin', 2)
    })
    window.user = this
  }
}
</script>
