<template>
  <div v-if="$route.name == 'ruKuFuJian'">
    <chejian-month :danWei="danWei" :cheJian="cheJian" :month="month" :disabled="editing" :state="$store.state" @cheJianChanged="cheJianChanged" @monthChanged="monthChanged"></chejian-month>
    <moditable :table="table" @edit="edit" @cancel="cancel" @save="save" @delete="del">
      <a href="#/ruKuFuJian/create" class="act">新建</a>
      <span class="dt-info">{{`${this.tbl.data.length}条记录`}}</span>
    </moditable>
  </div>
  <kvtable v-else-if="$route.name == 'createRuKuFuJian'" :table="kv"><a href="#/ruKuFuJian" class="act">返回</a></kvtable>
  <div v-else>不合格处置</div>
</template>

<script>
import axios from 'axios'
import Vue from 'vue'
import {mapMutations, mapState} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import ChejianMonth from './ChejianMonth'
import {peiJianLeiBie} from './global'

const columns = {
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
    items: [{
      id: 0,
      name: '不合格'
    }, {
      id: 1,
      name: '合格'
    }]
  },
  user: {
    caption: '复检人',
    type: 'select',
    items: null
  }
}

export default {
  components: {Datable, Kvtable, Moditable, ChejianMonth},
  data() {
    return {
      danWei: this.$store.state.danWei[0].id,
      cheJian: this.$store.state.danWei[0].cheJian[0].id,
      month: null,
      tbl: {
        caption: '站修入库配件复检记录表',
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
    ...mapState(['dict', 'ruKuFuJian']),
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
      this.tbl.data = this.ruKuFuJian.filter(r => r.cheJian == this.cheJian && r.date.substr(0, 7) == this.month)
      return this.tbl
    }
  },
  watch: {
    '$route.name': {
      immediate: true,
      handler(v) {
        if(v == 'createRuKuFuJian')
          this.kv.data = {date: (new Date).toDate()}
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    cheJianChanged(d, c) {
      this.danWei = d
      this.cheJian = c
    },
    monthChanged(m) {
      this.month = m
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
    edit() {
      columns.user.items = this.users
    },
    cancel() {
      columns.user.items = this.$store.state.users
    },
    save(d, i, next) {
      //todo: 数据检查
      if(this.check(d)) {
        this.loading(true)
        let t = {...d}
        delete t.peiJian
        delete t.leiBie
        delete t.danWei
        columns.user.items = this.$store.state.users
        axios.put(`api/ruKuFuJian/${d.id}`, t).then(r => {
          this.loading(false)
          this.message('保存成功')
          this.$store.state.fixRuKuFuJian(d)
          next()
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
    columns.user.items = this.$store.state.users
  }
}
</script>
