function sizeFilter(t) {
  return t > 0x100000 ? Math.round(t * 10 / 0x100000) / 10 + 'M' : t > 0x400 ? Math.round(t * 10 / 0x400) / 10 + 'K' : t
}

export {sizeFilter}
