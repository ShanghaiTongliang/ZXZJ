import Vue from 'vue'
import VueRouter from 'vue-router'
import Login from './Login.vue'

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
  }]
})