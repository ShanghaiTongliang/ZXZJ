let callback
export default function orientation(cb) {
  let e
  if(cb instanceof Function)
    callback = cb
  else
    e = cb
  if(callback)
    callback(window.innerWidth < window.innerHeight, e)
}

window.addEventListener(window.onorientationchange === undefined ? 'resize' : 'orientationchange', e => setTimeout(orientation, 100, e))
