import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transact-input"
export default class extends Controller {
  connect() {
    const max =  parseInt(this.element.getAttribute("max"))

    this.element.addEventListener("input", () => {
      if (parseInt(this.element.value) > max) {
        this.element.value = max
      }
    })
  }
}
