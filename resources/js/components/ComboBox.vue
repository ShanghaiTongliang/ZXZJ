<script>
export default {
  props: ['value', 'items', 'valueName'],
  render(h) {
    let valueName = this.valueName || 'name'
    if(!this.id)
      do this.id = 'dl' + Math.floor(Math.random() * 10000)
      while(document.querySelector('#' + this.id))
    return h('input', {attrs: {type: 'text', list: this.id},
      domProps: {value: this.value}, on: {
        input: e => this.$emit('input', e.target.value)
      }}, [h('datalist', {attrs: {id: this.id}},
        this.items.map((o, k) => h('option', {attrs: {value: o[valueName]}, key: k})))])
  }
}
</script>
