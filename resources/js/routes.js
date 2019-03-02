import Frame from './Frame.vue'
import ZhengCheJiaoJian from './ZhengCheJiaoJian.vue'
import RuKuJianCha from './RuKuJianCha.vue'
import DanWei from './DanWei.vue'
import User from './User.vue'
import Group from './Group.vue'
import Standard from './Standard.vue'
import Test from './Test.vue'

export default [{
  name: 'home',
  path: '/',
  component: Frame,
  children: [{
    name: 'zhengCheJiaoJian',
    path: '/zhengCheJiaoJian',
    component: ZhengCheJiaoJian,
    children: [{
      name: 'zhengCheJiaoJianCreate',
      path: '/zhengCheJiaoJian/create'
    }]
  }, {
    name: 'ruKuJianCha',
    path: '/ruKuJianCha',
    component: RuKuJianCha
  }, {
    name: 'danWeis',
    path: '/danwei',
    component: DanWei,
    children: [{
      name: 'createDanWei',
      path: 'create'
    }, {
      name: 'danWei',
      path: ':did',
      children: [{
        name: 'createCheJian',
        path: 'create',
      }, {
        name: 'cheJian',
        path: ':cid',
        children: [{
          name: 'createBanZu',
          path: 'create',
        }, {
          name: 'banZu',
          path: ':bid'
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
      path: 'xiuCheng'
    }, {
      name: 'cheZhong',
      path: 'cheZhong'
    }, {
      name: 'daBuWei',
      path: 'daBuWei'
    }, {
      name: 'xiaoBuWei',
      path: 'xiaoBuWei'
    }, {
      name: 'juTiBuWei',
      path: 'juTiBuWei'
    }, {
      name: 'guZhang',
      path: 'guZhang'
    }, {
      name: 'dengJi',
      path: 'dengJi'
    }]
  }, {
    name: 'test',
    path: '/test',
    component: Test
  }]
}]
