import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    removeAfterSubmit: Boolean
  }

  connect() {
    addEventListener("turbo:submit-end", this.afterSubmit.bind(this))
  }

  afterSubmit() {
    this.clear()
    if (this.removeAfterSubmitValue) {
      this.remove()
    }
  }

  clear() {
    this.element.reset()
  }

  remove() {
    if (this.element.parentNode) {
      this.element.parentNode.removeChild(this.element)
    }
  }
}