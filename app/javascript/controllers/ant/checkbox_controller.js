import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "box", "checkmark", "indeterminate"]
  static values = { indeterminate: Boolean }

  connect() {
    this.updateUI()
  }

  handleChange(event) {
    // 如果处于半选状态，变更为全选
    if (this.indeterminateValue) {
      this.indeterminateValue = false
      this.inputTarget.checked = true
    }

    this.updateUI()

    // 触发自定义事件
    const customEvent = new CustomEvent('checkbox:change', {
      detail: {
        name: this.inputTarget.name,
        value: this.inputTarget.value,
        checked: this.inputTarget.checked
      },
      bubbles: true
    })
    
    this.element.dispatchEvent(customEvent)
  }

  updateUI() {
    const isChecked = this.inputTarget.checked
    const isIndeterminate = this.indeterminateValue

    if (isIndeterminate) {
      // 半选状态
      this.inputTarget.indeterminate = true
      this.boxTarget.classList.remove('border-gray-300')
      this.boxTarget.classList.add('border-[#1677ff]', 'bg-[#1677ff]')
      this.checkmarkTarget.style.display = 'none'
      this.checkmarkTarget.classList.remove('opacity-100', 'scale-100')
      this.checkmarkTarget.classList.add('opacity-0', 'scale-50')
      this.indeterminateTarget.style.display = 'flex'
      this.indeterminateTarget.classList.remove('opacity-0', 'scale-50')
      this.indeterminateTarget.classList.add('opacity-100', 'scale-100')
    } else if (isChecked) {
      // 选中状态
      this.inputTarget.indeterminate = false
      this.boxTarget.classList.remove('border-gray-300')
      this.boxTarget.classList.add('border-[#1677ff]', 'bg-[#1677ff]')
      this.checkmarkTarget.style.display = 'flex'
      this.checkmarkTarget.classList.remove('opacity-0', 'scale-50')
      this.checkmarkTarget.classList.add('opacity-100', 'scale-100')
      this.indeterminateTarget.style.display = 'none'
      this.indeterminateTarget.classList.remove('opacity-100', 'scale-100')
      this.indeterminateTarget.classList.add('opacity-0', 'scale-50')
    } else {
      // 未选中状态
      this.inputTarget.indeterminate = false
      this.boxTarget.classList.remove('border-[#1677ff]', 'bg-[#1677ff]')
      this.boxTarget.classList.add('border-gray-300')
      this.checkmarkTarget.style.display = 'flex'
      this.checkmarkTarget.classList.remove('opacity-100', 'scale-100')
      this.checkmarkTarget.classList.add('opacity-0', 'scale-50')
      this.indeterminateTarget.style.display = 'none'
      this.indeterminateTarget.classList.remove('opacity-100', 'scale-100')
      this.indeterminateTarget.classList.add('opacity-0', 'scale-50')
    }
  }

  indeterminateValueChanged() {
    this.updateUI()
  }
}
