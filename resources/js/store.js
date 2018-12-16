import cookie from 'js-cookie'
import Vue from 'vue'
import Vuex from 'vuex'
import router from './router'
import routes from './routes'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    users: null, groups: null, user: null, std: null, data: null,
    vertical: false, loading: false, message: null, error: false
  },
  mutations: {
    auth(state, {data, id, url}) {
      state.groups = data.groups
      data.users.filter(u => u.banZu == null).forEach(u => {
        u.danWei = u.cheJian = null
      })
      state.users = data.users
      data.danWei.forEach(d => {
        d.url = `#/danWei/${d.id}`
        d.items = d.cheJian //菜单结构
        d.cheJian.forEach(c => {
          c.url = `#/danWei/${d.id}/${c.id}`
          c.items = c.banZu
          c.banZu.forEach(b => {
            b.url = `#/danWei/${d.id}/${c.id}/${b.id}`
            b.user = b.user.map(id => state.users.find(u => u.id == id))
            b.items = b.user
            b.user.forEach(u => {
              u.danWei = d.id
              u.cheJian = c.id
              u.banZu = b.id
            })
          })
        })
      })
      //data.danWei.unshift({name: '无'})
      state.danWei = data.danWei
      state.std = data.std
      data.data.zhengCheJiaoJian.forEach(d => {
        //let std = data.std.find(s => s.id == )
        let g = data.std.guZhang.find(g => g.id == d.guZhang), u
        for(let k in g)
          if(k != 'id')
            d[k] = g[k]
        if(u = data.users.find(u => u.id == d.user)) {
          d.danWei = u.danWei
          d.cheJian = u.cheJian
          d.banZu = u.banZu
        }
      })
      state.data = data.data

      if(!id)
        id = parseInt(cookie.get('id'))
      state.user = data.users.find(u => u.id == id)
      if(!state.routes) {
        state.routes = true
        router.addRoutes(routes)
      }
      let r = router.currentRoute.name
      if(url && url != '/')
        router.replace(url)
      else if(!r || ['home', 'login', 'register', 'reset'].includes(r))
        router.replace('/guZhang')
    },
    logout(state) {
      state.users = state.groups = state.user = null
      cookie.remove('id')
      router.replace('/auth/login')
    },
    loading(state, v) {
      state.loading = v
    },
    fade(state, v) {
      state.message = v
      clearTimeout(this.tmr)
      this.tmr = setTimeout(() => {
        state.message = null
        state.error = false
      }, 5000)
    },
    message(state, v) {
      state.error = false
      this.commit('fade', v)
    },
    error(state, v) {
      state.error = true
      this.commit('fade', v)
    }
  }
})