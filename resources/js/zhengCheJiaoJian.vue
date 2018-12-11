<style>
</style>
<template>
  <div class="container">
    <datable v-if="$route.name == 'zhengCheJiaoJian'" :tbl="tbl" :data="data.zhengCheJiaoJian"></datable>
    <kvtable v-else :tbl="kv"></kvtable>
  </div>
</template>
<script>
import axios from 'axios'
import {mapState} from 'vuex'
import Datable from './components/Datable'
import Kvtable from './components/Kvtable'

const columns = {
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
}

export default {
  components: {Datable, Kvtable},
  data() {
    return {
      tbl: {
        caption: '故障',
        columns
      },
      kv: {
        caption: '故障',
        columns,
        data: null
      }
    }
  },
  computed: {
    ...mapState(['std', 'data'])
  },
  watch: {
    std(v) {
      this.init()
    }
  },
  methods: {
    init() {
      for(let k in columns) {
        let r = {}
        this.std[k].forEach(v => r[v.id] = v.name)
        columns[k].items = r
      }
    }
  },
  mounted() {
    this.init()
  }
}
</script>
