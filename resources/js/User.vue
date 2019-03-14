<template>
  <moditable :table="tbl" @save="save" @delete="del"></moditable>
</template>
<script>
import axios from 'axios'
import Vue from 'vue'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import { mapState, mapMutations } from 'vuex'

export default {
  components: {Datable, Moditable},
  data() {
    return {
      show: true,
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
          }
        },
        data: this.$store.state.users
      }
    }
  },
  computed: {
    ...mapState(['dict'])
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    save(d, i, next, o) {
      this.loading(true)
      axios.put(`zxzj/api/user/${d.id}`, {name: d.name, groups: d.groups, banZu: d.banZu}).then(res => {
        this.loading(false)
        if(d.banZu != o.banZu) {
          let f, t = this.dict.banZu[d.banZu].user
          if(o.banZu !== null) {
            f = this.dict.banZu[o.banZu].user
            for(let i = 0; i < f.length; i++)
              if(f[i].id == o.id) {
                f.splice(i, 1)
                break
              }
          }
          t.push(d)
          t.sort((a, b) => a.id - b.id)
        }
        next()
        this.message('保存成功')
      }).catch(res => {
        this.loading(false)
        this.error(res.response.data)
      })
    },
    del(d, i, next) {
      if(confirm(`确定要删除用户 ${d.name} ?`)) {
        this.loading(true)
        axios.delete(`zxzj/api/user/${d.id}`).then(res => {
          this.loading(false)
          this.message('删除成功')
          next()
        }).catch(res => {
          this.loading(false)
          this.error(res.response.data)
        })
      }
      return false
    }
  }
}
</script>
