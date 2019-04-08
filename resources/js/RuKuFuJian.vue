<template>
  <div v-if="$route.name == 'ruKuFuJian'">
    <div>
      <div class="group">从 <input type="month" v-model="from" :disabled="editing"> 到 <input type="month" v-model="to" :disabled="editing"></div> <button @click="query" :disabled="editing">查询</button>
    </div>
    <moditable :table="tbl" @edit="edit" @cancel="cancel" @save="save" @delete="del">
      <a href="#/ruKuFuJian/create" class="act">新建</a>
      <span class="dt-info">{{`${this.$store.state.ruKuFuJian.length}条记录`}}</span>
    </moditable>
  </div>
  <kvtable v-else-if="$route.name == 'createRuKuFuJian'" :table="kv"><a href="#/ruKuFuJian" class="act">返回</a></kvtable>
  <div v-else>不合格处置</div>
</template>

<script>
import axios from 'axios'
import {mapMutations} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import {peiJianLeiBie} from './global'

const columns = {
  date: {
    caption: '日期',
    type: 'date'
  },
  peiJian: {
    caption: '配件名称',
    type: 'select',
    items: null
  },
  xingHao: '型号',
  leiBie: {
    caption: '类别',
    items: peiJianLeiBie
  },
  danWei: '单位',
  ruKuShuLiang: {
    caption: '入库数量',
    type: 'int',
    min: 1
  },
  fuJianShuLiang: {
    caption: '复检数量',
    type: 'int',
    min: 1
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
  components: {Datable, Kvtable, Moditable},
  data() {
    return {
      from: (new Date).toDate().substr(0, 7),
      to: (new Date).toDate().substr(0, 7),
      tbl: {
        caption: '站修入库配件复检记录表',
        columns,
        data: this.$store.state.ruKuFuJian
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
              axios.post('zxzj/api/ruKuFuJian', d).then(r => {
                this.loading(false)
                this.message('保存成功')
                d.id = r.data.id
                this.$store.state.ruKuFuJian.push(d)
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
    editing() {
      return this.tbl.editingIndex >= 0
    },
    users() {
      let c = this.$store.state.user.cheJian, r = []
      if(c) {
        c = this.$store.state.dict.cheJian[c]
        c.banZu.forEach(b => b.user.forEach(u => r.push(u)))
      }
      return r
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
    check(d) {
      for(let k of ['ruKuShuLiang', 'fuJianShuLiang'])
        if(isNaN(d[k])) {
          this.error(`请输入${columns[k].caption}`)
          return
        }
      if(!d.bianHao) {
        this.error(`请输入编号`)
        return
      }
      return true
    },
    query() {
      if(this.from > this.to)
        this.from = this.to
      this.loading(true)
      axios.post('zxzj/api/ruKuFuJian/query', {from: this.from, to: this.to}).then(r => {
        this.loading(false)
        r.data.forEach(d => this.$store.state.fixRuKuFuJian(d))
        this.$store.state.ruKuFuJian = r.data
        this.tbl.data = r.data
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },
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
        delete t.xingHao
        delete t.leiBie
        delete t.danWei
        columns.user.items = this.$store.state.users
        axios.put(`zxzj/api/ruKuFuJian/${d.id}`, t).then(r => {
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

    }
  },
  created() {
    columns.peiJian.items = this.$store.state.std.peiJian
    columns.user.items = this.$store.state.users
  }
}
</script>
