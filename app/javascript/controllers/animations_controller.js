import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="animations"
export default class extends Controller {
  connect() {
    this.animateIn()

    document.addEventListener('turbo:before-frame-render', async (e) => {
      e.preventDefault()

      await this.animateOut()

      e.detail.resume()
    })
  }

  disconnect() {
    this.animateOut()
  }

  animateIn() {
    this.element.style.transform = "translateY(-100%)"
    this.element.style.opacity = 0
    requestAnimationFrame(() => {
      this.element.style.transition = "transform 0.5s ease-in-out, opacity 0.5s ease-in-out"
      this.element.style.transform = "translateY(0)"
      this.element.style.opacity = 1
    })
  }

  async animateOut() {
    return new Promise((resolve) => {
      this.element.style.transform = "translateY(0)"
      this.element.style.opacity = 1
      requestAnimationFrame(() => {
        this.element.style.transition = "transform 0.5s ease-in-out, opacity 0.5s ease-in-out"
        this.element.style.transform = "translateY(-100%)"
        this.element.style.opacity = 0
        setTimeout(resolve, 500)
      })
    })
  }
}
