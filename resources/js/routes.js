import Frame from './Frame.vue'
import jiaoJian from './jiaoJian.vue'
import jiaoJianGuZhang from './jiaoJianGuZhang.vue'
import ruKuFuJian from './ruKuFuJian.vue'
import pingJia from './pingJia.vue'
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
    }, {
      name: 'jiaoJianXiaFa',
      path: 'xiaFa',
      meta: {keepAlive: true},
    }, {
      name: 'jiaoJianChuLi',
      path: 'chuLi',
      meta: {keepAlive: true},
    }, {
      name: 'jiaoJianXiaoHao',
      path: 'xiaoHao',
      meta: {keepAlive: true},
    }]
  }, {
    name: 'ruKuFuJian',
    path: 'ruKuFuJian',
    component: ruKuFuJian,
    children: [{
      name: 'createRuKuFuJian',
      path: 'create'
    }, {
      name: 'ruKuChuZhi',
      path: 'chuZhi'
    }]
  }, {
    name: 'jiaoJianGuZhang',
    path: 'jiaoJianGuZhang',
    component: jiaoJianGuZhang,
    meta: {keepAlive: true}
  }, {
    name: 'pingJias',
    path: 'pingJia',
    component: pingJia,
    meta: {keepAlive: true},
    children: [{
      name: 'createPingJia',
      path: 'create'
    }, {
      name: 'pingJia',
      path: ':id',
      children: [{
        name: 'editPingJia',
        path: 'edit'
      }]
    }]
  }, {
    name: 'danWei',
    path: 'danWei',
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
    path: 'user',
    component: User,
    children: [{
      name: 'curUser',
      path: ':id'
    }]
  }, {
    name: 'groups',
    path: 'group',
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
      name: 'peiJian',
      path: 'peiJian',
      children: [{
        name: 'createPeiJian',
        path: 'create'
      }]
    }, {
      name: 'xingHao',
      path: 'xingHao',
      children: [{
        name: 'createXingHao',
        path: 'create'
      }]
    }]
  }]
}]
