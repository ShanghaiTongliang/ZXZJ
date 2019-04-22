import Vue from 'vue'
import Vuex from 'vuex'
import router from './router'
import routes from './routes'
import {daBuWei, dengJi, peiJianLeiBie} from './global'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    users: null, user: null, groups: null, danWei: null, std: null, jiaoJian: null, jiaoJianChuLi: null, ruKuFuJian: null, zhiJianYuan: null, dict: null,
    vertical: false, options: null, loading: false, message: null, error: false,

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
    fixFile(f, t) {
      f.url = `zhiJianYuan/${t}/${f.name}`
    },
    fixDianWen(d) {
      d.url = `#/zhiJianYuan/dianWen/${d.id}`
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
      c.url = `#/danWei/${c.danWei}/cheJian/${c.id}/user`
      this.dict.cheJian[c.id] = c
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
      let dict = {groups: {}, danWei: {}, cheJian: {}, user: {}}
      state.dict = dict
      data.groups.forEach(g => state.fixGroup(g))
      state.groups = data.groups
      state.users = data.users
      //建立字典
      data.danWei.forEach(d => {
        state.fixDanWei(d)
        d.cheJian.forEach(c => {
          c.danWei = d.id
          state.fixCheJian(c)
          c.user = c.user.map(id => {
            return state.users.find(u => {
              return u.id == id
            })
          })
        })
      })
      let cs = []
      data.danWei.forEach(d => d.cheJian.forEach(c => cs.push(c)))
      data.std.cheJian = cs
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
      dict.leiBie = {}
      peiJianLeiBie.forEach(l => dict.leiBie[l.id] = l)
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
      data.zhiJianYuan.dianWen.forEach(d => state.fixDianWen(d))
      data.zhiJianYuan.zhiDaoShu.forEach(f => state.fixFile(f, 'zhiDaoShu'))
      data.zhiJianYuan.ziLiao.forEach(f => state.fixFile(f, 'ziLiao'))
      state.zhiJianYuan = data.zhiJianYuan

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
    },
    width(state, w) {
      state.options.frame.width = w
      localStorage.setItem('options', JSON.stringify(state.options))
    },
    toggle(state, v) {
      state.options.frame.visible = v
      localStorage.setItem('options', JSON.stringify(state.options))
    }
  }
})