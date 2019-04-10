<style>
.text {
  background-color: white;
  flex-grow: 1;
  margin: .2em 0;
  font-size: 1.1em;
  text-align: left;
}
</style>
<script>
import axios from 'axios';
import Tabs from './components/Tabs'
import Datable from './components/Datable'
import { mapState, mapMutations } from 'vuex';

const columns = {
  title: {
    caption: '标题',
    href: 'url',
  },
  poster: {
    caption: '发布人',
    items: null
  }
}
export default {
  components: {Tabs, Datable},
  render(h) {
    let n = this.$route.name, r
    if(n == 'pingJias') {
      return h('tabs', {props: {tabs: this.tabs}},
        this.tbls.map((t, i) => h('datable', {props: {table: t}, slot: i}, [h('a', {attrs: {href: '#/pingJia/create', class: 'act'}}, '新建')])))
    } else if(n == 'pingJia')
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [this.curPingJia.title, h('div', {class: 'act'}, [
          h('a', {attrs: {href: '#/pingJia'}}, '返回'), ' ',
          h('a', {attrs: {href: `#/pingJia/${this.curPingJia.id}/edit`}}, '编辑')
        ])]),
        h('pre', {class: 'text'}, this.curPingJia.detail),
        //this.user.permission[]
        h('div', [h('button', '签收')])
      ])
    else if(n == 'createPingJia' || n == 'editPingJia')
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [
          `${this.new ? '新建' : '编辑'}质检员工作评价`,
          h('a', {attrs: {href: `#/pingJia${this.new ? '' : '/' + this.curPingJia.id}`, class: 'act'}}, '返回')
        ]),
        h('div', {class: 'group tc-chk'}, this.cheJians.map(c => h('label', [
          h('input', {attrs: {type: 'checkbox', value: c.id}, domProps: {checked: this.pingJia.cheJian.includes(c.id)}, on: {
            change: e => {
              let i, v = parseInt(e.target.value)
              if(e.target.checked) {
                this.pingJia.cheJian.push(v)
                this.pingJia.cheJian.sort()
              } else {
                i = this.pingJia.cheJian.indexOf(v)
                this.pingJia.cheJian.splice(i, 1)
              }
            }
          }}), c.name
        ]))),
        h('div', {style: {display: 'flex'}}, ['标题', h('input', {style: {flexGrow: 1, marginLeft: '.5em'}, domProps: {value: this.pingJia.title}, on: {
          input: e => this.pingJia.title = e.target.value
        }})]),
        h('textarea', {style: {flexGrow: 1, margin: '.2em 0'}, domProps: {value: this.pingJia.detail}, on: {
          input: e => this.pingJia.detail = e.target.value
        }}),
        h('div', [h('button', {on: {
          click: this.save
        }}, '保存')])
      ])
  },
  data() {
    return {
      pingJia: null,
      curPingJia: null,
      new: true,
      tbls: []
    }
  },
  computed: {
    ...mapState(['dict', 'user', 'dict']),
    tabs() {
      let r = [], pj = this.$store.state.pingJia, ps
      for(let id in this.user.permission) {
        ps = pj.filter(p => p.cheJian.includes(parseInt(id)))
        r.push(this.dict.cheJian[id].name)
        this.tbls.push({
          caption: this.dict.cheJian[id].name,
          columns,
          data: ps
        })
      }
      return r
    },
    cheJians() {
      let r = [], d = this.dict.cheJian
      for(let id in this.user.permission)
        r.push(d[id])
      return r
    }
  },
  watch: {
    '$route': {
      immediate: true,
      handler(r) {
        if(r.name == 'createPingJia') {
          this.new = true
          this.pingJia = {cheJian: []}
        } else if(r.name == 'pingJia' || r.name == 'editPingJia') {
          this.new = false
          this.curPingJia = this.$store.state.pingJia.find(p => p.id == r.params.id)
          if(r.name == 'editPingJia')
            this.pingJia = {...this.curPingJia}
        }
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    _save(f, url, cb) {
      this.loading(true)
      f.call(axios, url, this.pingJia).then(r => {
        cb(r)
        this.loading(false)
        this.message('保存成功')
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },
    save() {
      if(!this.pingJia.title)
        this.error('请输入标题')
      else if(!this.pingJia.detail)
        this.error('请输入内容')
      else {
        if(this.new)
          this._save(axios.post, 'api/pingJia', r => {
            this.pingJia.id = r.data.id
            this.$store.state.pingJia.push(this.pingJia)
            this.$router.push('/pingJia')
          })
        else {
          let id = this.pingJia.id
          delete this.pingJia.id
          delete this.pingJia.url
          this._save(axios.put, `api/pingJia/${id}`, r => {
            for(let k in this.pingJia)
              this.curPingJia[k] = this.pingJia[k]
            this.$router.push(`/pingJia/${id}`)
          })
        }
      }
    }
  },
  created() {
    columns.poster.items = this.$store.state.users
  }
}
</script>
