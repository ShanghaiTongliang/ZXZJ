<style>
.tabs-flex {display: flex}
.tabs-grow {flex-grow: 1}
.tabs-column {flex-direction: column}
div.tabs {
  display: flex;
  flex-direction: column;
  overflow: auto;
}
div.bottom {flex-direction: column-reverse}
.tabs ul {
  list-style: none;
  margin: 0;
  padding: 0;
  flex-shrink: 0;
  display: flex;
  overflow: auto;
}
.tabs li {
  color: #eee;
  background-color: #777;
  padding: .2em;
  border-width: 1px;
  flex-grow: 1;
  flex-shrink: 0;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  cursor: pointer;
  border: 1px solid;
  border-color: white #333 white white;
  border-radius: .5em .5em 0 0;
}
.bottom>ul>li {
  border-radius: 0 0 .5em .5em;
  border-top-color: #333;
  border-bottom-color: #333;
}
li.selected {
  background-color: #eee;
  color: black;
  border-right-color: gray;
  border-bottom-style: none;
}
li.selected.bottom {
  border-top-style: none;
  border-bottom-color: gray;
  border-bottom-style: solid;
}
.page {
  padding: .2em;
  border: 1px solid;
  border-color: white gray gray white;
  border-top-style: none;
  background-color: #eee;
  overflow: auto;
  flex-grow: 1;
}
.bottom>.page {
  border-top-style: solid;
  border-bottom-style: none;
}

</style>
<script>
export default {
  render(h) {
    return h('div', {class: {bottom: this.bottomTab, 'tabs-grow': this.grow}, staticClass: 'tabs'}, [h('ul', this.tabs.map((t, i) => {
      let c = this.bottomTab ? ['bottom'] : ['top'], r = []
      if(i == this.tabIdx)
        c.push('selected')
      if(t instanceof Object) {
        if(t.icon)
          r.push(h('img', {attrs: {src: t.icon}}))
        else if(this.icons && this.icons[t.iconIndex])
          r.push(h('img', {attrs: {src: this.icons[t.iconIndex]}}))
        t = t.caption
      } else if(this.icons && this.icons[i])
        r.push(h('img', {attrs: {src: this.icons[i]}}))
      r.push(t)
      return h('li', {class: c, on: {
        click: () => this.click(i)
      }, key: i}, r)
    })), ...this.tabs.map((t, i) => {
      let s
      if(this.tabIdx == i) {
        s = ''
        this.$nextTick(() => this.$emit('pageShow', i, this))
      } else
        s = 'none'
      return h('div', {class: t instanceof Object ? {'tabs-flex': t.flex, 'tabs-column': !t.row} : null, staticClass: 'page', style: {display: s}, key: i}, [this.$slots[i]])
    })])
  },
  props: ['tabs', 'tabIndex', 'icons', 'bottomTab', 'grow'],
  data() {
    return {
      ti: 0
    }
  },
  computed: {
    tabIdx() {
      if(typeof this.tabIndex != 'undefined')
        this.ti = this.tabIndex
      return this.ti
    }
  },
  methods: {
    getClass(i) {
      let r = this.bottomTab ? ['bottom'] : ['top']
      if(i == this.tabIdx)
        r.push('selected')
      return r
    },
    click(i) {
      this.ti = i
      this.$emit('tabIndex', i)
    }
  }
}
</script>
