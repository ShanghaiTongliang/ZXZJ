<template>
  <div v-if="$route.name == 'ruKuFuJian' || $route.name == 'ruKuChuZhi'">
    <chejian-month :danWeis="user.data" :danWei="danWei" :cheJian="cheJian" :month="month" :year="3" :disabled="editing" :state="$store.state" @cheJianChanged="cheJianChanged" @monthChanged="monthChanged"></chejian-month>
    <moditable v-if="$route.name == 'ruKuFuJian'" :table="table" @editable="editable" @edit="edit" @cancel="cancel" @save="save" @delete="del">
      <a v-if="user.permission[cheJian] & PERMISSION_DATA" href="#/ruKuFuJian/create" class="act">新建</a>
      <span class="dt-info">{{`${this.tbl.data.length}条记录`}}</span>
    </moditable>
    <moditable v-else :table="tableBuHeGe" @editable="editable" @edit="edit" @cancel="cancel" @save="save" @delete="del">
      <span class="dt-info">{{`${this.tblBuHeGe.data.length}条记录`}}</span>
    </moditable>
  </div>
  <kvtable v-else-if="$route.name == 'createRuKuFuJian'" :table="kv" :vertical="$store.state.vertical"><a href="#/ruKuFuJian" class="act">返回</a></kvtable>
</template>

<script>
import axios from 'axios'
import Vue from 'vue'
import {mapMutations, mapState} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import ChejianMonth from './ChejianMonth'
import {peiJianLeiBie, PERMISSION_DATA} from './global'

const biJianBuHeGe = 0, biJianHeGe = 1, chouJianYiCiHeGe = 2, chouJianErCiHeGe = 3, chouJianErCiBuHeGe = 4,
jieGuo = [{
  id: biJianBuHeGe,
  name: '部分合格'
}, {
  id: biJianHeGe,
  name: '全部合格'
}, {
  id: chouJianYiCiHeGe,
  name: '一次抽检合格'
}, {
  id: chouJianErCiHeGe,
  name: '二次抽检合格'
}, {
  id: chouJianErCiBuHeGe,
  name: '二次抽检不合格'
}],
columns = {
  date: {
    caption: '日期',
    type: 'date'
  },
  peiJian: {
    caption: '配件名称',
    type: 'select',
    itemName: 'xingHao',
    items: null,
    onchange(d, i, r) {
      let l = this.dict.peiJian[d].leiBie
      if(l == 1 && r.ruKuShuLiang)
        Vue.set(r, 'fuJianShuLiang', r.ruKuShuLiang)
      Vue.set(r, 'leiBie', l)
      columns.jieGuo.items = r.leiBie == 1 ? biJianJieGuo : chouJianJieGuo
    }
  },
  xingHao: {
    caption: '型号',
    type: 'select',
    master: ['peiJian']
  },
  leiBie: {
    caption: '类别',
    show: true,
    items: peiJianLeiBie,
    filter(l, i, v) {
      let d = this.dict
      return v.peiJian && d.leiBie[d.peiJian[v.peiJian].leiBie].name
    }
  },
  ruKuShuLiang: {
    caption: '入库数量',
    type: 'number',
    min: 1,
    step: 1,
    onchange(d, i, r) {
      Vue.set(r, 'fuJianShuLiang', r.leiBie == 1 ? d : Math.round(d < 100 ? d * .03 : d < 300 ? d * .02 : d * .015) || 1)
    }
  },
  fuJianShuLiang: {
    caption: '复检数量',
    type: 'number',
    min: 1,
    step: 1
  },
  bianHao: {
    caption: '编号',
    type: 'text'
  },
  jieGuo: {
    caption: '结果',
    type: 'select',
    items: jieGuo,
    filter(t, i, r) {
      i = r[i]
      let c = i == chouJianErCiBuHeGe ? 'red' : i == biJianBuHeGe || i == chouJianErCiHeGe ? 'orange' : 'green'
      return `<span class="${c}">${t}</span>`
    }
  },
  remark: {
    caption: '备注',
    type: 'text'
  },
  user: {
    caption: '复检人',
    type: 'select',
    default: '已删除',
    items: null
  }
},
biJianJieGuo = [jieGuo[0], jieGuo[1]],
chouJianJieGuo = [jieGuo[2], jieGuo[3], jieGuo[4]]

