import cookie from 'js-cookie'
import axios from 'axios'
import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex, {mapMutations} from 'vuex'
import Message from './components/message'
import routes from './routes'
import Login from './Login'

Vue.use(Vuex)

let store = new Vuex.Store({
  state: {
    users: [], groups: [],
    user: null,
  },
  mutations: {
    auth(state, {data, id, url}) {
      state.users = data.users
      state.groups = data.groups
      if(!id)
        id = parseInt(cookie.get('id'))
      state.user = data.users.find(u => u.id == id)
      if(!state.routes) {
        state.routes = true
        router.addRoutes(routes)
      }
      let r = app.$route.name
      if(url && url != '/')
        router.replace(url)
      else if(!r || r == 'login')
        router.replace('/')
    },
    logout() {
      cookie.remove('id')
      router.replace('/auth/login')
    },
    loading(state, v) {
      window.loading.style.display = v ? '' : 'none'
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
  components: {Message},
  router,
  store,
  methods: {
    ...mapMutations(['auth', 'loading', 'message', 'error']),
    run() {
      let id = parseInt(cookie.get('id'))
      if(id) {
        this.loading(true)
        axios.get('api/auth').then(res => {
          this.loading(false)
          this.auth(res, id)
        }).catch(res => {
          this.loading(false)
          this.$router.replace('/auth/login')
        })
      } else
        this.$router.replace('/auth/login')
    }
  }
}).$mount('#app')
window.app = app

app.run()
