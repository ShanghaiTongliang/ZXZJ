<style>
.ctx {
  flex-grow: 1;
  overflow: auto;
}
</style>
<template>
  <div style="display: flex; background-color: white">
    <resizer>
      <side-menu :menu="menu" :selection="selection" @select="menuSelect" style="background-color: white; flex-grow: 1"></side-menu>
    </resizer>
    <div v-if="$route.name == 'home'" class="ctx">
      <form class="form" @submit.prevent="register">
        　用户名<input type="text" v-model="user.name"><br>
        　　密码<input type="password" v-model="user.password"><br>
        确认密码<input type="password" v-model="user.password_confirmation"><br>
        <input type="submit" value="注册">
        <div style="color: red; font-weight: bold; margin: .5em">{{err}}</div>
      </form>
    </div>
    <router-view v-else class="ctx"></router-view>
  </div>
</template>
<script>
import axios from 'axios'
import SideMenu from './components/SideMenu'
import Resizer from './components/Resizer'

export default {
  components: {SideMenu, Resizer},
  data() {
    return {
      user: {
        name: null,
        password: null,
        password_confirmation: null
      },
      err: null,
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
    register() {
      axios.post('api/user', this.user).then(r => {
        console.log(r.data)
      }).catch(r => {
        this.err = r.response.data
      })
    },
    menuSelect(selection) {
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
        if(m.items)
          return find(m.items, n)
      }
    }
    this.selection = find(this.menu, this.$route.name)
  }
}
</script>
