<template>
  <div>
    {{txt}}
  </div>
</template>
<script>
import axios from 'axios'
import Tabs from './components/Tabs'

Date.prototype.time12 = true

axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'Content-Type': 'application/json'
}
export default {
  data() {
    return {
      d: new Date,
    }
  },
  computed: {
    txt() {
      return this.d.toDateTime()
    }
  }
}
</script>
