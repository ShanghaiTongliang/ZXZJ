<style>
.group {
  border: inset 1px;
  margin: .1em;
}
.group span {
  text-align: left;
  min-width: 3em;
}
.group, .group span {display: inline-block}
</style>
<template>
  <moditable v-if="$route.name == 'groups'" :tbl="tbl" @editable="editable">
    <a href="#/group/create" class="act">新建用户组</a>
  </moditable>
  <moditable v-else-if="$route.name == 'group'" :tbl="tblGroup">
    <div class="act">
      <a href="#/group">返回</a>
      <a :href="`#/group/${$route.params.gid}/create`">添加车间</a>
    </div>
  </moditable>
  <kvtable v-else-if="$route.name == 'createGroupCheJian'" :tbl="kvPermission" :vertical="vertical">
    <a :href="`#/group/${$route.params.gid}`" class="act">返回</a>
  </kvtable>
  <kvtable v-else :tbl="kv" :vertical="vertical">
    <a href="#/group" class="act">返回</a>
  </kvtable>
</template>

<script>
import {mapState} from 'vuex'
import Kvtable from './components/Kvtable'
import Datable from './components/Datable'
import Moditable from './components/Moditable'

const cp = [{
  id: 1,
  name: '数据'
}, {
  id: 2,
  name: '管理'
}]
const columns = {
  id: {
    caption: 'id',
    type: 'number',
    editable() {
      return this.$route.name == 'createGroup'
    }
  },
  name: {
    caption: '名称',
    type: 'text',
    href: 'url'
  },
  cheJian: {
    caption: '车间',
    filter(cs) {
      return cs.map(o => this.cheJian.find(c => c.id == o.id).name).join(', ')
    },
    items: null,
    /*render(h, d, k, i, l) {
      if(l) {
        if(this.tbl.editingIndex == i) {
          return d[k].map((c, i) => {
            let r = [], j
            for(j = 0; j < cp.length; j++)
              r.push(h('label', [h('input', {
                attrs: {type: 'checkbox', value: 1 << j},
                domProps: {checked: c.permission >> j & 1},
                on: {
                  change: e => {
                    d[k][i].permission ^= e.target.value
                    console.log(e.target.value, e.target.checked, c.id, d[k][i].permission)
                  }
                }
              }), h('span', cp[j].name)]))
            return h('div', {class: 'group'}, [l.find(o => o.id == c.id).name, h('div', r)])
          })
        } else {
          return d[k].map(c => {
            let r = [], i
            for(i = 0; i < cp.length; i++)
              if(c.permission >> i & 1)
                r.push(cp[i].name)
            return l.find(o => o.id == c.id).name + '(' + r.join(',') + ')'
          }).join(', ')
        }
      }
    }*/
  }
}, colGroup = {
  id: 'id',
  name: '车间',
  permission: {
    caption: '权限',
    type: 'checkbox',
    items: cp
  }
}

export default {
  components: {Kvtable, Datable, Moditable},
  data() {
    return {
      tbl: {
        caption: '用户组',
        columns,
        data: this.$store.state.groups
      },
      kv: {
        caption: '新建用户组',
        columns,
        actions: [{
          caption: '保存',
          onclick(d) {
            this.$store.state.groups.push(d)
            this.$router.push('/group')
          }
        }],
        data: {},
        editing: true
      },
      tblGroup: {
        caption: null,
        columns: colGroup,
        data: null
      },
      kvPermission: {
        caption: '权限',
        columns: {
          id: {
            caption: '车间',
            type: 'select',
            items: null
          },
          permission: {
            caption: '权限',
            type: 'checkbox',
            items: cp
          }
        },
        actions: [{
          caption: '保存',
          onclick(d) {
            console.log(d)
          }
        }],
        editing: true,
        data: {}
      }
    }
  },
  computed: {
    ...mapState(['vertical']),
    cheJian() {
      let r = []
      this.$store.state.danWei.forEach(d => d.cheJian.forEach(c => r.push(c)))
      return r
    },
  },
  methods: {
    editable(d) {
      return d.id != 255
    },
    setGroup(gid) {
      let g = this.$store.state.groups.find(g => g.id == gid)
      this.tblGroup.caption = g.name + ' 用户组'
      this.tblGroup.data = g.cheJian.map(c => {
        let t = this.cheJian.find(v => v.id == c.id), p = [], i
        for(i = 0; i < cp.length; i++)
          if(c.permission & cp[i].id)
            p.push(cp[i].id)
        return {id: t.id, name: t.name, permission: p}
      })
      this.kvPermission.caption = g.name + ' 添加车间'
      this.kvPermission.columns.id.items = this.cheJian
    }
  },
  mounted() {
    this.tbl.columns.cheJian.items = this.cheJian
    if(this.$route.params.gid)
      this.setGroup(this.$route.params.gid)
  },
  beforeRouteUpdate(to, from, next) {
    if(to.name == 'createGroup')
      this.kv.data = {}
    else if(to.params.gid)
      this.setGroup(to.params.gid)
    next()
  }
}
</script>
