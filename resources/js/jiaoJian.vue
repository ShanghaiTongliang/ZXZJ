<style>
#list {
  min-height: 5.5em;
  margin-bottom: .5em;
}
.jj-date {
  display: inline-block;
  margin: .1em;
}
.jj-date input {width: 2.5em !important}
.jj-date input.gray:focus {background-color: white}
.jj-date span {
  width: 1.4em;
  display: inline-block;
  text-align: right;
  margin-right: .1em;
}
</style>
<script>
import axios from 'axios'
import Vue from 'vue'
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import Mission from './Mission'
import {PERMISSION_DATA, stateColor, chuLiStates} from './global'

const colJiaoJian = {
  date: {
    caption: '日期',
    //class: 'dt-nowrap',
    type: 'date',
    min: null,
    max: null
  },
  cheHao: {
    caption: '车号',
    type: 'text'
  },
  xiuCheng: {
    caption: '修程',
    type: 'select',
    items: null
  },
  cheZhong: {
    caption: '车种',
    type: 'select',
    items: null
  },
  daBuWei: {
    caption: '大部位',
    type: 'select',
    itemName: 'guZhang',
    items: null
  },
  guZhang: {
    caption: '故障',
    type: 'select',
    master: ['daBuWei'],
    onchange(v, i, d) {
      d.dengJi = this.std.guZhang.find(g => g.id == v).dengJi
    }
  },
  dengJi: {
    caption: '等级',
    items: null,
    show: true,
    filter(l, i, v) {
      let d = this.dict
      return v.guZhang && d.dengJi[d.guZhang[v.guZhang].dengJi].name
    }
  },
  state: {
    caption: '状态',
    items: chuLiStates,
    filter(t) {
      return t && `<span class="${stateColor[t]}">${chuLiStates.find(s => s.id == t).name}</span>`
    }
  },
  banZu: {
    caption: '班组',
    type: 'select',
    itemName: 'user',
    items: null
  },
  user: {
    caption: '质检员',
    type: 'select',
    master: ['banZu'],
    items: null
  }
}, months = []

function init() {
  let d = new Date, y = d.getFullYear(), m = d.getMonth() + 1
  for(let i = 0; i < 12; i++) {
    months.push(`${y}-${m > 9 ? m : '0' + m}`)
    if(m > 1) m--
    else {
      m = 12
      y--
    }
  }
}
init()

