import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hiddenInput", "panel", "daysGrid", "monthYear"]
  static values = {
    name: String,
    format: String
  }

  connect() {
    this.selectedDate = this.parseCurrentValue() || new Date()
    this.currentMonth = new Date(this.selectedDate.getFullYear(), this.selectedDate.getMonth(), 1)
    this.render()
    
    // Close calendar when clicking outside
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.boundHandleClickOutside)
  }

  disconnect() {
    document.removeEventListener('click', this.boundHandleClickOutside)
  }

  parseCurrentValue() {
    if (this.hasHiddenInputTarget && this.hiddenInputTarget.value) {
      return new Date(this.hiddenInputTarget.value)
    }
    return null
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  toggle(event) {
    event.stopPropagation()
    if (this.panelTarget.classList.contains('hidden')) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.panelTarget.classList.remove('hidden')
  }

  close() {
    this.panelTarget.classList.add('hidden')
  }

  prevMonth() {
    this.currentMonth = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth() - 1, 1)
    this.render()
  }

  nextMonth() {
    this.currentMonth = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth() + 1, 1)
    this.render()
  }

  selectToday() {
    this.selectDate(new Date())
  }

  selectDate(date) {
    this.selectedDate = date
    this.updateInputs()
    this.render()
    this.close()
  }

  updateInputs() {
    const formatted = this.formatDate(this.selectedDate)
    this.inputTarget.value = formatted
    if (this.hasHiddenInputTarget) {
      this.hiddenInputTarget.value = this.formatForServer(this.selectedDate)
    }
  }

  formatDate(date) {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    
    // Simple format handling
    return `${year}-${month}-${day}`
  }

  formatForServer(date) {
    // Always send in YYYY-MM-DD format
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  render() {
    this.renderHeader()
    this.renderDays()
  }

  renderHeader() {
    const months = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
    const monthName = months[this.currentMonth.getMonth()]
    const year = this.currentMonth.getFullYear()
    this.monthYearTarget.textContent = `${year}年 ${monthName}`
  }

  renderDays() {
    const firstDay = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth(), 1)
    const lastDay = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth() + 1, 0)
    const daysInMonth = lastDay.getDate()
    const startingDayOfWeek = firstDay.getDay()
    
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    let html = ''
    
    // Previous month's days
    const prevMonthLastDay = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth(), 0)
    const prevMonthDays = prevMonthLastDay.getDate()
    for (let i = startingDayOfWeek - 1; i >= 0; i--) {
      const day = prevMonthDays - i
      html += this.renderDayButton(day, true)
    }
    
    // Current month's days
    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth(), day)
      const isToday = date.getTime() === today.getTime()
      const isSelected = this.selectedDate && 
                        date.getDate() === this.selectedDate.getDate() &&
                        date.getMonth() === this.selectedDate.getMonth() &&
                        date.getFullYear() === this.selectedDate.getFullYear()
      
      html += this.renderDayButton(day, false, isToday, isSelected, date)
    }
    
    // Next month's days to fill the grid
    const totalCells = html.match(/button/g)?.length || 0
    const remainingCells = totalCells < 35 ? 35 - totalCells : 42 - totalCells
    for (let day = 1; day <= remainingCells; day++) {
      html += this.renderDayButton(day, true)
    }
    
    this.daysGridTarget.innerHTML = html
  }

  renderDayButton(day, isOtherMonth, isToday = false, isSelected = false, date = null) {
    const baseClasses = "h-[32px] flex items-center justify-center text-[14px] rounded-md transition-all"
    let classes = baseClasses
    
    if (isOtherMonth) {
      classes += " text-gray-300 cursor-not-allowed"
    } else {
      classes += " cursor-pointer hover:bg-[#e6f4ff] text-gray-900"
      
      if (isSelected) {
        classes += " bg-[#1677ff] text-white hover:bg-[#4096ff]"
      } else if (isToday) {
        classes += " border border-[#1677ff]"
      }
    }

    const dateAttr = date ? `data-date="${this.formatForServer(date)}"` : ''
    const actionAttr = !isOtherMonth ? `data-action="click->ant--calendar#handleDayClick"` : ''
    
    return `<button type="button" class="${classes}" ${dateAttr} ${actionAttr}>${day}</button>`
  }

  handleDayClick(event) {
    const dateStr = event.currentTarget.dataset.date
    if (dateStr) {
      this.selectDate(new Date(dateStr))
    }
  }
}
