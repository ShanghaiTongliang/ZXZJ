<style>
@keyframes loading {
  0% {
    opacity: 0;
    transform: scale(.4);
  }
  20% {
    opacity: 1;
    transform: scale(1);
  }
  80% {
    opacity: 0;
    transform: scale(.4);
  }
}
.mask {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, .5);
  z-index: 100;
  display: flex;
}
.loading {
  width: 64px;
  height: 64px;
  margin: auto;
  position: relative;
}
.loading>div {
  background-color: yellow;
  width: 40%;
  height: 40%;
  border-radius: 50%;
  opacity: 0;
  margin: -20% 0 0 -20%;
  animation-fill-mode: both;
  position: absolute;
}
.loading>div:nth-child(1) {
  left: 100%;
  top: 50%;
  animation: loading 1s 0s infinite;
}
.loading>div:nth-child(2) {
  left: 85.4%;
  top: 85.4%;
  animation: loading 1s .125s infinite;
}
.loading>div:nth-child(3) {
  left: 50%;
  top: 100%;
  animation: loading 1s .25s infinite;
}
.loading>div:nth-child(4) {
  left: 14.6%;
  top: 85.4%;
  animation: loading 1s .375s infinite;
}
.loading>div:nth-child(5) {
  left: 0;
  top: 50%;
  animation: loading 1s .5s infinite;
}
.loading>div:nth-child(6) {
  left: 14.6%;
  top: 14.6%;
  animation: loading 1s .625s infinite;
}
.loading>div:nth-child(7) {
  left: 50%;
  top: 0%;
  animation: loading 1s .75s infinite;
}
.loading>div:nth-child(8) {
  left: 85.4%;
  top: 14.6%;
  animation: loading 1s .875s infinite;
}
</style>
<script>
export default {
  functional: true,
  props: ['loading'],
  render(h, ctx) {
    let a = []
    for(let i = 0; i < 8; i++)
      a.push(h('div'))
    return h('div', {class: 'mask', style: ctx.props.loading ? undefined : {display: 'none'}}, [h('div', {class: 'loading'}, a)])
  }
}
</script>
