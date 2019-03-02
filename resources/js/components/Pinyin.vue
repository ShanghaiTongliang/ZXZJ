<style>
.pinyin {position: relative}
.pinyin ul {
  position: absolute;
  white-space: nowrap;
  margin: 0;
  padding: 0;
  list-style: none;
  background-color: white;
  border: outset 1px;
  user-select: none;
  min-width: 100%;
  max-height: 6.5em;
  overflow: auto;
  z-index: 100;
}
.pinyin li {padding: 0 .2em}
.pinyin li.select {background-color: lightblue}
</style>

<script>
import PininEngine from 'pinyin-engine'

export default {
  props: ['value', 'items', 'size', 'valueName'],
  render(h) {
    let valueName = this.valueName || 'name'
    return h('div', {class: 'pinyin'}, [h('input', {
      attrs: {type: 'text'}, domProps: {value: this.value},
      on: {
        input: e => this.$emit('input', e.target.value),
        keydown: e => {
          if(!this.match.length) return
          const scroll = () => {
            let n = this.$refs.items, s = n.childNodes[this.index], t
            if((t = s.offsetTop) < n.scrollTop)
              n.scrollTo(0, t)
            else if((t = t + s.offsetHeight) > n.scrollTop + n.clientHeight)
              n.scrollTo(0, t - n.clientHeight)
          }
          if(e.key == 'ArrowUp') {
            e.preventDefault()
            this.popup = true
            if(this.index > 0) this.index--
            else this.index = this.match.length - 1
            scroll()
          } else if(e.key == 'ArrowDown') {
            e.preventDefault()
            this.popup = true
            if(this.index >= this.match.length - 1) this.index = 0
            else this.index++
            scroll()
          } else if(e.key == 'Enter' && this.popup && this.match[this.index]) {
            e.stopPropagation()
            e.target.value = this.match[this.index][valueName]
            this.$emit('input', e.target.value)
          }
        },
        focus: () => this.popup = true,
        blur: () => setTimeout(() => this.popup = false, 200)
      }}), h('ul', {style: {display: this.popup ? null : 'none'}, ref: 'items'}, this.match.map((o, i) => {
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
      if(this.items) {
        if(this.items.length) {
          let valueName = this.valueName || 'name'
          let pinyin = new PininEngine(this.items, valueName, false, true)
          this.index = -1
          return pinyin.query(this.value === undefined ? '' : this.value)
        } else
          return this.items
      } else
        return []
    }
  }
}
</script>
