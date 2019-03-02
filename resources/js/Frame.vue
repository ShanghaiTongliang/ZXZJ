<style>
#nav {
  background-color: white;
  flex-grow: 1;
}
</style>
<template>
  <div>
    <resizer :width="110">
      <side-menu id="nav" :menu="menu" :selection="selection" @select="select"></side-menu>
    </resizer>
    <router-view class="container"></router-view>
  </div>
</template>
<script>
import SideMenu from './components/SideMenu'
import Resizer from './components/Resizer'

export default {
  components: {SideMenu, Resizer},
  data() {
    return {
      menu: [{
        name: 'zhengCheJiaoJian',
        caption: '整车交检故障',
        href: '#/zhengCheJiaoJian'
      }, {
        name: 'ruKuJianCha',
        caption: '入库检查记录',
        href: '#/ruKuJianCha'
      }, {
        name: 'danWeis',
        caption: '单位',
        href: '#/danWei'
      }, {
        name: 'users',
        caption: '用户',
        href: '#/user',
      }, {
        name: 'groups',
        caption: '用户组',
        href: '#/group'
      }, {
        caption: '基础数据',
        items: [{
          name: 'xiuCheng',
          caption: '修程',
          href: '#/standard/xiuCheng'
        }, {
          name: 'cheZhong',
          caption: '车种',
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
          name: 'dengJi',
          caption: '等级',
          href: '#/standard/dengJi'
        }]
      }, {
        name: 'test',
        caption: '测试',
        href: '#/test'
      }],
      selection: null
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler(r, from) {
        if(!r.name)
          this.$router.replace('/zhengCheJiaoJian')
        else {
          function find(menu, r) {
            for(let m of menu) {
              for(let i = r.matched.length - 1; i > 0; i--)
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
    }
  }
}
</script>
