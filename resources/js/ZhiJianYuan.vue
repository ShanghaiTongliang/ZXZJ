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
import {sizeFilter} from './components/filters'
import {mapState, mapMutations} from 'vuex';
import {timeFilter} from './components/filters'
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
    items: null
  },
  state: {
    caption: '状态',
    filter(t, i, r) {
      console.log(t, i, r)
      if(t = dianWenState.find(s => s.id == t))
        t = t.id ? t.name : `<span class="red">${t.name}</span>`
      return t
    }
  }
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
  components: {Tabs, Datable},
  render(h) {
    let n = this.$route.name, r
    if(n == 'dianWens') {
      let a, c, p
      if(this.user.manage.length)
        a = h('div', {style: 'text-align: left'}, [h('a', {attrs: {href: '#/zhiJianYuan/dianWen/create'}, class: 'act static'}, '新建')])
      p = h('tabs', {props: {tabs: this.tabs}, ref: 'tab', on: {
        tabIndex: this.onTabIndex
      }}, this.tbls.map((t, i) => h('datable', {props: {table: t}, slot: i, ref: `tbl${i}`, on: {
        rowSelect: this.rowSelect
      }})))
      return h('div', [a, p, h('datable', {props: {table: this.tblCheckin}})])
    } else if(n == 'dianWen') {
      let m = this.user.manage.find(d => d.cheJian.find(c => this.curDianWen.cheJian.includes(c.id))), cs = this.dict.cheJian
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [this.curDianWen.title, h('div', {class: 'act'}, [
          h('a', {attrs: {href: '#/zhiJianYuan/dianWen'}}, '返回'), ' ',
          m ? h('a', {attrs: {href: `#/zhiJianYuan/dianWen/${this.curDianWen.id}/edit`}}, '编辑') : null
        ])]),
        m ? h('div', `下发至: ${this.curDianWen.cheJian.map(c => cs[c].name).join(', ')}`) : null,
        h('pre', {class: 'text'}, this.curDianWen.detail),
        this.curDianWen.state === 0 ? h('div', [h('button', {on: {
          click: this.checkin
        }}, '签收')]) : null
      ])
    } else if(n == 'createDianWen' || n == 'editDianWen')
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [
          `${this.new ? '新建' : '编辑'}质检员工作评价`,
          h('a', {attrs: {href: `#/zhiJianYuan/dianWen${this.new ? '' : '/' + this.curDianWen.id}`, class: 'act'}}, '返回')
        ]),
        h('div', {class: 'group tc-chk'}, this.cheJians.map(c => h('label', [
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
        ]))),
        h('div', {style: {display: 'flex'}}, ['标题', h('input', {style: {flexGrow: 1, marginLeft: '.5em'}, domProps: {value: this.dianWen.title}, on: {
          input: e => this.dianWen.title = e.target.value
        }})]),
        h('textarea', {style: {flexGrow: 1, margin: '.2em 0'}, domProps: {value: this.dianWen.detail}, on: {
          input: e => this.dianWen.detail = e.target.value
        }}),
        h('div', [h('button', {on: {
          click: this.save
        }}, '保存')])
      ])
    else if(n == 'zhiDaoShu')
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
      tabIndex: 0,
      tbls: [],
      tblCheckin: {
        caption: '签收情况',
        columns: {
          user: '质检员',
          date: '签收日期',
        },
        data: null
      },
      tblZhiDaoShu: {
        caption: '质检作业指导书',
        columns: colFiles,
        actions: [{
          caption: '更新',
          onclick(d) {
            this.update('zhiDaoShu', d)
          }
        }, {
          caption: '删除',
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
          onclick(d) {
            this.update('ziLiao', d)
          }
        }, {
          caption: '删除',
          onclick(d) {
            this.delete('ziLiao', d)
          }
        }],
        data: this.$store.state.zhiJianYuan.ziLiao
      }
    }
  },
  computed: {
    ...mapState(['dict', 'user', 'dict', 'options', 'zhiJianYuan']),
    tabs() {
      let r = [], ks = ['uncheck', 'checkin'], c, id, gs = this.dict.groups
      this.tbls = []
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
          r.checkin = d.checkin.filter(u => us.includes(u))
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
          data: ds
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
          data: this.zhiJianYuan.dianWen
        })
      }
      if(this.tbls[0].data.length)
        this.tblCheckin.selection = this.tbls[0]
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
        if(r.name == 'dianWens') {
          if(this.tbls.length && this.tbls[0].data.length)
            this.tblCheckin.selection = this.tbls[0].data[0]
        }
        else if(r.name == 'createDianWen') {
          this.new = true
          this.dianWen = {cheJian: [], checkin: []}
        } else if(r.name == 'dianWen' || r.name == 'editDianWen') {
          this.new = false
          this.curDianWen = this.zhiJianYuan.dianWen.find(p => p.id == r.params.id)
          if(r.name == 'editDianWen')
            this.dianWen = {...this.curDianWen}
        }
      }
    }
  },
  methods: {
    ...mapMutations(['loading', 'progress', 'message', 'error']),
    onTabIndex(i) {
      this.tabIndex = i
      this.tblCheckin.data = this.tbls[i].selection
      setTimeout(() => this.$refs[`tbl${i}`].onScroll(), 0)
    },
    rowSelect(d, i, r) {
      this.$refs[`tbl${this.$refs.tab.tabIdx}`].selection = d
      this.tblCheckin.data = d
    },
    _save(f, url, cb) {
      this.loading(true)
      f.call(axios, url, this.dianWen).then(r => {
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
            this.$router.push('/zhiJianYuan/dianWen')
          })
        else {
          let id = this.dianWen.id
          delete this.dianWen.id
          delete this.dianWen.url
          this._save(axios.put, `api/zhiJianYuan/dianWen/${id}`, r => {
            for(let k in this.dianWen)
              this.curDianWen[k] = this.dianWen[k]
            this.$router.push(`/zhiJianYuan/dianWen/${id}`)
          })
        }
      }
    },
    check(cb) {
      let i = document.createElement('input')
      i.type = 'file'
      i.addEventListener('change', e => {
        let f = e.target.files[0]
        if(f.size > this.options.zhiJianYuan.uploadMaxSize)
          this.error(`文件不能大于${sizeFilter(this.options.zhiJianYuan.uploadMaxSize)}`)
        else {
          let fd = new FormData
          fd.append('file', f)
          cb(fd, f)
        }
      })
      i.click()
    },
    upload(t) {
      this.check((fd, f) => {
        if(this.zhiJianYuan[t].find(d => d.name == f.name)) {
          this.error(`${f.name} 已经存在`)
          return
        }
        this.loading(true)
        axios.post(`api/zhiJianYuan/${t}`, fd, {
          onUploadProgress: e => e.total && this.progress(e.loaded / e.total)
        }).then(() => {
          let d = {name: f.name, time: f.lastModifiedDate.getTime() / 1000, size: f.size}
          this.$store.state.fixFile(d, t)
          this.zhiJianYuan[t].push(d)
          this.loading(false)
          this.message('上传成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      })
    },
    update(t, d) {
      this.check((fd, f) => {
        this.loading(true)
        fd.append('name', d.name)
        axios.post(`api/zhiJianYuan/${t}`, fd).then(() => {
          d.time = f.lastModifiedDate.getTime() / 1000
          d.size = f.size
          this.loading(false)
          this.message('更新成功')
        }).catch(r => {
          this.loading(false)
          this.error(r.response.data)
        })
      })
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
        this.curDianWen.checkin.push(this.user.id)
        let i = this.curDianWen.uncheck.indexOf(this.user.id)
        if(i >= 0)
          this.curDianWen.uncheck.splice(i, 1)
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
