<script>
import axios from 'axios'
import {mapState, mapMutations} from 'vuex'
import Kvtable from './components/Kvtable'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import {permissions} from './global'

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
      let d = this.$store.state.dict.cheJian
      return cs.map(c => {
        let i, r = d[c.id].name
        for(i = 0; i < permissions.length; i++)
          if(c.permission & permissions[i].id)
            r += ' ' + `<span class="${permissions[i].color}">${permissions[i].name}</span>`
        return r
      }).join(', ')
    },
    items: null,
  }
}, colGroup = {
  id: {
    caption: '车间',
    type: 'select',
    items: null
  },
  permission: {
    caption: '权限',
    type: 'checkbox',
    items: permissions
  }
}

export default {
  components: {Kvtable, Datable, Moditable},
  render(h) {
    switch(this.$route.name) {
    case 'groups':
      return h('moditable', {props: {table: this.tbl}, on: {
        editable: this.editable,
        save: this.save,
        delete: this.del
      }}, [h('a', {attrs: {href: '#/group/create', class: 'act'}}, '新建用户组')])
      break
    case 'group':
      return h('moditable', {props: {table: this.tblGroup}, on: {
        save: this.groupSave,
        delete: this.groupDel
      }}, [h('div', {attrs: {class: 'act'}}, [
        h('a', {attrs: {href: '#/group'}}, '返回'), ' ',
        h('a', {attrs: {href: `#/group/${this.$route.params.gid}/create`}}, '添加车间')
      ])])
      break
    case 'createGroupCheJian':
      this.kvPermission.columns.id.items = this.cheJian.filter(c => !this.group.cheJian.find(v => v.id == c.id))
      return h('kvtable', {props: {table: this.kvPermission, vertical: this.vertical}},
        [h('a', {attrs: {href: `#/group/${this.$route.params.gid}`, class: 'act'}}, '返回')])
      break
    default:
      return h('kvtable', {props: {table: this.kv, vertical: this.vertical}},
        [h('a', {attrs: {href: `#/group/${this.$route.params.gid}`, class: 'act'}}, '返回')])
    }
  },
  data() {
    return {
      tbl: {
        caption: '用户组',
        columns,
        data: null
      },
      kv: {
        caption: '新建用户组',
        columns,
        actions: [{
          caption: '保存',
          onclick(d) {
            let id = parseInt(d.id), g
            if(isNaN(id) || id < 1 || id > 254)
              this.error('id 范围: 1~254')
            else if(!d.name)
              this.error('请输入用户组名称')
            else if(g = this.groups.find(g => g.id == d.id || g.name == d.name))
              this.error(`${g.id}: ${g.name} 已经存在`)
            else {
              this.loading(true)
              axios.post('zxzj/api/group', d).then(() => {
                this.groups.push(d)
                this.groups.sort((a, b) => a.id - b.id)
                this.$store.state.fixGroup(d)
                this.$router.push('/group')
                this.loading(false)
                this.message('保存成功')
              }).catch(r => {
                this.loading(false)
                this.error(r.response.data)
              })
            }
          }
        }],
        data: null,
        editing: true
      },
      tblGroup: {
        caption: null,
        columns: colGroup,
        data: null
      },
      kvPermission: {
        caption: null,
        columns: {
          id: {
            caption: '车间',
            type: 'select',
            items: null
          },
          permission: {
            caption: '权限',
            type: 'checkbox',
            items: permissions
          }
        },
        actions: [{
          caption: '保存',
          onclick(d) {
            if(!d.id) {
              this.error('请选择车间')
              return
            }
            let g = {cheJian: [...this.group.cheJian]}, i, p = 0
            if(!d.permission) d.permission = []
            d.permission.forEach(v => p |= v)
            g.cheJian.push({id: d.id, permission: p})
            this.loading(true)
            axios.put(`zxzj/api/group/${this.group.id}`, g).then(() => {
              this.group.cheJian = g.cheJian
              this.loading(false)
              this.message('保存成功')
              this.$router.push(`/group/${this.group.id}`)
            }).catch(r => {
              this.loading(false)
              this.error(r.response.data)
            })
          }
        }],
        editing: true,
        data: null
      }
    }
  },
  computed: {
    ...mapState(['vertical', 'groups']),
    group() {
      let id = this.$route.params.gid
      return id && this.groups.find(g => g.id == id)
    },
    cheJian() {
      let r = []
      this.$store.state.danWei.forEach(d => d.cheJian.forEach(c => r.push(c)))
      return r
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler(to, from) {
        switch(to.name) {
        case 'groups':
          this.tbl.columns.cheJian.items = this.cheJian
          this.tbl.data = this.groups
          break
        case 'createGroup':
          let i
          for(i = 1; i < 255; i++)
            if(!this.groups.find(g => g.id == i))
              break
          this.kv.data = {id: i, name: null, cheJian: []}
          break
        case 'createGroupCheJian':
          this.kvPermission.data = {permission: []}
        default:
          let g = this.group
          if(g) {
            if(to.name == 'group') {
              this.tblGroup.caption = g.name + ' 用户组'
              this.tblGroup.data = g.cheJian.map(c => {
                let t = this.cheJian.find(v => v.id == c.id), p = [], i
                for(i = 0; i < permissions.length; i++)
                  if(c.permission & permissions[i].id)
                    p.push(permissions[i].id)
                return {id: t.id, name: t.name, permission: p}
              })
              this.tblGroup.columns.id.items = this.cheJian
            } else
              this.kvPermission.caption = g.name + ' 添加车间'
          } else
            this.$router.replace('/group')
        }
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    editable(d) {
      return d.id != 255
    },
    save(d, i, next) {
      if(this.groups.find(g => g.name == d.name))
        this.error(`用户组 ${d.name} 已经存在`)
      else {
        this.loading(true)
        axios.put(`zxzj/api/group/${d.id}`, {name: d.name}).then(() => {
          this.loading(false)
          this.message('保存成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
    del(d, i, next) {
      if(this.$store.state.users.find(u => u.groups.find(g => g == d.id)))
        this.error(`请先删除 ${d.name} 下所有用户`)
      else if(confirm(`确定要删除 ${d.name} ?`)) {
        this.loading(true)
        axios.delete(`zxzj/api/group/${d.id}`).then(() => {
          this.loading(false)
          this.message('删除成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
    groupSave(d, i, next) {
      let g, j, p = 0, cs = this.tblGroup.data
      for(j = 0; j < cs.length; j++)
        if(j != i && cs[j].id == d.id) {
          this.error(`${cs[j].name} 已经存在`)
          return
        }
      for(j = 0; j < d.permission.length; j++)
        p |= d.permission[j]
      g = this.group
      cs = g.cheJian.map(c => ({...c}))
      cs[i].id = d.id
      cs[i].permission = p
      this.loading(true)
      axios.put(`zxzj/api/group/${g.id}`, {cheJian: cs}).then(() => {
        g.cheJian[i].id = cs[i].id
        g.cheJian[i].permission = cs[i].permission
        this.loading(false)
        this.message('保存成功')
        next()
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },
    groupDel(d, i, next) {
      if(confirm(`确定要删除 ${d.name} ?`)) {
        this.loading(true)
        let c = [...this.group.cheJian]
        c.splice(i, 1)
        axios.put(`zxzj/api/group/${this.group.id}`, {cheJian: c}).then(() => {
          this.group.cheJian.splice(i, 1)
          this.loading(false)
          this.message('保存成功')
          next()
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
  }
}
</script>
