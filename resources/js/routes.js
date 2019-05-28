import Frame from './Frame.vue'
import JiaoJian from './JiaoJian.vue'
import JiaoJianFenXi from './JiaoJianFenXi.vue'
import RuKuFuJian from './RuKuFuJian.vue'
import ZhiJianYuan from './ZhiJianYuan.vue'
import DanWei from './DanWei.vue'
import User from './User.vue'
import Group from './Group.vue'
import Standard from './Standard.vue'
import Option from './Option.vue'

export default [{
  name: 'home',
  path: '/',
  component: Frame,
  children: [{
    name: 'jiaoJian',
    path: 'jiaoJian',
    component: JiaoJian,
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
    component: RuKuFuJian,
    children: [{
      name: 'createRuKuFuJian',
      path: 'create'
    }, {
      name: 'ruKuChuZhi',
      path: 'chuZhi'
    }]
  }, {
    name: 'jiaoJianChaXun',
    path: 'jiaoJianChaXun',
    component: JiaoJianFenXi,
    meta: {keepAlive: true},
    children: [{
      name: 'jiaoJianFunXi',
      path: 'fenXi',
      meta: {keepAlive: true},
    }]
  }, {
    name: 'zhiJianYuan',
    path: 'zhiJianYuan',
    component: ZhiJianYuan,
    children: [{
      name: 'dianWens',
      path: 'dianWen',
      children: [{
        name: 'createDianWen',
        path: 'create'
      }, {
        name: 'dianWen',
        path: ':id',
        children: [{
          name: 'editDianWen',
          path: 'edit'
        }]
      }]
    }, {
      name: 'zhiDaoShu',
      path: 'zhiDaoShu'
    }, {
      name: 'ziLiao',
      path: 'ziLiao'
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
        name: 'user',
        path: ':cid/user'
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
      name: 'cheXing',
      path: 'cheXing',
      children: [{
        name: 'createCheXing',
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
  }, {
    name: 'option',
    path: 'option',
    component: Option
  }]
}]
