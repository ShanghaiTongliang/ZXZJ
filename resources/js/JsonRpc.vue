<style>
.list {
  width: 200px;
  background-color: white;
  border: 1px inset;
  flex-shrink: 0;
}
.list div {padding: .5em}
.select {
  color: white;
  background-color: blue;
}
.calc {
  width: 15em;
  background-color: lightgray;
  padding: 1em;
  margin: 0 auto;
  border-radius: .5em;
  border: 2px outset white;
  text-align: center;
}
.calc input[type=number] {width: 5em}
.tab>a {margin-right: 2em}
.page {text-align: center}
</style>
<template>
  <tabs :tabs="tabs">
    <template slot="0">
      输入
    </template>
    <template slot="1">
      <div class="list">
        <div v-for="(v, k) in list" :key="k" :class="k == index ? ['select'] : null" @click="select(k)">{{v.name}}</div>
      </div>
      <div style="flex-grow: 1">
        <div class="calc">
          <div style="height: 1.5em">{{result}}</div>
          a: <input type="number" v-model="a">
          b: <input type="number" v-model="b"><br>
          <button @click.prevent="operate('+')">+</button> <button @click.prevent="operate('-')">-</button>
          <br>
        </div>
        子窗口<br>
        <div class="tab">
          <a href="#/page1">page1</a> <a href="#/page2">page2</a>
          <router-view class="page"></router-view>
        </div>
      </div>
    </template>
  </tabs>
</template>
<script>
import axios from 'axios'
import Tabs from './components/Tabs'

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'Content-Type': 'application/json'
}
export default {
  components: {Tabs},
  data() {
    return {
      tabs: [
        '输入',
        {
          caption: '统计',
          flex: true,
          row: true
        }
      ],
      list: {},
      index: 0,
      a: Math.round(Math.random() * 10),
      b: Math.round(Math.random() * 10),
      result: null
    }
  },
  methods: {
    select(k) {
      if(k != this.index)
        this.index = k
    },
    operate(op) {
      axios.post('/calc', {a: this.a, b: this.b, op}).then(res => {
        this.result = `${this.a} ${op} ${this.b} = ${res.data.result}`
      }).catch(res => {
        alert('发送失败')
      })
    }
  },
  watch: {
    result(v, o) {
      console.log(v, o)
    }
  },
  mounted() {
    axios.get('api/list').then(res => {
      this.list = res.data
    })
  }
}
</script>
