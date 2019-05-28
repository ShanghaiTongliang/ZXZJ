<style>
.uploader {
  display: inline-block;
  margin: .1em .2em;
  padding: .2em;
  background-color: rgba(0, 0, 0, .2);
  border-radius: .5em;
}
.uploader div {
  max-width: 10em;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.uploader button {float: right}
.uploader .del {text-decoration: line-through}
</style>
<script>
import Vue from 'vue'
import {sizeFilter} from './filters'

export function addFile(success, error, maxSize, accept) {
  let inp = document.createElement('input')
  inp.type = 'file'
  inp.accept = accept
  inp.addEventListener('change', e => {
    let f = e.target.files[0]
    if(maxSize && f.size > maxSize)
      error(`文件不能大于${sizeFilter(maxSize)}`)
    else
      success(f)
  })
  inp.click()
}

export default {
  props: ['files', 'accept', 'maxSize'],
  render(h) {
    return h('div', [
      this.files.map((f, i) => h('div', {class: 'uploader'}, [h('div', {class: f.deleted ? 'del' : null, attrs: {title: f.name}}, [f.url ? h('a', {attrs: {href: f.url, target: '_blank'}}, f.name) : f.name]), h('span', sizeFilter(f.size)), h('button', {on: {
        click: () => {
          if(f.url) {
            Vue.set(f, 'deleted', !f.deleted)
            if(f.deleted)
              this.deleted.push(f)
            else
              this.deleted.splice(this.deleted.indexOf(f), 1)
          } else {
            this.files.splice(i, 1)
            this.added.splice(this.added.indexOf(f), 1)
          }
        }
      }}, f.deleted ? '取消' : '删除')])), this.$slots.default
    ])
  },
  data() {
    return {
      added: [],
      deleted: []
    }
  },
  methods: {
    addFile() {
      addFile(f => {
        if(this.files.find(e => e.name == f.name))
          this.$emit('error', `${f.name} 已经存在`)
        else {
          let a = {name: f.name, size: f.size, file: f}
          this.files.push(a)
          this.added.push(a)
        }
      }, e => {
        this.$emit('error', e)
      }, this.maxSize, this.accept)
    }
  }
}
</script>
