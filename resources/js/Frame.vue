<style>
#nav {
  background-color: white;
  flex-grow: 1;
}
</style>
<template>
  <div>
    <resizer>
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
        name: 'guZhang',
        caption: '故障录入',
        href: '#/guZhang',
        items: [{
          name: 'zhengCheJiaoJian',
          caption: '整车交检故障',
          href: '#/guZhang/zhengCheJiaoJian'
        }, {
          name: 'lingBuJianJiaoJian',
          caption: '零部件交检故障',
          href: '#/guZhang/lingBuJianJiaoJian'
        }, {
          name: 'lingBuJianChouYang',
          caption: '零部件抽样故障',
          href: '#/guZhang/lingBuJianChouYang'
        }, {
          name: 'lingBuJianFuJian',
          caption: '零部件复检故障',
          href: '#/guZhang/lingBuJianFuJian'
        }]
      }, {
        caption: '检查记录',
        items: [{
          name: 'chouYang',
          caption: '抽样检查记录',
          href: '#/jiLu/chouYang'
        }, {
          name: 'ruKu',
          caption: '入库检查记录',
          href: '#/jiLu/ruKu'
        }]
      }, {
        name: 'danWeis',
        caption: '单位',
        href: '#/danWei'
      }, {
        name: 'users',
        caption: '用户',
        href: '#/user',
      }, {
        name: 'test',
        caption: '测试',
        href: '#/test'
      }],
      selection: null
    }
  },
  watch: {
    '$route': function(v) {
      this.setRoute(v)
    }
  },
  methods: {
    select(selection) {
      this.selection = selection
    },
    setRoute(r) {
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
  },
  mounted() {
    if(!this.$route.name) {
      this.$router.replace('/guZhang')
    }
    this.setRoute(this.$route)
  }
}
</script>
