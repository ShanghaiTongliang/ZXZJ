import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from './Login.vue'
import MissionPrint from './MissionPrint.vue'

Vue.use(VueRouter)

export default new VueRouter({
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
  }, {
    name: 'mission',
    path: '/mission/:id'
  }]
})