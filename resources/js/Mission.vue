<style>
.mission {
  width: 50em;
  max-width: 100%;
  margin: 0 auto;
}
.mission>table {margin-bottom: .2em}
.mission-print input {
  font-size: 1em;
  min-height: 1.9em;
  box-sizing: border-box;
}
.mission-print input[type=text] {width: 100%}
.mission-print textarea {
  width: 100%;
  font-size: 1.5em;
}
</style>
<script>
import axios from 'axios'
import {mapState, mapMutations} from 'vuex'
import {PERMISSION_DATA, PERMISSION_MANAGE, PERMISSION_REPAIR, dispatched, checkedin, rejected, resolved, stateColor, chuLiStates} from './global'

const sState = [],
//处理中, 复检中
checking = 1, reviewing = 2
chuLiStates.forEach(c => sState[c.id] = c.name)

export default {
  props: ['mission', 'role', 'editing'], //role: 0: 无, 1: 检修, 2: 质检
  render(h) {
    if(this.mission) {
      let tbl, pnl, g = this.mission, f = this.editing, bs = []
      if(this.chuLiEditable(g))
        bs.push(h('button', {on: {
          click: () => this.edit(g)
        }}, f ? '保存' : '处理'))
      if(f)
        bs.push(' ', h('button', {on: {
          click: e => this.$emit('onEditing', false)
        }}, '取消'))
      else if(this.role == 2 && !g.chuLiRen)
        bs.push(' ', h('button', {on: {
          click: () => this.del(g)
        }}, '删除'))
      tbl = h('table', {class: 'datable'}, [
        h('caption', ['货车检修质量不合格通知书', !this.printing && h('button', {class: 'act', on: {
          click: () => open(`#/mission/${g.id}`)
        }}, '打印')]),
        h('tbody', [
          h('tr', [h('td', '状态'), h('td', sState[g.state]), h('td', '下发人'), h('td', this.getUser(g.xiaFaRen)), h('td', {attrs: {colspan: 2}}, this.dict.cheJian[g.cheJian].name)]),
          h('tr', [h('td', '车号'), h('td', g.cheHao), h('td', '修程'), h('td', this.dict.xiuCheng[g.xiuCheng].name), h('td', '下发时间'), h('td', g.xiaFaShiJian.substr(0, 16))]),
          h('tr', [h('td', '故障'), h('td', {attrs: {colspan: 5}}, `${this.dict.daBuWei[g.daBuWei].name} ${this.dict.guZhang[g.guZhang].name}`)]),
          h('tr', [h('td', '处理方式'),
            h('td', f && this.stage == checking && g.state != resolved ? [h('input', {domProps: {value: g.chuLi}, on: {
              input: e => this.chuLi = e.target.value
            }})] : g.chuLi),
            h('td', '处理人'), h('td', this.getUser(g.chuLiRen)),
            h('td', '处理时间'), h('td', g.chuLiShiJian && g.chuLiShiJian.substr(0, 16))]
          ),
          h('tr', [h('td', '复检结果'),
            h('td', f && this.stage == reviewing && (g.state == checkedin || g.state == rejected)
              ? [rejected, resolved].map((v, k) => h('label', {key: k}, [
                h('input', {attrs: {type: 'radio', value: v}, domProps: {checked: v == this.fuJian}, on: {
                  change: e => this.fuJian = parseInt(e.target.value)
                }}), sState[v]
              ]))
              : g.state >= rejected ? sState[g.state] : null),
            h('td', '复检人'), h('td', this.getUser(g.fuJianRen)),
            h('td', '复检时间'), h('td', g.fuJianShiJian && g.fuJianShiJian.substr(0, 16))]
          ),
          h('tr', [h('td', '延滞原因'), h('td', {attrs: {colspan: 5}}, f && this.stage == checking && g.state != resolved ? [h('input', {domProps: {value: g.yanZhiYuanYin}, on: {
            input: e => this.yanZhiYuanYin = e.target.value
          }})] : g.yanZhiYuanYin)])
        ])
      ])
      pnl = bs.length ? h('div', bs): null
      return h('div', {class: 'mission'}, [tbl, pnl])
    }
  },
  data() {
    return {
      stage: 0,
      chuLi: null,
      yanZhiYuanYin: null,
      fuJian: null
    }
  },
  computed: {
    ...mapState(['user', 'std', 'dict']),
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    getStage(g) {
      let p = this.user.permission[g.cheJian]
      this.stage = this.role == 1 && p & PERMISSION_REPAIR ? checking : this.role == 2 && p & PERMISSION_DATA && reviewing
      return this.stage
    },
    chuLiEditable(g) {
      if(g.state == resolved || !this.mission)
        return false
      let d = this.dict.groups, s = this.getStage(g)
      return s == checking && g.state != resolved || s == reviewing && (g.state == checkedin || g.state == rejected)
    },
    getUser(id) {
      let r = id && this.$store.state.users.find(u => u.id == id)
      return r && r.name
    },
    edit(g) {
      if(this.editing) {
        let t = (new Date).toDateTime().substr(0, 16)
        //签收
        if(this.stage == checking) {
          if(!this.chuLi) {
            this.error('请填写处理方式')
            return
          }
          this.$emit('onEditing', false)
          this.loading(true)
          let d = {state: checkedin, chuLi: this.chuLi, chuLiRen: this.user.id, chuLiShiJian: t, yanZhiYuanYin: this.yanZhiYuanYin}
          axios.put(`api/jiaoJian/${g.id}/chuLi`, d).then(() => {
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
          if(this.fuJian < rejected) {
            this.error('请选择复检结果')
            return
          }
          this.$emit('onEditing', false)
          this.loading(true)
          let d = {state: this.fuJian, fuJianRen: this.user.id, fuJianShiJian: t}
          axios.put(`api/jiaoJian/${g.id}/chuLi`, d).then(() => {
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
        this.$emit('onEditing', true)
        this.chuLi = g.chuLi
        this.yanZhiYuanYin = g.yanZhiYuanYin
        this.fuJian = g.state
      }
    },
    del(g) {
      if(confirm('确定要删除不合格通知书?')) {
        this.loading(true)
        axios.delete(`api/jiaojian/${g.id}/chuLi`).then(() => {
          this.loading(false)
          this.$emit('delete', g)
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    }
  }
}
</script>
