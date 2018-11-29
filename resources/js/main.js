// @ts-nocheck
//import cookie from 'js-cookie'
//import axios from 'axios'
import Vue from 'vue'
//import Vuex from 'vuex'
import VueRouter from 'vue-router'
import SideMenu from './components/SideMenu'
import guZhang from './guZhang.vue'
import zhengCheJiaoJian from './zhengCheJiaoJian.vue'
import lingBuJianJiaoJian from './lingBuJianJiaoJian.vue'

Vue.use(VueRouter)

let app = new Vue({
  el: '#app',
  components: {SideMenu, guZhang, zhengCheJiaoJian, lingBuJianJiaoJian},
  router: new VueRouter({
    routes: [{
      name: 'guZhang',
      path: '/guZhang',
      component: guZhang,
    }, {
      name: 'zhengCheJiaoJian',
      path: '/guZhang/zhengCheJiaoJian',
      component: zhengCheJiaoJian
    }, {
      name: 'lingBuJianJiaoJian',
      path: '/guZhang/lingBuJianJiaoJian',
      component: lingBuJianJiaoJian
    }]
  }),
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
        /*onclick: e => {
          console.log(this, e)
        },*/
        items: [{
          name: 'chouYang',
          caption: '抽样检查记录',
          href: '#/jiLu/chouYang'
        }, {
          name: 'ruKu',
          caption: '入库检查记录',
          href: '#/jiLu/ruKu'
        }]
      }],
      selection: null
    }
  },
  methods: {
    menuSelect(selection) {
      this.selection = selection
    }
  },
  mounted() {
    if(!this.$route.name) {
      this.$router.replace('/guZhang')
    }
    function find(menu, n) {
      for(let m of menu) {
        if(m.name == n)
          return m
        if(m.items)
          return find(m.items, n)
      }
    }
    this.selection = find(this.menu, this.$route.name)
  }
})
window.a = app

/*axios.get('api/list').then(res => {

})
*/
