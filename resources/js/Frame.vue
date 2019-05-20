<style>
#nav {background-color: white}
</style>
<template>
  <div>
    <resizer :width="width" :visible="visible" @resize="resize" @toggle="toggle">
      <side-menu id="nav" :menu="menu" :selection="selection" @select="select"></side-menu>
    </resizer>
    <keep-alive>
      <router-view v-if="$route.meta.keepAlive" class="container"></router-view>
    </keep-alive>
    <router-view v-if="!$route.meta.keepAlive" class="container"></router-view>
  </div>
</template>
<script>
import SideMenu from './components/SideMenu'
import Resizer from './components/Resizer'
import {USER_STATE_APPROVED_RESET_PASSWORD} from './global'

export default {
  components: {SideMenu, Resizer},
  data() {
    return {
      width: this.$store.state.options.frame.width || 140,
      visible: this.$store.state.options.frame.visible,
      selection: null
    }
  },
  computed: {
    menu() {
      let u = this.$store.state.user, data = u.data.length, repair = u.repair.length, manage = u.manage.length
      return [{
        caption: '整车交检故障',
        items: [{
          name: 'jiaoJian',
          caption: '故障录入',
          href: '#/jiaoJian',
          condition: data
        }, {
          name: 'jiaoJianXiaFa',
          caption: '故障下发不合格通知书',
          href: '#/jiaoJian/xiaFa',
          condition: data
        }, {
          name: 'jiaoJianChuLi',
          caption: '故障处理',
          href: '#/jiaoJian/chuLi',
          condition: repair
        }, {
          name: 'jiaoJianXiaoHao',
          caption: '故障销号',
          href: '#/jiaoJian/xiaoHao',
          condition: data
        }]
      }, {
        caption: '入库复检记录',
        condition: data,
        items: [{
          name: 'ruKuFuJian',
          caption: '复检记录',
          href: '#/ruKuFuJian'
        }, {
          name: 'ruKuChuZhi',
          caption: '不合格处置',
          href: '#/ruKuFuJian/chuZhi'
        }]
      }, {
        name: 'jiaoJianFenXi',
        caption: '故障分析',
        href: '#/jiaoJianFenXi',
        condition: data
      }, {
        caption: '质检员技术管理',
        condition: data,
        items: [{
          name: 'dianWens',
          caption: '电文下发',
          href: '#/zhiJianYuan/dianWen'
        }, {
          name: 'zhiDaoShu',
          caption: '质检作业指导书',
          href: '#/zhiJianYuan/zhiDaoShu'
        }, {
          name: 'ziLiao',
          caption: '学习资料',
          href: '#/zhiJianYuan/ziLiao'
        }]
      }, {
        name: 'danWei',
        caption: '单位',
        href: '#/danWei',
        condition: manage
      }, {
        name: 'users',
        caption: '用户',
        href: '#/user',
        condition: manage
      }, {
        name: 'groups',
        caption: '用户组',
        href: '#/group',
        condition: manage
      }, {
        caption: '基础数据',
        condition: manage,
        items: [{
          name: 'xiuCheng',
          caption: '修程',
          href: '#/standard/xiuCheng'
        }, {
          name: 'cheZhong',
          caption: '车型',
          href: '#/standard/cheZhong'
        }, {
          name: 'daBuWei',
          caption: '大部位',
          href: '#/standard/daBuWei'
        }, {
          name: 'guZhang',
          caption: '故障',
          href: '#/standard/guZhang'
        }, {
          name: 'peiJian',
          caption: '配件',
          href: '#/standard/peiJian'
        }, {
          name: 'xingHao',
          caption: '型号',
          href: '#/standard/xingHao'
        }]
      }, {
        name: 'option',
        caption: '系统参数',
        href: '#/option',
        condition: u.admin
      }]
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler(r, from) {
        let u = this.$store.state.user
        if(!u)
          this.$router.replace('/auth/login')
        else if(u.state == USER_STATE_APPROVED_RESET_PASSWORD && r.name != 'curUser')
          this.$router.replace(`/user/${u.id}`)
        else if(!r.name)
          this.$router.replace('/jiaoJian')
        else {
          function find(menu, r) {
            //广度优先
            for(let i = r.matched.length - 1; i > 0; i--)
              for(let m of menu) {
                if(m.name == r.matched[i].name)
                  return m
              if(m.items) {
                let v = find(m.items, r)
                if(v)
                  return v
              }
            }
          }
          this.selection = find(this.menu, r)
        }
      }
    }
  },
  methods: {
    select(selection) {
      this.selection = selection
    },
    resize(w) {
      this.width = w
      this.$store.commit('width', w)
    },
    toggle(v) {
      this.visible = v
      this.$store.commit('toggle', v)
    }
  }
}
</script>
