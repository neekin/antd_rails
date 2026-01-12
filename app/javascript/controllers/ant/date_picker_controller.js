import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "panel", "input", "label"]

  connect() {
    // 点击外部关闭面板
    this.boundClose = this.closeOnClickOutside.bind(this)
  }

  disconnect() {
    document.removeEventListener('click', this.boundClose)
  }

  toggle(event) {
    event.stopPropagation()
    
    if (this.triggerTarget.disabled) return

    const isVisible = !this.panelTarget.classList.contains('hidden')

    if (isVisible) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.panelTarget.classList.remove('hidden')
    
    // 监听点击外部
    setTimeout(() => {
      document.addEventListener('click', this.boundClose)
    }, 0)

    // 为日期单元格添加点击事件
    const days = this.panelTarget.querySelectorAll('.grid.grid-cols-7 > div:not(:empty)')
    days.forEach(day => {
      day.addEventListener('click', (e) => this.selectDate(e))
    })
  }

  close() {
    this.panelTarget.classList.add('hidden')
    document.removeEventListener('click', this.boundClose)
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  selectDate(event) {
    const dayElement = event.currentTarget
    const dayText = dayElement.textContent.trim()
    
    if (!dayText || dayElement.classList.contains('py-1')) return

    // 获取当前月份和年份
    const monthYearText = this.panelTarget.querySelector('.flex.items-center span').textContent
    const date = new Date(monthYearText)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(dayText).padStart(2, '0')
    
    const selectedDate = `${year}-${month}-${day}`

    // 更新隐藏输入
    this.inputTarget.value = selectedDate

    // 更新显示文本
    this.labelTarget.textContent = selectedDate

    // 移除其他日期的选中状态
    this.panelTarget.querySelectorAll('.grid.grid-cols-7 > div').forEach(d => {
      d.classList.remove('bg-[#1677ff]', 'text-white')
      d.classList.add('hover:bg-[#f5f5f5]', 'text-gray-700')
    })

    // 添加当前日期的选中状态
    dayElement.classList.add('bg-[#1677ff]', 'text-white')
    dayElement.classList.remove('hover:bg-[#f5f5f5]', 'text-gray-700')

    // 关闭面板
    this.close()
  }
}
