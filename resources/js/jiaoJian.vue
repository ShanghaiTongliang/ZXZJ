<style>
#list {
  background-color: white;
  user-select: none;
  overflow: auto;
  border: inset 1px;
  flex-grow: 1;
}
</style>
<script>
import axios from 'axios'
import Vue from 'vue'
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import {PERMISSION_DATA, PERMISSION_REPAIR, PERMISSION_MANAGE, chuLiStates} from './global'

const columns = {
  date: {
    caption: '日期',
    //class: 'dt-nowrap',
    type: 'select',
    items: null
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
    master: ['daBuWei']
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
    items: chuLiStates
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
  components: {Datable, Kvtable, Moditable},
  render(h) {
    let n = this.$route.name, pg, c, d, t = this.curMonth
    if(n == 'jiaoJian') {
      d = this.tbl.editingIndex >= 0
      pg = h('moditable', {props: {table: this.table}, on: {
        editable: this.isEditable,
        save: this.save,
        delete: this.del
      }}, [t ? h('a', {attrs: {href: '#/jiaoJian/create', class: 'act'}}, '新建') : h('div', {class: 'act'}, '请输入检修总数'), h('div', {class: 'dt-info'}, `${this.tbl.data.length}条记录`)])
    } else if(n == 'createJiaoJian') {
      d = true
      pg = h('kvtable', {props: {table: this.kv, vertical: this.$store.state.vertical}},
        [h('a', {attrs: {href: '#/jiaoJian', class: 'act'}}, '返回')])
    } else
      return
    c = this.curCheJian
    let pnl = h('div', [
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
    h('div', {class: 'group'}, ['检修总数 ', h('input', {
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
          axios.put('zxzj/api/jiaoJian/count', {cheJian: this.cheJian, month: this.month, count: this.count}).then(r => {
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
    }}, '保存')])])
    return h('div', [pnl, pg])
  },
  data() {
    return {
      danWei: this.$store.state.danWei[0].id,
      cheJian: this.$store.state.danWei[0].cheJian[0].id,
      month: months[0],
      count: undefined,
      editable: false,
      tbl: {
        caption: '整车交检故障',
        columns,
        actions: [{
          caption: '下发',
          condition(d) {
            return this.editable && this.tbl.editingIndex < 0 && !d.state
          },
          onclick(d) {
            if(confirm('是否下发不合格通知单 ?')) {
              this.loading(true)
              axios.post(`zxzj/api/jiaoJian/${d.id}/chuLi`).then(r => {
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
        editingIndex: -1,
      },
      kv: {
        caption: '故障',
        columns,
        editing: true,
        data: null,
        actions: [{
          caption: '保存',
          onclick(d) {
            this.saveFields(d, r => {
              this.loading(true)
              axios.post('zxzj/api/jiaoJian', r).then(res => {
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
      this.count = r && r.count
      return r
    },
    table() {
      columns.banZu.items = this.curCheJian && this.curCheJian.banZu
      this.tbl.data = this.$store.state.jiaoJian.filter(g =>
        g.cheJian == this.cheJian && g.date.substr(0, 7) == this.month)
      return this.tbl
    }
  },
  watch: {
    '$route.name': {
      immediate: true,
      handler(v) {
        if(v == 'jiaoJian')
          this.tbl.editingIndex = -1
        else if(v == 'createJiaoJian')
          this.kv.data = {danWei: this.danWei, cheJian: this.cheJian}
      }
    },
    std: {
      deep: true,
      immediate: true,
      handler(v) {
        columns.xiuCheng.items = v.xiuCheng
        columns.cheZhong.items = v.cheZhong
        columns.daBuWei.items = v.daBuWei
        columns.dengJi.items = v.dengJi
      },
    },
    month: {
      immediate: true,
      handler(v) {
        let i, c = new Date(this.month.substr(0, 4), this.month.substr(5), 0).getDate() + 1, d = []
        for(i = 1; i < c; i++) {
          let s = `${this.month}-` + (i > 9 ? i : `0${i}`)
          d.push({id: s, name: s})
        }
        this.tbl.columns.date.items = d
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    isEditable() {
      return this.editable
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
        axios.put(`zxzj/api/jiaoJian/${d.id}`, r).then(() => {
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
        axios.delete(`zxzj/api/jiaoJian/${d.id}`).then(() => {
          this.loading(false)
          this.message('删除成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    }
  },
  created() {
    let d = this.dict.groups
    this.editable = this.user.groups.find(g => {
      return g == 255 || d[g].cheJian.find(c => {
        let r = c.id == this.cheJian && c.permission & PERMISSION_DATA
        return r
      })
    })
    columns.user.items = this.$store.state.users
  }
}
</script>
