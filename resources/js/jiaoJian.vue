<style>
#list {
  min-height: 5.5em;
  margin-bottom: .5em;
  flex-grow: 1;
}
.jj-calendar {
  text-align: left;
  width: 100%;
  width: 21em;
}
.jj-calendar, .jj-calendar>* {margin: .1em auto}
.jj-date {
  text-align: center;
  display: inline-block;
  width: 3em;
}
.jj-date input {
  width: 1.5em !important;
  text-align: center;
  -moz-appearance: textfield;
}
.jj-date input::-webkit-inner-spin-button, .jj-date input::-webkit-outer-spin-button {-webkit-appearance: none}
.jj-date input.gray {
  border: 1px inset;
  padding: 2px 1px;
}
.jj-date input.gray:focus {background-color: white}
.jj-date span {
  width: 1.4em;
  display: inline-block;
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
import ChejianMonth from './ChejianMonth'
import Mission from './Mission'
import {PERMISSION_DATA, stateColor, chuLiStates} from './global'

const colJiaoJian = {
  date: {
    caption: '日期',
    //class: 'dt-nowrap',
    type: 'date'
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
    caption: '车型',
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
      return v.guZhang && d.guZhang[v.guZhang] && d.dengJi[d.guZhang[v.guZhang].dengJi].name
    }
  },
  state: {
    caption: '状态',
    items: chuLiStates,
    filter(t) {
      return t && `<span class="${stateColor[t]}">${chuLiStates.find(s => s.id == t).name}</span>`
    }
  },
  user: {
    caption: '质检员',
    type: 'select',
    default: '已删除',
    items: null
  }
}

export default {
  components: {Datable, Kvtable, Moditable, ChejianMonth, Mission},
  render(h) {
    let ds, gs, c, d, on, t = this.curMonth
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
      gs = h('kvtable', {style: 'flex-grow: 1', props: {table: this.kv, vertical: this.vertical}},
        [h('a', {attrs: {href: '#/jiaoJian', class: 'act'}}, '返回')])
    }
    c = this.curCheJian
    if(this.rn == 1) {
      ds = ['一', '二', '三', '四', '五', '六', '日'].map(t => h('div', {class: 'jj-date'}, t))
      let i, d = (new Date(`${this.month}-01`)).getDay()
      for(i = 1; i < d; i++)
        ds.push(h('div', {class: 'jj-date'}))
      for(i = 0; i < this.dateCount; i++)
        ds.push(h('div', {class: 'jj-date'}, [h('span', i + 1), h('input',
          {attrs: {type: 'number', min: 0, step: 1, id: i, class: this.counts[i] === undefined ? 'gray' : undefined}, domProps: {value: this.counts[i]}, on: {
            input: this.countInput
          }}
        )]))
      ds.push(h('button', {style: 'float: right'}, '保存'))
      ds = h('div', {style: {margin: 'auto', flexShrink: 0, display: this.vertical ? null : 'flex'}}, [h('div', {style: this.vertical ? null : 'width: 1em; margin: 0 .2em 0 .5em'}, '日检修量'), h('form', {class: 'group jj-calendar', on: {
        submit: e => this.saveCount(e, t, c)
      }}, ds)])
    }
    return h('div', {style: 'display: flex; flex-direction: column'}, [
      h('div', {style: {display: 'flex', margin: 'auto', flexShrink: 0, flexDirection: this.vertical ? 'column' : null}}, [
        h('chejian-month', {props: {
          danWeis: this.rn == 3 ? this.user.repair : this.user.data, danWei: this.danWei, cheJian: this.cheJian, month: this.month,
          disabled: d, state: this.$store.state, vertical: this.rn == 1 && !this.vertical
        }, on: {
          cheJianChanged: this.cheJianChanged,
          monthChanged: this.monthChanged
        }}, this.rn == 1 ? [h('div', {class: 'group'}, `检修总量: ${this.count || 0}`)] : null), ds
      ])
      , gs, h('mission', {
        props: {mission: this.mission, role: this.role, editing: this.editingXiaFa}, on: {
          onEditing: v => this.editingXiaFa = v
        }, key: 'm'
      })
    ])
  },
  data() {
    return {
      rn: null,
      danWei: 0,
      cheJian: 0,
      month: null,
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
            return this.rn == 2 && this.editable && this.tbl.editingIndex < 0 && !d.state
          },
          onclick(d) {
            if(confirm('是否下发不合格通知单 ?')) {
              this.loading(true)
              axios.post(`api/jiaoJian/${d.id}/chuLi`).then(r => {
                this.loading(false)
                this.message('下发成功')
                d.state = 1
                this.$store.state.fixJiaoJian(r.data)
                this.jiaoJianChuLi.push(r.data)
                this.jiaoJianChuLi.sort((a, b) => {
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
                this.$store.state.fixJiaoJian(r)
                this.jiaoJian.push(r)
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
    ...mapState(['user', 'std', 'dict', 'vertical', 'jiaoJian', 'jiaoJianChuLi']),
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
      if(this.jiaoJian) {
        let d = this.jiaoJian.filter(g =>
          g.cheJian == this.cheJian && g.date.substr(0, 7) == this.month)
        if(this.rn > 2) {
          d = d.filter(g => g.state)
          this.selection = d.length ? d[0] : null
        }
        this.tbl.data = d
      }
      colJiaoJian.user.items = this.curCheJian && this.curCheJian.user
      return this.tbl
    },
    missions() {
      return this.jiaoJianChuLi.filter(g => g.cheJian == this.cheJian && g.date.substr(0, 7) == this.month)
    }
  },
  watch: {
    '$route.name': {
      immediate: true,
      handler(n) {
        let u = this.user
        if(!u.data.length && !u.manage.length)
          if(u.repair.length) {
            if(n != 'jiaoJianChuLi')
              this.$router.replace('/jiaoJian/chuLi')
          } else if(n != 'curUser')
            this.$router.replace(`/user/${u.id}`)
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
          let u = this.user
          if(this.rn == 3) {
            this.danWei = u.repair.length && u.repair[0].id
            this.cheJian = u.repair.length && u.repair[0].cheJian[0].id
          } else {
            this.danWei = u.data.length && u.data[0].id
            this.cheJian = u.data.length && u.data[0].cheJian[0].id
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
    selection(g) {
      this.mission = g && this.jiaoJianChuLi.find(c => c.id == g.id)
      this.editingXiaFa = false
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    cheJianChanged(d, c) {
      this.danWei = d
      this.cheJian = c
    },
    monthChanged(m, f, t) {
      this.month = m
      this.dateCount = new Date(m.substr(0, 4), m.substr(5), 0).getDate()
    },
    countInput(e) {
      let v
      if(e.target.validity.valid)
        if(e.target.value === '')
          Vue.delete(this.counts, e.target.id)
        else
          !isNaN(v = parseInt(e.target.value)) && Vue.set(this.counts, e.target.id, v)
      else
        e.target.form.reportValidity()
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
          Vue.set(t, 'counts', this.counts)
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
    this.editable = this.user.admin || this.user.groups.find(g => {
      return d[g].cheJian.find(c => {
        let r = c.id == this.cheJian && c.permission & PERMISSION_DATA
        return r
      })
    })
    colJiaoJian.user.items = this.$store.state.users
  }
}
</script>
