import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 4500 },
    placement: { type: String, default: 'topRight' }
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
    
    // 添加进入动画
    this.element.style.opacity = '0'
    this.element.style.transform = this.placementValue.includes('Right') ? 'translateX(100%)' : 'translateX(-100%)'
    this.element.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
    
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.element.style.opacity = '1'
        this.element.style.transform = 'translateX(0)'
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
    this.element.style.transform = this.placementValue.includes('Right') ? 'translateX(100%)' : 'translateX(-100%)'
    
    setTimeout(() => {
      this.element.remove()
      
      // 如果容器为空，移除容器
      const container = document.querySelector(`.ant-notification-${this.placementValue}`)
      if (container && container.children.length === 0) {
        container.remove()
      }
    }, 300)
  }

  getContainer() {
    const className = `ant-notification-${this.placementValue}`
    let container = document.querySelector(`.${className}`)
    
    if (!container) {
      container = document.createElement('div')
      container.className = `ant-notification ${className} ${this.getPositionClasses()}`
      document.body.appendChild(container)
    }
    
    return container
  }

  getPositionClasses() {
    const positions = {
      topLeft: 'fixed top-6 left-6 z-[9999] flex flex-col gap-4 pointer-events-none',
      topRight: 'fixed top-6 right-6 z-[9999] flex flex-col gap-4 pointer-events-none',
      bottomLeft: 'fixed bottom-6 left-6 z-[9999] flex flex-col-reverse gap-4 pointer-events-none',
      bottomRight: 'fixed bottom-6 right-6 z-[9999] flex flex-col-reverse gap-4 pointer-events-none'
    }
    
    return positions[this.placementValue] || positions.topRight
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }
}