export default {
  components: {Datable, Kvtable, Moditable, ChejianMonth},
  data() {
    let d = this.$store.state.user.data
    return {
      PERMISSION_DATA,
      danWei: d.length && d[0].id,
      cheJian: d.length && d[0].cheJian[0].id,
      month: null,
      from: null,
      to: null,
      tbl: {
        caption: '站修入库配件复检记录表',
        columns,
        data: null
      },
      tblBuHeGe: {
        caption: '站修入库配件复检不合格记录表',
        columns,
        data: null
      },
      kv: {
        caption: '新建入库配件复检记录',
        columns,
        editing: true,
        data: null,
        actions: [{
          caption: '保存',
          onclick(d) {
            if(this.check(d)) {
              this.loading(true)
              d.cheJian = this.cheJian
              let t = {...d}
              delete t.peiJian
              delete t.leiBie
              axios.post('api/ruKuFuJian', t).then(r => {
                this.loading(false)
                this.message('保存成功')
                d.id = r.data.id
                this.ruKuFuJian.push(d)
                this.$router.push('/ruKuFuJian')
              }).catch(r => {
                this.loading(false)
                this.error(r.response.data)
              })
            }
          }
        }]
      }
    }
  },
  computed: {
    ...mapState(['dict', 'user', 'ruKuFuJian']),
    editing() {
      return this.tbl.editingIndex >= 0
    },
    users() {
      let c = this.dict.cheJian[this.cheJian], r = []
      if(c)
        c.user.forEach(u => r.push(u))
      return r
    },
    table() {
      this.tbl.data = this.from
        ? this.ruKuFuJian.filter(r => {
          if(r.cheJian == this.cheJian) {
            let m = r.date.substr(0, 7)
            return m >= this.from && m <= this.to
          }
        }) : this.ruKuFuJian.filter(r => r.cheJian == this.cheJian && r.date.substr(0, 7) == this.month)
      return this.tbl
    },
    tableBuHeGe() {
      this.tblBuHeGe.data = this.from
        ? this.ruKuFuJian.filter(r => {
          let j = r.jieGuo, m
          if(r.cheJian == this.cheJian && (j == biJianBuHeGe || j == chouJianErCiBuHeGe || j == chouJianErCiHeGe)) {
            m = r.date.substr(0, 7)
            return m >= this.from && m <= this.to
          }
        }) : this.ruKuFuJian.filter(r => {
          let j = r.jieGuo
          return r.cheJian == this.cheJian && (j == biJianBuHeGe || j == chouJianErCiBuHeGe || j == chouJianErCiHeGe) && r.date.substr(0, 7) == this.month
        })
      return this.tblBuHeGe
    }
  },
  watch: {
    '$route.name': {
      immediate: true,
      handler(v) {
        if(v == 'createRuKuFuJian') {
          this.kv.data = {date: (new Date).toDate(), user: this.user.id}
          columns.user.items = this.users
        } else {
          columns.user.items = this.$store.state.users
          columns.jieGuo.items = jieGuo
        }
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    cheJianChanged(d, c) {
      this.danWei = d
      this.cheJian = c
    },
    monthChanged(m, from, to) {
      this.month = m
      this.from = from
      this.to = to
    },
    check(d) {
      for(let k of ['ruKuShuLiang', 'fuJianShuLiang'])
        if(isNaN(d[k])) {
          this.error(`请输入${columns[k].caption}`)
          return
        }
      return true
    },
    /*query() {
      if(this.from > this.to)
        this.from = this.to
      this.loading(true)
      axios.post('api/ruKuFuJian/query', {from: this.from, to: this.to}).then(r => {
        this.loading(false)
        r.data.forEach(d => this.$store.state.fixRuKuFuJian(d))
        this.ruKuFuJian = r.data
        this.tbl.data = r.data
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },*/
    editable() {
      return this.user.permission[this.cheJian] & PERMISSION_DATA
    },
    edit(d) {
      columns.jieGuo.items = d.leiBie == 1 ? biJianJieGuo : chouJianJieGuo
      columns.user.items = this.users
    },
    cancel() {
      columns.jieGuo.items = jieGuo
      columns.user.items = this.$store.state.users
    },
    save(d, i, next, o) {
      //todo: 数据检查
      if(this.check(d)) {
        this.loading(true)
        let t = {...d}
        delete t.peiJian
        delete t.leiBie
        delete t.danWei
        columns.jieGuo.items = jieGuo
        columns.user.items = this.$store.state.users
        axios.put(`api/ruKuFuJian/${d.id}`, t).then(r => {
          this.loading(false)
          this.message('保存成功')
          this.$store.state.fixRuKuFuJian(d)
          next()
          Vue.set(this.$store.state.ruKuFuJian, this.ruKuFuJian.indexOf(o), d)
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
    del(d, i) {
      if(confirm(`确定要删除入库复检记录 ?`)) {
        this.loading(true)
        axios.delete(`api/ruKuFuJian/${d.id}`).then(() => {
          let rs = this.ruKuFuJian
          for(let i in rs)
            if(rs[i].id == d.id) {
              rs.splice(i, 1)
              break
            }
          this.loading(false)
          this.message('删除成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.date)
        })
      }
    }
  },
  created() {
    columns.peiJian.items = this.$store.state.std.peiJian
  }
}
</script>
