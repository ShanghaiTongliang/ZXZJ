import App from './App.vue'
import GuZhang from './GuZhang.vue'
import ZhengCheJiaoJian from './ZhengCheJiaoJian.vue'
import LingBuJianJiaoJian from './LingBuJianJiaoJian.vue'
import Test from './Test.vue'

export default [{
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
  }, {
    name: 'test',
    path: '/test',
    component: Test
  }]
}, {
  name: 'logout',
  path: '/logout'
}]
