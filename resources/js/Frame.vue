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
        name: 'test',
        caption: '测试',
        href: '#/test'
      }],
      selection: null
    }
  },
  methods: {
    select(selection) {
      this.selection = selection
    },
  },
  mounted() {
    if(!this.$route.name) {
      this.$router.replace('/guZhang')
    }
    function find(menu, n) {
      for(let m of menu) {
        if(m.name == n)
          return m
        if(m.items) {
          let r = find(m.items, n)
          if(r)
            return r
        }
      }
    }
    this.selection = find(this.menu, this.$route.name)
  }
}
</script>
