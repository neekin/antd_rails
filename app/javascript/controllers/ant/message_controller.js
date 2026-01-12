import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 3000 }
  }

  connect() {
    this.show()
  }

  show() {
    // 获取或创建容器
    const container = this.getContainer()
    
    // 从 body 移动到容器（如果还在 body 下）
    if (this.element.parentElement === document.body) {
      container.appendChild(this.element)
    }
    
    // 添加指针事件（允许交互）
    this.element.style.pointerEvents = 'auto'
    
    // 添加进入动画
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateY(-20px)'
    this.element.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
    
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.opacity = '1'
        this.element.style.transform = 'translateY(0)'
      })
    })
    
    // 自动关闭
    if (this.durationValue > 0) {
      this.timeout = setTimeout(() => {
        this.close()
      }, this.durationValue)
    }
  }

  close() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
    
    // 添加退出动画
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateY(-20px)'
    
    setTimeout(() => {
      this.element.remove()
      
      // 如果容器为空，移除容器
      const container = document.querySelector('.ant-message')
      if (container && container.children.length === 0) {
        container.remove()
      }
    }, 300)
  }

  getContainer() {
    let container = document.querySelector('.ant-message')
    
    if (!container) {
      container = document.createElement('div')
      container.className = 'ant-message fixed top-6 left-1/2 -translate-x-1/2 z-[9999] flex flex-col gap-2 items-center pointer-events-none'
      document.body.appendChild(container)
    }
    
    return container
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}
