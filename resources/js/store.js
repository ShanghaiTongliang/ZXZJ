import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    users: [], groups: [],
    user: null,
  },
  mutations: {
    auth(state, {data, id, url}) {
      store.state.users = data.users
      store.state.groups = data.groups
    }
  }
})
