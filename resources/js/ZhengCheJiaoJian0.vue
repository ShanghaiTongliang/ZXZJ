<style>
#pnl span {
  margin: 0 .2em;
  white-space: nowrap;
}
#pnl select {
  font-size: 1em;
  height: 1.5em;
  margin: 0 .2em .2em 0;
}
#pnl input {width: 4em}
#list {
  background-color: white;
  user-select: none;
  overflow: auto;
  border: inset 1px;
  flex-grow: 1;
}
</style>
<!--template>
  <div v-if="$route.name == 'zhengCheJiaoJian'">
    单位 <select v-model="danWei" @change="danWeiChange">
      <option v-for="(o, i) in $store.state.danWei" :value="o.id" :key="i">{{o.name}}</option>
    </select>
    车间 <select v-model="cheJian" @change="cheJianChange">
      <option v-for="(o, i) in (curDanWei && curDanWei.cheJian)" :value="o.id" :key="i">{{o.name}}</option>
    </select>
    <moditable :tbl="tbl" @editable="editable" @save="save" @delete="del">
      <a href="#/zhengCheJiaoJian/create" class="act">新建</a>
    </moditable>
  </div>
  <div v-else style="display: flex; flex-direction: column">
    <kvtable :tbl="kv" :vertical="$store.state.vertical" style="overflow: visible; flex-shrink: 0">
      <a href="#/zhengCheJiaoJian" class="act">返回</a>
    </kvtable>
  </div>
</template-->
<script>
import axios from 'axios'
import {mapState, mapMutations} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'
import {fixZhengCheJiaoJian} from './store'
import {PERMISSION_DATA, PERMISSION_MANAGE} from './global'

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
}, months = []

function init() {
  let d = new Date, y = d.getFullYear(), m = d.getMonth() + 1
  for(let i = 0; i < 6; i++) {
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
    if(this.$route.name == 'zhengCheJiaoJian') {
      let t = this.curCheJian && this.curCheJian.zhengCheJiaoJian.find(g => g.month == this.month)
      return h('div', [h('div', {attrs: {id: 'pnl'}}, [h('span', '单位'), h('select', {on: {
        change: e => this.danWei = parseInt(e.target.value)
      }}, this.$store.state.danWei && this.$store.state.danWei.map(
        (d, i) => h('option', {attrs: {value: d.id}, domProps: {selected: this.danWei == d.id}, key: i}, d.name)
      )),
      h('span', '车间'), h('select', {on: {
        change: e => this.cheJian = parseInt(e.target.value)
      }}, this.curDanWei && this.curDanWei.cheJian.map(
        (c, i) => h('option', {attrs: {value: c.id}, domProps: {selected: this.cheJian == c.id}, key: i}, c.name)
      )),
      h('span', '月份'), h('select', {on: {
        change: e => this.month = e.target.value
      }}, months.map((m, i) => h('option', {attrs: {value: m}, domProps: {selected: this.month == m}, key: i}, m))),
      h('span', '数量'), h('input', {attrs: {type: 'number'}, domProps: {value: t && t.count}}),
      ' ', h('button', {on: {
        click: e => axios.put('zxzj/api/zhengCheJiaoJian/count', {}).then(r => {

        }).catch(r => {

        })
      }}, '保存')]),
      h('moditable', {props: {tbl: this.tbl}, on: {
        editable: this.editable,
        save: this.save,
        delete: this.del
      }}, [h('a', {attrs: {href: '#/zhengCheJiaoJian/create', class: 'act'}}, '新建')])])

    } else {
  /*<div v-else style="display: flex; flex-direction: column">
    <kvtable :tbl="kv" :vertical="$store.state.vertical" style="overflow: visible; flex-shrink: 0">
      <a href="#/zhengCheJiaoJian" class="act">返回</a>
    </kvtable>
  </div>*/
      return h('div', [h('kvtable', {props: {tbl: this.kv, vertical: this.$store.state.vertical}},
        [h('a', {attrs: {href: '#/zhengCheJiaoJian', class: 'act'}}, '返回')])])
    }
    //if(this.$route.name == 'zhengCheJiaoJian')
    //  return h('div', ['aaa', h('div', 'fuck'), 'bbb'])
  },
  data() {
    return {
      danWei: 1,
      cheJian: 1,
      month: months[0],
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
              axios.post('zxzj/api/zhengCheJiaoJian', r).then(res => {
                r.id = res.data
                fixZhengCheJiaoJian.call(this.$store.state, r)
                this.$store.state.zhengCheJiaoJian.push(r)
                this.message('新建成功')
                this.$router.push('/zhengCheJiaoJian')
              })
              if(!this.list.length) {
                let l = {}
                l.guZhang = r.guZhang
                axios.post('zxzj/api/standard/guZhangList', l).then(r => {
                  l.id = r.data
                  this.std.guZhangList.push(l)
                }).catch(r => this.error(r.response.data))
              }
            })
          }
        }]
      },
    }
  },
  computed: {
    ...mapState(['user', 'std']),
    curDanWei() {
      return this.$store.state.danWei && this.$store.state.danWei.find(d => d.id == this.danWei)
    },
    curCheJian() {
      return this.curDanWei && this.curDanWei.cheJian.find(c => c.id == this.cheJian)
    }
    /*list() {
      let dict = this.$store.state.dict, d = this.kv.data, r
      return fields.reduce((gs, f) => gs.filter(
        g => !d[f] || dict[f][g[f]].name.includes(d[f])),
        this.std.guZhangList
      ).map(g => [`${dict.daBuWei[g.daBuWei].name} ${dict.guZhang[g.guZhang].name}`, g])
    }*/
  },
  watch: {
    $route: {
      immediate: true,
      handler(to) {
        if(to.name == 'zhengCheJiaoJianCreate') {
          let d = {date: (new Date).toDate()}
          d.guZhang = ''
          this.kv.data = d
        }
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
    '$store.state.zhengCheJiaoJian': {
      deep: true,
      immediate: true,
      handler(v) {
        this.tbl.data = v
      }
    },
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    editable() {
      let dict = this.$store.state.dict.groups
      let r = this.user.groups.find(g => {
        return g == 255 || dict[g].cheJian.find(c => {
          let r = c.id == this.cheJian && c.permission & PERMISSION_DATA
          return r
        })
      })
      return r
    },
    saveFields(d, next) {
      let std = this.std, r = {date: d.date, xiuCheng: d.xiuCheng, cheZhong: d.cheZhong, user: d.user}, a = []
      if(!d.date)
        this.error('请选择 日期')
      else if(!d.user)
        this.error(`请选择 质检员`)
      else {
        if(!d.guZhang) {
          this.error(`请输入${columns[f].caption}`)
          return
        } else {
          let v = std.guZhang.find(v => v.name == d.guZhang)
          if(v)
            r.guZhang = v.id
          else
            if(confirm(`是否添加新的 故障: ${d.guZhang} ?`)) {
              this.loading(true)
              a.push(axios.post(`zxzj/api/standard/guZhang`, d.guZhang).then(res => {
                std.guZhang.push(res.data)
                this.$store.state.dict.guZhang[res.data.id] = res.data
                r.guZhang = res.data.id
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
        axios.put(`zxzj/api/zhengCheJiaoJian/${d.id}`, r).then(() => {
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
        axios.delete(`zxzj/api/zhengCheJiaoJian/${d.id}`).then(() => {
          this.loading(false)
          this.message('删除成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
    danWeiChange(e) {
      console.log(e)
    },
    cheJianChange(e) {
      console.log(e)
    }
  }
}
</script>
