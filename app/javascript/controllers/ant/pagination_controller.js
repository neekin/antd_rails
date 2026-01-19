import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["jumper"]

  jumpToPage(event) {
    // 按下 Enter 键时提交表单
    if (event.key === "Enter") {
      event.preventDefault()
      const form = event.target.closest("form")
      const page = parseInt(event.target.value)
      const maxPage = parseInt(event.target.max)
      
      // 验证页码范围
      if (page >= 1 && page <= maxPage) {
        form.submit()
      } else {
        event.target.value = ""
        event.target.placeholder = event.target.dataset.current || "1"
      }
    }
  }
}
