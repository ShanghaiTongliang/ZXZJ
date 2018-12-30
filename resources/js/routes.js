import Frame from './Frame.vue'
import GuZhang from './GuZhang.vue'
import ZhengCheJiaoJian from './ZhengCheJiaoJian.vue'
import LingBuJianJiaoJian from './LingBuJianJiaoJian.vue'
import DanWei from './DanWei.vue'
import User from './User.vue'
import Group from './Group.vue'
import Test from './Test.vue'

export default [{
  name: 'home',
  path: '/',
  component: Frame,
  children: [{
    name: 'guZhang',
    path: '/guZhang',
    component: GuZhang,
  }, {
    name: 'zhengCheJiaoJian',
    path: '/guZhang/zhengCheJiaoJian',
    component: ZhengCheJiaoJian,
    children: [{
      name: 'zhengCheJiaoJianCreate',
      path: '/guZhang/zhengCheJiaoJian/create'
    }]
  }, {
    name: 'lingBuJianJiaoJian',
    path: '/guZhang/lingBuJianJiaoJian',
    component: LingBuJianJiaoJian
  }, {
    name: 'chouYangJianCha',
    path: '/jianCha/chouYang'
  }, {
    name: 'ruKuJianCha',
    path: '/jianCha/ruKu'
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
    name: 'test',
    path: '/test',
    component: Test
  }]
}]
