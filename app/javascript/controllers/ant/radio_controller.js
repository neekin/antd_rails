import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "circle", "dot"]

  connect() {
    this.updateUI()
  }

  handleChange(event) {
    // 更新所有同名 radio 的显示状态
    const name = this.inputTarget.name
    const allRadios = document.querySelectorAll(`input[type="radio"][name="${name}"]`)
    
    allRadios.forEach(radio => {
      const controller = this.application.getControllerForElementAndIdentifier(
        radio.closest('[data-controller="ant--radio"]'),
        'ant--radio'
      )
      if (controller) {
        controller.updateUI()
      }
    })

    // 触发自定义事件
    const customEvent = new CustomEvent('radio:change', {
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
    
    if (isChecked) {
      // 选中状态
      this.circleTarget.classList.remove('border-[#d9d9d9]')
      this.circleTarget.classList.add('border-[#1677ff]')
      this.dotTarget.classList.remove('opacity-0', 'scale-0')
      this.dotTarget.classList.add('opacity-100', 'scale-100')
    } else {
      // 未选中状态
      this.circleTarget.classList.remove('border-[#1677ff]')
      this.circleTarget.classList.add('border-[#d9d9d9]')
      this.dotTarget.classList.remove('opacity-100', 'scale-100')
      this.dotTarget.classList.add('opacity-0', 'scale-0')
    }
  }
}
