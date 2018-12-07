import cookie from 'js-cookie'
import axios from 'axios'
import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex, {mapMutations, mapState} from 'vuex'
import './date'
import Message from './components/Message'
import DropMenu from './components/DropMenu'
import routes from './routes'
import Login from './Login'

Vue.use(Vuex)

let store = new Vuex.Store({
  state: {
    users: null, groups: null, user: null,
  },
  mutations: {
    auth(state, {data, id, url}) {
      state.users = data.users
      state.groups = data.groups
      if(!id)
        id = parseInt(cookie.get('id'))
      state.user = data.users.find(u => u.id == id)
      app.menu[0].caption = state.user.name
      app.menu[0].icon = state.user.icon
      app.menu[0].href = `#/user/${state.user.id}`
      if(!state.routes) {
        state.routes = true
        router.addRoutes(routes)
      }
      let r = app.$route.name
      if(url && url != '/')
        router.replace(url)
      else if(!r || ['home', 'login', 'register', 'logout'].includes(r))
        router.replace('/guZhang')
    },
    logout(state) {
      state.users = state.groups = state.user = null
      cookie.remove('id')
      router.replace('/auth/login')
    },
    loading(state, v) {
      app.loading = v
    },
    message(state, v) {
      app.$refs.message.message(v)
    },
    error(state, v) {
      app.$refs.message.error(v)
    }
  }
})

let router = new VueRouter({
  routes: [{
    name: 'auth',
    path: '/auth',
    component: Login,
    children: [{
      name: 'login',
      path: 'login'
    }, {
      name: 'register',
      path: 'register'
    }, {
      name: 'reset',
      path: 'reset'
    }]
  }]
})
Vue.use(VueRouter)

let app = new Vue({
  router,
  store,
  components: {Message, DropMenu},
  data() {
    return {
      loading: false,
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
  methods: {
    ...mapMutations(['auth', 'message', 'error', 'logout']),
  },
  mounted() {
    let id = parseInt(cookie.get('id'))
    if(id) {
      this.loading = true
      axios.get('api/auth').then(res => {
        this.loading = false
        this.auth({data: res.data, id})
      }).catch(res => {
        let a = location.hash.match(/\?.*url=(.*)/), url = a ? decodeURIComponent(a[1]) : location.hash
        if(url[0] == '#')
          url = url.substr(1)
        router.push({name: 'login', query: url ? {url} : null})
        this.loading = false
        this.error(res.response.data)
      })
    } else {
      if(this.$route.name != 'login' && this.$route.name != 'reset') {
        let url = location.hash
        if(url[0] == '#')
          url = url.substr(1)
        router.push({name: 'login', query: {url}})
      }
    }
  }
}).$mount('#app')
window.app = app
