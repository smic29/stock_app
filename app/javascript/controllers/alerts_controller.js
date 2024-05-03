import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alerts"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.remove("show")
    }, 5000)

    setTimeout(() => {
      this.element.remove()
    }, 6000)
  }
}
