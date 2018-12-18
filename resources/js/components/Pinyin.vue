<style>
.pinyin {position: relative}
.pinyin ul {
  position: absolute;
  min-width: 100%;
  white-space: nowrap;
  margin: 0;
  padding: 0;
  list-style: none;
  background-color: white;
  border: outset 1px;
  user-select: none;
}
.pinyin li {padding: 0 .2em}
.pinyin li.select {background-color: lightblue}
</style>

<script>
import PininEngine from 'pinyin-engine'

export default {
  props: ['value', 'items', 'valueName'],
  render(h) {
    let valueName = this.valueName || 'name'
    let self = this
    return h('div', {class: 'pinyin'}, [h('input', {
      attrs: {type: 'text', value: this.value},
      on: {
        input: e => this.$emit('input', e.target.value),
        keydown: e => {
          if(e.key == 'ArrowUp') {
            e.preventDefault()
            this.popup = true
            if(this.index > 0) this.index--
            else this.index = this.match.length - 1
          } else if(e.key == 'ArrowDown') {
            e.preventDefault()
            this.popup = true
            if(this.index >= this.match.length - 1) this.index = 0
            else this.index++
          } else if(e.key == 'Enter' && this.match[this.index]) {
            e.target.value = this.match[this.index][valueName]
            this.$emit('input', e.target.value)
            this.popup = false
          }
        },
        focus: () => this.popup = true,
        blur: () => {
          setTimeout(() => this.popup = false, 200)
        }
      }}), h('ul', {style: {display: this.popup ? null : 'none'}}, this.match.map((o, i) => {
        let a = {key: i, on: {
          mouseenter: () => this.index = i,
          click: e => {
            e.target.parentNode.previousSibling.value = this.match[this.index][valueName]
            this.$emit('input', this.match[this.index][valueName])
          }
        }}
        if(i == this.index)
          a.class = 'select'
        return h('li', a, o[valueName])
      }))
    ])
  },
  data() {
    return {
      popup: false,
      index: -1
    }
  },
  computed: {
    match() {
      let valueName = this.valueName || 'name'
      let pinyin = new PininEngine(this.items ? this.items.map(o => o[valueName]) : [])
      this.index = -1
      return pinyin.query(this.value).map(v => {
        let r = {}
        r[valueName] = v
        return r
      })
    }
  }
}
</script>
