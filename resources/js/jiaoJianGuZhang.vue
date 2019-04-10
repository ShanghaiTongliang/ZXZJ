<script>
import axios from 'axios';
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Tabs from './components/Tabs'
import Popup from './components/Popup'
import Mission from './Mission'
import {stateColor, chuLiStates} from './global'

const lv = {1: 6, 2: 3, 3: 1}, num = ['一', '二', '三', '四'],
colCheJian = [{
  caption: '时间',
}, '交检总数', '一次合格数', 'A类故障', 'B类故障', 'C类故障', '一次合格率', '故障率'],
columns = {
  date: {
    caption: '日期',
    filter(t) {
      return t && t.substr(2)
    }
  },
  cheHao: '车号',
  xiuCheng: {
    caption: '修程',
    items: null
  },
  cheZhong: {
    caption: '车种',
    items: null
  },
  daBuWei: {
    caption: '大部位',
    items: null
  },
  guZhang: {
    caption: '故障',
    items: null
  },
  dengJi: {
    caption: '等级',
    items: null
  },
  state: {
    caption: '状态',
    render(h, r, j) {
      let t = r[j]
      return t && h('span',
        {class: `${stateColor[r[j]]} url`, on: {
          click: () => {
            this.$parent.mission = this.$parent.$store.state.jiaoJianChuLi.find(g => g.id == r.id)
          }
        }},
        chuLiStates.find(s => s.id == t).name
      )
    }
  },
  danWei: {
    caption: '单位',
    items: null
  },
  cheJian: {
    caption: '车间',
    items: null
  },
  banZu: {
    caption: '班组',
    items: null
  },
  user: {
    caption: '质检员',
    items: null
  }
}
let dbw = []

