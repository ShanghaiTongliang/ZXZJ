function clone(o) {
  if(o instanceof Array) {
    let r = [], i
    for(i = 0; i < o.length; i++)
      r[i] = clone(o[i])
    return r
  } else if(o instanceof Object) {
    let r = {}
    for(let k in o)
      r[k] = clone(o[k])
    return r
  } else
    return o
}

function merge(t, s) {
  for(let k in s)
    if(t[k] instanceof Object && !(t[k] instanceof Array))
      merge(t[k], s[k])
    else
      t[k] = s[k]
  return t
}

export {clone}
export default merge
