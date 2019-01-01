import Vue from 'vue'
import Vuex from 'vuex'
import router from './router'
import routes from './routes'
import {fields} from './global'

Vue.use(Vuex)

export function fixGuZhang(g) {
  fields.forEach(f => g[f] = this.dict[f][g[f]].name)
  let u = this.users.find(u => u.id == g.user)
  if(u) {
    g.danWei = u.danWei
    g.cheJian = u.cheJian
    g.banZu = u.banZu
  }
}

export function fixGroup(g) {
  g.url = `#/group/${g.id}`
}

export default new Vuex.Store({
  state: {
    users: null, groups: null, user: null, std: null, guZhang: null, dict: null,
    vertical: false, loading: false, message: null, error: false
  },
  mutations: {
    auth(state, {data, id, url}) {
      let dict = {groups: [], danWei: [], cheJian: [], banZu: [], user: []}
      fields.forEach(f => dict[f] = [])
      data.groups.forEach(g => dict.groups[g.id] = g)
      state.groups = data.groups
      state.groups.filter(g => g.id != 255).forEach(fixGroup)
      data.users.filter(u => u.banZu == null).forEach(u => {
        u.danWei = u.cheJian = null
      })
      data.users.forEach(u => {
        let p = []
        for(let i = 0; i < 2; i++)
          if(u.permission >> i & 1)
            p.push(i)
        u.permission = p
      })
      state.users = data.users
      data.danWei.forEach(d => {
        d.url = `#/danWei/${d.id}`
        dict.danWei[d.id] = d
        d.cheJian.forEach(c => {
          c.url = `#/danWei/${d.id}/${c.id}`
          dict.cheJian[c.id] = c
          c.banZu.forEach(b => {
            b.url = `#/danWei/${d.id}/${c.id}/${b.id}`
            b.user = b.user.map(id => state.users.find(u => u.id == id))
            dict.banZu[b.id] = b
            b.user.forEach(u => {
              u.danWei = d.id
              u.cheJian = c.id
              u.banZu = b.id
              dict.user[u.id] = u
            })
          })
        })
      })
      state.danWei = data.danWei
      fields.forEach(f => data.std[f].forEach(d => dict[f][d.id] = d))
      state.std = data.std
      state.guZhang = data.guZhang
      state.dict = dict
      state.guZhang.zhengCheJiaoJian.forEach(fixGuZhang, state)

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