export default {
  components: {Datable, Tabs, Popup, Mission},
  render(h) {
    let r = [
      h('datable', {props: {table: this.tbl}, slot: 0},
        [h('span', {class: 'dt-info'}, `${this.tbl.data.length}条记录`)]),
      this.tabTime.length && h('tabs', {props: {tabs: this.tabTime, tabIndex: this.tiTime}, on: {
          tabIndex: i => this.timeTabIndex(i)
        }, slot: 1},
        this.tblTime.map((t, i) => {
          let th = [[h('th', {attrs: {rowspan: 2}}, '单位'), h('th', {attrs: {rowspan: 2}}, '车间')], []], r, a = {attrs: {colspan: 3, width: '12.5%'}}
          dbw.forEach(d => {
            th[0].push(h('th', a, d.name))
            th[1].push(h('th', 'A'), h('th', 'B'), h('th', 'C'))
          })
          th[0].push(h('th', a, '总计'))
          th[1].push(h('th', 'A'), h('th', 'B'), h('th', 'C'))
          return h('div', {class: 'dt-out', slot: i, key: i}, [
            h('table', {class: 'datable dt-head time-tbl'}, [
              h('caption', t.caption),
              h('thead', th.map(r => h('tr', r))),
              h('tbody', t.data.length ? t.data.map(d => {
                let t, r = h('tr', t = d.data.map(d => h('td', d)))
                if(d.detail.length)
                  t[1].data = {class: 'url', on: {click: () => this.tblPopCheJian.data = d.detail}}
                return r
              }) : [h('tr', [h('td', {attrs: {colspan: dbw.length * 3 + 2}}, '无数据')])])
            ])
          ])
        })
      ),
      this.tabCheJian.length && h('tabs', {props: {tabs: this.tabCheJian, tabIndex: this.tiCheJian}, on: {
          tabIndex: i => this.cheJianTabIndex(i)
        }, slot: 2},
        this.tblCheJian.map((t, i) => h('datable', {props: {table: t}, ref: `tblCheJian${i}`, slot: i, key: i}))
      )
    ]
    return h('div' , {style: {display: 'flex', flexDirection: 'column', position: 'relative'}}, [
      h('div', {style: {flexShrink: 0}}, [
        h('div', {class: 'group'}, ['从 ',
          h('input', {attrs: {type: 'month'}, domProps: {value: this.from}, on: {
            change: e => this.from = e.target.value
          }}), ' 到 ',
          h('input', {attrs: {type: 'month'}, domProps: {value: this.to}, on: {
            change: e => this.from = e.target.value
          }}),
        ]),
        h('div', {class: 'group'}, ['单位 ',
          h('select', {domProps: {value: this.danWei}, on: {
            change: e => this.danWei = parseInt(e.target.value)
          }}, this.danWeis.map((d, i) => h('option', {attrs: {value: d.id}, key: i}, d.name)))
        ]),
        h('div', {class: 'group'}, ['车间 ',
          h('select', {domProps: {value: this.cheJian}, on: {
            change: e => this.cheJian = parseInt(e.target.value)
          }}, this.curDanWei.cheJian.map((d, i) => h('option', {attrs: {value: d.id}, key: i}, d.name)))
        ]),
        h('button', {on: {
          click: this.query
        }}, '查询')
      ]),
      h('tabs', {props: {tabs: this.tabs, tabIndex: this.tabIndex, grow: true}, on:  {
        tabIndex: this.onTabIndex,
        pageShow: this.pageShow
      }}, r),
      h('popup', {props: {popup: this.mission}, on: {
        close: () => this.mission = null
      }}, [h('mission', {props: {mission: this.mission}})]),
      h('popup', {props: {popup: this.tblPopCheJian.data.length, caption: '交检故障详细列表'}, on: {
        close: () => this.tblPopCheJian.data = []
      }}, [h('datable', {props: {table: this.tblPopCheJian}})])
    ])
  },
  data() {
    return {
      from: (new Date).toDate().substr(0, 7),
      to: (new Date).toDate().substr(0, 7),
      danWei: this.$store.state.danWei[0].id,
      cheJian: 0,
      banZu: 0,
      tabIndex: 0,
      mission: null,
      tabs: [{
        caption: '详情',
        flex: true
      }, {
        caption: '时间',
        flex: true
      }, {
        caption: '车间',
        flex: true
      }],
      tabTime: [],
      tiTime: 0,
      tabCheJian: [],
      tiCheJian: 0,
      tbl: {
        caption: '交检故障查询结果',
        columns,
        data: []
      },
      tblTime: null,
      tblCheJian: null,
      tblPopCheJian: {
        columns,
        data: []
      }
    }
  },
  computed: {
    ...mapState(['std', 'dict']),
    danWeis() {
      let r = [{id: 0, name: '全部', cheJian: [{id: 0, name: '全部'}]}]
      this.$store.state.danWei.forEach(d => r.push(d))
      return r
    },
    curDanWei() {
      let r = [{id: 0, name: '全部', banZu: [{id: 0, name: '全部'}]}], t
      if(t = this.danWeis.find(d => d.id == this.danWei)) {
        if(t.id) {
          t.cheJian.forEach(c => r.push(c))
          return {id: t.id, name: t.name, cheJian: r}
        } else {
          this.cheJian = 0
          return t
        }
      }
    },
    /*curCheJian() {
      let r = [{id: 0, name: '全部'}], t
      if(t = this.curDanWei && this.curDanWei.cheJian.find(c => c.id == this.cheJian))
        if(t.id) {
          t.banZu.forEach(b => r.push(b))
          return {id: t.id, name: t.name, banZu: r}
        } else {
          this.banZu = 0
          return t
        }
    },
    curBanZu() {
      return this.curCheJian && this.curCheJian.banZu.find(b => b.id == this.banZu)
    },*/
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    query() {
      if(this.from > this.to)
        this.from = this.to
      let q = {from: this.from, to: this.to}
      if(this.danWei)
        q.danWei = this.danWei
      if(this.cheJian)
        q.cheJian = this.cheJian
      if(this.banZu)
        q.banZu = this.banZu
      this.loading(true)
      axios.post('api/jiaoJian/query', q).then(res => {
        this.loading(false)
        res.data.forEach(g => this.$store.state.fixJiaoJian(g))
        this.tbl.data = res.data
        let ds
        if(this.danWei == 0)
          ds = this.$store.state.danWei.map(d => ({...d}))
        else {
          let d = {...this.dict.danWei[this.danWei]}
          if(this.cheJian != 0)
            d.cheJian = [this.dict.cheJian[this.cheJian]]
          ds = [d]
        }
        this.tabTime = []
        this.tblTime = []
        let ms = [], m = new Date(this.from), y = 1900 + m.getYear(), mb = m.getMonth(), i = mb, t
        while((t = (new Date(y, i++)).toDate().substr(0, 7)) <= this.to) {
          ms.push(t)
          this.tabTime.push(t)
          this.tblTime.push({
            caption: `${t} 各车间交检分析`,
            data: []
          })
        }
        this.tabCheJian = []
        this.tblCheJian = []
        ds.forEach(d => {
          d.cheJian = d.cheJian.map(c => {
            let r = {...c}
            r.jiaoJian = {
              count: r.jiaoJian,
              items: res.data.filter(g => g.cheJian == c.id)
            }
            return r
          })
          d.cheJian.forEach(c => {
            this.tabCheJian.push({
              caption: c.name,
              flex: true
            })
            let tb = [], dj = {1: 0, 2: 0, 3: 0}, j, p = 0
            ms.forEach((t, i) => {
              //dt: 时间 行数据
              let dt = {data: [d.name, c.name, ...Array(dbw.length * 3)], detail: []}, r = []
              this.tblTime[i].data.push(dt)
              if(m = c.jiaoJian.count.find(m => m.month == t)) {
                //gs: 故障, ts: 故障车, pc: 合格数
                let gs = c.jiaoJian.items.filter(g => g.date.substr(0, 7) == m.month), ts = [], pc = 0, l = dbw.length * 3 - 1
                dbw.forEach(d => d.dj = {1: 0, 2: 0, 3: 0})
                gs.forEach(g => {
                  //时间
                  dbw[g.daBuWei].dj[g.dengJi]++
                  dt.detail.push(g)
                  //归并相同车号
                  let t = ts.find(v => v.date == g.date && v.cheHao.toUpperCase() == g.cheHao.toUpperCase())
                  if(!t) {
                    t = {date: g.date, cheHao: g.cheHao, g: 0}
                    ts.push(t)
                  }
                  t.g += lv[g.dengJi]
                  dj[g.dengJi]++
                })
                dbw.forEach((d, i) => {
                  if(d.dj[1]) {
                    dt.data[i * 3 - 1] = d.dj[1]
                    dt.data[l] = (dt.data[l] || 0) + d.dj[1]
                  }
                  if(d.dj[2]) {
                    dt.data[i * 3] = d.dj[2]
                    dt.data[l + 1] = (dt.data[l + 1] || 0) + d.dj[2]
                  }
                  if(d.dj[3]) {
                    dt.data[i * 3 + 1] = d.dj[3]
                    dt.data[l + 2] = (dt.data[l + 2] || 0) + d.dj[3]
                  }
                })

                ts.forEach(t => t.g < 6 && pc++)
                r.push(t, m.count, m.count - ts.length + pc)
                for(let k in dj)
                  r.push(dj[k])
                r.push(Math.round((m.count - ts.length + pc) * 100 / m.count) + '%', Math.round((ts.length - pc) * 100 / m.count) + '%')
              } else
                r.push(t)
              i += mb
              if((i + 1) % 3 == 0) {
                tb.push(r)
                i = Math.floor(i / 3)
                r = [`第${num[i % 4]}季度`]
                while(p < tb.length) {
                  if(tb[p][1] !== undefined) {
                    if(r[1] === undefined)
                      r.push(0, 0, 0, 0, 0, 0, 0)
                    for(j = 1; j < 6; j++)
                      r[j] += tb[p][j]
                    r[6] = Math.round(r[2] * 100 / r[1]) + '%'
                    r[7] = Math.round((r[1] - r[2]) * 100 / r[1]) + '%'
                  }
                  p++
                }
                p++
              }
              tb.push(r)
            })
            this.tblCheJian.push({
              caption: `${d.name}${c.name}交检分析`,
              columns: colCheJian,
              sortable: false,
              data: tb
            })
          })
        })
        this.tabIndex = 0
        this.tiTime = 0
        this.tiCheJian = 0
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },
    onTabIndex(i) {
      this.tabIndex = i
    },
    pageShow(i) {
      if(i == 1) {
        if(this.tabTime.length)
          this.timeTabIndex(this.tiTime)
      } else if(i == 2 && this.tabCheJian.length)
        this.cheJianTabIndex(this.tiCheJian)
    },
    timeTabIndex(i) {
      this.tiTime = i
      //setTimeout(() => this.$refs[`tblTime${i}`].onScroll(), 0)
    },
    cheJianTabIndex(i) {
      this.tiCheJian = i
      setTimeout(() => this.$refs[`tblCheJian${i}`].onScroll(), 0)
    }
  },
  created() {
    let d
    if(d = this.$store.state.danWei.length && this.$store.state.danWei[0])
      this.danWei = d.id
    this.std.daBuWei.forEach(d => dbw[d.id] = {name: d.name})
    dbw.pop()
    for(let k in columns)
      if(this.std[k])
        columns[k].items = this.std[k]
    columns.danWei.items = this.$store.state.danWei
    columns.user.items = this.$store.state.users

    window.gz = this
  }
}
</script>
