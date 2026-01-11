import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectAll", "selectRow", "sortIcon", "filterDropdown"]
  static values = {
    sortColumn: String,
    sortDirection: String,
    selectedRows: Array
  }

  connect() {
    this.selectedRowsValue = []
  }

  // 排序功能
  sort(event) {
    const column = event.currentTarget.dataset.column
    const currentDirection = event.currentTarget.dataset.direction || "none"
    
    let newDirection = "ascend"
    if (currentDirection === "ascend") {
      newDirection = "descend"
    } else if (currentDirection === "descend") {
      newDirection = "none"
    }
    
    // 更新图标状态
    this.updateSortIcons(column, newDirection)
    
    // 触发自定义事件
    this.dispatch("sort", {
      detail: { column, direction: newDirection }
    })
  }

  updateSortIcons(column, direction) {
    // 重置所有排序图标
    this.element.querySelectorAll('[data-sortable]').forEach(header => {
      const icon = header.querySelector('svg')
      if (icon && header.dataset.column !== column) {
        header.dataset.direction = "none"
        this.updateIconColors(icon, "none")
      }
    })
    
    // 更新当前列的排序图标
    const currentHeader = this.element.querySelector(`[data-column="${column}"]`)
    if (currentHeader) {
      const icon = currentHeader.querySelector('svg')
      currentHeader.dataset.direction = direction
      if (icon) {
        this.updateIconColors(icon, direction)
      }
    }
  }

  updateIconColors(svg, direction) {
    const paths = svg.querySelectorAll('path')
    if (paths.length >= 2) {
      // 第一个 path 是向上箭头，第二个是向下箭头
      const ascendPath = paths[0]
      const descendPath = paths[1]
      
      if (direction === "ascend") {
        ascendPath.classList.remove('text-gray-400')
        ascendPath.classList.add('text-[#1677ff]')
        descendPath.classList.remove('text-[#1677ff]')
        descendPath.classList.add('text-gray-400')
      } else if (direction === "descend") {
        ascendPath.classList.remove('text-[#1677ff]')
        ascendPath.classList.add('text-gray-400')
        descendPath.classList.remove('text-gray-400')
        descendPath.classList.add('text-[#1677ff]')
      } else {
        ascendPath.classList.remove('text-[#1677ff]')
        ascendPath.classList.add('text-gray-400')
        descendPath.classList.remove('text-[#1677ff]')
        descendPath.classList.add('text-gray-400')
      }
    }
  }

  getSortIcon(direction) {
    const ascendActive = direction === "ascend" ? "text-[#1677ff]" : "text-gray-400"
    const descendActive = direction === "descend" ? "text-[#1677ff]" : "text-gray-400"
    
    return `
      <svg class="w-3 h-3" viewBox="0 0 16 16" fill="none">
        <path d="M8 3L12 7H4L8 3Z" class="${ascendActive} transition-colors" fill="currentColor"/>
        <path d="M8 13L4 9H12L8 13Z" class="${descendActive} transition-colors" fill="currentColor"/>
      </svg>
    `
  }

  // 筛选功能
  toggleFilter(event) {
    event.stopPropagation()
    const column = event.currentTarget.dataset.column
    const button = event.currentTarget // 保存按钮引用
    
    // 找到对应的下拉菜单
    const dropdown = this.element.querySelector(`[data-ant--table-target="filterDropdown"][data-column="${column}"]`)
    
    if (dropdown) {
      // 关闭所有其他下拉菜单
      this.filterDropdownTargets.forEach(d => {
        if (d !== dropdown) {
          d.classList.add('hidden')
        }
      })
      
      // 切换当前下拉菜单
      dropdown.classList.toggle('hidden')
    }
    
    // 点击外部关闭下拉菜单
    if (dropdown && !dropdown.classList.contains('hidden')) {
      const closeDropdown = (e) => {
        if (!dropdown.contains(e.target) && !button.contains(e.target)) {
          dropdown.classList.add('hidden')
          document.removeEventListener('click', closeDropdown)
        }
      }
      setTimeout(() => document.addEventListener('click', closeDropdown), 0)
    }
  }

  applyFilter(event) {
    const column = event.currentTarget.dataset.column
    const value = event.currentTarget.dataset.value
    
    // 关闭下拉框
    const dropdown = event.currentTarget.closest('[data-ant--table-target="filterDropdown"]')
    if (dropdown) {
      dropdown.classList.add('hidden')
    }
    
    // 触发自定义事件
    this.dispatch("filter", {
      detail: { column, value }
    })
  }

  clearFilter(event) {
    const column = event.currentTarget.dataset.column
    
    // 关闭下拉框
    const dropdown = event.currentTarget.closest('[data-ant--table-target="filterDropdown"]')
    if (dropdown) {
      dropdown.classList.add('hidden')
    }
    
    // 触发自定义事件
    this.dispatch("filterClear", {
      detail: { column }
    })
  }

  // 行选择功能
  toggleSelectAll(event) {
    const isChecked = event.target.checked
    
    this.selectRowTargets.forEach(checkbox => {
      checkbox.checked = isChecked
      checkbox.dispatchEvent(new Event('change', { bubbles: true }))
    })
    
    this.updateSelectedRows()
  }

  toggleSelectRow(event) {
    this.updateSelectedRows()
    this.updateSelectAllState()
  }

  updateSelectedRows() {
    const selected = []
    this.selectRowTargets.forEach(checkbox => {
      if (checkbox.checked) {
        selected.push(checkbox.value)
      }
    })
    
    this.selectedRowsValue = selected
    
    // 触发自定义事件
    this.dispatch("selectionChange", {
      detail: { selectedRows: selected }
    })
  }

  updateSelectAllState() {
    if (!this.hasSelectAllTarget) return
    
    const total = this.selectRowTargets.length
    const checked = this.selectRowTargets.filter(cb => cb.checked).length
    
    if (checked === 0) {
      this.selectAllTarget.checked = false
      this.selectAllTarget.indeterminate = false
    } else if (checked === total) {
      this.selectAllTarget.checked = true
      this.selectAllTarget.indeterminate = false
    } else {
      this.selectAllTarget.checked = false
      this.selectAllTarget.indeterminate = true
    }
  }

  selectedRowsValueChanged() {
    console.log('Selected rows:', this.selectedRowsValue)
  }
}
