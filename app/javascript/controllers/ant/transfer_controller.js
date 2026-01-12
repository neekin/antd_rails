import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["leftItem", "rightItem", "input", "empty"]

  connect() {
    // 初始化所有列表项的点击事件
    this.updateItems()
  }

  updateItems() {
    // 为左侧项目添加选择样式
    this.leftItemTargets.forEach(item => {
      item.addEventListener('click', (e) => {
        if (!this.isDisabled()) {
          item.classList.toggle('bg-[#e6f4ff]')
          item.classList.toggle('border-[#1677ff]')
        }
      })
    })

    // 为右侧项目添加选择样式
    this.rightItemTargets.forEach(item => {
      item.addEventListener('click', (e) => {
        if (!this.isDisabled()) {
          item.classList.toggle('bg-[#e6f4ff]')
          item.classList.toggle('border-[#1677ff]')
        }
      })
    })
  }

  toRight(event) {
    event.preventDefault()
    if (this.isDisabled()) return

    // 获取左侧选中的项
    const selectedItems = this.leftItemTargets.filter(item => 
      item.classList.contains('bg-[#e6f4ff]')
    )

    if (selectedItems.length === 0) return

    // 移动项目到右侧
    selectedItems.forEach(item => {
      // 移除选中状态
      item.classList.remove('bg-[#e6f4ff]', 'border-[#1677ff]')
      
      // 找到右侧面板
      const panels = this.element.querySelectorAll('.flex-1')
      const rightPanel = panels[panels.length - 1].querySelector('.p-2')
      
      if (rightPanel) {
        const ul = rightPanel.querySelector('ul') || this.createList(rightPanel)
        const newItem = this.createRightItem(item.textContent.trim(), item.dataset.value)
        ul.appendChild(newItem)
      }
      
      // 移除左侧项目
      item.remove()
    })

    // 更新隐藏输入字段
    this.updateHiddenInputs()
    
    // 更新计数
    this.updateCounts()
  }

  toLeft(event) {
    event.preventDefault()
    if (this.isDisabled()) return

    // 获取右侧选中的项
    const selectedItems = this.rightItemTargets.filter(item => 
      item.classList.contains('bg-[#e6f4ff]')
    )

    if (selectedItems.length === 0) return

    // 移动项目到左侧
    selectedItems.forEach(item => {
      // 移除选中状态
      item.classList.remove('bg-[#e6f4ff]', 'border-[#1677ff]')
      
      // 找到左侧面板（第一个 .flex-1）
      const panels = this.element.querySelectorAll('.flex-1')
      const leftPanel = panels[0].querySelector('.p-2')
      
      if (leftPanel) {
        const ul = leftPanel.querySelector('ul') || this.createList(leftPanel)
        const newItem = this.createLeftItem(item.textContent.trim(), item.dataset.value)
        ul.appendChild(newItem)
      }
      
      // 移除右侧项目
      item.remove()
    })

    // 更新隐藏输入字段
    this.updateHiddenInputs()
    
    // 更新计数
    this.updateCounts()
  }

  createLeftItem(label, value) {
    const li = document.createElement('li')
    li.className = 'px-2 py-1 rounded hover:bg-[#f5f5f5] cursor-pointer'
    li.dataset.value = value
    // 正确的 Stimulus target 属性设置
    li.setAttribute('data-ant--transfer-target', 'leftItem')
    li.textContent = label
    
    li.addEventListener('click', () => {
      if (!this.isDisabled()) {
        li.classList.toggle('bg-[#e6f4ff]')
        li.classList.toggle('border-[#1677ff]')
      }
    })
    
    return li
  }

  createRightItem(label, value) {
    const li = document.createElement('li')
    li.className = 'px-2 py-1 rounded hover:bg-[#f5f5f5] cursor-pointer'
    li.dataset.value = value
    // 正确的 Stimulus target 属性设置
    li.setAttribute('data-ant--transfer-target', 'rightItem')
    li.textContent = label
    
    li.addEventListener('click', () => {
      if (!this.isDisabled()) {
        li.classList.toggle('bg-[#e6f4ff]')
        li.classList.toggle('border-[#1677ff]')
      }
    })
    
    return li
  }

  createList(panel) {
    // 移除 "No Data" 提示
    const noData = panel.querySelector('.text-center')
    if (noData) noData.remove()
    
    const ul = document.createElement('ul')
    ul.className = 'space-y-1'
    panel.appendChild(ul)
    return ul
  }

  updateHiddenInputs() {
    // 移除所有现有的隐藏输入
    this.inputTargets.forEach(input => input.remove())
    if (this.hasEmptyTarget) {
      this.emptyTarget.remove()
    }

    // 获取右侧所有项的值
    const rightValues = this.rightItemTargets.map(item => item.dataset.value)

    // 获取 name 属性
    const firstInput = this.element.querySelector('input[type="hidden"]')
    const name = firstInput ? firstInput.name : 'transfer[]'

    if (rightValues.length === 0) {
      // 如果没有选中项，添加空输入以保持表单字段
      const emptyInput = document.createElement('input')
      emptyInput.type = 'hidden'
      emptyInput.name = name
      emptyInput.value = ''
      emptyInput.setAttribute('data-ant--transfer-target', 'empty')
      this.element.insertBefore(emptyInput, this.element.firstChild)
    } else {
      // 为每个选中值创建隐藏输入
      rightValues.forEach(value => {
        const input = document.createElement('input')
        input.type = 'hidden'
        input.name = name
        input.value = value
        input.setAttribute('data-ant--transfer-target', 'input')
        this.element.insertBefore(input, this.element.firstChild)
      })
    }
  }

  updateCounts() {
    // 更新左侧计数
    const leftHeader = this.element.querySelector('.flex-1:first-of-type .border-b')
    if (leftHeader) {
      const leftCount = this.leftItemTargets.length
      leftHeader.textContent = leftHeader.textContent.replace(/\(\d+\)/, `(${leftCount})`)
    }

    // 更新右侧计数
    const rightHeader = this.element.querySelector('.flex-1:last-of-type .border-b')
    if (rightHeader) {
      const rightCount = this.rightItemTargets.length
      rightHeader.textContent = rightHeader.textContent.replace(/\(\d+\)/, `(${rightCount})`)
    }

    // 如果列表为空，显示 "No Data"
    this.checkEmptyLists()
  }

  checkEmptyLists() {
    // 检查左侧
    const leftPanel = this.element.querySelector('.flex-1:first-of-type .p-2')
    if (leftPanel && this.leftItemTargets.length === 0) {
      leftPanel.innerHTML = '<div class="text-center text-gray-400 py-8">No Data</div>'
    }

    // 检查右侧
    const rightPanel = this.element.querySelector('.flex-1:last-of-type .p-2')
    if (rightPanel && this.rightItemTargets.length === 0) {
      rightPanel.innerHTML = '<div class="text-center text-gray-400 py-8">No Data</div>'
    }
  }

  isDisabled() {
    return this.element.querySelector('button[disabled]') !== null
  }
}
