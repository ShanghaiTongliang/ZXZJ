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
store.state.options = localStorage

let o = localStorage.getItem('options')
store.state.options = o ? JSON.parse(o) : {visible: true}
window.root = root

orientation((v, e) => root.$store.state.vertical = v)
