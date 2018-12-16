<style>
</style>
<template>
  <div>
    <moditable v-if="$route.name == 'zhengCheJiaoJian'" :tbl="tbl" @save="save" @delete="del">
      <a href="#/guZhang/zhengCheJiaoJian/create" class="act">新建</a>
    </moditable>
    <kvtable v-else :tbl="kv" :vertical="$store.state.vertical">
      <a href="#/guZhang/zhengCheJiaoJian" class="act">返回</a>
    </kvtable>
  </div>
</template>
<script>
import axios from 'axios'
import {mapState} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'
import Moditable from './components/Moditable'

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
  daBuWei: {
    caption: '大部位',
    type: 'select',
    items: null
  },
  cheZhong: {
    caption: '车种',
    type: 'select',
    items: null
  },
  danWei: {
    caption: '单位',
    type: 'select',
    items: null
  },
  cheJian: {
    caption: '车间',
    type: 'select',
    master: ['danWei']
  },
  banZu: {
    caption: '班组',
    type: 'select',
    master: ['danWei', 'cheJian']
  },
  user: {
    caption: '质检员',
    type: 'select',
    master: ['danWei', 'cheJian', 'banZu']
  }
}

export default {
  components: {Datable, Kvtable, Moditable},
  data() {
    return {
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
        data: {},
        action: [{
          caption: '保存',
          onclick() {
            console.log(this.kv.data)
          }
        }]
      }
    }
  },
  watch: {
    '$store.state.std': {
      deep: true,
      handler(v) {
        this.setStd(v)
      },
    },
    '$store.state.danWei': {
      deep: true,
      handler(v) {
        this.setDanWei(v)
      }
    },
    '$store.state.data': {
      deep: true,
      handler(v) {
        this.setData(v)
      }
    },
  },
  methods: {
    save(d, i) {
      console.log(d, i)
    },
    del(d, i) {
      console.log(this, d, i)
      if(!confirm('确定要删除数据 ?'))
        return false
    },
    setStd(std) {
      ['xiuCheng', 'daBuWei', 'cheZhong'].forEach(k => columns[k].items = std[k])
      columns.user.items = std
    },
    setDanWei(v) {
      columns.danWei.items = v
    },
    setData(v) {
      this.tbl.data = v.zhengCheJiaoJian
    },
  },
  beforeRouteUpdate(to, from, next) {
    if(to.name == 'zhengCheJiaoJianCreate')
      this.kv.data = {}
    next()
  },
  mounted() {
    this.setStd(this.$store.state.std)
    this.setDanWei(this.$store.state.danWei)
    this.setData(this.$store.state.data)
  }
}
</script>
