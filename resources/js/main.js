import axios from 'axios'
import Vue from 'vue'
import router from './router'
import store from './store'
import App from './App'
import './components/date'
import orientation from './components/orientation'

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'Content-Type': 'application/json'
}

let root = new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

let o = localStorage.getItem('options')
store.state.options = o ? JSON.parse(o) : {frame: {visible: true}}
o = localStorage.getItem('state')
if(o) {
  store.state.state = JSON.parse(o)
  store.state.std.daBuWei = JSON.parse(localStorage.getItem('daBuWei'))
  store.state.std.cheXing = JSON.parse(localStorage.getItem('cheXing'))
} else
  store.state.state = {guZhangTime: '', cheXingTime: ''}
window.root = root

orientation(v => store.state.vertical = v)
