<style>
.resizer-box {display: flex}
.resizer {
  width: .5em;
  background-color: rgba(0, 0, 0, .3);
  cursor: col-resize;
  flex-shrink: 0;
}
.resizer-btn {
  background-color: yellow;
  border: 1px outset white;
  cursor: pointer;
  width: 1.5em;
  height: 3em;
  line-height: 3em;
  border-radius: 50%;
  text-align: center;
  position: absolute;
  top: 50%;
  margin: -1.5em -.75em;
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
    flex: {
      type: Boolean,
      default: true
    }
  },
  render(h) {
    let s = h('div', {style: {
      display: this.v ? this.flex ? 'flex' : '' : 'none',
      width: this.w + 'px'
    }}, [this.$slots.default]), m = h('div', {
        class: 'resizer',
        on: mobile() ? {
          touchstart: this.touchstart
        } : {
          mousedown: this.touchstart
        }
      }, [
        h('b', {
          class: 'resizer-btn',
          on: {
            mousedown: e => {
              e.stopPropagation()
              this.v = !this.v
              this.$emit('visible', this.v)
            }
          }
        }, this.v ^ this.right ? '<' : '>')
      ]
    )
    return h('div', {class: 'resizer-box'}, this.right ? [m, s] : [s, m])
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
        //防止选择文本
        e.preventDefault()
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
