import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static classes = ["active", "inactive"]

  switch(event) {
    const selectedId = event.currentTarget.dataset.id
    
    // 只操作直接属于当前控制器的 Tabs 和 Panels
    // 使用 .filter 排除掉嵌套在其他 ant--tabs 控制器内部的元素
    const scopedTabs = this.tabTargets.filter(t => t.closest('[data-controller="ant--tabs"]') === this.element)
    const scopedPanels = this.panelTargets.filter(p => p.closest('[data-controller="ant--tabs"]') === this.element)

    // Update Tabs
    scopedTabs.forEach(tab => {
      if (tab.dataset.id === selectedId) {
        tab.classList.add(...this.activeClasses)
        tab.classList.remove(...this.inactiveClasses)
      } else {
        tab.classList.remove(...this.activeClasses)
        tab.classList.add(...this.inactiveClasses)
      }
    })

    // Update Panels
    scopedPanels.forEach(panel => {
      if (panel.dataset.id === selectedId) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })
  }
}
