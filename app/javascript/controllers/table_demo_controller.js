import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tableContainer", "totalCount", "filterInfo", "sortInfo", "toolbar", "selectionInfo"]
  static values = {
    initialData: String
  }

  connect() {
    console.log("📊 Table Demo 已加载 - 支持完整的客户端排序和筛选")
    
    // 解析初始数据
    try {
      this.allData = JSON.parse(this.initialDataValue || "[]")
      this.filteredData = [...this.allData]
      this.currentSort = { column: null, direction: "none" }
      this.currentFilters = {}
      this.selectedIds = []
      
      console.log(`✅ 加载了 ${this.allData.length} 条数据`)
    } catch (e) {
      console.error("解析数据失败:", e)
      this.allData = []
      this.filteredData = []
    }
    
    // 监听表格事件
    this.sortHandler = this.handleSort.bind(this)
    this.filterHandler = this.handleFilter.bind(this)
    this.filterClearHandler = this.handleFilterClear.bind(this)
    this.selectionChangeHandler = this.handleSelectionChange.bind(this)
    
    this.element.addEventListener("ant--table:sort", this.sortHandler)
    this.element.addEventListener("ant--table:filter", this.filterHandler)
    this.element.addEventListener("ant--table:filterClear", this.filterClearHandler)
    this.element.addEventListener("ant--table:selectionChange", this.selectionChangeHandler)
  }

  disconnect() {
    this.element.removeEventListener("ant--table:sort", this.sortHandler)
    this.element.removeEventListener("ant--table:filter", this.filterHandler)
    this.element.removeEventListener("ant--table:filterClear", this.filterClearHandler)
    this.element.removeEventListener("ant--table:selectionChange", this.selectionChangeHandler)
  }

  handleSort(event) {
    const { column, direction } = event.detail
    const dirText = direction === 'ascend' ? '升序↑' : direction === 'descend' ? '降序↓' : '无排序'
    console.log(`📊 排序: ${column} - ${dirText}`)
    
    this.currentSort = { column, direction }
    this.updateSortInfo(column, direction)
    this.applyFiltersAndSort()
  }

  handleFilter(event) {
    const { column, value } = event.detail
    console.log(`🔍 筛选: ${column} = ${value}`)
    
    this.currentFilters[column] = value
    this.updateFilterInfo()
    this.applyFiltersAndSort()
  }

  handleFilterClear(event) {
    const { column } = event.detail
    console.log(`🗑️ 清除筛选: ${column}`)
    
    delete this.currentFilters[column]
    this.updateFilterInfo()
    this.applyFiltersAndSort()
  }

  handleSelectionChange(event) {
    const { selectedRows } = event.detail
    this.selectedIds = selectedRows
    console.log(`✅ 选中 ${selectedRows.length} 行:`, selectedRows)
    
    if (this.hasToolbarTarget) {
      if (this.selectedIds.length > 0) {
        this.toolbarTarget.classList.remove('hidden')
        this.selectionInfoTarget.textContent = `已选择 ${this.selectedIds.length} 项`
      } else {
        this.toolbarTarget.classList.add('hidden')
      }
    }
  }

  applyFiltersAndSort() {
    let result = [...this.allData]
    
    // 应用筛选
    Object.entries(this.currentFilters).forEach(([column, value]) => {
      result = result.filter(item => {
        const itemValue = item[column.toLowerCase()]
        // 处理 Symbol 类型 (:success -> "success")
        const normalizedValue = String(itemValue).replace(/^:/, '')
        return normalizedValue.toLowerCase() === String(value).toLowerCase()
      })
    })
    
    // 应用排序
    if (this.currentSort.direction !== "none" && this.currentSort.column) {
      const column = this.currentSort.column.toLowerCase()
      result.sort((a, b) => {
        let aVal = a[column]
        let bVal = b[column]
        
        // 处理数字
        if (typeof aVal === 'number' && typeof bVal === 'number') {
          return this.currentSort.direction === "ascend" ? aVal - bVal : bVal - aVal
        }
        
        // 转换为字符串比较
        aVal = String(aVal)
        bVal = String(bVal)
        
        const comparison = aVal.localeCompare(bVal)
        return this.currentSort.direction === "ascend" ? comparison : -comparison
      })
    }
    
    this.filteredData = result
    this.renderTable()
    this.updateTotalCount()
    
    console.log(`✨ 显示 ${result.length} / ${this.allData.length} 条数据`)
  }

  renderTable() {
    const tableHTML = this.generateTableHTML(this.filteredData)
    this.tableContainerTarget.innerHTML = tableHTML
  }

  generateTableHTML(data) {
    const rows = data.map(item => {
      const status = String(item.status).replace(':', '')
      return `
        <tr class="hover:bg-gray-50">
          <td class="px-4 py-3 w-12">
            <input type="checkbox" 
                   class="w-4 h-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                   value="${item.id}"
                   data-ant--table-target="selectRow"
                   data-action="change->ant--table#toggleSelectRow">
          </td>
          <td class="px-4 py-3 w-16 font-mono">${item.id}</td>
          <td class="px-4 py-3 font-medium">${item.name}</td>
          <td class="px-4 py-3">
            <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-blue-50 text-blue-700">${item.role}</span>
          </td>
          <td class="px-4 py-3">
            <span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium ${this.getStatusClass(status)}">Active</span>
          </td>
          <td class="px-4 py-3 text-sm text-gray-600">${item.email}</td>
          <td class="px-4 py-3 text-blue-600"><a href="#" class="hover:underline">编辑</a></td>
        </tr>
      `
    }).join('')
    
    const emptyState = data.length === 0 ? `
      <tr>
        <td colspan="7" class="px-4 py-12 text-center text-gray-400">
          <div class="flex flex-col items-center gap-2">
            <svg class="w-12 h-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
            </svg>
            <span>无匹配数据</span>
          </div>
        </td>
      </tr>
    ` : rows
    
    return `
      <div class="relative flex flex-col border border-[#f0f0f0] rounded-lg bg-white" data-controller="ant--table">
        <div class="overflow-x-auto overflow-y-hidden rounded-t-lg isolate">
          <table class="w-full text-left text-sm whitespace-nowrap border-collapse">
            <thead class="bg-[#fafafa] border-b border-[#f0f0f0]">
              <tr>
                <th class="px-4 py-3 w-12">
                  <input type="checkbox" class="w-4 h-4" data-ant--table-target="selectAll" data-action="change->ant--table#toggleSelectAll">
                </th>
                ${this.generateHeader('ID', 'w-16 font-mono', true, false)}
                ${this.generateHeader('Name', 'font-medium', true, false)}
                ${this.generateHeader('Role', '', false, true, [
                  {text: "Developer", value: "Developer"},
                  {text: "Designer", value: "Designer"},
                  {text: "Manager", value: "Manager"}
                ])}
                ${this.generateHeader('Status', '', false, true, [
                  {text: "Success", value: "success"},
                  {text: "Processing", value: "processing"},
                  {text: "Error", value: "error"}
                ])}
                <th class="px-4 py-3 font-semibold text-gray-900 text-sm text-gray-600">Email</th>
                <th class="px-4 py-3 font-semibold text-gray-900 text-blue-600">Action</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-[#f0f0f0] bg-white">
              ${emptyState}
            </tbody>
          </table>
        </div>
      </div>
    `
  }

  generateHeader(title, className = '', sortable = false, filterable = false, filters = []) {
    const sortIcon = sortable ? `
      <span class="cursor-pointer select-none flex items-center gap-2" 
            data-sortable="true" 
            data-column="${title}" 
            data-direction="${this.currentSort.column === title ? this.currentSort.direction : 'none'}"
            data-action="click->ant--table#sort">
        ${title}
        <svg class="w-3 h-3" viewBox="0 0 16 16" fill="none">
          <path d="M8 3L12 7H4L8 3Z" class="${this.currentSort.column === title && this.currentSort.direction === 'ascend' ? 'text-[#1677ff]' : 'text-gray-400'}" fill="currentColor"/>
          <path d="M8 13L4 9H12L8 13Z" class="${this.currentSort.column === title && this.currentSort.direction === 'descend' ? 'text-[#1677ff]' : 'text-gray-400'}" fill="currentColor"/>
        </svg>
      </span>
    ` : title

    const filterBtn = filterable ? `
      <div class="relative">
        <button type="button" class="inline-flex opacity-0 group-hover:opacity-100 text-gray-400 hover:text-[#1677ff]"
                data-column="${title}" data-action="click->ant--table#toggleFilter">
          <svg class="w-4 h-4" viewBox="0 0 16 16"><path d="M2 4h12M4 8h8M6 12h4" stroke="currentColor" stroke-width="1.5"/></svg>
        </button>
        <div class="hidden absolute top-full left-0 mt-1 bg-white border rounded-lg shadow-lg z-[60] min-w-[120px]"
             data-ant--table-target="filterDropdown" data-column="${title}">
          <div class="py-1">
            ${filters.map(f => `
              <button class="w-full px-4 py-2 text-left text-sm hover:bg-gray-50"
                      data-column="${title}" data-value="${f.value}"
                      data-action="click->ant--table#applyFilter">${f.text}</button>
            `).join('')}
            <div class="border-t mt-1 pt-1">
              <button class="w-full px-4 py-2 text-left text-sm text-gray-500 hover:bg-gray-50"
                      data-column="${title}" data-action="click->ant--table#clearFilter">Clear</button>
            </div>
          </div>
        </div>
      </div>
    ` : ''

    return `
      <th class="px-4 py-3 font-semibold text-gray-900 ${className} relative group">
        <div class="flex items-center gap-2">
          ${sortIcon}
          ${filterBtn}
        </div>
      </th>
    `
  }

  getStatusClass(status) {
    const map = {
      success: 'bg-green-50 text-green-700',
      processing: 'bg-blue-50 text-blue-700',
      error: 'bg-red-50 text-red-700'
    }
    return map[status] || 'bg-gray-50 text-gray-700'
  }

  updateTotalCount() {
    if (this.hasTotalCountTarget) {
      this.totalCountTarget.textContent = this.filteredData.length
    }
  }

  updateFilterInfo() {
    if (!this.hasFilterInfoTarget) return
    const count = Object.keys(this.currentFilters).length
    if (count === 0) {
      this.filterInfoTarget.innerHTML = '<span class="font-semibold">筛选:</span> 无'
    } else {
      const text = Object.entries(this.currentFilters).map(([k,v]) => `${k}=${v}`).join(', ')
      this.filterInfoTarget.innerHTML = `<span class="font-semibold">筛选:</span> <span class="text-blue-600">${text}</span>`
    }
  }

  updateSortInfo(column, direction) {
    if (!this.hasSortInfoTarget) return
    if (direction === 'none') {
      this.sortInfoTarget.innerHTML = '<span class="font-semibold">排序:</span> 无'
    } else {
      const dir = direction === 'ascend' ? '升序 ↑' : '降序 ↓'
      this.sortInfoTarget.innerHTML = `<span class="font-semibold">排序:</span> <span class="text-blue-600">${column} ${dir}</span>`
    }
  }

  batchDelete(event) {
    event.preventDefault()
    if (this.selectedIds.length === 0) return
    alert(`删除选中的 ${this.selectedIds.length} 项: ${this.selectedIds.join(', ')}`)
  }

  batchExport(event) {
    event.preventDefault()
    if (this.selectedIds.length === 0) return
    alert(`导出选中的 ${this.selectedIds.length} 项: ${this.selectedIds.join(', ')}`)
  }
}
