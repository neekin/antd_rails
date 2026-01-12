import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["monthYear", "monthPanel", "yearPanel", "daysGrid"]
  static values = {
    mode: { type: String, default: "month" },
    value: { type: String, default: "" },
    selectable: { type: Boolean, default: false },
    locale: { type: String, default: "en" },
    events: { type: Array, default: [] }
  }

  connect() {
    this.currentDate = this.valueValue ? new Date(this.valueValue) : new Date()
    this.selectedDate = new Date(this.currentDate)
    this.render()
  }

  prevMonth() {
    if (this.modeValue === 'month') {
      this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() - 1, 1)
    } else {
      this.currentDate = new Date(this.currentDate.getFullYear() - 1, this.currentDate.getMonth(), 1)
    }
    this.render()
  }

  nextMonth() {
    if (this.modeValue === 'month') {
      this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 1)
    } else {
      this.currentDate = new Date(this.currentDate.getFullYear() + 1, this.currentDate.getMonth(), 1)
    }
    this.render()
  }

  selectToday() {
    this.currentDate = new Date()
    this.selectedDate = new Date()
    this.render()
    this.dispatchSelectEvent(this.selectedDate)
  }

  switchMode(event) {
    const newMode = event.currentTarget.dataset.mode
    if (newMode !== this.modeValue) {
      this.modeValue = newMode
      this.render()
    }
  }

  selectDate(event) {
    if (!this.selectableValue) return
    
    const dateString = event.currentTarget.dataset.date
    // Parse date string as local date to avoid timezone issues
    const [year, month, day] = dateString.split('-').map(Number)
    this.selectedDate = new Date(year, month - 1, day)
    this.currentDate = new Date(this.selectedDate)
    this.render()
    this.dispatchSelectEvent(this.selectedDate)
  }

  selectMonth(event) {
    const month = parseInt(event.currentTarget.dataset.month)
    this.currentDate = new Date(this.currentDate.getFullYear(), month - 1, 1)
    this.modeValue = 'month'
    this.render()
  }

  render() {
    this.updateHeader()
    if (this.modeValue === 'month') {
      this.renderMonthView()
    } else {
      this.renderYearView()
    }
    this.updateModeButtons()
  }

  updateHeader() {
    if (!this.hasMonthYearTarget) return
    
    const formatter = this.modeValue === 'month'
      ? new Intl.DateTimeFormat(this.localeValue, { month: 'long', year: 'numeric' })
      : new Intl.DateTimeFormat(this.localeValue, { year: 'numeric' })
    
    this.monthYearTarget.textContent = formatter.format(this.currentDate)
  }

  renderMonthView() {
    if (!this.hasDaysGridTarget) return
    
    const year = this.currentDate.getFullYear()
    const month = this.currentDate.getMonth()
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const prevLastDay = new Date(year, month, 0)
    
    const firstDayOfWeek = firstDay.getDay()
    const daysInMonth = lastDay.getDate()
    const daysInPrevMonth = prevLastDay.getDate()
    
    let html = ''
    
    // Previous month days
    for (let i = firstDayOfWeek - 1; i >= 0; i--) {
      const day = daysInPrevMonth - i
      const date = new Date(year, month - 1, day)
      html += this.renderDayCell(date, true)
    }
    
    // Current month days
    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(year, month, day)
      html += this.renderDayCell(date, false)
    }
    
    // Next month days
    const remainingDays = 42 - (firstDayOfWeek + daysInMonth)
    for (let day = 1; day <= remainingDays; day++) {
      const date = new Date(year, month + 1, day)
      html += this.renderDayCell(date, true)
    }
    
    this.daysGridTarget.innerHTML = html
  }

  renderDayCell(date, outsideMonth) {
    const isToday = this.isToday(date)
    const isSelected = this.selectableValue && this.isSameDay(date, this.selectedDate)
    const hasEvents = this.hasEvents(date)
    
    const classes = [
      'relative min-h-[80px] p-2 rounded-lg border border-transparent transition-all',
      outsideMonth ? 'text-gray-300 bg-gray-50' : 'text-gray-900 hover:border-blue-300 hover:bg-blue-50 cursor-pointer',
      isToday ? 'ring-2 ring-blue-500' : '',
      isSelected ? 'bg-blue-100 border-blue-500' : ''
    ].filter(Boolean).join(' ')
    
    const action = this.selectableValue && !outsideMonth ? 'click->ant--calendar#selectDate' : ''
    // Use local date format to avoid timezone issues
    const dateStr = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
    
    let eventHtml = ''
    if (hasEvents) {
      const dayEvents = this.getDateEvents(date)
      eventHtml = '<div class="mt-1 space-y-1">'
      dayEvents.slice(0, 3).forEach(event => {
        const colorClass = this.getEventColorClass(event.color)
        eventHtml += `<div class="text-xs px-1 py-0.5 rounded truncate ${colorClass}">${this.escapeHtml(event.title)}</div>`
      })
      if (dayEvents.length > 3) {
        eventHtml += `<div class="text-xs text-gray-500">+${dayEvents.length - 3} more</div>`
      }
      eventHtml += '</div>'
    }
    
    return `
      <div class="${classes}" data-action="${action}" data-date="${dateStr}">
        <div class="text-sm font-medium ${isToday ? 'text-blue-600' : ''}">${date.getDate()}</div>
        ${eventHtml}
      </div>
    `
  }

  renderYearView() {
    // Year view is rendered server-side, no need to re-render
  }

  updateModeButtons() {
    const buttons = this.element.querySelectorAll('[data-mode]')
    buttons.forEach(button => {
      const mode = button.dataset.mode
      if (mode === this.modeValue) {
        button.classList.remove('bg-white', 'text-gray-700')
        button.classList.add('bg-blue-500', 'text-white')
      } else {
        button.classList.remove('bg-blue-500', 'text-white')
        button.classList.add('bg-white', 'text-gray-700')
      }
    })
  }

  isToday(date) {
    const today = new Date()
    return this.isSameDay(date, today)
  }

  isSameDay(date1, date2) {
    return date1.getFullYear() === date2.getFullYear() &&
           date1.getMonth() === date2.getMonth() &&
           date1.getDate() === date2.getDate()
  }

  hasEvents(date) {
    return this.eventsValue.some(event => {
      const eventDate = new Date(event.date)
      return this.isSameDay(eventDate, date)
    })
  }

  getDateEvents(date) {
    return this.eventsValue.filter(event => {
      const eventDate = new Date(event.date)
      return this.isSameDay(eventDate, date)
    })
  }

  getEventColorClass(color) {
    const colors = {
      'blue': 'bg-blue-100 text-blue-700',
      'green': 'bg-green-100 text-green-700',
      'red': 'bg-red-100 text-red-700',
      'yellow': 'bg-yellow-100 text-yellow-700',
      'purple': 'bg-purple-100 text-purple-700'
    }
    return colors[color] || 'bg-gray-100 text-gray-700'
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }

  dispatchSelectEvent(date) {
    this.dispatch('select', {
      detail: {
        date: date,
        dateString: date.toISOString().split('T')[0]
      }
    })
  }
}
