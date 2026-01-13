import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "panel", "okButton"]
  static values = { 
    open: Boolean,
    maskClosable: { type: Boolean, default: true },
    destroyOnClose: { type: Boolean, default: false }
  }

  connect() {
    // Expose controller instance to element for external access
    this.element.ant_modal_controller = this
    
    if (this.openValue) {
      this.show()
    }

    // Listen for ESC key
    this.escHandler = this.handleEsc.bind(this)
    document.addEventListener('keydown', this.escHandler)
  }

  disconnect() {
    document.removeEventListener('keydown', this.escHandler)
    document.body.style.overflow = ""
  }

  handleEsc(event) {
    if (event.key === 'Escape' && this.openValue) {
      this.close(event)
    }
  }

  open(event) {
    if (event) event.preventDefault()
    this.dispatch('open', { detail: { modal: this } })
    this.openValue = true
  }

  close(event) {
    if (event) event.preventDefault()
    
    // Dispatch cancel event (can be prevented)
    const cancelEvent = this.dispatch('cancel', { 
      detail: { modal: this },
      cancelable: true 
    })
    
    if (!cancelEvent.defaultPrevented) {
      this.openValue = false
      this.dispatch('close', { detail: { modal: this } })
    }
  }
  
  ok(event) {
    if (event) event.preventDefault()
    
    // Dispatch ok event (can be prevented for async operations)
    const okEvent = this.dispatch('ok', { 
      detail: { modal: this },
      cancelable: true 
    })
    
    // Only close if not prevented (for async operations)
    if (!okEvent.defaultPrevented) {
      this.openValue = false
      this.dispatch('close', { detail: { modal: this } })
    }
  }

  closeByBackdrop(event) {
    if (this.maskClosableValue) {
      this.close(event)
    }
  }

  // Set loading state for OK button
  setConfirmLoading(loading) {
    if (!this.hasOkButtonTarget) return
    
    const okButton = this.okButtonTarget
    
    if (loading) {
      okButton.disabled = true
      okButton.classList.add('opacity-60', 'cursor-not-allowed')
      
      // Add loading spinner if not exists
      if (!okButton.querySelector('.spinner')) {
        const spinner = document.createElement('svg')
        spinner.className = 'animate-spin h-4 w-4 spinner'
        spinner.setAttribute('xmlns', 'http://www.w3.org/2000/svg')
        spinner.setAttribute('fill', 'none')
        spinner.setAttribute('viewBox', '0 0 24 24')
        spinner.innerHTML = `
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        `
        okButton.insertBefore(spinner, okButton.firstChild)
      }
    } else {
      okButton.disabled = false
      okButton.classList.remove('opacity-60', 'cursor-not-allowed')
      
      // Remove loading spinner
      const spinner = okButton.querySelector('.spinner')
      if (spinner) spinner.remove()
    }
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
      
      // Destroy modal DOM if configured
      if (this.destroyOnCloseValue) {
        this.element.remove()
      }
    }, 200) 
  }
}
