import Vue from 'vue'
import Vuex from 'vuex'
import router from './router'
import routes from './routes'
import {daBuWei, dengJi} from './global'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    users: null, user: null, groups: null, danWei: null, std: null, jiaoJian: null, jiaoJianChuLi: null, ruKuFuJian: null, pingJia: null, dict: null,
    vertical: false, loading: false, message: null, error: false,

    fixJiaoJian(g) {
      let t = this.dict.guZhang[g.guZhang]
      g.daBuWei = t.daBuWei
      g.dengJi = t.dengJi
    },
    fixRuKuFuJian(g) {
      let t = this.dict.xingHao[g.xingHao], p = this.dict.peiJian[t.peiJian]
      g.peiJian = t.peiJian
      g.leiBie = p.leiBie
    },
    fixPingJia(p) {
      p.url = `#/pingJia/${p.id}`
    },
    fixGroup(g) {
      if(g.id != 255)
        g.url = `#/group/${g.id}`
      this.dict.groups[g.id] = g
    },
    fixDanWei(d) {
      d.url = `#/danWei/${d.id}/cheJian`
      this.dict.danWei[d.id] = d
    },
    fixCheJian(c) {
      c.url = `#/danWei/${c.danWei}/cheJian/${c.id}/banZu`
      this.dict.cheJian[c.id] = c
    },
    fixBanZu(b) {
      b.url = `#/danWei/${this.dict.cheJian[b.cheJian].danWei}/cheJian/${b.cheJian}/banZu/${b.id}/user`
      this.dict.banZu[b.id] = b
    },
    fixUser(u) {
      u.permission = {}
      if(u.groups.includes(255))
        this.danWei.forEach(d => d.cheJian.forEach(c => u.permission[c.id] = 255))
      else
        u.groups.forEach(id => this.dict.groups[id].cheJian.forEach(c =>
          u.permission[c.id] = u.permission[c.id] === undefined ? c.permission : u.permission[c.id] | c.permission))
      this.dict.user[u.id] = u
    }
  },
  mutations: {
    auth(state, {data, id, url}) {
      let dict = {groups: {}, danWei: {}, cheJian: {}, banZu: {}, user: {}}
      state.dict = dict
      data.groups.forEach(g => state.fixGroup(g))
      state.groups = data.groups
      data.users.filter(u => u.banZu == null).forEach(u => {
        u.danWei = u.cheJian = null
      })
      state.users = data.users
      //建立字典
      data.danWei.forEach(d => {
        state.fixDanWei(d)
        d.cheJian.forEach(c => {
          state.fixCheJian(c)
          c.banZu.forEach(b => {
            state.fixBanZu(b, c)
            b.user = b.user.map(id => {
              return state.users.find(u => {
                return u.id == id
              })
            })
            b.user.forEach(u => {
              u.danWei = d.id
              u.cheJian = c.id
              u.banZu = b.id
            })
          })
        })
      })
      let cs = [], bs = []
      data.danWei.forEach(d => d.cheJian.forEach(c => {
        cs.push(c)
        c.banZu.forEach(b => bs.push(b))
      }))
      data.std.cheJian = cs
      data.std.banZu = bs
      state.danWei = data.danWei
      data.users.forEach(u => state.fixUser(u))
      dict.cheZhong = {}
      data.std.cheZhong.forEach(d => dict.cheZhong[d.id] = d)
      dict.dengJi = {}
      dengJi.forEach(d => dict.dengJi[d.id] = d)
      dict.peiJian = {}
      dict.xingHao = {}
      data.std.xingHao = []
      data.std.peiJian.forEach(p => {
        dict.peiJian[p.id] = p
        p.xingHao.forEach(x => {
          data.std.xingHao.push(x)
          dict.xingHao[x.id] = x
        })
      })
      let t = []
      data.std.daBuWei = daBuWei
      data.std.daBuWei.forEach(d => d.guZhang.forEach(g => t.push(g)))
      data.std.dengJi = dengJi
      data.std.guZhang = t
      dict.guZhang = {}
      data.std.daBuWei.forEach(d => d.guZhang.forEach(g => {
        dict.guZhang[g.id] = g
        g.daBuWei = d.id
      }))
      state.std = data.std
      data.jiaoJian.forEach(g => state.fixJiaoJian(g))
      state.jiaoJian = data.jiaoJian
      data.jiaoJianChuLi.forEach(c => state.fixJiaoJian(c))
      state.jiaoJianChuLi = data.jiaoJianChuLi
      data.ruKuFuJian.forEach(r => state.fixRuKuFuJian(r))
      state.ruKuFuJian = data.ruKuFuJian
      data.pingJia.forEach(p => state.fixPingJia(p))
      state.pingJia = data.pingJia

      state.user = data.users.find(u => u.id == id)
      state.user.url = `#/user/${state.user.id}`
      if(!state.routes) {
        state.routes = true
        router.addRoutes(routes)
      }
      let r = router.currentRoute.name
      if(url && url != '/')
        router.replace(url)
      else if(!r || ['home', 'login', 'register', 'reset'].includes(r))
        router.replace('/jiaoJian')
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