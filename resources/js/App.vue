<template>
  <mission-print v-if="$route.name == 'mission'" :mission="mission"></mission-print>
  <div v-else id="app">
    <div v-show="!login" class="header" style="position: relative"><span style="font-weight: bold">货车站修质检评价系统</span>
      <drop-menu id="menu" v-if="user" :menu="menu"></drop-menu>
    </div>
    <div v-if="!$route.name" id="frame"></div>
    <router-view v-else id="frame"></router-view>
    <div v-show="!login" class="footer">copyright 2019</div>
    <message :message="$store.state.message" :error="$store.state.error"></message>
    <loading :loading="$store.state.loading" :value="$store.state.progress"></loading>
  </div>
</template>
<script>
import cookie from 'js-cookie'
import axios from 'axios'
import {mapMutations, mapState} from 'vuex'
import Loading from './components/Loading'
import Message from './components/Message'
import DropMenu from './components/DropMenu'
import MissionPrint from './MissionPrint'

export default {
  components: {Loading, Message, DropMenu, MissionPrint},
  data() {
    return {
      login: true,
      menu: [{
        caption: null,
        icon: null,
        onclick() {
          this.menu.selection = this.menu[0]
        },
        items: [{
          caption: '修改密码',
          href: null
        }, {
          caption: '退出',
          onclick() {
            axios.delete('api/auth').then(() => {
              let state = this.$store.state
              state.users = state.groups = state.user = null
              this.$router.replace('/auth/login')
            }).catch(res => this.error(res.response.data))
          }
        }]
      }],
      mission: null
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
        this.menu[0].items[0].href = this.user.url
      }
    },
    '$route.name': {
      immediate: true,
      handler(n) {
        this.login = ['login', 'register', 'reset'].includes(n)
      }
    }
  },
  methods: {
    ...mapMutations(['auth', 'loading', 'message', 'error'])
  },
  created() {
    let id = parseInt(cookie.get('id'))
    if(id) {
      this.loading(true)
      axios.get('api/auth').then(res => {
        this.loading(false)
        this.auth({data: res.data, id})
        if(this.$route.name == 'mission') {
          let id = this.$route.params.id
          this.mission = this.$store.state.jiaoJianChuLi.find(m => m.id == id)
        }
      }).catch(res => {
        let a = location.hash.match(/\?.*url=(.*)/), url = a ? decodeURIComponent(a[1]) : location.hash
        if(url[0] == '#')
          url = url.substr(1)
        this.$router.push({name: 'login', query: url ? {url} : null})
        this.loading(false)
        this.error(res.response.data)
      })
    } else if(!this.$route.name || this.$route.matched.length && this.$route.matched[0].name != 'auth') {
      let url = location.hash
      if(url[0] == '#')
        url = url.substr(1)
      this.$router.push({name: 'login', query: {url}})
    }
  }
}
</script>
