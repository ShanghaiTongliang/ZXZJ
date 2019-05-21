<style>
.err {
  color: red;
  font-weight: bold;
  margin: .5em
}
.form a {margin: 0 1em}
.form.inSideBox {background-color:white}
.form.inSideBox input {
  margin: 1em 0 1em 1em;
  padding: .5em;
}
#login-msg {
  margin: 10px 0 0 -58px;
  padding: 18px 10px 18px 60px;
  background: #27A9E3;
  color: #fff;
  font-size: 22px;
}
#darkbannerwrap {
  width: 18px;
  height: 10px;
  margin: 0 0 20px -58px;
}
.login{
  margin:auto;
  min-height: 420px;
  max-width: 420px;
  padding: 40px;
  background-color: #ffffff;
  margin-left: auto;
  margin-right: auto;
  border-radius: 4px;
  box-sizing: border-box;
}
</style>
<template>
  <div>
     <div class="container" style="background-image: url(img/loginback.jpg);background-size: 100% 100%; display: flex; min-heigh:100vh" >
     <div class="login">
      <div id="login-msg">铁路货车站修质检评价系统</div>
      <div id="darkbannerwrap" style="background: url(img/aiwrap.png)"></div>
      <form v-if="$route.name == 'login'" class="form inSideBox" @submit.prevent="login">
        用户名<input type="text" placeholder="用户名" v-model="data.name"><div class="close" @click="clear"/><br>
        　密码<input type="password"  placeholder="密码" v-model="data.password"><div class="close" @click="clear"/><br>
        <label><input type="checkbox" v-model="data.remember">自动登录</label>
        <input type="submit" value="登录"><br>
        <a href="#/auth/register">注册</a> <a href="#/auth/reset">重置密码</a>
        <div class="err">{{err}}</div>
      </form>
      <form v-else-if="$route.name == 'register'" class="form inSideBox" @submit.prevent="register">
        　用户名<input type="text" v-model="data.name"><br>
        　　密码<input type="password" v-model="data.password"><br>
        确认密码<input type="password" v-model="data.password_confirmation"><br>
        <input type="submit" value="注册"><br>
        <a href="#/auth/login">登录</a> <a href="#/auth/reset">重置密码</a>
        <div class="err">{{err}}</div>
      </form>
      <form v-else class="form inSideBox" @submit.prevent="reset">
        用户名<input type="text" v-model="data.name"><br>
        <input type="submit" value="重置"><br>
        <a href="#/auth/login">登录</a> <a href="#/auth/register">注册</a>
        <div class="err">{{err}}</div>
      </form>
     </div>
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
      axios.post('api/auth', this.data).then(r => {
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
      axios.post('api/user', this.data).then(r => {
        this.loading(false)
        this.auth({data: r.data, id: parseInt(cookie.get('id'))})
      }).catch(r => {
        this.loading(false)
        this.err = r.response.data
      })
    },
    reset() {
      this.loading(true)
      axios.post('api/user/password', {name: this.data.name, action: 'apply'}).then(r => {
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
