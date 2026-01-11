import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectAll", "item"]

  connect() {
    this.updateSelectAllState()
  }

  toggleSelectAll(event) {
    const isChecked = event.target.checked
    
    this.itemTargets.forEach(checkbox => {
      checkbox.checked = isChecked
      // 触发 change 事件以更新 UI
      checkbox.dispatchEvent(new Event('change', { bubbles: true }))
    })
    
    this.updateSelectAllState()
  }

  toggleItem() {
    this.updateSelectAllState()
  }

  updateSelectAllState() {
    if (!this.hasSelectAllTarget) return

    const total = this.itemTargets.length
    const checked = this.itemTargets.filter(cb => cb.checked).length

    const selectAllCheckbox = this.selectAllTarget
    const controller = this.application.getControllerForElementAndIdentifier(
      selectAllCheckbox.closest('[data-controller~="ant--checkbox"]'),
      'ant--checkbox'
    )

    if (checked === 0) {
      // 全不选
      selectAllCheckbox.checked = false
      if (controller) {
        controller.indeterminateValue = false
        controller.updateUI()
      }
    } else if (checked === total) {
      // 全选
      selectAllCheckbox.checked = true
      if (controller) {
        controller.indeterminateValue = false
        controller.updateUI()
      }
    } else {
      // 部分选中
      selectAllCheckbox.checked = false
      if (controller) {
        controller.indeterminateValue = true
        controller.updateUI()
      }
    }
  }
}
