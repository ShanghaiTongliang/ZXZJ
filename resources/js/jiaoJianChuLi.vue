<style>
.report {margin-bottom: 1em}
.report table {margin-bottom: .5em}
</style>
<script>
import axios from 'axios'
import {mapState, mapMutations} from 'vuex';
import Tabs from './components/Tabs'
import {PERMISSION_DATA, PERMISSION_MANAGE, PERMISSION_REPAIR, dispatched, checkedin, rejected, resolved, chuLiStates} from './global'

const sChuLi = ['返工', '报废'], sState = []
//处理中, 复检中
const checking = 1, reviewing = 2

for(let s of chuLiStates)
  sState[s.id] = s.name

export default {
  components: {Tabs},
  render(h) {
    return h('tabs', {props: {tabs: this.tabs}}, this.missions.map(
      (c, i) => h('div', {slot: i}, c.mission.map(
        g => {
          let f = g == this.report, bs = []
          if(this.editable(g))
            bs.push(h('button', {on: {
              click: e => this.edit(g)
            }}, f ? '保存' : '处理'))
          if(f)
            bs.push(h('button', {on: {
              click: e => this.report = null
            }}, '取消'))
          return h('div', {class: 'report'}, [h('table', {class: 'datable'}, [
            h('caption', ['货车检修质量不合格通知书', bs.length ? h('div', {class: 'act'}, bs): null]),
            h('tbody', [
              h('tr', [h('td', '状态'), h('td', sState[g.state]), h('td', '下发人'), h('td', this.getUser(g.xiaFaRen)), h('td', {attrs: {colspan: 2}}, this.dict.cheJian[g.cheJian].name)]),
              h('tr', [h('td', '车号'), h('td', g.cheHao), h('td', '修程'), h('td', this.std.xiuCheng[g.xiuCheng].name), h('td', '下发时间'), h('td', g.xiaFaShiJian.substr(0, 16))]),
              h('tr', [h('td', '故障'), h('td', {attrs: {colspan: 5}}, `${this.std.daBuWei[g.daBuWei].name} ${this.std.guZhang[g.guZhang].name}`)]),
              h('tr', [h('td', '处理方式'), h('td', f && this.stage == checking && g.state != resolved
                ? sChuLi.map((v, k) => h('label', {key: k}, [h('input', {attrs: {type: 'radio', value: k}, domProps: {checked: k == this.chuLi}, on: {
                  change: e => this.chuLi = e.target.value
                }}), v]))
                : sChuLi[g.chuLi]), h('td', '处理人'), h('td', this.getUser(g.chuLiRen)), h('td', '处理时间'), h('td', g.chuLiShiJian && g.chuLiShiJian.substr(0, 16))]),
              h('tr', [h('td', '复检结果'), h('td', f && this.stage == reviewing && (g.state == checkedin || g.state == rejected)
                ? [rejected, resolved].map((v, k) => h('label', {key: k}, [h('input', {attrs: {type: 'radio', value: v}, domProps: {checked: v == this.fuJian}, on: {
                  change: e => this.fuJian = e.target.value
                }}), sState[v]]))
                : g.state >= rejected ? sState[g.state] : null), h('td', '复检人'), h('td', this.getUser(g.fuJianRen)), h('td', '复检时间'), h('td', g.fuJianShiJian && g.fuJianShiJian.substr(0, 16))])
            ]),
          ])])
        }
      ))
    ))
  },
  data() {
    return {
      stage: 0,
      tabs: [],
      report: null,
      chuLi: null,
      fuJian: null
    }
  },
  computed: {
    ...mapState(['std', 'user', 'dict']),
    missions() {
      let r = [], cl = this.$store.state.jiaoJianChuLi, gs
      for(let id in this.user.permission) {
        if((gs = cl.filter(g => g.cheJian == id)).length) {
          r.push({id, mission: gs})
          this.tabs.push(this.dict.cheJian[id].name)
        }
      }
      return r
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    getStage(g) {
      let p = this.user.permission[g.cheJian]
      this.stage = p && PERMISSION_REPAIR ? checking : p & PERMISSION_DATA && reviewing
      return this.stage
    },
    editable(g) {
      if(g.state == resolved || this.report && this.report != g)
        return false
      let d = this.dict.groups, s = this.getStage(g)
      return s == checking && g.state != resolved || s == reviewing && (g.state == checkedin || g.state == rejected)
    },
    edit(g) {
      if(this.report == g) {
        const s = ['', '处理方式', '复检结果']
        if(this.chuLi === null) {
          this.error(`请选择${s[g.state]}`)
          return
        }
        this.report = null
        let t = (new Date).toDateTime().substr(0, 16)
        //签收
        if(this.stage == checking) {
          this.loading(true)
          let d = {state: checkedin, chuLi: this.chuLi, chuLiRen: this.user.id, chuLiShiJian: t}
          axios.put(`zxzj/api/jiaoJian/${g.id}/chuLi`, d).then(() => {
            this.$store.state.jiaoJian.find(v => v.id == g.id).state = d.state
            for(let k in d)
              g[k] = d[k]
            this.loading(false)
            this.message('保存成功')
          }).catch(r => {
            this.loading(false)
            this.error(r.response.data)
          })
        } else {  //复检
          this.loading(true)
          let d = {state: this.fuJian, fuJianRen: this.user.id, fuJianShiJian: t}
          axios.put(`zxzj/api/jiaoJian/${g.id}/chuLi`, d).then(() => {
            this.$store.state.jiaoJian.find(v => v.id == g.id).state = d.state
            for(let k in d)
              g[k] = d[k]
            this.loading(false)
            this.message('保存成功')
          }).catch(r => {
            this.loading(false)
            this.error(r.response.data)
          })
        }
      } else {
        this.report = g
        this.chuLi = g.chuLi
        this.fuJian = g.state
      }
    },
    getUser(id) {
      return id && this.$store.state.users.find(u => u.id == id).name
    }
  }
}
</script>
