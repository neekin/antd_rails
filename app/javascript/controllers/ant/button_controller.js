import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    debounce: { type: Number, default: 0 },      // 防抖延迟（毫秒）
    throttle: { type: Number, default: 0 },       // 节流延迟（毫秒）
    loading: { type: Boolean, default: false }    // 加载状态
  }

  connect() {
    this.debounceTimer = null
    this.throttleTimer = null
    this.lastExecutionTime = 0
    this.originalOnclick = null
    
    // 拦截原始的 onclick 事件
    if (this.element.onclick) {
      this.originalOnclick = this.element.onclick
      this.element.onclick = null
    }
  }

  disconnect() {
    if (this.debounceTimer) clearTimeout(this.debounceTimer)
    if (this.throttleTimer) clearTimeout(this.throttleTimer)
  }

  // 处理点击事件
  handleClick(event) {
    // 如果正在加载，阻止点击
    if (this.loadingValue) {
      event.preventDefault()
      event.stopImmediatePropagation()
      return
    }

    // 防抖处理
    if (this.debounceValue > 0) {
      event.preventDefault()
      event.stopImmediatePropagation()
      
      if (this.debounceTimer) clearTimeout(this.debounceTimer)
      
      this.debounceTimer = setTimeout(() => {
        this.executeOriginalHandler(event)
      }, this.debounceValue)
      
      return
    }

    // 节流处理
    if (this.throttleValue > 0) {
      const now = Date.now()
      const timeSinceLastExecution = now - this.lastExecutionTime

      if (timeSinceLastExecution < this.throttleValue) {
        event.preventDefault()
        event.stopImmediatePropagation()
        return
      }

      this.lastExecutionTime = now
    }

    // 如果没有防抖或节流，或者已经通过节流检查，执行原始处理器
    if (this.originalOnclick) {
      this.executeOriginalHandler(event)
    }
  }

  // 执行原始的点击处理器
  executeOriginalHandler(event) {
    if (this.originalOnclick) {
      // 创建一个新的事件对象，因为原始事件可能已经失效
      const newEvent = new MouseEvent(event.type, {
        bubbles: event.bubbles,
        cancelable: event.cancelable,
        view: event.view,
        detail: event.detail,
        screenX: event.screenX,
        screenY: event.screenY,
        clientX: event.clientX,
        clientY: event.clientY,
        ctrlKey: event.ctrlKey,
        altKey: event.altKey,
        shiftKey: event.shiftKey,
        metaKey: event.metaKey,
        button: event.button,
        relatedTarget: event.relatedTarget
      })
      
      this.originalOnclick.call(this.element, newEvent)
    }
  }

  // 设置加载状态
  setLoading(loading) {
    this.loadingValue = loading
  }

  // 当加载状态改变时
  loadingValueChanged() {
    if (this.loadingValue) {
      this.element.disabled = true
      this.element.classList.add('opacity-60', 'cursor-not-allowed')
      
      // 添加加载图标
      if (!this.element.querySelector('.btn-spinner')) {
        const spinner = document.createElement('span')
        spinner.className = 'btn-spinner inline-block mr-2'
        spinner.innerHTML = `
          <svg class="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        `
        this.element.insertBefore(spinner, this.element.firstChild)
      }
    } else {
      this.element.disabled = false
      this.element.classList.remove('opacity-60', 'cursor-not-allowed')
      
      // 移除加载图标
      const spinner = this.element.querySelector('.btn-spinner')
      if (spinner) spinner.remove()
    }
  }
}
