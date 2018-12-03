import cookie from 'js-cookie'
import axios from 'axios'
import Vue from 'vue'
import router from './router'
import store from './store'
import { mapMutations } from 'vuex';

let app = new Vue({
  router,
  store,
  methods: {
    ...mapMutations(['auth'])
  }
}).$mount('#app')

let id = parseInt(cookie.get('id'))
if(id)
  axios.get('api/auth').then(res => {
    this.auth(res, id)
  }).catch(res => {

  })
