import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toolbar", "selectionInfo"]
  
  connect() {
    this.selectedIds = []
    this.setupEventListeners()
    console.log("🎯 Table 交互示例已加载")
  }

  disconnect() {
    this.removeEventListeners()
  }

  setupEventListeners() {
    this.sortHandler = this.handleSort.bind(this)
    this.filterHandler = this.handleFilter.bind(this)
    this.filterClearHandler = this.handleFilterClear.bind(this)
    this.selectionHandler = this.handleSelection.bind(this)
    
    this.element.addEventListener("ant--table:sort", this.sortHandler)
    this.element.addEventListener("ant--table:filter", this.filterHandler)
    this.element.addEventListener("ant--table:filterClear", this.filterClearHandler)
    this.element.addEventListener("ant--table:selectionChange", this.selectionHandler)
  }

  removeEventListeners() {
    this.element.removeEventListener("ant--table:sort", this.sortHandler)
    this.element.removeEventListener("ant--table:filter", this.filterHandler)
    this.element.removeEventListener("ant--table:filterClear", this.filterClearHandler)
    this.element.removeEventListener("ant--table:selectionChange", this.selectionHandler)
  }

  handleSort(event) {
    const { column, direction } = event.detail
    console.log("📊 排序事件:", { 
      列名: column, 
      方向: direction === 'ascend' ? '升序' : direction === 'descend' ? '降序' : '无排序' 
    })
    
    const url = new URL(window.location)
    url.searchParams.set('sort_column', column)
    url.searchParams.set('sort_direction', direction)
    
    // 使用 Turbo Frame 局部刷新表格
    Turbo.visit(url.toString(), { frame: "demo_table" })
  }

  handleFilter(event) {
    const { column, value } = event.detail
    console.log("🔍 筛选事件:", { 列名: column, 筛选值: value })
    
    const url = new URL(window.location)
    url.searchParams.set(`filter_${column}`, value)
    
    Turbo.visit(url.toString(), { frame: "demo_table" })
  }

  handleFilterClear(event) {
    const { column } = event.detail
    console.log("🗑️ 清除筛选:", { 列名: column })
    
    const url = new URL(window.location)
    url.searchParams.delete(`filter_${column}`)
    
    Turbo.visit(url.toString(), { frame: "demo_table" })
  }

  handleSelection(event) {
    this.selectedIds = event.detail.selectedRows
    console.log("✅ 行选择变化:", { 
      已选择: this.selectedIds.length + " 项", 
      ID列表: this.selectedIds 
    })
    
    if (this.selectedIds.length > 0) {
      this.showToolbar()
    } else {
      this.hideToolbar()
    }
  }

  showToolbar() {
    if (this.hasToolbarTarget) {
      this.toolbarTarget.classList.remove('hidden')
      this.selectionInfoTarget.textContent = `已选择 ${this.selectedIds.length} 项`
    }
  }

  hideToolbar() {
    if (this.hasToolbarTarget) {
      this.toolbarTarget.classList.add('hidden')
    }
  }

  deleteSelected(event) {
    event.preventDefault()
    
    if (this.selectedIds.length === 0) {
      alert("请先选择要删除的项")
      return
    }
    
    const confirmed = confirm(`确定要删除选中的 ${this.selectedIds.length} 项吗？\n\nID: ${this.selectedIds.join(', ')}`)
    
    if (confirmed) {
      console.log("🗑️ 执行批量删除:", this.selectedIds)
      alert(`模拟删除成功！\n删除了 ${this.selectedIds.length} 项`)
      
      // 实际项目中的实现：
      // fetch('/users/batch_delete', {
      //   method: 'DELETE',
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      //   },
      //   body: JSON.stringify({ ids: this.selectedIds })
      // }).then(response => {
      //   if (response.ok) {
      //     Turbo.visit(window.location, { action: "replace" })
      //   }
      // })
    }
  }

  exportSelected(event) {
    event.preventDefault()
    
    if (this.selectedIds.length === 0) {
      alert("请先选择要导出的项")
      return
    }
    
    console.log("📥 执行批量导出:", this.selectedIds)
    alert(`模拟导出成功！\n导出了 ${this.selectedIds.length} 项数据`)
    
    // 实际项目中的实现：
    // const params = new URLSearchParams({ ids: this.selectedIds })
    // window.location.href = `/users/export?${params.toString()}`
  }

  clearSelection(event) {
    event.preventDefault()
    
    // 触发所有复选框的取消选中
    const checkboxes = this.element.querySelectorAll('input[type="checkbox"][data-ant--table-target="selectRow"]')
    checkboxes.forEach(checkbox => {
      if (checkbox.checked) {
        checkbox.checked = false
        checkbox.dispatchEvent(new Event('change', { bubbles: true }))
      }
    })
    
    // 同时取消全选复选框
    const selectAllCheckbox = this.element.querySelector('input[data-ant--table-target="selectAll"]')
    if (selectAllCheckbox && selectAllCheckbox.checked) {
      selectAllCheckbox.checked = false
      selectAllCheckbox.dispatchEvent(new Event('change', { bubbles: true }))
    }
    
    console.log("🔄 已清除所有选择")
  }
}
