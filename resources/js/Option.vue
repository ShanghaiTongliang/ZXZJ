<template>
  <div class="container">
    <kvtable :table="kv" :vertical="$store.state.vertical"></kvtable>
  </div>
</template>
<script>
import axios from 'axios'
//import Tabs from './components/Tabs'
import Kvtable from './components/Kvtable'
import {sizeFilter} from './components/filters'
import { mapState, mapMutations } from 'vuex';

export default {
  components: {/*Tabs, */Kvtable},
  data() {
    return {
      /*tabs: [
        '质检员技术管理'
      ],*/
      kv: {
        caption: '质检员技术管理',
        columns: {
          uploadMaxSize: {
            caption: '上传文件最大值',
            type: 'number',
            min: 1,
            filter: sizeFilter
          }
        },
        actions: [{
          caption: '编辑',
          condition() {
            return !this.kv.editing
          },
          onclick() {
            this.kv.data = {...this.options.zhiJianYuan}
            this.kv.editing = true
          }
        }, {
          caption: '保存',
          condition() {
            return this.kv.editing
          },
          onclick(d) {
            this.loading(true)
            axios.put('api/option', {zhiJianYuan: d}).then(() => {
              this.options.zhiJianYuan = d
              this.kv.editing = false
              this.loading(false)
              this.message('保存成功')
            }).catch(r => {
              this.loading(false)
              this.error(r.response.data)
            })
          }
        }, {
          caption: '取消',
          type: 'button',
          condition() {
            return this.kv.editing
          },
          onclick() {
            this.kv.data = this.options.zhiJianYuan
            this.kv.editing = false
          }
        }],
        editing: false,
        data: this.$store.state.options.zhiJianYuan
      }
    }
  },
  computed: {
    ...mapState(['options'])
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error']),
  }
}
</script>
