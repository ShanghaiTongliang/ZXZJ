<style>
.mission-print {
  width: 30em;
  font-size: 1.5em;
  background-color: white;
  margin: .2em auto;
  padding: 3em;
}
.mission-print table {
  width: 100%;
  height: 26em;
  border-spacing: 0;
  text-align: center;
  margin-bottom: .5em;
}
.mission-print caption {
  font-weight: bold;
  font-size: 1.5em;
  margin-bottom: .5em;
  position: relative;
}
.mission-print th {font-weight: normal}
.mission-print td {border: solid 1px black}
.mission-print .remark {
  text-align: left;
  font-size: .9em;
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
  props: ['mission'],
  render(h) {
    if(this.mission) {
      let g = this.mission
      return h('div', {class: 'mission-print'}, [h('div', [h('table', [
        h('caption', '货车检修质量不合格通知书'),
        h('thead', [h('tr', [
          h('th', {attrs: {colspan: 4, width: '58%'}}, `质检部门 ${this.dict.danWei[g.danWei].name} ${this.dict.cheJian[g.cheJian].name}`),
          h('th', '第 19-01-01号')
        ])]),
        h('tbody', [
          h('tr', [h('td', {attrs: {colspan: 2, width: '20%', height: '12%'}}, '车型车号'), h('td', {attrs: {width: '30%'}}, `${this.dict.cheXing[g.cheXing].name} ${g.cheHao}`), h('td', {attrs: {rowspan: 2}}, [h('div', {class: 'vertical'}, '移 交')]), h('td', g.xiaFaShiJian && g.xiaFaShiJian.substr(0, 16))]),
          h('tr', [h('td', {attrs: {colspan: 2, height: '12%'}}, '修 程'), h('td', this.dict.xiuCheng[g.xiuCheng].name), h('td', `${this.dict.danWei[g.danWei].name} ${this.dict.cheJian[g.cheJian].name}`)]),
          h('tr', [h('td', {attrs: {colspan: 5, height: '12%'}, style: 'text-align: left; padding-left: .5em'}, '不合格品描述:')]),
          h('tr', [h('td', {attrs: {colspan: 5}}, [h('div', `${this.std.daBuWei[g.daBuWei].name} ${this.std.guZhang[g.guZhang].name}`)])]),
          h('tr', [h('td', {attrs: {rowspan: 3, width: '8%'}}, [h('div', {class: 'vertical'}, '问题处置')]),
            h('td', {attrs: {colspan: 2, height: '12%'}}, g.chuLi), h('td', {attrs: {rowspan: 3}}, [h('div', {class: 'vertical'}, '复查复检')]),
            h('td', g.state >= rejected ? sState[g.state] : null
            )
          ]),
          h('tr', [h('td', {attrs: {colspan: 2, height: '12%'}}, g.chuLiShiJian && g.chuLiShiJian.substr(0, 16)), h('td', g.fuJianShiJian && g.fuJianShiJian.substr(0, 16))]),
          h('tr', [h('td', {attrs: {colspan: 2, height: '12%'}}, `移交负责人: ${this.getUser(g.xiaFaRen)}`), h('td', `质检员: ${this.getUser(g.chuLiRen)}`)])
        ])]),
        h('div', {class: 'remark'}, [
          h('div', {style: 'min-height: 4em'}, `延滞不修原因: ${g.yanZhiYuanYin || ''}`),
          '说明: 1. 质检人员执行竣工检修时发现有不符合修理规程技术条件时填写本《货车检修质量不合格通知书》。', h('div', {style: 'margin-left: 2.5em'}, '2. 本表由质检员编制两份，一份自存一份交检修车间。')
        ])
      ])])
    }
  },
  computed: {
    ...mapState(['std', 'dict', 'users']),
  },
  methods: {
    getUser(id) {
      let r = id && this.users.find(u => u.id == id)
      return r ? r.name : '已删除'
    }
  },
  created() {
    document.body.style = 'height: auto'
  }
}
</script>
