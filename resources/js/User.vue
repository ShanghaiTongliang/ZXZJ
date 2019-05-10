<template>
  <div style="display: flex; flex-direction: column; position: relative">
    <template v-if="$route.name == 'users'">
      <datable v-if="reset.length" :table="tblReset" style="flex-shrink: 0; max-height: 50%"></datable>
      <moditable :table="tbl" @editable="editable" @edit="edit" @save="save" @delete="del" @cancel="cancel"></moditable>
    </template>
    <template v-else-if="user == curUser">
      <a v-if="user.manage.length" href="#/user" class="act" style="bottom: auto; font-weight: bold">返回</a>
      <template v-if="curUser.state == USER_STATE_APPROVED_RESET_PASSWORD">
        请重置您的密码
        <form class="form" @submit.prevent="changePassword">
          　新密码<input type="password" name="password"><br>
          确认密码<input type="password" name="confirm"><br>
          <input type="submit" value="重置密码">
        </form>
      </template>
      <template v-else>
        {{curUser.name}} 修改密码
        <form class="form" @submit.prevent="changePassword">
          　原密码<input type="password" name="previous"><br>
          　新密码<input type="password" name="password"><br>
          确认密码<input type="password" name="confirm"><br>
          <input type="submit" value="修改密码">
        </form>
      </template>
    </template>
  </div>
</template>
<script>
import axios from 'axios'
import Vue from 'vue'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import { mapState, mapMutations } from 'vuex'
import {USER_STATE_APPLY_RESET_PASSWORD, USER_STATE_APPROVED_RESET_PASSWORD} from './global'

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
    caption: '作业场',
    type: 'select',
    master: ['danWei']
  }
}
let groups

export default {
  components: {Datable, Moditable},
  data() {
    return {
      USER_STATE_APPROVED_RESET_PASSWORD,
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
            if(confirm(`确定要重置 ${d.name} 的密码 ?`))
              this.resetPassword('approve', d)
          }
        }, {
          caption: '拒绝',
          onclick(d) {
            if(confirm(`确定要拒绝 ${d.name} 的重置密码请求 ?`))
              this.resetPassword('reject', d)
          }
        }],
        data: null
      }
    }
  },
  computed: {
    ...mapState(['dict', 'groups', 'users', 'user']),
    curUser() {
      return this.users.find(u => u.id == this.$route.params.id)
    },
    reset() {
      let r = this.users.filter(u => u.state == USER_STATE_APPLY_RESET_PASSWORD)
      this.tblReset.data = r
      return r
    },
    danWei() {
      let r = this.$store.state.danWei.map(d => {
        let r = {...d}
        r.cheJian = [...d.cheJian]
        return r
      })
      r.push({
        id: null,
        name: '无',
        cheJian: []
      })
      r.forEach(d => d.cheJian.push({
        id: null,
        name: '无'
      }))
      return r
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler(r) {
        if(r.name == 'curUser' && this.user.id != this.curUser.id)
          this.$router.replace('/jiaoJian')
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    editable(d) {
      return this.user.admin || !d.groups.includes(255)
    },
    edit() {
      if(!this.user.admin)
        columns.groups.items = groups
    },
    save(d, i, next, o) {
      this.loading(true)
      axios.put(`api/user/${d.id}`, {name: d.name, groups: d.groups, danWei: d.danWei, cheJian: d.cheJian}).then(() => {
        this.loading(false)
        if(d.cheJian != o.cheJian) {
          let f, t
          if(o.cheJian !== null) {
            f = this.dict.cheJian[o.cheJian].user
            for(let i = 0; i < f.length; i++)
              if(f[i].id == o.id) {
                f.splice(i, 1)
                break
              }
          }
          if(d.cheJian) {
            t = this.dict.cheJian[d.cheJian].user
            t.push(d)
            t.sort((a, b) => a.id - b.id)
          }
        }
        this.$store.state.fixUser(d)
        next()
        if(d.id == this.user.id) {
          this.$store.state.user = d
          this.$store.state.fixPermission(d)
        }
        if(!this.user.admin)
          columns.groups.items = this.groups
        this.message('保存成功')
      }).catch(res => {
        if(!this.user.admin)
          columns.groups.items = this.groups
        this.loading(false)
        this.error(res.response.data)
      })
    },
    del(d, i, next) {
      if(confirm(`确定要删除用户 ${d.name} ?`)) {
        this.loading(true)
        axios.delete(`api/user/${d.id}`).then(res => {
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
    cancel() {
      if(!this.user.admin)
        columns.groups.items = this.groups
    },
    resetPassword(action, d) {
      this.loading(true)
      axios.post('api/user/password', {action, id: d.id}).then(() => {
        d.state = null
        this.loading(false)
        this.message('操作成功')
      })
    },
    changePassword(e) {
      e = e.target
      if(e.previous && !e.previous.value)
        this.error('请输入原密码')
      else if(!e.password.value)
        this.error('请输入新密码')
      else if(!e.confirm.value)
        this.error('请输入确认密码')
      else if(e.password.value != e.confirm.value)
        this.error('新密码和确认密码不一致')
      else {
        this.loading(true)
        let d = {id: this.curUser.id, password: e.password.value, password_confirmation: e.confirm.value}
        if(e.previous)
          d.previous = e.previous.value
        axios.put(`api/user/${this.$route.params.id}/password`, d).then(r => {
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
    groups = [...this.groups]
    groups.pop()
    columns.groups.items = this.groups
    columns.danWei.items = this.danWei
  }
}
</script>
