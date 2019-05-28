<style>
.text {
  background-color: white;
  flex-grow: 1;
  margin: .2em 0;
  font-size: 1.1em;
  text-align: left;
}
.attachment {
  display: inline-block;
  margin: .1em .2em;
  padding: .2em;
  background-color: rgba(0, 0, 0, .2);
  border-radius: .5em;
}
.attachment div {
  max-width: 10em;
  overflow: hidden;
  text-overflow: ellipsis;
}
.attachment button {float: right}
</style>
<script>
import axios from 'axios';
import Tabs from './components/Tabs'
import Datable from './components/Datable'
import Uploader, {addFile} from './components/Uploader'
import {mapState, mapMutations} from 'vuex';
import {sizeFilter, timeFilter} from './components/filters'
import {clone, exclude} from './components/merge'
import {PERMISSION_DATA, PERMISSION_MANAGE, dianWenState} from './global'

const columns = {
  title: {
    caption: '标题',
    href: 'url',
  },
  poster: {
    caption: '发布人',
    items: null
  },
  date: '发布日期',
  uncheck: {
    caption: '未签收',
    items: null
  },
  checkin: {
    caption: '已签收',
    items: null,
    filter(t) {
      let us = this.$store.state.dict.user
      return t.map(u => {
        let v = us[u.id]
        return v ? v.name : '已删除'
      }).join(', ')
    }
  },
  state: {
    caption: '状态',
    filter(t, i, r) {
      if(t = dianWenState.find(s => s.id == t))
        t = t.id ? t.name : `<span class="red">${t.name}</span>`
      return t
    }
  }
}, actions = [{
  caption: '删除',
  condition(d) {
    return this.$parent.user.manage.length
  },
  onclick(d) {
    if(confirm(`确定要删除 ${d.title} ?`)) {
      let i, p = this.$parent, ds = p.zhiJianYuan.dianWen
      p.loading(true)
      axios.delete(`api/zhiJianYuan/dianWen/${d.id}`).then(() => {
        p.loading(false)
        for(i = 0; i < ds.length; i++)
          if(ds[i].id == d.id) {
            p.zhiJianYuan.dianWen.splice(i, 1)
            break
          }
      })
    }
  }
}], colCheckin = {
  user: '质检员',
  date: '签收日期',
}, colFiles = {
  name: {
    caption: '标题',
    href: 'url',
    target: '_blank'
  },
  time: {
    caption: '时间',
    filter(t) {
      return new Date(t * 1000).toDateTime()
    }
  },
  size: {
    caption: '大小',
    filter: sizeFilter
  }
}

