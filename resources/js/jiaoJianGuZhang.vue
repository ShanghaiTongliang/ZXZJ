<style>
.gz .datable td:first-child {white-space: nowrap}
</style>
<script>
import axios from 'axios';
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Tabs from './components/Tabs'

const lv = {1: 6, 2: 3, 3: 1},
colCheJian = ['时间', '交检总数', '一次合格数', 'A类故障', 'B类故障', 'C类故障', '一次合格率', '故障率']

export default {
  components: {Datable, Tabs},
  render(h) {
    let r = [
      h('datable', {props: {table: this.tbl}, slot: 0},
        [h('span', {class: 'dt-info'}, `${this.tbl.data.length}条记录`)]),
      this.tabTime.length && h('tabs', {props: {tabs: this.tabTime, tabIndex: this.tiTime}, on: {
          tabIndex: i => this.timeTabIndex(i)
        }, slot: 1},
        this.tblTime.map((t, i) => h('datable', {props: {table: t}, ref: `tblTime${i}`, slot: i, key: i}))
      ),
      this.tabCheJian.length && h('tabs', {props: {tabs: this.tabCheJian, tabIndex: this.tiCheJian}, on: {
          tabIndex: i => this.cheJianTabIndex(i)
        }, slot: 2},
        this.tblCheJian.map((t, i) => h('datable', {props: {table: t}, ref: `tblCheJian${i}`, slot: i, key: i}))
      )
    ]
    return h('div' , {style: {display: 'flex', flexDirection: 'column'}}, [
      h('div', {style: {flexShrink: 0}}, [
        h('div', {class: 'group'}, ['从 ',
          h('input', {ref: 'from', attrs: {type: 'month'}, domProps: {value: this.from}}), ' 到 ',
          h('input', {ref: 'to', attrs: {type: 'month'}, domProps: {value: this.to}}),
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
          click: () => {
            this.from = this.$refs.from.value
            this.to = this.$refs.to.value
            this.query()
          }
        }}, '查询')
      ]),
      h('tabs', {props: {tabs: this.tabs, tabIndex: this.tabIndex, grow: true}, class: 'gz', on:  {
        tabIndex: this.onTabIndex,
        pageShow: this.pageShow
      }}, r)
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
        caption: '交检故障分析',
        columns: {
          date: {
            caption: '日期',
            filter(t) {
              return t.substr(2)
            }
          },
          cheHao: '车号',
          xiuCheng: {
            caption: '修程',
            items: this.$store.state.std.xiuCheng
          },
          cheZhong: {
            caption: '车种',
            items: this.$store.state.std.cheZhong
          },
          daBuWei: {
            caption: '大部位',
            items: this.$store.state.std.daBuWei
          },
          guZhang: {
            caption: '故障',
            items: this.$store.state.std.guZhang
          },
          dengJi: {
            caption: '等级',
            items: this.$store.state.std.dengJi
          },
          danWei: {
            caption: '单位',
            items: this.$store.state.danWei
          },
          cheJian: {
            caption: '车间',
            items: this.$store.state.std.cheJian
          },
          banZu: {
            caption: '班组',
            items: this.$store.state.std.banZu
          },
          user: {
            caption: '质检员',
            items: this.$store.state.users
          }
        },
        data: []
      },
      tblTime: null,
      tblCheJian: null
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
      axios.post('zxzj/jiaoJian/query', q).then(res => {
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
        let ms = [], m = new Date(this.from), y = 1900 + m.getYear(), i = m.getMonth(), t, col = ['单位', '车间']
        this.std.daBuWei.forEach(d => {
          col.push(`${d.name} A`, 'B', 'C')
        })
        while((t = (new Date(y, i++)).toDate().substr(0, 7)) <= this.to) {
          ms.push(t)
          this.tabTime.push(t)
          this.tblTime.push({
            caption: `${t} 各车间交检分析`,
            columns: col,
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
            let tb = [], dj = {1: 0, 2: 0, 3: 0}
            ms.forEach((t, i) => {
              //if(i % 3 == 0)
              let r = [t]
              if(m = c.jiaoJian.count.find(m => m.month == t)) {
                //gs: 故障, ts: 故障车, pc: 合格数
                let gs = c.jiaoJian.items.filter(g => g.date.substr(0, 7) == m.month), ts = [], pc = 0
                gs.forEach(g => {
                  let t = ts.find(v => v.date == g.date && v.cheHao.toUpperCase() == g.cheHao.toUpperCase())
                  if(!t) {
                    t = {date: g.date, cheHao: g.cheHao, g: 0}
                    ts.push(t)
                  }
                  t.g += lv[g.dengJi]
                  dj[g.dengJi]++
                })
                ts.forEach(t => t.g < 6 && pc++)
                r.push(m.count, m.count - ts.length + pc)
                for(let k in dj)
                  r.push(dj[k])
                r.push(Math.round((m.count - ts.length + pc) * 100 / m.count) + '%', Math.round((ts.length - pc) * 100 / m.count) + '%')
              }
              tb.push(r)
            })
            this.tblCheJian.push({
              caption: `${d.name}${c.name}交检分析`,
              columns: colCheJian,
              data: tb
            })
          })
        })

        /*let r = [
          h('datable', {props: {table: this.tbl}, slot: 0},
            [h('span', {class: 'dt-info'}, `${this.tbl.data.length}条记录`)]),
          h('div', {slot: 1}, '总表')
        ], i = 2
        this.ds.forEach(d => d.cheJian.forEach(c => {
          let th = ['时间', '交检总数', '一次合格数'], tb = [], djs = this.$store.state.std.dengJi, dj = {},
            m = new Date(this.from), y = 1900 + m.getYear(), j = m.getMonth(), t, rc = 0
          djs.forEach(d => {
            th.push(`${d.name}类故障`)
            dj[d.id] = 0
          })
          th.push('一次合格率', '故障率')
          while((t = (new Date(y, j++)).toDate().substr(0, 7)) <= this.to) {
            //if(j % 3 == 0)
            let r = []
            if(m = c.jiaoJian.count.find(m => m.month == t)) {
              //gs: 故障, ts: 故障车, pc: 合格数
              let gs = c.jiaoJian.items.filter(g => g.date.substr(0, 7) == m.month), ts = [], pc = 0
              gs.forEach(g => {
                let t = ts.find(v => v.date == g.date && v.cheHao.toUpperCase() == g.cheHao.toUpperCase())
                if(!t) {
                  t = {date: g.date, cheHao: g.cheHao, g: 0}
                  ts.push(t)
                }
                t.g += lv[g.dengJi]
                dj[g.dengJi]++
              })
              ts.forEach(t => t.g < 6 && pc++)
              r.push(m.month, m.count, m.count - ts.length + pc)
              for(let k in dj)
                r.push(dj[k])
              r.push(Math.round((m.count - ts.length + pc) * 100 / m.count) + '%', Math.round((ts.length - pc) * 100 / m.count) + '%')
            } else
              r.push(t, {attrs: {colspan: 7}})
            tb.push(h('tr', {key: rc++}, r.map(d => h('td', d))))
          }
          if(!tb.length)
            tb.push(h('tr', [h('td', {attrs: {colspan: 8}}, '无数据')]))
          r.push(h('div', {class: 'dt-out', slot: i++}, [
            h('table', {class: 'datable dt-head'}, [
              h('caption', `${d.name}${c.name}交检分析`),
              h('thead', [h('tr', th.map(t => h('th', t)))]),
              h('tbody', tb)
            ])
          ]))
        }))
        */
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
      setTimeout(() => this.$refs[`tblTime${i}`].onScroll(), 0)
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
  }
}
</script>
