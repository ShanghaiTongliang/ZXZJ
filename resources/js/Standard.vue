<script>
import axios from 'axios'
import Vue from 'vue'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import Kvtable from './components/Kvtable'
import {mapMutations} from 'vuex';
import {peiJianLeiBie} from './global'

const names = {
  xiuCheng: '修程',
  cheZhong: '车种',
  daBuWei: '大部位',
  guZhang: '故障',
  dengJi: '等级',
  peiJian: '配件'
},
contain = {},
columns = {
  id: 'id',
  name: {
    caption: '名称',
    type: 'text'
  }
},
colGuZhang = {
  id: 'id',
  name: {
    caption: '名称',
    type: 'text',
  },
  daBuWei: {
    caption: '大部位',
    type: 'select',
    items: null
  },
  dengJi: {
    caption: '等级',
    type: 'select',
    items: null
  }
}, colPeiJian = {
  id: 'id',
  name: {
    caption: '名称',
    type: 'text',
  },
  xingHao: {
    caption: '型号',
    type: 'text'
  },
  id: 'id',
  name: {
    caption: '名称',
    type: 'text',
  },
  leiBie: {
    caption: '类别',
    type: 'select',
    items: peiJianLeiBie
  },
  danWei: {
    caption: '单位',
    type: 'text'
  }
}

export default {
  components: {Datable, Moditable, Kvtable},
  render(h) {
    let n = this.type.name
    if(this.type.create) {
      n = this.$route.matched[2].name
      this.kv[n].data = {}
      return h('kvtable', {props: {table: this.kv[n]}}, [h('a', {attrs: {class: 'act', href: `#/standard/${n}`}}, '返回')])
    } else
      return h('moditable', {props: {table: this.tbl[n]}, on: {
        save: (d, i, next) => {
          if(this.check(d, n, this.tbl[n].columns)) {
            this.loading(true)
            axios.put(`zxzj/api/standard/${n}/${d.id}`, d).then(res => {
              this.loading(false)
              this.message('保存成功')
              next()
            }).catch(res => {
              this.loading(false)
              this.error(res.response.data)
            })
          }
        },
        delete: (d, i, next) => {
          if(this.$store.state[contain[n]].find(g => g[n] == d.id))
            this.error(`${names[n]}: ${d.name} 已被使用, 不能删除`)
          else if(confirm(`确定要删除 ${names[n]}: ${d.name} ?`)) {
            this.loading(true)
            axios.delete(`zxzj/api/standard/${this.$route.name}/${d.id}`).then(res => {
              this.loading(false)
              this.message('删除成功')
              next()
            }).catch(res => {
              this.loading(false)
              this.error(res.response.data)
            })
          }
        }
      }}, [h('a', {attrs: {class: 'act', href: `#/standard/${n}/create`}}, `新建${names[n]}`)])
  },
  data() {
    let r = {tbl: {}, kv: {}}
    for(let n in names) {
      r.tbl[n] = {
        caption: names[n],
        columns,
        data: this.$store.state.std[n]
      },
      r.kv[n] = {
        caption: `新建${names[n]}`,
        columns,
        actions: [{
          caption: '保存',
          onclick(d) {
            let n = this.type.name
            if(this.check(d, n, this.kv[n].columns, true)) {
              this.loading(true)
              axios.post(`zxzj/api/standard/${n}/${d.id}`, d).then(r => {
                this.loading(false)
                this.message('保存成功')
                d.id = r.data.id
                this.$store.state.std[n].push(d)
                this.$router.push({name: n})
              }).catch(r => {
                this.loading(false)
                this.error(res.response.data)
              })
            }
          }
        }],
        editing: true,
        data: null
      }
    }
    r.tbl.guZhang.columns = colGuZhang
    r.kv.guZhang.columns = colGuZhang
    r.tbl.peiJian.columns = colPeiJian
    r.kv.peiJian.columns = colPeiJian
    return r
  },
  computed: {
    std() {
      return this.$store.state.std
    },
    type() {
      let r = {name: this.$route.name}
      if(r.name.substr(0, 6) == 'create') {
        r.name = this.$route.matched[2].name
        r.create = true
      }
      return r
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    check(d, n, c, noRep) {
      for(let k in c)
        if(c[k] instanceof Object && !d[k] && isNaN(parseInt(d[k]))) {
          this.error(`请输入${names[n]}${c[k].caption}`)
          return
        }
      if(noRep && this.std[n].find(s => s.name == d.name))
        this.error(`${d.name} 已经存在`)
      else
        return true
    }
  },
  created() {
    colGuZhang.daBuWei.items = this.std.daBuWei
    colGuZhang.dengJi.items = this.std.dengJi
    for(let k in names)
      contain[k] = 'jiaoJian'
    contain.peiJian = 'ruKuFuJian'
  }
}
</script>