export default {
  components: {Tabs, Datable, Uploader},
  render(h) {
    let n = this.$route.name, r
    if(n == 'dianWens') {
      let a, c, p
      if(this.user.manage.length)
        a = h('div', {style: 'text-align: left'}, [h('a', {attrs: {href: '#/zhiJianYuan/dianWen/create'}, class: 'act static'}, '新建')])
      p = h('tabs', {props: {tabs: this.tabs}, ref: 'tab', on: {
        tabIndex: this.tabIndex
      }}, this.tbls.map((t, i) => h('div', {slot: i}, [
        h('datable', {props: {table: t, selection: t.selection}, ref: `tbl${i}`, on: {
          rowSelect: this.rowSelect
        }}),
        h('datable', {props: {table: this.tblCheckin[i]}})
      ])))
      return a ? h('div', [a, p]) : p
    } else if(n == 'dianWen') {
      let m = this.user.manage.find(d => d.cheJian.find(c => this.curDianWen.cheJian.includes(c.id))), cs = this.dict.cheJian
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [this.curDianWen.title, h('div', {class: 'act'}, [
          h('a', {attrs: {href: '#/zhiJianYuan/dianWen'}}, '返回'), ' ',
          m ? h('a', {attrs: {href: `#/zhiJianYuan/dianWen/${this.curDianWen.id}/edit`}}, '编辑') : null
        ])]),
        m ? h('div', `下发至: ${this.curDianWen.cheJian.map(c => cs[c].name).join(', ')}`) : null,
        h('pre', {class: 'text'}, this.curDianWen.detail),
        h('div', [h('span', {style: 'float: left'}, '附件'), this.curDianWen.attachments.map(a => h('div', {class: 'uploader'}, [h('div', [h('a', {attrs: {href: a.url, target: '_blank'}}, a.name)]), h('span', sizeFilter(a.size))]))]),
        this.curDianWen.state === 0 ? h('div', [h('button', {on: {
          click: this.checkin
        }}, '签收')]) : null
      ])
    } else if(n == 'createDianWen' || n == 'editDianWen') {
      let cs = this.cheJians.map(c => h('label', [
        h('input', {attrs: {type: 'checkbox', value: c.id}, domProps: {checked: this.dianWen.cheJian.includes(c.id)}, on: {
          change: e => {
            let i, v = parseInt(e.target.value)
            if(e.target.checked) {
              this.dianWen.cheJian.push(v)
              this.dianWen.cheJian.sort()
            } else {
              i = this.dianWen.cheJian.indexOf(v)
              this.dianWen.cheJian.splice(i, 1)
            }
          }
        }}), c.name
      ]))
      cs.push(h('label', [h('input', {attrs: {type: 'checkbox'}, domProps: {checked: this.all}, on: {
        change: e => {
          this.all = e.target.checked
          this.dianWen.cheJian = this.all ? this.cheJians.map(c => c.id) : []
        }
      }}), '全部']))
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [
          `${this.new ? '新建' : '编辑'}质检员工作评价`,
          h('a', {attrs: {href: `#/zhiJianYuan/dianWen${this.new ? '' : '/' + this.curDianWen.id}`, class: 'act'}}, '返回')
        ]),
        h('div', {class: 'group tc-chk'}, cs),
        h('div', {style: {display: 'flex'}}, ['标题', h('input', {style: {flexGrow: 1, marginLeft: '.5em'}, domProps: {value: this.dianWen.title}, on: {
          input: e => this.dianWen.title = e.target.value
        }})]),
        h('textarea', {style: {flexGrow: 1, margin: '.2em 0'}, domProps: {value: this.dianWen.detail}, on: {
          input: e => this.dianWen.detail = e.target.value
        }}),
        h('uploader', {props: {files: this.dianWen.attachments, maxSize: this.options.zhiJianYuan.uploadMaxSize}, on: {
          error: e => this.error(e)
        }, ref: 'uploader'}, [
          h('div', {style: 'float: right'}, [
            this.dianWen.attachments.length < 5 && h('button', {on: {
              click: this.addAttachment
            }}, '添加附件'), ' ', h('button', {on: {
              click: this.save
            }}, '保存')
          ])
        ])
      ])
    } else if(n == 'zhiDaoShu')
      return h('datable', {props: {table: this.tblZhiDaoShu}, class: 'container'}, this.user.manage.length ? [
        h('button', {class: 'act', on: {
          click: () => this.upload('zhiDaoShu')
        }}, '上传')
      ] : null)
    else
      return h('datable', {props: {table: this.tblZiLiao}, class: 'container'}, this.user.manage.length ? [
        h('button', {class: 'act', on: {
          click: () => this.upload('ziLiao')
        }}, '上传')
      ] : null)
  },
  data() {
    return {
      dianWen: null,
      curDianWen: null,
      new: true,
      all: true,
      tbls: null,
      tblCheckin: null,
      tblZhiDaoShu: {
        caption: '质检作业指导书',
        columns: colFiles,
        actions: [{
          caption: '更新',
          condition() {
            return this.user.manage.length
          },
          onclick(d) {
            this.update('zhiDaoShu', d)
          }
        }, {
          caption: '删除',
          condition() {
            return this.user.manage.length
          },
          onclick(d) {
            this.delete('zhiDaoShu', d)
          }
        }],
        data: this.$store.state.zhiJianYuan.zhiDaoShu
      },
      tblZiLiao: {
        caption: '学习资料',
        columns: colFiles,
        actions: [{
          caption: '更新',
          condition() {
            return this.user.manage.length
          },
          onclick(d) {
            this.update('ziLiao', d)
          }
        }, {
          caption: '删除',
          condition() {
            return this.user.manage.length
          },
          onclick(d) {
            this.delete('ziLiao', d)
          }
        }],
        data: this.$store.state.zhiJianYuan.ziLiao
      },
      uploadOption: {
        onUploadProgress: e => e.total && this.progress(e.loaded / e.total)
      }
    }
  },
  computed: {
    ...mapState(['dict', 'user', 'dict', 'options', 'zhiJianYuan']),
    tabs() {
      let r = [], ks = ['uncheck', 'checkin'], c, id, gs = this.dict.groups
      this.tbls = []
      this.tblCheckin = []
      for(id in this.user.permission) {
        let p = this.user.permission[id] == PERMISSION_DATA, us, ds
        c = {...columns}
        id = parseInt(id)
        us = this.$store.state.users.filter(u => {
          return u.groups.find(g => {
            return gs[g].cheJian.find(c => c.id == id)
          })
        }).map(u => u.id)
        ds = this.zhiJianYuan.dianWen.filter(d => d.cheJian.includes(id)).map(d => {
          let r = {...d}, c = this.dict.cheJian[id]
          r.checkin = d.checkin.filter(u => us.find(v => v == u.id))
          r.uncheck = d.uncheck.filter(u => us.includes(u))
          return r
        })
        r.push(this.dict.cheJian[id].name)
        ks.forEach(k => c[k] = {...columns[k], condition: !p})
        c.state = {...columns.state, condition: p}
        this.tbls.push({
          id,
          caption: this.dict.cheJian[id].name,
          columns: c,
          actions,
          data: ds,
          selection: null
        })
        this.tblCheckin.push({
          caption: '签收情况',
          columns: colCheckin,
          data: null
        })
      }
      if(r.length > 1) {
        c = {...columns}
        ks.forEach(k => c[k] = {...columns[k], condition: true})
        c.state = {...columns.state, condition: false}
        r.unshift('全部')
        this.tbls.unshift({
          caption: '全部',
          columns: c,
          actions,
          data: this.zhiJianYuan.dianWen,
          selection: null
        })
        this.tblCheckin.unshift({
          caption: '签收情况',
          columns: colCheckin,
          data: null
        })
      }
      return r
    },
    cheJians() {
      let r = [], d = this.dict.cheJian, c, p = this.user.permission
      for(c in p)
        if(p[c] & PERMISSION_MANAGE)
          r.push(d[c])
      return r
    }
  },
  watch: {
    '$route': {
      immediate: true,
      handler(r) {
        if(r.name == 'createDianWen') {
          this.new = true
          this.all = true
          this.dianWen = {poster: this.user.id, date: (new Date).toDate(), cheJian: this.cheJians.map(c => c.id), attachments: [], checkin: []}
        } else if(r.name == 'dianWen' || r.name == 'editDianWen') {
          this.new = false
          this.curDianWen = this.zhiJianYuan.dianWen.find(p => p.id == r.params.id)
          if(r.name == 'editDianWen')
            this.dianWen = clone(this.curDianWen)
        }
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'progress', 'message', 'error']),
    tabIndex(i) {
      setTimeout(() => this.$refs[`tbl${i}`].onScroll(), 0)
    },
    rowSelect(d) {
      let i = this.$refs.tab.tabIdx, us = this.dict.user
      this.tbls[i].selection = d
      this.tblCheckin[this.$refs.tab.tabIdx].data = d.checkin.map(u => ({user: us[u.id].name, date: u.date}))
    },
    addAttachment() {
      this.$refs.uploader.addFile()
    },
    _save(f, url, cb) {
      this.loading(true)
      let fd = new FormData
      this.$refs.uploader.added.forEach((f, i) => fd.append(`attachment${i}`, f.file, f.name))
      fd.append('dianWen', JSON.stringify({
        ...exclude(this.dianWen, ['url', 'users', 'uncheck']),
        attachments: this.dianWen.attachments.filter(a => !a.deleted).map(a => ({name: a.name, size: a.size}))
      }))
      f.call(axios, url, fd, this.uploadOption).then(r => {
        this.$refs.uploader.deleted.forEach(a => this.dianWen.attachments.splice(this.dianWen.attachments.indexOf(a), 1))
        this.$refs.uploader.added.forEach(a => a.url = `zhiJianYuan/dianWen/${this.dianWen.id}/${a.name}`)
        cb(r)
        this.loading(false)
        this.message('保存成功')
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    },
    save() {
      if(!this.dianWen.title)
        this.error('请输入标题')
      else if(!this.dianWen.detail)
        this.error('请输入内容')
      else {
        if(this.new)
          this._save(axios.post, 'api/zhiJianYuan/dianWen', r => {
            this.dianWen.id = r.data.id
            this.zhiJianYuan.dianWen.push(this.dianWen)
            this.$store.state.fixDianWen.call(this.$store.state, this.dianWen)
            this.$router.push(`/zhiJianYuan/dianWen/${this.dianWen.id}`)
          })
        else {
          let id = this.dianWen.id
          this._save(axios.post, `api/zhiJianYuan/dianWen/${id}`, r => {
            for(let k in this.dianWen)
              this.curDianWen[k] = this.dianWen[k]
            this.$router.push(`/zhiJianYuan/dianWen/${id}`)
          })
        }
      }
    },
    upload(t) {
      addFile(f => {
        if(this.zhiJianYuan[t].find(d => d.name == f.name)) {
          this.error(`${f.name} 已经存在`)
          return
        }
        this.loading(true)
        let fd = new FormData
        fd.append('file', f)
        axios.post(`api/zhiJianYuan/${t}`, fd, this.uploadOption).then(() => {
          let d = {name: f.name, time: f.lastModifiedDate.getTime() / 1000, size: f.size}
          this.$store.state.fixFile(d, t)
          this.zhiJianYuan[t].push(d)
          this.loading(false)
          this.message('上传成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }, e => this.error(e), this.options.zhiJianYuan.uploadMaxSize)
    },
    update(t, d) {
      addFile(f => {
        if(this.zhiJianYuan[t].find(d => d.name == f.name)) {
          this.error(`${f.name} 已经存在`)
          return
        }
        this.loading(true)
        let fd = new FormData
        fd.append('file', f)
        fd.append('name', d.name)
        axios.post(`api/zhiJianYuan/${t}`, fd).then(() => {
          d.name = f.name
          d.time = f.lastModifiedDate.getTime() / 1000
          d.size = f.size
          d.url = `zhiJianYuan/${t}/${f.name}`
          this.loading(false)
          this.message('更新成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }, e => this.error(e), this.options.zhiJianYuan.uploadMaxSize)
    },
    delete(t, d) {
      if(confirm(`确定要删除 ${d.name} ?`)) {
        this.loading(true)
        axios.delete(`api/zhiJianYuan/${t}`, {data: {name: d.name}}).then(() => {
          let i = this.zhiJianYuan[t].indexOf(d)
          this.zhiJianYuan[t].splice(i, 1)
          this.loading(false)
          this.message('删除成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      }
    },
    checkin() {
      this.loading(true)
      axios.put(`api/zhiJianYuan/dianWen/${this.curDianWen.id}/checkin`).then(r => {
        this.curDianWen.state = 1
        this.curDianWen.checkin.push(r.data)
        for(let i in this.curDianWen.uncheck)
          if(this.curDianWen.uncheck[i].id == this.user.id) {
            this.curDianWen.uncheck.splice(i, 1)
            break
          }
        this.loading(false)
        this.message('签收成功')
      }).catch(r => {
        this.loading(false)
        this.error(r.response.data)
      })
    }
  },
  created() {
    columns.poster.items = columns.uncheck.items = columns.checkin.items = this.$store.state.users
  }
}
</script>
