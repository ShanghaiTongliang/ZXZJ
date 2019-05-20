import axios from 'axios'
import Vue from 'vue'
import Vuex from 'vuex'
import router from './router'
import routes from './routes'
import merge from './components/merge'
import {dengJi, peiJianLeiBie, PERMISSION_DATA, PERMISSION_REPAIR, PERMISSION_VIEW, PERMISSION_MANAGE} from './global'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    users: null, user: null, groups: null, danWei: null, std: {daBuWei: null, guZhang: null}, options: null, state: null,
    jiaoJian: null, jiaoJianChuLi: null, ruKuFuJian: null, zhiJianYuan: null,
    dict: null, vertical: false, loading: false, progress: undefined, message: null, error: false,

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
      let gs = this.dict.groups, us = []
      d.url = `#/zhiJianYuan/dianWen/${d.id}`
      this.users.forEach(u => {
        if(u.groups.find(g => gs[g].cheJian.find(c => d.cheJian.includes(c.id) && c.permission & PERMISSION_DATA)))
          us.push(u.id)
      })
      d.users = us
      Vue.set(d, 'uncheck', us.filter(u => !d.checkin.find(v => v.user == u)))
      for(let id in this.user.permission) {
        id = parseInt(id)
        if(d.cheJian.includes(id) && this.user.permission[id] & PERMISSION_DATA && !this.user.groups.includes(255)) {
          Vue.set(d, 'state', d.checkin.find(u => u.user == this.user.id) ? 1 : 0)
          break
        }
      }
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
      this.dict.user[u.id] = u
    },
    fixPermission(u) {
      u.permission = {}
      u.data = []
      u.repair = []
      //u.view = []
      u.manage = []
      if(u.groups.includes(255)) {
        u.admin = true
        this.std.danWei.forEach(d0 => {
          let d = {...d0, cheJian: []}
          d0.cheJian.forEach(c => {
            u.permission[c.id] = 255
            d.cheJian.push(c)
          })
          u.data.push(d)
          u.repair.push(d)
          //u.view.push(d)
          u.manage.push(d)
        })
      } else {
        let d, cx = {data: [], repair: [], manage: []}, dx = {data: [], repair: [], manage: []}, dd = this.dict.danWei
        function addCheJian(c, t) {
          if(!(d = dx[t][c.danWei])) {
            d = {...dd[c.danWei], cheJian: []}
            dx[t][c.danWei] = d
            u[t].push(d)
          }
          if(!cx[t][c.id]) {
            cx[t][c.id] = 1
            d.cheJian.push(c)
          }
        }
        u.admin = false
        u.groups.forEach(id => this.dict.groups[id].cheJian.forEach(c => {
          u.permission[c.id] = u.permission[c.id] === undefined ? c.permission : u.permission[c.id] | c.permission
          let t = this.dict.cheJian[c.id]
          if(c.permission & (PERMISSION_DATA | PERMISSION_VIEW | PERMISSION_MANAGE))
            addCheJian(t, 'data')
          if(c.permission & (PERMISSION_REPAIR | PERMISSION_VIEW | PERMISSION_MANAGE))
            addCheJian(t, 'repair')
          //if(c.permission & PERMISSION_VIEW)
          //  addCheJian(t, 'view')
          if(c.permission & PERMISSION_MANAGE)
            addCheJian(t, 'manage')
        }))
      }
    }
  },
  mutations: {
    auth(state, {data, id, url}) {
      let dict = {groups: {}, danWei: {}, cheJian: {}, user: {}}, cs = [], u
      state.dict = dict
      data.groups.forEach(g => state.fixGroup(g))
      state.groups = data.groups
      state.users = data.users
      merge(state.options, data.options)
      //建立字典
      data.std.danWei.forEach(d => {
        state.fixDanWei(d)
        d.cheJian.forEach(c => {
          cs.push(c)
          c.danWei = d.id
          state.fixCheJian(c)
          c.user = c.user.map(id => state.users.find(u => u.id == id))
        })
      })
      state.std.danWei = data.std.danWei
      data.users.forEach(u => state.fixUser(u))
      dict.cheZhong = {}
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
      dict.guZhang = {}
      peiJianLeiBie.forEach(l => dict.leiBie[l.id] = l)
      let fixDaBuWei = d => {
        let t = []
        if(d)
          state.std.daBuWei = d
        state.std.daBuWei.forEach(d => d.guZhang.forEach(g => {
          dict.guZhang[g.id] = g
          g.daBuWei = d.id
          t.push(g)
        }))
        state.std.guZhang = t
        state.jiaoJian.forEach(g => state.fixJiaoJian(g))
        state.jiaoJianChuLi.forEach(c => state.fixJiaoJian(c))
      }, fixCheZhong = d => {
        if(d)
          state.std.cheZhong = d
        state.std.cheZhong.forEach(d => dict.cheZhong[d.id] = d)
      }
      state.jiaoJian = data.jiaoJian
      state.jiaoJianChuLi = data.jiaoJianChuLi
      if(data.state.guZhangTime > state.state.guZhangTime) {
        this.commit('loading', true)
        axios.get('api/standard/daBuWei').then(r => {
          this.commit('loading', false)
          fixDaBuWei(r.data)
          state.state.guZhangTime = data.state.guZhangTime
          localStorage.setItem('state', JSON.stringify(state.state))
          localStorage.setItem('daBuWei', JSON.stringify(r.data))
        }).catch(r => {
          this.commit('loading', false)
          this.commit('error', r.response.data)
        })
      } else
        fixDaBuWei()
      if(data.state.cheZhongTime > state.state.cheZhongTime) {
        this.commit('loading', true)
        axios.get('api/standard/cheZhong').then(r => {
          this.commit('loading', false)
          fixCheZhong(r.data)
          state.state.cheZhongTime = data.state.cheZhongTime
          localStorage.setItem('state', JSON.stringify(state.state))
          localStorage.setItem('cheZhong', JSON.stringify(r.data))
        }).catch(r => {
          this.commit('loading', false)
          this.commit('error', r.response.data)
        })
      } else
        fixCheZhong()
      data.std.dengJi = dengJi
      for(let k in data.std)
        Vue.set(state.std, k, data.std[k])

      data.ruKuFuJian.forEach(r => state.fixRuKuFuJian(r))
      state.ruKuFuJian = data.ruKuFuJian
      data.zhiJianYuan.zhiDaoShu.forEach(f => state.fixFile(f, 'zhiDaoShu'))
      data.zhiJianYuan.ziLiao.forEach(f => state.fixFile(f, 'ziLiao'))
      state.zhiJianYuan = data.zhiJianYuan

      u = data.users.find(u => u.id == id)
      u.url = `#/user/${u.id}`
      if(u.groups.includes(255))
        state.danWei = state.std.danWei
      else {
        let ds = [], dx = []
        cs = []
        u.groups.forEach(g => {
          dict.groups[g].cheJian.forEach(c => !cs[c.id] && (cs[c.id] = dict.cheJian[c.id]))
        })
        cs.forEach(c => {
          let d = dx[c.danWei], d0
          if(!d) {
            d = {...dict.danWei[c.danWei], cheJian: []}
            dx[c.danWei] = d
          }
          d.cheJian.push(c)
        })
        dx.forEach(d => ds.push(d))
        state.danWei = ds
      }
      state.user = u
      state.fixPermission(u)
      state.zhiJianYuan.dianWen.forEach(d => state.fixDianWen(d))

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
    progress(state, v) {
      state.loading = v === undefined ? false : true
      state.progress = v
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
      localStorage.setItem('options', JSON.stringify({frame: state.options.frame}))
    },
    toggle(state, v) {
      state.options.frame.visible = v
      localStorage.setItem('options', JSON.stringify({frame: state.options.frame}))
    }
  }
})