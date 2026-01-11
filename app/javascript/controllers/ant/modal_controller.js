import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel"]
  static values = { open: Boolean }

  connect() {
    // Expose controller instance to element for external access
    this.element.ant_modal_controller = this
    
    if (this.openValue) {
      this.show()
    }
  }

  open(event) {
    if (event) event.preventDefault()
    this.openValue = true
  }

  close(event) {
    if (event) event.preventDefault()
    this.openValue = false
  }
  
  ok(event) {
    this.close(event)
  }

  closeByBackdrop(event) {
    this.close(event)
  }

  openValueChanged() {
    if (this.openValue) {
      this.show()
    } else {
      this.hide()
    }
  }

  show() {
    this.element.classList.remove("hidden")
    
    requestAnimationFrame(() => {
      this.backdropTarget.classList.remove("opacity-0")
      this.backdropTarget.classList.add("opacity-100")

      this.panelTarget.classList.remove("opacity-0", "scale-95", "translate-y-4", "sm:translate-y-0")
      this.panelTarget.classList.add("opacity-100", "scale-100", "translate-y-0")
    })
    
    document.body.style.overflow = "hidden" 
  }

  hide() {
    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")

    this.panelTarget.classList.remove("opacity-100", "scale-100", "translate-y-0")
    this.panelTarget.classList.add("opacity-0", "scale-95", "translate-y-4", "sm:translate-y-0")

    setTimeout(() => {
      this.element.classList.add("hidden")
      document.body.style.overflow = "" 
    }, 200) 
  }
}
