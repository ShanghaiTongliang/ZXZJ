import Vue from 'vue'
import Vuex from 'vuex'
import router from './router'
import routes from './routes'
import {daBuWei} from './global'

Vue.use(Vuex)

export function fixZhengCheJiaoJian(g) {
  let t = this.dict.guZhang[g.guZhang]
  g.daBuWei = t.daBuWei
  g.dengJi = t.dengJi
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
    users: null, user: null, groups: null, danWei: null, std: null, zhengCheJiaoJian: null, rukUJianCha: null, dict: null,
    vertical: false, loading: false, message: null, error: false
  },
  mutations: {
    auth(state, {data, id, url}) {
      let dict = {groups: {}, danWei: {}, cheJian: {}, banZu: {}, user: {}}
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
      //建立字典
      data.danWei.forEach(d => {
        d.url = `#/danWei/${d.id}`
        dict.danWei[d.id] = d
        d.cheJian.forEach(c => {
          c.url = `#/danWei/${d.id}/${c.id}`
          dict.cheJian[c.id] = c
          c.banZu.forEach(b => {
            b.url = `#/danWei/${d.id}/${c.id}/${b.id}`
            b.user = b.user.map(id => {
              return state.users.find(u => {
                return u.id == id
              })
            })
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
      const fs = ['cheZhong', 'daBuWei']
      dict.cheZhong = {}
      data.std.cheZhong.forEach(d => dict.cheZhong[d.id] = d)
      let t = []
      data.std.daBuWei = daBuWei
      data.std.daBuWei.forEach(d => d.guZhang.forEach(g => t.push(g)))
      data.std.guZhang = t
      dict.guZhang = {}
      data.std.daBuWei.forEach(d => d.guZhang.forEach(g => {
        dict.guZhang[g.id] = g
        g.daBuWei = d.id
      }))
      state.std = data.std
      state.dict = dict
      state.zhengCheJiaoJian = data.zhengCheJiaoJian
      state.zhengCheJiaoJian.forEach(fixZhengCheJiaoJian, state)

      state.user = data.users.find(u => u.id == id)
      if(!state.routes) {
        state.routes = true
        router.addRoutes(routes)
      }
      let r = router.currentRoute.name
      if(url && url != '/')
        router.replace(url)
      else if(!r || ['home', 'login', 'register', 'reset'].includes(r))
        router.replace('/zhengCheJiaoJian')
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