import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "modal"]

  connect() {
    // Don't setup image loading for preview mode
    // to avoid interfering with click events
  }

  handleError(event) {
    const img = event ? event.target : this.imageTarget
    const fallback = img.dataset.fallback
    if (fallback && img.src !== fallback) {
      img.src = fallback
    }
  }

  preview(event) {
    event.preventDefault()
    const img = this.imageTarget
    
    // Create modal backdrop with frosted glass effect
    const modal = document.createElement('div')
    modal.className = 'fixed inset-0 z-[9999] flex items-center justify-center bg-black/40 backdrop-blur-md p-4'
    modal.addEventListener('click', () => this.closePreview())
    
    // Create image container
    const container = document.createElement('div')
    container.className = 'relative max-w-7xl max-h-full'
    container.addEventListener('click', (e) => e.stopPropagation())
    
    // Create preview image
    const previewImg = document.createElement('img')
    previewImg.src = img.src
    previewImg.alt = img.alt
    previewImg.className = 'max-w-full max-h-[90vh] object-contain rounded-lg shadow-2xl'
    
    // Create close button
    const closeBtn = document.createElement('button')
    closeBtn.type = 'button'
    closeBtn.className = 'absolute -top-12 right-0 w-10 h-10 flex items-center justify-center bg-white/10 backdrop-blur-sm rounded-full text-white hover:bg-white/20 transition-colors'
    closeBtn.addEventListener('click', () => this.closePreview())
    closeBtn.innerHTML = `
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    `
    
    container.appendChild(previewImg)
    container.appendChild(closeBtn)
    modal.appendChild(container)
    
    // Add to DOM
    document.body.appendChild(modal)
    document.body.style.overflow = 'hidden'
    
    // Store reference
    this.currentModal = modal
  }

  closePreview() {
    if (this.currentModal) {
      this.currentModal.remove()
      this.currentModal = null
      document.body.style.overflow = ''
    }
  }

  disconnect() {
    this.closePreview()
  }
}

