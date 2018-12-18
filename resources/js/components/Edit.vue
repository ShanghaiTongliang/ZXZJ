<style>
.edit {
  border: inset 1px;
  -webkit-user-modify: read-write-plaintext-only;
  background-color: white;
}
</style>
<script>
export default {
  props: ['value', 'readonly'],
  render(h) {
    return h('pre', {domProps: {innerHTML: this.v}, attrs: {contenteditable: !this.readonly && 'plaintext-only', class: !this.readonly && 'edit'}, on: {
      focus: () => this.locked = true,
      blur: () => this.locked = false,
      input: e => this.$emit('input', e.target.innerHTML)
    }})
  },
  data() {
    return {
      v: this.value
    }
  },
  watch: {
    value(v) {
      if(!this.locked || !this.v)
        this.v = v
    }
  }
}
</script>
