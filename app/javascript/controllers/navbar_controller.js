import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  connect() {
    document.addEventListener('turbo:before-frame-render',(e) => {
      const turboFrame = e.target

      if (turboFrame.id !== "user_frame" && turboFrame.id !== "admin_dash") {
        return
      }
      const links = this.element.querySelectorAll('a')

      links.forEach((link) => {
        if (link.href !== turboFrame.src) {
          link.classList.remove('active')
        } else {
          link.classList.add('active')
        }
      })
    })
  }
}
