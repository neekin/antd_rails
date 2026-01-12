import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "fileList", "uploadButton"]
  static values = {
    mode: String,
    multiple: Boolean,
    maxSize: Number,
    maxCount: Number,
    disabled: Boolean
  }

  connect() {
    this.files = []
  }

  triggerFileInput(event) {
    event.preventDefault()
    if (this.disabledValue) return
    this.fileInputTarget.click()
  }

  handleFileSelect(event) {
    const files = Array.from(event.target.files)
    
    // Check max count
    if (this.maxCountValue > 0) {
      const totalCount = this.files.length + files.length
      if (totalCount > this.maxCountValue) {
        alert(`Maximum ${this.maxCountValue} file(s) allowed`)
        return
      }
    }

    // Validate and add files
    files.forEach(file => {
      if (this.validateFile(file)) {
        this.addFile(file)
      }
    })

    // Clear input for re-selection
    event.target.value = ''
  }

  validateFile(file) {
    // Check file size
    if (this.maxSizeValue > 0) {
      const fileSizeMB = file.size / 1024 / 1024
      if (fileSizeMB > this.maxSizeValue) {
        alert(`File size must be less than ${this.maxSizeValue}MB`)
        return false
      }
    }

    // Check if image mode accepts only images
    if (this.modeValue === 'image' && !file.type.startsWith('image/')) {
      alert('Please upload an image file')
      return false
    }

    return true
  }

  addFile(file) {
    const fileId = `file-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    this.files.push({ id: fileId, file: file })
    
    const fileItem = this.createFileItem(fileId, file)
    this.fileListTarget.appendChild(fileItem)

    // Hide upload button if max count reached
    if (this.maxCountValue > 0 && this.files.length >= this.maxCountValue) {
      if (this.hasUploadButtonTarget) {
        this.uploadButtonTarget.style.display = 'none'
      }
    }
  }

  createFileItem(fileId, file) {
    const isPictureCard = this.element.querySelector('[data-ant--upload-target="uploadButton"]')?.classList.contains('w-[104px]')
    
    if (isPictureCard && file.type.startsWith('image/')) {
      return this.createImageCard(fileId, file)
    } else {
      return this.createFileRow(fileId, file)
    }
  }

  createImageCard(fileId, file) {
    const card = document.createElement('div')
    card.className = 'relative w-[104px] h-[104px] border border-gray-300 rounded-lg overflow-hidden group'
    card.dataset.fileId = fileId

    // Create image preview
    const img = document.createElement('img')
    img.className = 'w-full h-full object-cover'
    
    const reader = new FileReader()
    reader.onload = (e) => {
      img.src = e.target.result
    }
    reader.readAsDataURL(file)

    // Create mask overlay on hover
    const mask = document.createElement('div')
    mask.className = 'absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity'
    mask.innerHTML = `
      <button type="button" 
              class="text-white hover:text-gray-200 p-1"
              data-action="click->ant--upload#previewFile"
              data-file-id="${fileId}"
              title="Preview">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
        </svg>
      </button>
      <button type="button" 
              class="text-white hover:text-red-300 p-1"
              data-action="click->ant--upload#removeFile"
              data-file-id="${fileId}"
              title="Remove">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
        </svg>
      </button>
    `

    card.appendChild(img)
    card.appendChild(mask)
    return card
  }

  createFileRow(fileId, file) {
    const row = document.createElement('div')
    row.className = 'flex items-center justify-between p-2 bg-gray-50 rounded border border-gray-200 hover:bg-gray-100 transition-colors'
    row.dataset.fileId = fileId

    const fileInfo = document.createElement('div')
    fileInfo.className = 'flex items-center gap-2 flex-1 min-w-0'
    
    const fileIcon = this.getFileIcon(file)
    const fileName = document.createElement('span')
    fileName.className = 'text-sm text-gray-700 truncate'
    fileName.textContent = file.name
    
    const fileSize = document.createElement('span')
    fileSize.className = 'text-xs text-gray-500 ml-2'
    fileSize.textContent = this.formatFileSize(file.size)

    fileInfo.appendChild(fileIcon)
    fileInfo.appendChild(fileName)
    fileInfo.appendChild(fileSize)

    const removeBtn = document.createElement('button')
    removeBtn.type = 'button'
    removeBtn.className = 'ml-2 text-gray-400 hover:text-red-500 transition-colors'
    removeBtn.dataset.action = 'click->ant--upload#removeFile'
    removeBtn.dataset.fileId = fileId
    removeBtn.innerHTML = `
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    `

    row.appendChild(fileInfo)
    row.appendChild(removeBtn)
    return row
  }

  getFileIcon(file) {
    const icon = document.createElement('span')
    icon.className = 'text-[#1677ff]'
    
    if (file.type.startsWith('image/')) {
      icon.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
        </svg>
      `
    } else {
      icon.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      `
    }
    
    return icon
  }

  removeFile(event) {
    const fileId = event.currentTarget.dataset.fileId
    
    // Remove from files array
    this.files = this.files.filter(f => f.id !== fileId)
    
    // Remove DOM element
    const fileElement = this.element.querySelector(`[data-file-id="${fileId}"]`)
    if (fileElement) {
      fileElement.remove()
    }

    // Show upload button if below max count
    if (this.maxCountValue > 0 && this.files.length < this.maxCountValue) {
      if (this.hasUploadButtonTarget) {
        this.uploadButtonTarget.style.display = ''
      }
    }
  }

  previewFile(event) {
    const fileId = event.currentTarget.dataset.fileId
    const fileData = this.files.find(f => f.id === fileId)
    
    if (fileData && fileData.file.type.startsWith('image/')) {
      // Simple preview - could be enhanced with modal
      const reader = new FileReader()
      reader.onload = (e) => {
        window.open(e.target.result, '_blank')
      }
      reader.readAsDataURL(fileData.file)
    }
  }

  formatFileSize(bytes) {
    if (bytes === 0) return '0 B'
    const k = 1024
    const sizes = ['B', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }
}
