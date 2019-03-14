<style>
.report {margin-bottom: 1em}
.report table {margin-bottom: .5em}
</style>
<template>
  <div>
    <div v-for="(g, i) in $store.state.jiaoJianChuLi" :key="i" class="report">
      <table class="datable">
        <caption>货车检修质量不合格通知书</caption>
        <tbody>
          <tr><td>状态</td><td>{{sState[g.state]}}</td><td>下发人</td><td>{{getUser(g.xiaFaRen)}}</td><td colspan="2">{{$store.state.dict.cheJian[g.cheJian].name}}</td></tr>
          <tr><td>车号</td><td>{{g.cheHao}}</td><td>修程</td><td>{{std.xiuCheng[g.xiuCheng].name}}</td><td>下发时间</td><td>{{g.xiaFaShiJian.substr(0, 16)}}</td></tr>
          <tr><td>故障</td><td colspan="5">{{`${std.daBuWei[g.daBuWei].name} ${std.guZhang[g.guZhang].name}`}}</td></tr>
          <tr><td>处理方式</td><td v-if="report == g && stage == checking && g.state != resolved"><label v-for="(v, k) in sChuLi" :key="k"><input type="radio" :value="k" v-model="chuLi">{{v}}</label></td>
          <td v-else>{{sChuLi[g.chuLi]}}</td><td>处理人</td><td>{{getUser(g.chuLiRen)}}</td><td>处理时间</td><td>{{g.chuLiShiJian}}</td></tr>
          <tr><td>复检结果</td><td v-if="report == g && stage == reviewing && (g.state == checkedin || g.state == rejected)"><label v-for="k in [rejected, resolved]" :key="k"><input type="radio" :value="k" v-model="fuJian">{{sState[k]}}</label></td><td v-else>{{g.state >= rejected ? sState[g.state] : null}}</td><td>复检人</td><td>{{getUser(g.fuJianRen)}}</td><td>复检时间</td><td>{{g.fuJianShiJian}}</td></tr>
        </tbody>
      </table>
      <button v-if="editable(g)" @click="edit(g)">{{report == g ? '保存' : '处理'}}</button>
      <button v-if="report == g" @click="report = null">取消</button>
    </div>
  </div>
</template>
<script>
import axios from 'axios'
import {mapState, mapMutations} from 'vuex';
import {PERMISSION_DATA, PERMISSION_MANAGE, PERMISSION_REPAIR, dispatched, checkedin, rejected, resolved, chuLiStates} from './global'

const sChuLi = ['返工', '报废'], sState = []
//处理中, 复检中
const checking = 1, reviewing = 2

for(let s of chuLiStates)
  sState[s.id] = s.name

export default {
  data() {
    return {
      sChuLi, sState, dispatched, checkedin, rejected, resolved,
      checking, reviewing,
      stage: 0,
      report: null,
      chuLi: null,
      fuJian: null
    }
  },
  computed: {
    std() {
      return this.$store.state.std
    },
    user() {
      return this.$store.state.user
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    getStage(g) {
      let c, d = this.$store.state.dict.groups
      for(let id of this.user.groups)
        if(c = d[id].cheJian.find(c => c.id == g.cheJian)) {
          this.stage = c.permission & PERMISSION_REPAIR ? checking : c.permission & PERMISSION_DATA && reviewing
          return this.stage
        }
    },
    editable(gz) {
      if(gz.state == resolved)
        return false
      let d = this.$store.state.dict.groups, s = this.getStage(gz)
      return s == checking && gz.state != resolved || s == reviewing && (gz.state == checkedin || gz.state == rejected)
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
