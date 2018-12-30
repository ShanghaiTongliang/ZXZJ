<script>
import axios from 'axios'
import Vue from 'vue'
import Datable from './components/Datable'
import Moditable from './components/Moditable'
import { mapMutations } from 'vuex';

const names = {
  xiuCheng: '修程',
  cheZhong: '车种',
  daBuWei: '大部位',
  xiaoBuWei: '小部位',
  juTiBuWei: '具体部位',
  guZhang: '故障',
  dengJi: '等级'
}
const columns = {
  id: 'id',
  name: {
    caption: '名称',
    type: 'text'
  }
}

export default {
  components: {Datable, Moditable},
  render(h) {
    return h('moditable', {props: {tbl: this[this.$route.name]}, on: {
      save: (d, i, next) => {
        this.loading(true)
        axios.put(`api/standard/${this.$route.name}/${d.id}`, d).then(res => {
          this.loading(false)
          this.message('保存成功')
          next()
        }).catch(res => {
          this.loading(false)
          this.error(res.response.data)
        })
      },
      delete: (d, i, next) => {
        let n = this.$route.name
        if(this.$store.state.guZhang.zhengCheJiaoJian.find(g => g[n] == d.name))
          this.error(`${names[n]}: ${d.name} 已被使用, 不能删除`)
        else if(confirm(`确定要删除 ${names[n]}: ${d.name} ?`)) {
          this.loading(true)
          axios.delete(`api/standard/${this.$route.name}/${d.id}`).then(res => {
            this.loading(false)
            this.message('删除成功')
            next()
          }).catch(res => {
            this.loading(false)
            this.error(res.response.data)
          })
        }
      }
    }})
  },
  data() {
    let r = {}
    for(let n in names) {
      r[n] = {
        caption: names[n],
        columns,
        data: this.$store.state.std[n]
      }
    }
    return r
  },
  methods: {
    ...mapMutations(['loading', 'message', 'error'])
  }
}
</script>
