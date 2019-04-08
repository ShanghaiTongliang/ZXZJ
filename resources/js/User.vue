<template>
  <div>
    <template v-if="$route.name == 'users'">
      <datable v-if="reset.length" :table="tblReset"></datable>
      <moditable :table="tbl" @save="save" @delete="del"></moditable>
    </template>
    <template v-else-if="$store.state.user == curUser">
      <div style="position: relative; font-weight: bold"><a href="#/user" class="act">返回</a>{{curUser.name}} 修改密码</div>
      <form class="form" @submit.prevent="changePassword">
        　原密码<input type="password" name="previous"><br>
        　新密码<input type="password" name="password"><br>
        确认密码<input type="password" name="confirm"><br>
        <input type="submit" value="修改密码">
      </form>
    </template>
  </div>
</template>
<script>
import axios from 'axios'
import Vue from 'vue'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import { mapState, mapMutations } from 'vuex'

const columns = {
  id: 'id',
  name: {
    caption: '用户名',
    type: 'text',
    href: 'url'
  },
  groups: {
    caption: '用户组',
    type: 'checkbox',
    items: null,
  },
  danWei: {
    caption: '单位',
    type: 'select',
    itemName: 'cheJian',
    items: null
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
}

export default {
  components: {Datable, Moditable},
  data() {
    return {
      show: true,
      tbl: {
        caption: '用户',
        columns,
        data: this.$store.state.users
      },
      tblReset: {
        caption: '申请重置密码用户',
        columns,
        actions: [{
          caption: '重置',
          onclick(d) {
            this.resetPassword('approve', d)
          }
        }, {
          caption: '拒绝',
          onclick(d) {
            this.resetPassword('reject', d)
          }
        }],
        data: null
      }
    }
  },
  computed: {
    ...mapState(['dict', 'users']),
    curUser() {
      return this.users.find(u => u.id == this.$route.params.id)
    },
    reset() {
      let r = this.users.filter(u => u.state == 1)
      this.tblReset.data = r
      return r
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler(r) {
        if(r.name == 'curUser' && this.$store.state.user != this.curUser)
          this.$router.replace('/jiaoJian')
      }
    }
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
    },
    resetPassword(action, d) {
      this.loading(true)
      axios.post('zxzj/api/user/password', {action, id: d.id}).then(() => {
        d.state = null
        this.loading(false)
        this.message('操作成功')
      })
    },
    changePassword(e) {
      e = e.target
      if(!e.previous.value)
        this.error('请输入原密码')
      else if(!e.password.value)
        this.error('请输入新密码')
      else if(!e.confirm.value)
        this.error('请输入确认密码')
      else if(e.password.value != e.confirm.value)
        this.error('新密码和确认密码不一致')
      else {
        this.loading(true)
        axios.put(`zxzj/api/user/${this.$route.params.id}/password`, {
          id: this.curUser.id, previous: e.previous.value,
          password: e.password.value, password_confirmation: e.confirm.value
        }).then(r => {
          this.loading(false)
          this.message('修改成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    }
  },
  created() {
    columns.groups.items = this.$store.state.groups
    columns.danWei.items = this.$store.state.danWei
  }
}
</script>
