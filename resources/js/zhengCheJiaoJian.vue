<style>
#list {
  background-color: white;
  user-select: none;
  overflow: auto;
  border: inset 1px;
  flex-grow: 1;
}
</style>
<template>
  <moditable v-if="$route.name == 'zhengCheJiaoJian'" :tbl="tbl" @save="save" @delete="del">
    <a href="#/guZhang/zhengCheJiaoJian/create" class="act">新建</a>
  </moditable>
  <div v-else style="display: flex; flex-direction: column">
    <kvtable :tbl="kv" :vertical="$store.state.vertical" style="overflow: visible; flex-shrink: 0">
      <a href="#/guZhang/zhengCheJiaoJian" class="act">返回</a>
    </kvtable>
    <ul id="list" class="menu">
      <li v-for="(l, i) in list" :key="i" @click="listClick(i)" @dblclick="listDblClick(i)"><span :class="i == listIndex && 'select'">{{l}}</span></li>
    </ul>
  </div>
</template>
<script>
import axios from 'axios'
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import {fixGuZhang} from './store'
import {fields} from './global'

const columns = {
  date: {
    caption: '日期',
    type: 'date'
  },
  xiuCheng: {
    caption: '修程',
    type: 'select',
    items: null
  },
  cheZhong: {
    caption: '车种',
    type: 'pinyin',
    items: null
  },
  daBuWei: {
    caption: '大部位',
    type: 'pinyin',
    items: null
  },
  xiaoBuWei: {
    caption: '小部位',
    type: 'pinyin',
    items: null
  },
  juTiBuWei: {
    caption: '具体部位',
    type: 'pinyin',
    items: null
  },
  guZhang: {
    caption: '故障',
    type: 'pinyin',
    items: null
  },
  dengJi: {
    caption: '等级',
    type: 'select',
    items: null
  },
  danWei: {
    caption: '单位',
    type: 'select',
    itemName: 'cheJian',
    items: null
  },
  cheJian: {
    caption: '车间',
    type: 'select',
    itemName: 'banZu',
    master: ['danWei'],
  },
  banZu: {
    caption: '班组',
    type: 'select',
    itemName: 'user',
    master: ['danWei', 'cheJian'],
  },
  user: {
    caption: '质检员',
    type: 'select',
    master: ['danWei', 'cheJian', 'banZu']
  }
}

export default {
  components: {Datable, Kvtable, Moditable},
  data() {
    return {
      tbl: {
        caption: '故障',
        columns,
        editingIndex: -1,
        data: null,
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
              axios.post('api/guZhang/zhengCheJiaoJian', r).then(res => {
                r.id = res.data
                fixGuZhang.call(this.$store.state, r)
                this.$store.state.guZhang.zhengCheJiaoJian.push(r)
                this.message('新建成功')
                this.$router.push('/guZhang/zhengCheJiaoJian')
              })
              if(!this.list.length) {
                let l = {}
                for(let i = 1; i < fields.length; i++)
                  l[fields[i]] = r[fields[i]]
                axios.post('api/guZhang/guZhangList', l).then(r => {
                  l.id = r.data
                  this.std.guZhangList.push(l)
                }).catch(r => this.error(r.response.data))
              }
            })
          }
        }]
      },
      listIndex: -1
    }
  },
  computed: {
    ...mapState(['user', 'std']),
    list() {
      let dict = this.$store.state.dict, d = this.kv.data, r
      r = this.std.guZhangList.filter(g => {
        for(let i = 1; i < fields.length; i++) {
          let f = fields[i]
          if(d[f] && !dict[f][g[f]].name.includes(d[f]))
            return false
        }
        return true
      })
      return r.map(g => `${dict.daBuWei[g.daBuWei].name} ${dict.xiaoBuWei[g.xiaoBuWei].name} ${dict.juTiBuWei[g.juTiBuWei].name} ${dict.guZhang[g.guZhang].name}`)
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler(to) {
        if(to.name == 'zhengCheJiaoJianCreate') {
          let d = {date: (new Date).toDate()}
          fields.forEach(f => d[f] = '')
          this.kv.data = d
        }
      }
    },
    std: {
      deep: true,
      immediate: true,
      handler(v) {
        fields.forEach(f => columns[f].items = v[f])
        columns.xiuCheng.items = v.xiuCheng
        columns.dengJi.items = v.dengJi
        columns.user.items = v
      },
    },
    '$store.state.danWei': {
      deep: true,
      immediate: true,
      handler(v) {
        columns.danWei.items = v
      }
    },
    '$store.state.guZhang': {
      deep: true,
      immediate: true,
      handler(v) {
        this.tbl.data = v.zhengCheJiaoJian
      }
    },
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    saveFields(d, next) {
      let std = this.std, r = {date: d.date, xiuCheng: d.xiuCheng, dengJi: d.dengJi, user: d.user}, a = []
      if(!d.date)
        this.error('请选择 日期')
      else if(!d.user)
        this.error(`请选择 质检员`)
      else {
        for(let f of fields)
          if(!d[f]) {
            this.error(`请输入${columns[f].caption}`)
            return
          } else {
            let v = std[f].find(v => v.name == d[f])
            if(v)
              r[f] = v.id
            else
              if(confirm(`是否添加新的 ${columns[f].caption}: ${d[f]} ?`)) {
                this.loading(true)
                a.push(axios.post(`api/standard/${f}`, d[f]).then(res => {
                  std[f].push(res.data)
                  this.$store.state.dict[res.data.id] = res.data
                  r[f] = res.data.id
                }))
              } else
                return
          }
        Promise.all(a).then(() => next(r))
      }
    },
    save(d, i, next) {
      this.saveFields(d, r => {
        this.loading(true)
        axios.put(`api/guZhang/zhengCheJiaoJian/${d.id}`, r).then(() => {
          this.loading(false)
          this.message('保存成功')
          next()
        })
      })
    },
    del(d, i, next) {
      if(confirm('确定要删除数据 ?')) {
        axios.delete(`api/guZhang/zhengCheJiaoJian/${d.id}`).then(() => {
          this.loading(false)
          this.message('删除成功')
          next()
        })
      }
    },
    listClick(i) {
      this.listIndex = i
    },
    listDblClick(i) {
      let l = this.std.guZhangList[i], dict = this.$store.state.dict
      this.kv.data.daBuWei = dict.daBuWei[l.daBuWei].name
      this.kv.data.xiaoBuWei = dict.xiaoBuWei[l.xiaoBuWei].name
      this.kv.data.juTiBuWei = dict.juTiBuWei[l.juTiBuWei].name
      this.kv.data.guZhang = dict.guZhang[l.guZhang].name
    }
  }
}
</script>
