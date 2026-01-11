import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "trigger", "label", "panel", "option", "search", "noResults", "emptyInput", "arrow"]
  static values = { 
    open: Boolean,
    multiple: Boolean,
    searchable: Boolean,
    maxTagCount: Number
  }

  connect() {
    this.clickOutside = this.clickOutside.bind(this)
    this.allOptions = [] // Store original options for search filtering
    // Store the original name attribute from the first input or emptyInput
    this.fieldName = null
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.openValue = !this.openValue
  }

  openValueChanged() {
    if (this.openValue) {
      this.panelTarget.classList.remove("hidden")
      
      // Store field name on first open for multiple select
      if (this.multipleValue && !this.fieldName) {
        this.fieldName = this.inputTargets[0]?.name || this.emptyInputTarget?.name || "select[]"
        console.log("[Select] Stored field name:", this.fieldName)
      }
      
      // Cache all options for filtering
      if (this.searchableValue) {
        this.allOptions = Array.from(this.optionTargets).map(opt => ({
          element: opt,
          label: opt.dataset.label.toLowerCase(),
          value: opt.dataset.value
        }))
      }
      
      // Focus search input if searchable
      if (this.searchableValue && this.hasSearchTarget) {
        setTimeout(() => this.searchTarget.focus(), 50)
      }
      
      // Rotate arrow icon
      if (this.hasArrowTarget) {
        this.arrowTarget.style.transform = "rotate(180deg)"
      }
      
      document.addEventListener("click", this.clickOutside)
    } else {
      this.panelTarget.classList.add("hidden")
      
      // Clear search
      if (this.hasSearchTarget) {
        this.searchTarget.value = ""
        this.showAllOptions()
      }
      
      // Reset arrow icon
      if (this.hasArrowTarget) {
        this.arrowTarget.style.transform = "rotate(0deg)"
      }
      
      document.removeEventListener("click", this.clickOutside)
    }
  }

  select(event) {
    event.stopPropagation()
    
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.dataset.label
    
    if (this.multipleValue) {
      this.toggleMultipleSelection(value, label, event.currentTarget)
    } else {
      this.setSingleSelection(value, label, event.currentTarget)
      this.openValue = false // Close dropdown for single select
    }
  }
  
  setSingleSelection(value, label, optionElement) {
    // Update Hidden Input
    this.inputTarget.value = value
    
    // Update Trigger Label
    this.labelTarget.innerText = label
    
    // Update Option Styles
    this.optionTargets.forEach(opt => {
      const checkIcon = opt.querySelector("svg")
      if (opt.dataset.value === value) {
        opt.classList.add("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
        opt.classList.remove("text-gray-700")
        if (checkIcon) checkIcon.classList.remove("hidden")
      } else {
        opt.classList.remove("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
        opt.classList.add("text-gray-700")
        if (checkIcon) checkIcon.classList.add("hidden")
      }
    })
  }
  
  toggleMultipleSelection(value, label, optionElement) {
    const isCurrentlySelected = optionElement.classList.contains("bg-[#e6f4ff]")
    const checkIcon = optionElement.querySelector("svg")
    
    console.log("[Select] Toggle selection:", { value, label, isCurrentlySelected })
    
    if (isCurrentlySelected) {
      // Deselect
      console.log("[Select] Deselecting...")
      optionElement.classList.remove("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
      optionElement.classList.add("text-gray-700")
      if (checkIcon) checkIcon.classList.add("hidden")
      
      // Remove hidden input - query directly from DOM
      const inputToRemove = Array.from(this.element.querySelectorAll('input[type="hidden"]')).find(inp => inp.value === value)
      if (inputToRemove) {
        console.log("[Select] Removing input:", inputToRemove)
        inputToRemove.remove()
      }
      
      // Remove tag from trigger
      const tagElement = this.labelTarget.querySelector(`[data-value="${value}"]`)
      console.log("[Select] Looking for tag with value:", value)
      console.log("[Select] All tags before removal:", Array.from(this.labelTarget.querySelectorAll('span[data-value]')).map(t => t.dataset.value))
      if (tagElement) {
        console.log("[Select] Removing tag element:", value)
        tagElement.remove()
      } else {
        console.log("[Select] Tag element not found for:", value)
      }
      console.log("[Select] All tags after removal:", Array.from(this.labelTarget.querySelectorAll('span[data-value]')).map(t => t.dataset.value))
      
      // Update tag visibility after removal
      this.updateTagsVisibility()
    } else {
      // Select
      console.log("[Select] Selecting...")
      optionElement.classList.add("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
      optionElement.classList.remove("text-gray-700")
      if (checkIcon) checkIcon.classList.remove("hidden")
      
      // Add hidden input
      const newInput = document.createElement("input")
      newInput.type = "hidden"
      newInput.name = this.fieldName || "select[]"
      newInput.value = value
      newInput.setAttribute("data-ant--select-target", "input")
      console.log("[Select] Creating input with name:", newInput.name, "value:", newInput.value)
      this.element.insertBefore(newInput, this.triggerTarget)
      console.log("[Select] Input added, current inputTargets count:", this.inputTargets.length)
      
      // Add tag to trigger BEFORE calling updateMultipleLabel
      console.log("[Select] Calling addTag...")
      this.addTag(label, value)
      
      // Update tag visibility based on max_tag_count
      this.updateTagsVisibility()
    }
    
    // Update empty input disabled state
    if (this.hasEmptyInputTarget) {
      // Count actual inputs with values
      const actualInputs = Array.from(this.element.querySelectorAll('input[type="hidden"]')).filter(inp => inp.value !== "")
      this.emptyInputTarget.disabled = actualInputs.length > 0
      console.log("[Select] Empty input disabled:", this.emptyInputTarget.disabled)
    }
    
    // Update label if no selections
    console.log("[Select] Calling updateMultipleLabel...")
    this.updateMultipleLabel()
  }
  
  addTag(label, value) {
    console.log("[Select] addTag called:", { label, value })
    console.log("[Select] Current label content:", this.labelTarget.textContent)
    console.log("[Select] Current label innerHTML:", this.labelTarget.innerHTML)
    
    // If label still contains placeholder text, clear it first
    const labelContent = this.labelTarget.textContent.trim()
    const placeholder = this.element.dataset.placeholder || "Please select"
    console.log("[Select] Checking placeholder:", { labelContent, placeholder, matches: labelContent === placeholder })
    
    if (labelContent === placeholder) {
      console.log("[Select] Clearing placeholder from label")
      this.labelTarget.innerHTML = ""
    }
    
    const tag = document.createElement("span")
    tag.className = "inline-flex items-center gap-1 px-2 py-0.5 bg-[#f5f5f5] border border-[#d9d9d9] rounded text-[12px]"
    tag.dataset.value = value
    
    tag.innerHTML = `
      ${label}
      <svg data-action="click->ant--select#removeTag" 
           data-value="${value}"
           class="w-3 h-3 text-[rgba(0,0,0,0.45)] hover:text-[rgba(0,0,0,0.88)] cursor-pointer" 
           viewBox="64 64 896 896" fill="currentColor">
        <path d="M563.8 512l262.5-312.9c4.4-5.2.7-13.1-6.1-13.1h-79.8c-4.7 0-9.2 2.1-12.3 5.7L511.6 449.8 295.1 191.7c-3-3.6-7.5-5.7-12.3-5.7H203c-6.8 0-10.5 7.9-6.1 13.1L459.4 512 196.9 824.9A7.95 7.95 0 00203 838h79.8c4.7 0 9.2-2.1 12.3-5.7l216.5-258.1 216.5 258.1c3 3.6 7.5 5.7 12.3 5.7h79.8c6.8 0 10.5-7.9 6.1-13.1L563.8 512z"/>
      </svg>
    `
    
    console.log("[Select] Appending tag to label")
    this.labelTarget.appendChild(tag)
    console.log("[Select] Tag appended, label innerHTML now:", this.labelTarget.innerHTML)
  }
  
  removeTag(event) {
    event.stopPropagation()
    event.preventDefault()
    
    const value = event.currentTarget.dataset.value
    
    console.log("[Select] removeTag called for value:", value)
    console.log("[Select] Label innerHTML before removal:", this.labelTarget.innerHTML)
    
    // Remove hidden input - query directly from DOM
    const inputToRemove = Array.from(this.element.querySelectorAll('input[type="hidden"]')).find(inp => inp.value === value)
    if (inputToRemove) {
      console.log("[Select] Removing input for:", value)
      inputToRemove.remove()
    }
    
    // Remove tag element
    const tagElement = this.labelTarget.querySelector(`span[data-value="${value}"]`)
    if (tagElement) {
      console.log("[Select] Removing tag element for:", value)
      tagElement.remove()
    }
    
    console.log("[Select] Label innerHTML after removal:", this.labelTarget.innerHTML)
    console.log("[Select] All remaining tags in label:", Array.from(this.labelTarget.querySelectorAll('span[data-value]')).map(t => ({ value: t.dataset.value, hidden: t.classList.contains('hidden') })))
    
    // Update tag visibility after removal
    this.updateTagsVisibility()
    
    // Update option visual state
    const optionElement = this.optionTargets.find(opt => opt.dataset.value === value)
    if (optionElement) {
      optionElement.classList.remove("font-semibold", "bg-[#e6f4ff]", "text-gray-900")
      optionElement.classList.add("text-gray-700")
      const checkIcon = optionElement.querySelector("svg")
      if (checkIcon) checkIcon.classList.add("hidden")
    }
    
    // Update empty input disabled state
    if (this.hasEmptyInputTarget) {
      const actualInputs = Array.from(this.element.querySelectorAll('input[type="hidden"]')).filter(inp => inp.value !== "")
      this.emptyInputTarget.disabled = actualInputs.length > 0
    }
    
    this.updateMultipleLabel()
  }
  
  updateMultipleLabel() {
    // Count actual hidden inputs with values (not empty ones)
    const actualInputs = Array.from(this.element.querySelectorAll('input[type="hidden"]')).filter(inp => inp.value !== "")
    const selectedCount = actualInputs.length
    console.log("[Select] updateMultipleLabel - selectedCount:", selectedCount)
    console.log("[Select] actualInputs:", actualInputs)
    
    if (selectedCount === 0) {
      // Get placeholder from trigger's button or use default
      const placeholder = this.element.dataset.placeholder || this.triggerTarget.dataset.placeholder || "Please select"
      console.log("[Select] No selections, setting placeholder:", placeholder)
      this.labelTarget.innerHTML = placeholder
    } else {
      console.log("[Select] Has selections, keeping tags")
    }
    // Tags are already in the label, so no need to update if count > 0
  }
  
  updateTagsVisibility() {
    if (!this.multipleValue || !this.maxTagCountValue || this.maxTagCountValue === 0) {
      console.log("[Select] updateTagsVisibility - No limit or not multiple")
      return // No limit, show all tags
    }
    
    // Get all tag elements (not including overflow tag)
    const allTags = Array.from(this.labelTarget.querySelectorAll('span[data-value]'))
    const totalTags = allTags.length
    
    console.log("[Select] updateTagsVisibility - totalTags:", totalTags, "maxTagCount:", this.maxTagCountValue)
    console.log("[Select] All tags:", allTags.map(t => ({ value: t.dataset.value, hidden: t.classList.contains('hidden') })))
    
    // Remove existing overflow tag if any
    const existingOverflow = this.labelTarget.querySelector('span.overflow-tag')
    if (existingOverflow) {
      console.log("[Select] Removing existing overflow tag")
      existingOverflow.remove()
    }
    
    if (totalTags <= this.maxTagCountValue) {
      // Show all tags - remove hidden class from all
      console.log("[Select] Total tags <= max, showing all tags")
      allTags.forEach(tag => {
        tag.classList.remove('hidden')
        tag.style.display = '' // Remove inline style to show
        console.log("[Select] Showed tag:", tag.dataset.value, "hidden class removed:", !tag.classList.contains('hidden'))
      })
    } else {
      // Show only first N tags, hide the rest
      console.log("[Select] Total tags > max, showing first", this.maxTagCountValue, "tags")
      allTags.forEach((tag, index) => {
        if (index < this.maxTagCountValue) {
          tag.classList.remove('hidden')
          tag.style.display = '' // Remove inline style to show
          console.log("[Select] Showing tag", index, ":", tag.dataset.value)
        } else {
          tag.classList.add('hidden')
          tag.style.display = 'none' // Use inline style for stronger hiding
          console.log("[Select] Hiding tag", index, ":", tag.dataset.value)
        }
      })
      
      // Add overflow count tag
      const overflowCount = totalTags - this.maxTagCountValue
      const overflowTag = document.createElement('span')
      overflowTag.className = "overflow-tag inline-flex items-center px-2 py-0.5 bg-[#f5f5f5] border border-[#d9d9d9] rounded text-[12px]"
      overflowTag.textContent = `+${overflowCount}`
      this.labelTarget.appendChild(overflowTag)
      
      console.log("[Select] Added overflow tag:", `+${overflowCount}`)
    }
    
    console.log("[Select] After update, all tags:", allTags.map(t => ({ 
      value: t.dataset.value, 
      hasHiddenClass: t.classList.contains('hidden'),
      display: t.style.display,
      visible: t.offsetParent !== null
    })))
  }
  
  filterOptions(event) {
    const searchTerm = event.target.value.toLowerCase().trim()
    
    if (!searchTerm) {
      this.showAllOptions()
      return
    }
    
    let visibleCount = 0
    
    this.allOptions.forEach(({ element, label }) => {
      if (label.includes(searchTerm)) {
        element.classList.remove("hidden")
        visibleCount++
      } else {
        element.classList.add("hidden")
      }
    })
    
    // Show/hide no results message
    if (this.hasNoResultsTarget) {
      if (visibleCount === 0) {
        this.noResultsTarget.classList.remove("hidden")
      } else {
        this.noResultsTarget.classList.add("hidden")
      }
    }
  }
  
  showAllOptions() {
    this.optionTargets.forEach(opt => opt.classList.remove("hidden"))
    if (this.hasNoResultsTarget) {
      this.noResultsTarget.classList.add("hidden")
    }
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.openValue = false
    }
  }
  
  disconnect() {
    document.removeEventListener("click", this.clickOutside)
  }
}