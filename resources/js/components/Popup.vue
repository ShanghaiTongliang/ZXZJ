<style>
.popup {
  max-height: 90%;
  max-width: 100%;
  box-sizing: border-box;
  padding: .5em;
  margin: auto;
  background-color: #bdb;
  border: outset 1px;
  box-shadow: 1em 1em rgba(0, 0, 0, .5);
  overflow: auto;
}
.popup>div:first-child {
  position: relative;
  display: flex;
}
.popup>div:first-child span {flex-grow: 1}
</style>
<script>
export default {
  functional: true,
  props: ['popup', 'caption'],
  render(h, ctx) {
    return ctx.props.popup && h('div', {class: 'mask'}, [
      h('div', {class: 'popup'}, [
        h('div', [h('span', ctx.props.caption), h('div', {class: 'close', on: {
          click: () => ctx.listeners.close && ctx.listeners.close()
        }})]),
        ...ctx.children
      ]
    )])
  }
}
</script>
