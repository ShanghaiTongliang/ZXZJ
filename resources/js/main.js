import Vue from 'vue'
import router from './router'
import store from './store'
import App from './App'
import './date'

let root = new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
window.root = root
