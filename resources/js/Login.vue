<style>
.err {
  color: red;
  font-weight: bold;
  margin: .5em
}
.form a {margin: 0 1em}
</style>
<template>
  <div>
    <div class="container">
      <form v-if="$route.name == 'login'" class="form" @submit.prevent="login">
        用户名<input type="text" v-model="data.name"><div class="close" @click="clear"/><br>
        　密码<input type="password" v-model="data.password"><div class="close" @click="clear"/><br>
        <label><input type="checkbox" v-model="data.remember">自动登录</label>
        <input type="submit" value="登录"><br>
        <a href="#/auth/register">注册</a> <a href="#/auth/reset">重置密码</a>
        <div class="err">{{err}}</div>
      </form>
      <form v-else-if="$route.name == 'register'" class="form" @submit.prevent="register">
        　用户名<input type="text" v-model="data.name"><br>
        　　密码<input type="password" v-model="data.password"><br>
        确认密码<input type="password" v-model="data.password_confirmation"><br>
        <input type="submit" value="注册"><br>
        <a href="#/auth/login">登录</a> <a href="#/auth/reset">重置密码</a>
        <div class="err">{{err}}</div>
      </form>
      <form v-else class="form" @submit.prevent="reset">
        用户名<input type="text" v-model="data.name"><br>
        <input type="submit" value="重置"><br>
        <a href="#/auth/login">登录</a> <a href="#/auth/register">注册</a>
        <div class="err">{{err}}</div>
      </form>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
import cookie from 'js-cookie'
import {mapState, mapMutations} from 'vuex'

export default {
  data() {
    return {
      data: {
        name: null,
        password: null,
        password_confirmation: null,
        remember: parseInt(cookie.get('remember'))
      },
      err: null,
    }
  },
  computed: {
    ...mapState(['user'])
  },
  methods: {
    ...mapMutations(['auth', 'loading', 'message']),
    login() {
      this.loading(true)
      delete this.data.password_confirmation
      axios.post('zxzj/api/auth', this.data).then(r => {
        cookie.set('remember', this.data.remember ? 1 : 0)
        this.loading(false)
        this.auth({data: r.data, id: parseInt(cookie.get('id'))})
      }).catch(r => {
        this.loading(false)
        this.err = r.response.data
      })
    },
    register() {
      this.loading(true)
      delete this.data.remember
      axios.post('zxzj/api/user', this.data).then(r => {
        this.loading(false)
        this.auth({data: r.data, id: parseInt(cookie.get('id'))})
      }).catch(r => {
        this.loading(false)
        this.err = r.response.data
      })
    },
    reset() {
      this.loading(true)
      axios.post('zxzj/api/user/password', {name: this.data.name, action: 'apply'}).then(r => {
        this.loading(false)
        this.message('重置密码请求已发出, 请与管理员联系')
      }).catch(r => {
        this.err = r.response.data
      })
    },
    clear(e) {
      e.target.previousSibling.value = ''
    }
  }
}
</script>
