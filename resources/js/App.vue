<template>
  <div id="app">
    <div class="header" style="position: relative">站修质检
      <drop-menu id="menu" v-if="user" :menu="menu"></drop-menu>
    </div>
    <div v-if="!$route.name" id="frame"></div>
    <router-view v-else id="frame"></router-view>
    <div class="footer">联系电话: 021-51244254</div>
    <message :message="$store.state.message" :error="$store.state.error"></message>
    <div v-show="$store.state.loading" class="mask">
      <div class="loading">
        <div></div><div></div><div></div><div></div><div></div><div></div><div></div><div></div>
      </div>
    </div>
  </div>
</template>
<script>
import cookie from 'js-cookie'
import axios from 'axios'
import {mapMutations, mapState} from 'vuex'
import Message from './components/Message'
import DropMenu from './components/DropMenu'

export default {
  components: {Message, DropMenu},
  data() {
    return {
      menu: [{
        caption: null,
        icon: null,
        href: null,
        items: [{
          caption: '退出',
          onclick() {
            this.logout()
          }
        }]
      }]
    }
  },
  computed: {
    ...mapState(['user'])
  },
  watch: {
    user(v) {
      if(v) {
        this.menu[0].caption = this.user.name
        this.menu[0].icon = this.user.icon
        this.menu[0].href = `#/user/${this.user.id}`
      }
    }
  },
  methods: {
    ...mapMutations(['auth', 'loading', 'message', 'error', 'logout'])
  },
  mounted() {
    let id = parseInt(cookie.get('id'))
    if(id) {
      this.loading(true)
      axios.get('api/auth').then(res => {
        this.loading(false)
        this.auth({data: res.data, id})
      }).catch(res => {
        let a = location.hash.match(/\?.*url=(.*)/), url = a ? decodeURIComponent(a[1]) : location.hash
        if(url[0] == '#')
          url = url.substr(1)
        this.$router.push({name: 'login', query: url ? {url} : null})
        this.loading(false)
        this.error(res.response.data)
      })
    } else {
      if(this.$route.name != 'login' && this.$route.name != 'reset') {
        let url = location.hash
        if(url[0] == '#')
          url = url.substr(1)
        this.$router.push({name: 'login', query: {url}})
      }
    }
  }
}
</script>
