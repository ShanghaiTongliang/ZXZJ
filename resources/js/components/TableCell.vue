<style>
.tc-chk {text-align: left}
.tc-chk label {
  min-width: 6em;
  display: inline-block;
}
</style>

<script>
import Vue from 'vue'
import Edit from './Edit'
import ComboBox from './ComboBox'
import Pinyin from './Pinyin'

export default {
  props: ['column', 'value', 'items', 'options'],
  components: {Edit, ComboBox, Pinyin},
  render(h) {
    let c = this.column, r
    if(c.type) {
      let keyName = c.keyName || this.options.cascade.keyName, valueName = c.valueName || this.options.cascade.valueName
      switch(c.type) {
      case 'radio':
        r = this.items.map((o, k) => h('label', {key: k}, [h('input', {
          attrs: {type: 'radio', value: o[keyName]},
          domProps: {checked: this.value == o[keyName]},
          on: {
            change: e => this.$emit('input', e.target.value)
          }
        }), h('span', {domProps: {innerHTML: o[valueName]}})]))
        break
      case 'select':
        let os = []
        if(this.items && this.items.length) {
          let f
          this.items.forEach((v, i) => {
            let o = {value: v[keyName], innerHTML: v[valueName]}
            if(this.value == v[keyName]) {
              o.selected = true
              f = true
            }
            os.push(h('option', {domProps: o, key: i}))
          })
          if(!f && this.items && this.items.length)
            this.$emit('input', this.items[0][keyName])
        } else if(this.value !== undefined && this.value !== null)
          this.$emit('input', null)
        r = [h('select', {on: {
          change: e => this.$emit('input', e.target.value === '' ? null : isNaN(e.target.value) ? e.target.value : parseInt(e.target.value))
        }}, os)]
        break
      case 'checkbox':
        r = this.items && this.items.map((o, k) => h('label', {key: k}, [h('input', {
          attrs: {type: 'checkbox', value: o[keyName]},
          domProps: {checked: this.value && this.value.find(v => v == o[keyName])},
          on: {
            change: e => {
              let i, c, v
              if(this.value) {
                v = this.value
                c = v.length
              } else {
                v = []
                c = 0
              }
              for(i = 0; i < c; i++)  //indexOf不能类型转换
                if(v[i] == e.target.value)
                  break
              if(e.target.checked) {
                if(i >= c) {
                  v.push(o[keyName])
                  v.sort()
                }
              } else if(i < c)
                v.splice(i, 1)
              this.$emit('input', v)
            }
          }
        }), h('span', {domProps: {innerHTML: o[valueName]}})]))
        return h('td', {class: 'tc-chk'}, r)
      case 'pre':
        r = [h('edit', {props: {value: this.value}, on: {
          input: v => this.$emit('input', v)
        }, props: {readonly: c.readonly instanceof Function ? c.readonly.call(ctx.parent) : c.readonly}})]
        break
      case 'combo':
        r = [h('combo-box', {props: {value: this.value, items: this.items}, on: {
          input: v => this.$emit('input', v)
        }})]
        break
      case 'pinyin':
        r = [h('pinyin', {props: {value: this.value, items: this.items || []}, on: {
          input: v => {
            this.$emit('input', v)
          }
        }})]
        break
      case 'int': case'number':
        r = [h('input', {attrs: {id: this.key, type: 'number', min: c.min, max: c.max}, domProps: {value: this.value}, on: {
          input: c.type == 'int' ? e => {
            this.$emit('input', parseInt(e.target.value))
           } :
            e => {
              this.$emit('input', parseFloat(e.target.value))
            }
        }})]
        break
      default:
        r = [h('input', {attrs: {id: this.key, type: c.type, min: c.min, max: c.max}, domProps: {value: this.value}, on: {
          input: e => this.$emit('input', e.target.value)
        }})]
      }
    }
    return h('td', r)
  }
}
</script>