export default {
  components: {Datable, Kvtable, Moditable, Mission},
  render(h) {
    let gs, c, d, on, t = this.curMonth
    if(this.rn) {
      d = this.tbl.editingIndex >= 0
      on = {
        editable: this.isEditable,
        save: this.save,
        delete: this.del
      }
      if(this.rn > 2)
        on.rowSelect = this.rowSelect
      gs = h('moditable', {attrs: {id: 'list'}, props: {table: this.table, selection: this.selection}, on}, [this.rn == 1 ? t && t.count ? h('a', {attrs: {href: '#/jiaoJian/create', class: 'act'}}, '新建') : h('div', {class: 'act'}, '请输入检修数量') : null, h('div', {class: 'dt-info'}, `${this.tbl.data.length}条记录`)])
    } else {
      d = true
      gs = h('kvtable', {props: {table: this.kv, vertical: this.$store.state.vertical}},
        [h('a', {attrs: {href: '#/jiaoJian', class: 'act'}}, '返回')])
    }
    c = this.curCheJian
    let ds, pnl = h('div', [
    h('div', {class: 'group'}, [
      '单位 ', h('select', {attrs: {disabled: d}, on: {
        change: e => {
          this.danWei = parseInt(e.target.value)
          this.cheJian = this.curDanWei.cheJian[0].id
        }
      }}, this.$store.state.danWei && this.$store.state.danWei.map(
        (d, i) => h('option', {attrs: {value: d.id}, domProps: {selected: this.danWei == d.id}, key: i}, d.name)
      ))
    ]),
    h('div', {class: 'group'}, [
      '车间 ', h('select', {attrs: {disabled: d}, on: {
        change: e => this.cheJian = parseInt(e.target.value)
      }}, this.curDanWei && this.curDanWei.cheJian.map(
        (c, i) => h('option', {attrs: {value: c.id}, domProps: {selected: this.cheJian == c.id}, key: i}, c.name)
      ))
    ]),
    h('div', {class: 'group'}, [
      '月份 ', h('select', {attrs: {disabled: d}, on: {
        change: e => this.month = e.target.value
      }}, months.map((m, i) => h('option', {attrs: {value: m}, domProps: {selected: this.month == m}, key: i}, m)))
    ]),
    this.rn == 1 ? h('div', {class: 'group'}, `检修总量: ${this.count || 0}` /*['检修总数 ', h('input', {
      attrs: {type: 'number', min: 0, placeholder: '请输入', disabled: d},
      domProps: {value: t && t.count},
      on: {
        input: e => this.count = parseInt(e.target.value)
      }
    }),
    ' ', h('button', {attrs: {disabled: d}, on: {
      click: e => {
        if(!isNaN(this.count)) {
          this.loading(true)
          console.log(this.cheJian)
          axios.put('api/jiaoJian/count', {cheJian: this.cheJian, month: this.month, count: this.count}).then(r => {
            if(!t) {
              t = {id: r.data.id, month: this.month}
              c.jiaoJian.push(t)
            }
            Vue.set(t, 'count', this.count)
            this.loading(false)
            this.message('保存成功')
          }).catch(r => {
            this.loading(false)
            this.error(r.response.data)
          })
        } else
          this.error('请输入数量')
      }
    }}, '保存')]*/) : null])
    if(this.rn == 1) {
      ds = ['日检修量']
      for(let i = 0; i < this.dateCount; i++)
        ds.push(h('div', {class: 'jj-date'}, [h('span', i + 1), h('input',
          {attrs: {type: 'number', min: 0, id: i, class: this.counts[i] === undefined ? 'gray' : undefined}, domProps: {value: this.counts[i]}, on: {
            input: this.countInput
          }}
        )]))
      ds.push(h('button', {style: 'margin-left: .2em'}, '保存'))
      ds = h('form', {class: 'group', style: 'text-align: left', on: {
        submit: e => this.saveCount(e, t, c)
      }}, ds)
    }
    return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [pnl, ds, gs, h('mission', {
      props: {mission: this.mission, role: this.role, editing: this.editingXiaFa}, on: {
        onEditing: v => this.editingXiaFa = v
      }, key: 'm'
    })])
  },
  data() {
    return {
      rn: null,
      danWei: this.$store.state.danWei[0].id,
      cheJian: this.$store.state.danWei[0].cheJian[0].id,
      month: months[0],
      dateCount: 0,
      count: undefined,
      counts: {},
      editable: false,
      selection: null,
      mission: null,
      editingXiaFa: false,
      role: 0,
      tbl: {
        caption: '整车交检故障',
        columns: colJiaoJian,
        actions: [{
          caption: '下发',
          condition(d) {
            return this.$route.name == 'jiaoJianXiaFa' && this.editable && this.tbl.editingIndex < 0 && !d.state
          },
          onclick(d) {
            if(confirm('是否下发不合格通知单 ?')) {
              this.loading(true)
              axios.post(`api/jiaoJian/${d.id}/chuLi`).then(r => {
                this.loading(false)
                this.message('下发成功')
                d.state = 1
                this.$store.state.fixJiaoJian(r.data)
                this.$store.state.jiaoJianChuLi.push(r.data)
                this.$store.state.jiaoJianChuLi.sort((a, b) => {
                  a = a.xiaFaShiJian
                  b = b.xiaFaShiJian
                  return a == b ? 0 : a > b ? -1 : 1
                })
              }).catch(r => {
                this.loading(false)
                this.error(r.response.data)
              })
            }
          }
        }],
        data: [],
        editingIndex: -1,
      },
      kv: {
        caption: '故障',
        columns: colJiaoJian,
        editing: true,
        data: null,
        actions: [{
          caption: '保存',
          onclick(d) {
            this.saveFields(d, r => {
              this.loading(true)
              axios.post('api/jiaoJian', r).then(res => {
                this.loading(false)
                r.id = res.data
                let b = this.dict.user[r.user].banZu
                this.$store.state.fixJiaoJian(r)
                this.$store.state.jiaoJian.push(r)
                this.message('新建成功')
                this.$router.push('/jiaoJian')
              }).catch(r => {
                this.loading(false)
                this.error(r.response.data)
              })
            })
          }
        }]
      },
    }
  },
  computed: {
    ...mapState(['user', 'std', 'dict']),
    curDanWei() {
      return this.$store.state.danWei && this.$store.state.danWei.find(d => d.id == this.danWei)
    },
    curCheJian() {
      return this.curDanWei && this.curDanWei.cheJian.find(c => c.id == this.cheJian)
    },
    curMonth() {
      let r = this.curCheJian && this.curCheJian.jiaoJian.find(g => g.month == this.month)
      if(r) {
        this.count = r.count
        this.counts = r.counts
      } else {
        this.count = 0
        this.counts = {}
      }
      return r
    },
    table() {
      let d = this.$store.state.jiaoJian.filter(g =>
        g.cheJian == this.cheJian && g.date.substr(0, 7) == this.month)
      if(this.rn > 2) {
        d = d.filter(g => g.state)
        this.selection = d.length ? d[0] : null
      }
      this.tbl.data = d
      colJiaoJian.banZu.items = this.curCheJian && this.curCheJian.banZu
      return this.tbl
    },
    missions() {
      return this.$store.state.jiaoJianChuLi.filter(g => g.cheJian == this.cheJian && g.date.substr(0, 7) == this.month)
    }
  },
  watch: {
    '$route.name': {
      immediate: true,
      handler(n) {
        const rs = {createJiaoJian: 0, jiaoJian: 1, jiaoJianXiaFa: 2, jiaoJianChuLi: 3, jiaoJianXiaoHao: 4}
        this.rn = rs[n]
        if(this.rn) {
          if(this.rn < 3) {
            this.selection = null
            if(this.rn == 1)
              this.tbl.editingIndex = -1
          } else {
            this.role = this.rn - 2
            let d = this.tbl.data
            if(d.length)
              this.selection = d[0]
            this.editingXiaFa = false
          }
        } else
          this.kv.data = {danWei: this.danWei, cheJian: this.cheJian}
      }
    },
    std: {
      deep: true,
      immediate: true,
      handler(v) {
        colJiaoJian.xiuCheng.items = v.xiuCheng
        colJiaoJian.cheZhong.items = v.cheZhong
        colJiaoJian.daBuWei.items = v.daBuWei
        colJiaoJian.dengJi.items = v.dengJi
      },
    },
    month: {
      immediate: true,
      handler(v) {
        let i, c = new Date(v.substr(0, 4), v.substr(5), 0).getDate()
        this.dateCount = c
        colJiaoJian.date.min = `${v}-01`
        colJiaoJian.date.max = `${v}-${c}`
      }
    },
    selection(g) {
      this.mission = g && this.$store.state.jiaoJianChuLi.find(c => c.id == g.id)
      this.editingXiaFa = false
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    countInput(e) {
      if(e.target.value === '')
        Vue.delete(this.counts, e.target.id)
      else
        Vue.set(this.counts, e.target.id, parseInt(e.target.value))
    },
    saveCount(e, t, c) {
      e.preventDefault()
      let n = 0
      for(let d in this.counts)
        n += this.counts[d]
      this.count = n
      if(c) {
        this.loading(true)
        axios.put('api/jiaoJian/count', {cheJian: this.cheJian, month: this.month, counts: this.counts}).then(r => {
          if(!t) {
            t = {id: r.data.id, month: this.month}
            c.jiaoJian.push(t)
          }
          Vue.set(t, 'count', this.count)
          this.loading(false)
          this.message('保存成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      } else
        this.error('请输入数量')
    },
    rowSelect(r) {
      this.selection = r
      this.editingXiaFa = false
    },
    isEditable() {
      return this.editable && this.$route.name == 'jiaoJian'
    },
    saveFields(d, next) {
      let std = this.std, r
      if(!d.date)
        this.error('请选择 日期')
      else if(!d.cheHao)
        this.error('请输入 车号')
      else if(!d.user)
        this.error(`请选择 质检员`)
      else {
        r = {...d}
        delete r.daBuWei
        delete r.dengJi
        next(r)
      }
    },
    save(d, i, next) {
      this.saveFields(d, r => {
        this.loading(true)
        axios.put(`api/jiaoJian/${d.id}`, r).then(() => {
          this.loading(false)
          this.message('保存成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      })
    },
    del(d, i, next) {
      if(confirm('确定要删除数据 ?')) {
        axios.delete(`api/jiaoJian/${d.id}`).then(() => {
          this.loading(false)
          this.message('删除成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
  },
  created() {
    let d = this.dict.groups
    this.editable = this.user.groups.find(g => {
      return g == 255 || d[g].cheJian.find(c => {
        let r = c.id == this.cheJian && c.permission & PERMISSION_DATA
        return r
      })
    })
    colJiaoJian.user.items = this.$store.state.users
  }
}
</script>
