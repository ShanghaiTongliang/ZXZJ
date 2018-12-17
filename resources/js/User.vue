<template>
  <moditable :tbl="tbl" @save="save" @delete="del"></moditable>
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
            items: this.$store.state.danWei
          },
          cheJian: {
            caption: '车间',
            type: 'select',
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
            items: [{
              id: 1,
              name: 'aaa'
            }, {
              id: 2,
              name: 'bbb'
            }, {
              id: 3,
              name: 'ccc'
            }]
          }
        },
        data: this.$store.state.users
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    save(d, i) {
      /*this.loading(true)
      axios.put(`api/user/${d.id}`, d).then(res => {
        this.loading(false)
        this.message('保存成功')
      }).catch(res => {
        this.loading(false)
        this.error(res.response.data)
      })*/
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
    this.$store.state.users.forEach(u => Vue.set(u, 'test', 1))
  }
}
</script>
