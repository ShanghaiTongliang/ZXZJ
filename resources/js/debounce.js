export default class Debounce {
  constructor(cb, t) {
    this.t = t
    this.cb = cb
  }

  trigger(k) {
    if(this.cb) {
      clearTimeout(this.tmr)
      this.tmr = setTimeout(this.cb, this.t, k)
    }
  }
}