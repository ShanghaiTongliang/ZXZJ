import Frame from './Frame.vue'
import jiaoJian from './jiaoJian.vue'
import jiaoJianGuZhang from './jiaoJianGuZhang.vue'
import jiaoJianChuLi from './jiaoJianChuLi.vue'
import RuKuFuJian from './RuKuFuJian.vue'
import DanWei from './DanWei.vue'
import User from './User.vue'
import Group from './Group.vue'
import Standard from './Standard.vue'

export default [{
  name: 'home',
  path: '/',
  component: Frame,
  children: [{
    name: 'jiaoJian',
    path: 'jiaoJian',
    component: jiaoJian,
    meta: {keepAlive: true},
    children: [{
      name: 'createJiaoJian',
      path: 'create',
      meta: {keepAlive: true},
    }]
  }, {
    name: 'jiaoJianGuZhang',
    path: 'jiaoJianGuZhang',
    component: jiaoJianGuZhang,
    meta: {keepAlive: true}
  }, {
    name: 'jiaoJianChuLi',
    path: 'jiaoJianChuLi',
    component: jiaoJianChuLi
  }, {
    name: 'ruKuFuJian',
    path: '/ruKuFuJian',
    component: RuKuFuJian,
    children: [{
      name: 'createRuKuFuJian',
      path: 'create'
    }]
  }, {
    name: 'danWei',
    path: '/danwei',
    component: DanWei,
    children: [{
      name: 'createDanWei',
      path: 'create'
    }, {
      name: 'cheJian',
      path: ':did/cheJian',
      children: [{
        name: 'createCheJian',
        path: 'create',
      }, {
        name: 'banZu',
        path: ':cid/banZu',
        children: [{
          name: 'createBanZu',
          path: 'create',
        }, {
          name: 'user',
          path: ':bid/user'
        }]
      }]
    }]
  }, {
    name: 'users',
    path: '/user',
    component: User
  }, {
    name: 'groups',
    path: '/group',
    component: Group,
    children: [{
      name: 'createGroup',
      path: 'create'
    }, {
      name: 'group',
      path: ':gid',
      children: [{
        name: 'createGroupCheJian',
        path: 'create'
      }]
    }]
  }, {
    name: 'standard',
    path: 'standard',
    component: Standard,
    children: [{
      name: 'xiuCheng',
      path: 'xiuCheng',
      children: [{
        name: 'createXiuCheng',
        path: 'create'
      }]
    }, {
      name: 'cheZhong',
      path: 'cheZhong',
      children: [{
        name: 'createCheZhong',
        path: 'create'
      }]
    }, {
      name: 'daBuWei',
      path: 'daBuWei',
      children: [{
        name: 'createDaBuWei',
        path: 'create'
      }]
    }, {
      name: 'guZhang',
      path: 'guZhang',
      children: [{
        name: 'createGuZhang',
        path: 'create'
      }]
    }, {
      name: 'dengJi',
      path: 'dengJi',
      children: [{
        name: 'createDengJi',
        path: 'create'
      }]
    }, {
      name: 'peiJian',
      path: 'peiJian',
      children: [{
        name: 'createPeiJian',
        path: 'create'
      }]
    }]
  }]
}]
