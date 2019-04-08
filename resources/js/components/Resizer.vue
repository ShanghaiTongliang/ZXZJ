<style>
.resizer-box {
  display: flex;
  transition: all .2s;
}
.resizer-box>div:first-child {
  display: flex;
  flex-direction: column;
  overflow: auto;
}
.resizer {
  width: .5em;
  background-color: rgba(0, 0, 0, .3);
  position: relative;
  cursor: col-resize;
  flex-shrink: 0;
  user-select: none;
}
.resizer>b {
  background-color: yellow;
  border: 1px outset white;
  cursor: pointer;
  width: 1em;
  height: 3em;
  line-height: 3em;
  border-radius: .5em;
  text-align: center;
  position: absolute;
  top: 50%;
  margin: -1.5em -.5em;
  box-sizing: border-box;
  z-index: 50;
}
</style>
<script>
function mobile() {
  return /Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)
}

function touchEvent() {
  return mobile() ? {
    touchmove: 'touchmove',
    touchend: 'touchend'
  } : {
    touchmove: 'mousemove',
    touchend: 'mouseup'
  }
}

export default {
  props: {
    width: Number,
    right: Boolean,
    visible: {
      type: Boolean,
      default: true
    },
    contentStyle: Object
  },
  render(h) {
    let s, t = {width: `${this.w}px`}, m
    if(this.contentStyle)
      for(let k in this.contentStyle)
        t[k] = this.contentStyle[k]
    s = h('div', {style: t}, this.$slots.default)
    m = h('div', {class: 'resizer', on: mobile() ? {
      touchstart: this.touchstart
    } : {
      mousedown: this.touchstart
    }}, [h('b', {on: {
      mousedown: e => {
        e.stopPropagation()
        this.v = !this.v
        this.$emit('visible', this.v)
      }
    }}, this.v ^ this.right ? '<' : '>')])
    return h('div', {class: 'resizer-box', style: this.right ? {
      marginRight: this.v ? null : `-${this.w}px`
    } : {
      marginLeft: this.v ? null : `-${this.w}px`
    }}, this.right ? [m, s] : [s, m])
  },
  data() {
    return {
      w: this.width === undefined ? 150 : this.width,
      v: this.visible
    }
  },
  computed: {
    mobile() {
      return mobile()
    }
  },
  watch: {
    width(w) {
      this.w = w
    },
    visible(v) {
      this.v = v
    }
  },
  methods: {
    touchstart(e) {
      if(this.v) {
        this.move = true
        let t = e.targetTouches ? e.targetTouches[0] : e
        this.x0 = t.pageX
        this.w0 = this.w
      }
    },
    touchMove(e) {
      if(this.move) {
        if(e.targetTouches)
          e = e.targetTouches[0]
        let d = e.pageX - this.x0
        this.w = this.w0 + (this.right ? -d : d)
        //this.$emit('resizing', this.w + 'px')
      }
    },
    touchEnd(e) {
      if(this.move) {
        this.move = false
        if(this.w < 50) {
          this.w = 50
          this.$emit('visible', this.v = false)
        }
        this.$emit('resize', this.w + 'px')
      }
    }
  },
  mounted() {
    let e = touchEvent()
    document.addEventListener(e.touchmove, this.touchMove, {passive: false})
    document.addEventListener(e.touchend, this.touchEnd)
  },
  beforeDestroy() {
    let e = touchEvent()
    document.removeEventListener(e.touchmove, this.touchMove)
    document.removeEventListener(e.touchend, this.touchEnd)
  }
}
</script>
