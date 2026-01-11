import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "trigger", "label", "panel", "option"]
  static values = { open: Boolean }

  connect() {
    this.clickOutside = this.clickOutside.bind(this)
  }

  toggle(event) {
    event.preventDefault()
    this.openValue = !this.openValue
  }

  openValueChanged() {
    if (this.openValue) {
      this.panelTarget.classList.remove("hidden")
      // Animate later?
      document.addEventListener("click", this.clickOutside)
    } else {
      this.panelTarget.classList.add("hidden")
      document.removeEventListener("click", this.clickOutside)
    }
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.innerText
    
    // Update Hidden Input
    this.inputTarget.value = value
    
    // Update Trigger Label
    this.labelTarget.innerText = label
    
    // Update Option Styles (Visual Selection)
    this.optionTargets.forEach(opt => {
      if (opt.dataset.value === value) {
        opt.classList.add("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
        opt.classList.remove("text-gray-700")
      } else {
        opt.classList.remove("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
        opt.classList.add("text-gray-700")
      }
    })

    // Close Dropdown
    this.openValue = false
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.openValue = false
    }
  }
}