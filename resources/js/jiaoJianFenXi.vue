<style>
.time-tbl th.odd {background-color: lightyellow !important}
.time-tbl td.odd {background-color: #eee !important}
.time-tbl tr:nth-of-type(even) td.odd {background-color: lightcyan !important}
</style>
<script>
import axios from 'axios';
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Tabs from './components/Tabs'
import Popup from './components/Popup'
import Mission from './Mission'
import {stateColor, chuLiStates, daBuWei} from './global'

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
    caption: '车型',
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
            let _this = this.tbl ? this : this.$parent
            _this.mission = this.$parent.$store.state.jiaoJianChuLi.find(g => g.id == r.id)
          }
        }},
        chuLiStates.find(s => s.id == t).name
      )
    }
  },
  danWei: {
    caption: '单位',
    itemName: 'cheJian',
    items: null
  },
  cheJian: {
    caption: '作业场',
    master: ['danWei']
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
          let th = [[h('th', {attrs: {rowspan: 2}}, '单位'), h('th', {attrs: {rowspan: 2}}, '作业场')], []],
            a = [{attrs: {colspan: 3, width: '12.5%'}}], b = [{}], d = [...dbw, {name: '总计'}], r
          a[1] = {...a[0], class: 'odd'}
          b[1] = {class: 'odd'}
          d.forEach((d, i) => {
            th[0].push(h('th', a[i %= 2], d.name))
            th[1].push(h('th', b[i], 'A'), h('th', b[i], 'B'), h('th', b[i], 'C'))
          })
          return h('div', {class: 'dt-out', slot: i, key: i}, [
            h('table', {class: 'datable dt-head time-tbl'}, [
              h('caption', t.caption),
              h('thead', th.map(r => h('tr', r))),
              h('tbody', t.data.length ? t.data.map(d => {
                let t, r = h('tr', t = d.data.map((d, i) => {
                  let c = b[i > 1 && !(Math.floor((i - 2) / 3) % 2) ? 1 : 0]
                  return h('td', d ? {...c} : c, d)
                }))
                if(d.detail.length) {
                  t[1].data = {class: 'url', on: {
                    click: () => this.tblPopCheJian.data = d.detail}
                  }
                  dbw.forEach((p, i) => {
                    for(let l = 1, j; l < 4; l++) {
                      j = i * 3 + l - 2
                      if(d.data[j]) {
                        t[j].data.class = (t[j].data.class || '') + ' url'
                        t[j].data.on = {
                          click: () => this.tblPopCheJian.data = d.detail.filter(d => d.daBuWei == i && d.dengJi == l)
                        }
                      }
                    }
                  })
                  for(let l = 1; l < 4; l++) {
                    let i = dbw.length * 3 - 2 + l
                    if(d.data[i]) {
                      t[i].data.class = (t[i].data.class || '') + ' url'
                      t[i].data.on = {
                        click: () => this.tblPopCheJian.data = d.detail.filter(d => d.dengJi == l)
                      }
                    }
                  }
                }
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
            change: e => this.to = e.target.value
          }}),
        ]),
        h('div', {class: 'group'}, ['单位 ',
          h('select', {domProps: {value: this.danWei}, on: {
            change: e => this.danWei = parseInt(e.target.value)
          }}, this.danWeis.map((d, i) => h('option', {attrs: {value: d.id}, key: i}, d.name)))
        ]),
        h('div', {class: 'group'}, ['作业场 ',
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
      h('popup', {props: {popup: this.tblPopCheJian.data.length}, on: {
        close: () => this.tblPopCheJian.data = []
      }}, [h('datable', {props: {table: this.tblPopCheJian}}, [h('div', {class: 'dt-info'}, `共${this.tblPopCheJian.data.length}条记录`)])]),
      h('popup', {props: {popup: this.mission}, on: {
        close: () => this.mission = null
      }}, [h('mission', {props: {mission: this.mission}})])
    ])
  },
  data() {
    let d = this.$store.state.danWei
    return {
      from: (new Date).toDate().substr(0, 7),
      to: (new Date).toDate().substr(0, 7),
      danWei: d.length && d[0].id,
      cheJian: d.length && d[0].cheJian.length && d[0].cheJian[0].id,
      tabIndex: 0,
      mission: null,
      tabs: [
        '详情',
        {
          caption: '按月份',
          flex: true
        }, {
          caption: '按作业场',
          flex: true
        }
      ],
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
        caption: '交检故障详细列表',
        columns,
        data: []
      }
    }
  },
  computed: {
    ...mapState(['std', 'dict']),
    danWeis() {
      let d = this.$store.state.danWei, r = d.length == 1 ? [] : [{id: 0, name: '全部', cheJian: [{id: 0, name: '全部'}]}]
      this.$store.state.danWei.forEach(d => r.push(d))
      return r
    },
    curDanWei() {
      let r = [], t
      if(t = this.danWeis.find(d => d.id == this.danWei)) {
        if(t.id) {
          if(t.cheJian.length > 1)
            r.push({id: 0, name: '全部'})
          t.cheJian.forEach(c => r.push(c))
          return {id: t.id, name: t.name, cheJian: r}
        } else {
          this.cheJian = 0
          return t
        }
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    query() {
      if(this.from > this.to)
        [this.from, this.to] = [this.to, this.from]
      let q = {from: this.from, to: this.to}
      if(this.danWei)
        q.danWei = this.danWei
      if(this.cheJian)
        q.cheJian = this.cheJian
      this.loading(true)
      axios.post('api/jiaoJian/query', q).then(res => {
        this.loading(false)
        res.data.forEach(g => this.$store.state.fixJiaoJian(g))
        this.tbl.data = res.data
        //各单位, 按月份总计
        let ds, dtss = []
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
            caption: `${t} 各作业场交检分析`,
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
            let dts = {data: [d.name, c.name, ...Array(dbw.length * 3)], detail: []},
              tb = [], dj = {1: 0, 2: 0, 3: 0}, j, k, v, p = 0, sum = ['总计', 0, 0, 0, 0, 0, 0, 0]
            ms.forEach((t, i) => {
              //dt: 时间 行数据
              let dt = {data: [d.name, c.name, ...Array(dbw.length * 3)], detail: []}, r = [], a, b
              this.tblTime[i].data.push(dt)
              if(m = c.jiaoJian.count.find(m => m.month == t)) {
                //gs: 故障, ts: 故障车, pc: 合格数
                let gs = c.jiaoJian.items.filter(g => g.date.substr(0, 7) == m.month), ts = [], pc = 0, l = dbw.length * 3 - 1
                dbw.forEach(d => d.dj = {1: 0, 2: 0, 3: 0})
                gs.forEach(g => {
                  //时间
                  dbw[g.daBuWei].dj[g.dengJi]++
                  dt.detail.push(g)
                  dts.detail.push(g)
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
                  if(v = d.dj[1]) {
                    dt.data[j = i * 3 - 1] = v
                    dt.data[l] = (dt.data[l] || 0) + v
                    dts.data[j] = (dts.data[j] || 0) + v
                    dts.data[l] = (dts.data[l] || 0) + v
                  }
                  if(v = d.dj[2]) {
                    dt.data[j = i * 3] = v
                    dt.data[k = l + 1] = (dt.data[k] || 0) + v
                    dts.data[j] = (dts.data[j] || 0) + v
                    dts.data[k] = (dts.data[k] || 0) + v
                  }
                  if(v = d.dj[3]) {
                    dt.data[j = i * 3 + 1] = v
                    dt.data[k = l + 2] = (dt.data[k] || 0) + v
                    dts.data[j] = (dts.data[j] || 0) + v
                    dts.data[k] = (dts.data[k] || 0) + v
                  }
                })
                ts.forEach(t => t.g < 6 && pc++)
                r.push(t, m.count, m.count - ts.length + pc)
                for(k in dj)
                  r.push(dj[k])
                a = m.count - ts.length + pc
                b = ts.length - pc
                r.push(Math.round(a * 100 / m.count) + '%', Math.round(b * 100 / m.count) + '%')
                for(j = 1; j < 6; j++)
                  sum[j] += r[j]
                sum[6] += a
                sum[7] += b
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
            dtss.push(dts)
            if(sum[1]) {
              sum[6] = Math.round(sum[6] * 100 / sum[1]) + '%'
              sum[7] = Math.round(sum[7] * 100 / sum[1]) + '%'
            } else
              for(j = 1; j < sum.length; j++)
                sum[j] = null
            tb.push(sum)
            this.tblCheJian.push({
              caption: `${d.name}${c.name}交检分析`,
              columns: colCheJian,
              sortable: false,
              data: tb
            })
          })
        })
        //按月份 总计
        if(this.from != this.to) {
          this.tabTime.unshift('总计')
          this.tblTime.unshift({
            caption: `${this.from} - ${this.to} 各作业场交检分析`,
            data: dtss
          })
        }
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
    let d, s = this.$store.state
    if(d = s.danWei.length && s.danWei[0])
      this.danWei = d.id
    this.std.daBuWei.forEach(d => dbw[d.id] = {name: d.name})
    dbw.pop()
    for(let k in columns)
      if(this.std[k])
        columns[k].items = this.std[k]
    columns.danWei.items = s.danWei
    columns.user.items = s.users

    window.gz = this
  }
}
</script>
