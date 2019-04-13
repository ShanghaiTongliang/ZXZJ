<script>
import axios from 'axios'
import { mapMutations, mapState } from 'vuex';
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import Kvtable from './components/Kvtable'

const tier = ['danWei', 'cheJian', 'user'],
ids = ['did', 'cid', 'bid'],
fix = {
  danWei: 'fixDanWei',
  cheJian: 'fixCheJian'
},
names = {
  danWei: '单位',
  cheJian: '作业场',
  user: '用户'
},
columns = {
  id: 'id',
  name: {
    caption: null,
    type: 'text',
    href: 'url'
  }
}

export default {
  components: {Datable, Kvtable, Moditable},
  render(h) {
    let n = this.$route.name, p = this.$route.params
    if(n.substr(0, 6) == 'create') {
      n = this.$route.matched[this.$route.matched.length - 2].name
      let [t, pre, cur] = this.cal(n, p)
      this.kv.caption = `新建${names[n]}`
      this.kv.data = {}
      return h('kvtable', {props: {table: this.kv}}, [h('a', {attrs: {href: `#${pre}${cur}`, class: 'act'}}, '返回')])
    } else {
      let a = [], [t, pre, cur] = this.cal(n, p)
      if(t < 0)
        this.tbl.caption = '单位'
      else {
        this.tbl.caption = this.dict[tier[t]][p[ids[t]]].name
        a.push(h('a', {attrs: {href: `#${pre}`}}, '返回'))
      }
      let u
      if(t < 1) {
        if(a.length)
          a.push(' ')
        a.push(h('a', {attrs: {href: `#${pre}${cur}/create`}}, `新建${names[n]}`))
        this.tbl.readonly = false
        if(t >= 0) {
          let us = this.$store.state.users.filter(u => u[tier[t]] == p[ids[t]])
          this.tblUser.data = us
          u = h('datable', {props: {table: this.tblUser}}, [h('div', {class: 'dt-info'}, `共${us.length}人`)])
        }
      } else
        this.tbl.readonly = true
      columns.name.caption = names[n]
      this.tbl.data = this[n]
      return h('div', [h('moditable', {props: {table: this.tbl}, on: {
        save: this.save,
        delete: this.del
      }}, [h('div', {attrs: {class: 'act'}}, a), h('div', {attrs: {class: 'dt-info'}}, `共${this[n].length}${names[tier[t + 1]]}`)]), u])
    }
  },
  data() {
    return {
      tbl: {
        caption: null,
        columns,
        editingIndex: -1,
        data: null
      },
      tblUser: {
        caption: '全部用户',
        columns: {
          id: 'id',
          name: {
            caption: '用户名',
            href: 'url'
          }
        },
        data: null
      },
      kv: {
        caption: null,
        columns,
        actions: [{
          caption: '新建',
          onclick(v) {
            let r = this.$route, m = r.matched[r.matched.length - 2], n = m.name, [t, pre, cur] = this.cal(n, this.$route.params)
            if(!v.name)
              this.error(`请输入${names[n]}名称`)
            else if(this[n].find(d => d.name == v.name))
              this.error(`${v.name} 已经存在`)
            else {
              this.loading(true)
              axios.post(`api${pre}${cur}`, v).then(res => {
                this.loading(false)
                v.id = res.data.id
                if(t >= 0)
                  v[tier[t]] = r.params[ids[t]]
                v[tier[t + 2]] = []
                if(n == 'cheJian')
                  v.jiaoJian = []
                this.$store.state[fix[n]](v)
                this[n].push(v)
                this.$router.push({name: n})
                this.message('新建成功')
              }).catch(r => {
                this.loading(false)
                this.error(r.response.data)
              })
            }
          }
        }],
        data: {},
        editing: true
      }
    }
  },
  computed: {
    ...mapState(['dict', 'danWei']),
    cheJian() {
      return this.dict.danWei[this.$route.params.did].cheJian
    },
    user() {
      return this.dict.cheJian[this.$route.params.cid].user
    }
  },
  watch: {
    $route(v) {
      this.tbl.editingIndex = -1
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    cal(n, p) {
      let i, t = tier.indexOf(n) - 1, pre = '', cur = ''
      for(i = -1; i < t; i++) {
        if(i >= 0)
          pre += `/${p[ids[i]]}`
        pre += `/${tier[i + 1]}`
      }
      if(t >= 0)
        cur = `/${p[ids[t]]}`
      cur += `/${tier[t + 1]}`
      return [t, pre, cur]
    },
    save(d, i, next) {
      let n = this.$route.name, [t, pre, cur] = this.cal(n, this.$route.params)
      if(this[n].find(v => v.name == d.name)) {
        this.error(`${names[n]} ${d.name} 已经存在`)
        return
      }
      this.loading(true)
      axios.put(`api${pre}${cur}/${d.id}`, {name: d.name}).then(r => {
        this.loading(false)
        this.message('保存成功')
        next()

      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },
    del(d, i, next) {
      let n = this.$route.name, [t, pre, cur] = this.cal(n, this.$route.params)
      t += 2
      if(d[tier[t]].length)
        this.error(`请先删除 ${d.name} 内的所有${names[tier[t]]}`)
      else if(confirm(`确定要删除 ${d.name} ?`)) {
        this.loading(true)
        axios.delete(`api${pre}${cur}/${d.id}`).then(r => {
          this.loading(false)
          this.message('删除成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    }
  }
}
</script>
