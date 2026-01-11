import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "handle"]
  static values = { 
    checked: Boolean,
    disabled: Boolean
  }

  toggle(event) {
    event.preventDefault()
    
    if (this.disabledValue) {
      return
    }
    
    // Toggle the checked state
    this.checkedValue = !this.checkedValue
  }

  checkedValueChanged() {
    // Update hidden input value
    this.inputTarget.value = this.checkedValue ? '1' : '0'
    
    // Update aria-checked
    this.buttonTarget.setAttribute('aria-checked', this.checkedValue)
    
    // Update button background color
    if (this.checkedValue) {
      this.buttonTarget.classList.remove('bg-[rgba(0,0,0,0.25)]')
      this.buttonTarget.classList.add('bg-[#1677ff]')
    } else {
      this.buttonTarget.classList.remove('bg-[#1677ff]')
      this.buttonTarget.classList.add('bg-[rgba(0,0,0,0.25)]')
    }
    
    // Update handle position based on size
    const isSmall = this.buttonTarget.classList.contains('h-[16px]')
    const translateClass = this.checkedValue 
      ? (isSmall ? 'translate-x-[14px]' : 'translate-x-[24px]')
      : 'translate-x-[2px]'
    
    // Remove all translate classes and add the correct one
    this.handleTarget.classList.remove('translate-x-[2px]', 'translate-x-[14px]', 'translate-x-[24px]')
    this.handleTarget.classList.add(translateClass)
    
    // Dispatch custom event for form validation or other listeners
    this.element.dispatchEvent(new CustomEvent('switch:change', {
      detail: { checked: this.checkedValue },
      bubbles: true
    }))
  }
}
