<template>
  <div>
    <moditable v-if="$route.name == 'danWeis'" :tbl="tblDanWei" @save="saveDanWei" @delete="delDanWei">
      <a href="#/danWei/create" class="act">新建单位</a>
    </moditable>
    <kvtable v-else-if="$route.name == 'createDanWei'" :tbl="kvDanWei" :vertical="$store.state.vertical">
      <a href="#/danWei" class="act">返回</a>
    </kvtable>
    <moditable v-else-if="$route.name == 'danWei'" :tbl="tblCheJian" @save="saveCheJian" @delete="delCheJian">
      <div class="act">
        <a href="#/danWei">返回</a>
        <a :href="`#/danWei/${$route.params.did}/create`">新建车间</a>
      </div>
    </moditable>
    <kvtable v-else-if="$route.name == 'createCheJian'" :tbl="kvCheJian" :vertical="$store.state.vertical">
      <a :href="`#/danWei/${$route.params.did}`" class="act">返回</a>
    </kvtable>
    <moditable v-else-if="$route.name == 'cheJian'" :tbl="tblBanZu" @save="saveBanZu" @delete="delBanZu">
      <div class="act">
        <a :href="`#/danWei/${$route.params.did}`">返回</a>
        <a :href="`#/danWei/${$route.params.did}/${$route.params.cid}/create`">新建班组</a>
      </div>
    </moditable>
    <kvtable v-else-if="$route.name == 'createBanZu'" :tbl="kvBanZu" :vertical="$store.state.vertical">
      <a :href="`#/danWei/${$route.params.did}/${$route.params.cid}`" class="act">返回</a>
    </kvtable>
    <datable v-else-if="$route.name == 'banZu'" :tbl="tblUser">
      <a :href="`#/danWei/${$route.params.did}/${$route.params.cid}`" class="act">返回</a>
    </datable>
  </div>
</template>
<script>
import axios from 'axios'
import { mapMutations, mapState } from 'vuex';
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import Kvtable from './components/Kvtable'

const columns = {
  id: 'id',
  name: {
    caption: '名称',
    type: 'text',
    href: 'url'
  }
}

export default {
  components: {Datable, Kvtable, Moditable},
  data() {
    return {
      kvDanWei: {
        caption: '新建单位',
        columns,
        action: [{
          caption: '新建',
          onclick() {
            let v = this.kvDanWei.data
            if(!v.name)
              this.error('请输入单位名称')
            else if(this.$store.state.danWei.find(d => d.name == v.name))
              this.error(`${v.name} 已经存在`)
            else {
              this.loading(true)
              axios.post('api/danwei', v).then(res => {
                this.loading(false)
                this.$store.state.danWei.push(res.data)
                this.message('新建成功')
              }).catch(res => {
                this.loading(false)
                this.error(res.response.data)
              })
            }
          }
        }],
        data: {},
        editing: true
      },
      tblDanWei: {
        caption: '单位',
        columns,
        editingIndex: -1,
        data: this.$store.state.danWei
      },
      kvCheJian: {
        caption: '新建车间',
        columns,
        action: [{
          caption: '新建',
          onclick() {
            let v = this.kvDanWei.data
            if(!v.name)
              this.error('请输入单位名称')
            else if(this.danWei.find(d => d.name == v.name))
              this.error(`${v.name} 已经存在`)
            else {
              this.loading(true)
              axios.post('api/danwei', v).then(res => {
                this.loading(false)
                this.danWei.push(res.data)
                this.message('新建成功')
              }).catch(res => {
                this.loading(false)
                this.error(res.response.data)
              })
            }
          }
        }],
        data: {},
        editing: true
      },
      tblCheJian: {
        caption: null,
        columns: {
          id: 'id',
          name: {
            caption: '车间',
            type: 'text',
            href: 'url'
          }
        },
        editingIndex: -1,
        data: null
      },
      kvBanZu: {
        caption: '新建班组',
        columns,
        action: [{
          caption: '新建',
          onclick() {
            let v = this.kvDanWei.data
            if(!v.name)
              this.error('请输入单位名称')
            else if(this.danWei.find(d => d.name == v.name))
              this.error(`${v.name} 已经存在`)
            else {
              this.loading(true)
              axios.post('api/danwei', v).then(res => {
                this.loading(false)
                this.danWei.push(res.data)
                this.message('新建成功')
              }).catch(res => {
                this.loading(false)
                this.error(res.response.data)
              })
            }
          }
        }],
        data: {},
        editing: true
      },
      tblBanZu: {
        caption: null,
        columns: {
          id: 'id',
          name: {
            caption: '班组',
            type: 'text',
            href: 'url'
          }
        },
        editingIndex: -1,
        data: null
      },
      tblUser: {
        caption: null,
        columns,
        data: null
      },
    }
  },
  watch: {
    '$store.state.danWei': function(v) {
      this.tblDanWei.data = v
    }
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
    saveDanWei(d, i) {
      console.log(this)
    },
    delDanWei(d, i) {
      if(d.cheJian.length)
        this.error(`请先删除 ${d.name} 内的所有车间`)
      else if(confirm(`确定要删除 ${d.name} ?`)) {

        return
      }
      return false
    },
    saveCheJian(d, i) {

    },
    delCheJian(d, i) {
      if(d.banZu.length)
        this.error(`请先删除 ${d.name} 内的所有班组`)
      else if(confirm(`确定要删除 ${d.name} ?`)) {

        return
      }
      return false
    },
    saveBanZu(d, i) {

    },
    delBanZu(d, i) {
      if(d.user.length)
        this.error(`请先删除 ${d.name} 内的所有质检员`)
      else if(confirm(`确定要删除 ${d.name} ?`)) {

        return
      }
      return false
    },
    setRoute(p) {
      if(p.did) {
        let d = this.$store.state.danWei.find(d => d.id == p.did)
        this.tblCheJian.caption = d.name
        this.tblCheJian.data = d.cheJian
        if(p.cid) {
          let c = this.tblCheJian.data.find(c => c.id == p.cid)
          this.tblBanZu.caption = c.name
          this.tblBanZu.data = c.banZu
          if(p.bid) {
            let b = this.tblBanZu.data.find(b => b.id == p.bid)
            this.tblUser.caption = b.name
            this.tblUser.data = b.user
          }
        }
      }
      this.tblDanWei.editingIndex = this.tblCheJian.editingIndex = this.tblBanZu.editingIndex = -1
    }
  },
  beforeRouteUpdate(to, from, next) {
    this.setRoute(to.params)
    next()
  },
  mounted() {
    this.setRoute(this.$route.params)
  }
}
</script>
