import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
import Login from './Login.vue'
import GuZhang from './GuZhang.vue'
import ZhengCheJiaoJian from './zhengCheJiaoJian.vue'
import LingBuJianJiaoJian from './lingBuJianJiaoJian.vue'

Vue.use(VueRouter)

export default new VueRouter({
  routes: [{
    name: 'home',
    path: '/',
    component: App,
    children: [{
      name: 'guZhang',
      path: '/guZhang',
      component: GuZhang,
    }, {
      name: 'zhengCheJiaoJian',
      path: '/guZhang/zhengCheJiaoJian',
      component: ZhengCheJiaoJian
    }, {
      name: 'lingBuJianJiaoJian',
      path: '/guZhang/lingBuJianJiaoJian',
      component: LingBuJianJiaoJian
    }]
  }, {
    name: 'login',
    path: '/login',
    component: Login
  }],
})
