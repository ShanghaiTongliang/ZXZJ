<template>
  <div>
    <form class="form" @submit="submit">
      用户名<input type="text" v-model="name"><br>
      　密码<input type="password" v-model="password"><br>
      <input type="submit">
    </form>
  </div>
</template>
<script>
export default {
  data() {
    return {
      name: null,
      password: null
    }
  },
  methods: {
    submit() {

    }
  }
}
</script>
