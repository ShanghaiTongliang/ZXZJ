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

const columns = {
  title: {
    caption: '标题',
    href: 'url',
  },
  poster: {
    caption: '发布人',
    items: null
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
      return h('tabs', {props: {tabs: this.tabs}},
        this.tbls.map((t, i) => h('datable', {props: {table: t}, slot: i}, [h('a', {attrs: {href: '#/zhiJianYuan/dianWen/create', class: 'act'}}, '新建')])))
    } else if(n == 'dianWen')
      return h('div', {style: {display: 'flex', flexDirection: 'column'}}, [
        h('div', {class: 'caption'}, [this.curDianWen.title, h('div', {class: 'act'}, [
          h('a', {attrs: {href: '#/zhiJianYuan/dianWen'}}, '返回'), ' ',
          h('a', {attrs: {href: `#/zhiJianYuan/dianWen/${this.curDianWen.id}/edit`}}, '编辑')
        ])]),
        h('pre', {class: 'text'}, this.curDianWen.detail),
        //this.user.permission[]
        h('div', [h('button', '签收')])
      ])
    else if(n == 'createDianWen' || n == 'editDianWen')
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
      return h('datable', {props: {table: this.tblZhiDaoShu}, class: 'container'}, [
        h('button', {class: 'act', on: {
          click: () => this.upload('zhiDaoShu')
        }}, '上传')
      ])
    else
      return h('datable', {props: {table: this.tblZiLiao}, class: 'container'}, [
        h('button', {class: 'act', on: {
          click: () => this.upload('ziLiao')
        }}, '上传')
      ])
  },
  data() {
    return {
      dianWen: null,
      curDianWen: null,
      new: true,
      tbls: [],
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
    ...mapState(['dict', 'user', 'dict', 'zhiJianYuan']),
    tabs() {
      let r = [], pj = this.zhiJianYuan.dianWen, ps
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
        if(r.name == 'createDianWen') {
          this.new = true
          this.dianWen = {cheJian: []}
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
    ...mapMutations(['loading', 'message', 'error']),
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
        if(f.size > 0x28000)
          this.error('文件不能大于160K')
        else {
          let fd = new FormData
          fd.append('file', f)
          this.loading(true)
          cb(fd, f)
        }
      })
      i.click()
    },
    upload(t) {
      this.check((fd, f) => {
        axios.post(`api/zhiJianYuan/${t}`, fd).then(() => {
          this.zhiJianYuan[t].push({name: f.name, time: f.lastModifiedDate.getTime() / 1000, size: f.size})
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
    }
  },
  created() {
    columns.poster.items = this.$store.state.users
  }
}
</script>
