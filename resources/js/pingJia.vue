<script>
import Tabs from './components/Tabs'
import Datable from './components/Datable'
import { mapState } from 'vuex';

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
    let n = this.$route.name, c = '质检员工作评价'
    if(n == 'pingJias') {
      return h('tabs', {props: {tabs: this.tabs}},
        this.tbls.map((t, i) => h('datable', {props: {table: t}, slot: i}, [h('a', {attrs: {href: '#/pingJia/create', class: 'act'}}, '新建')])))
    } else {
      if(n == 'createPingJia') {
        c = '新建' + c
      } else {
        c = '编辑' + c
      }
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {style: {position: 'relative', fontWeight: 'bold'}}, [c, h('a', {attrs: {href: '#/pingJia', class: 'act'}}, '返回')]),
        h('div', {class: 'group'}, ['收件人 单位 ', h('select', {on: {
          change: e => this.danWei = e.target.value
        }}, this.danWeis.map(d => h('option', {attrs: {value: d.id}}, d.name))), '单位 ', h('select', {on: {
          change: e => this.cheJian = e.target.value
        }}, this.curDanWei.cheJian.map(d => h('option', {attrs: {value: d.id}}, d.name)))]),
        h('div', {style: {display: 'flex'}}, ['标题', h('input', {style: {flexGrow: 1, marginLeft: '.5em'}, domProps: {value: this.curPingJia.title}})]),
        h('textarea', {style: {flexGrow: 1, margin: '.2em 0'}, domProps: {value: this.curPingJia.detail}}),
        h('div', [h('button', '保存')])
      ])
    }
  },
  data() {
    return {
      danWei: 0,
      cheJian: 0,
      curPingJia: null,
      tbls: []
    }
  },
  computed: {
    ...mapState(['dict', 'user']),
    tabs() {
      let r = [], pj = this.$store.state.pingJia, ps
      for(let id in this.user.permission) {
        ps = pj.filter(p => p.cheJian == id)
        r.push(this.dict.cheJian[id].name)
        this.tbls.push({
          caption: this.dict.cheJian[id].name,
          columns,
          data: ps
        })
      }
      return r
    },
    danWeis() {
      let r = [{id: 0, name: '全部', cheJian: [{id: 0, name: '全部'}]}]
      this.$store.state.danWei.forEach(d => r.push(d))
      return r
    },
    curDanWei() {
      let r = [{id: 0, name: '全部', banZu: [{id: 0, name: '全部'}]}], t
      if(t = this.danWeis.find(d => d.id == this.danWei)) {
        if(t.id) {
          t.cheJian.forEach(c => r.push(c))
          return {id: t.id, name: t.name, cheJian: r}
        } else {
          this.cheJian = 0
          return t
        }
      }
    }
  },
  watch: {
    '$route': {
      immediate: true,
      handler(r) {
        if(r.name == 'createPingJia')
          this.curPingJia = {}
        else if(r.name == 'pingJia')
          this.curPingJia = this.$store.state.pingJia.find(p => p.id == r.params.id)
      }
    }
  }
}
</script>
