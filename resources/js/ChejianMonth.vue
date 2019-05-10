<script>
const months = []
function init() {
  let d = new Date, y = d.getFullYear(), m = d.getMonth() + 1
  for(let i = 0; i < 12; i++) {
    months.push(`${y}-${m > 9 ? m : '0' + m}`)
    if(m > 1) m--
    else {
      m = 12
      y--
    }
  }
}
init()

export default {
  functional: true,
  props: ['danWeis', 'danWei', 'cheJian', 'month', 'disabled', 'state', 'vertical'],
  render(h, ctx) {
    let p = ctx.props, l = ctx.listeners, ds = p.danWeis, cd, m = p.month, u = p.state.user
    cd = ds && ds.find(d => d.id == p.danWei)
    if(!m) {
      m = months[0]
      if(l.monthChanged)
        l.monthChanged(m)
    }
    return h('div', {style: p.vertical && 'display: flex; flex-direction: column'}, [
      h('div', {class: 'group'}, [
        '单位 ', h('select', {attrs: {disabled: p.disabled}, on: {
          change: e => {
            let d = parseInt(e.target.value), cd = ds.find(t => t.id == d), c = cd.cheJian
            l.cheJianChanged && l.cheJianChanged(d, cd.cheJian.length ? cd.cheJian[0].id : null)
          }
        }}, ds && ds.map(
          (d, i) => h('option', {attrs: {value: d.id}, domProps: {selected: p.danWei == d.id}, key: i}, d.name)
        ))
      ]),
      h('div', {class: 'group'}, [
        '作业场 ', h('select', {attrs: {disabled: p.disabled}, on: {
          change: e => l.cheJianChanged && l.cheJianChanged(p.danWei, parseInt(e.target.value))
        }}, cd && cd.cheJian.map(
          (c, i) => h('option', {attrs: {value: c.id}, domProps: {selected: p.cheJian == c.id}, key: i}, c.name)
        ))
      ]),
      h('div', {class: 'group'}, [
        '月份 ', h('select', {attrs: {disabled: p.disabled}, domProps: {value: m}, on: {
          change: e => l.monthChanged && l.monthChanged(e.target.value)
        }}, months.map((m, i) => h('option', {attrs: {value: m}, key: i}, m)))
      ]),
      ctx.children
    ])
  }
}
</script>
