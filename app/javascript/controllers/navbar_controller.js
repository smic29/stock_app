import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  connect() {
    const frame = document.querySelector('turbo-frame')
    
    if (frame.id === 'user_frame' || frame.id === 'admin_dash'){
      if (frame.src=== null) {
        frame.src = window.location.href
        this.setActive(frame)
      }
    }



    document.addEventListener('turbo:before-frame-render',(e) => {
      this.isItemActive(e)
    })
  }

  isItemActive(e) {
    const turboFrame = e.target

    if (turboFrame.id !== "user_frame" && turboFrame.id !== "admin_dash") {
      return
    }
    const links = this.element.querySelectorAll('a')

    links.forEach((link) => {
      if (link.href !== turboFrame.src) {
        link.classList.remove('active','pe-none')
      } else {
        link.classList.add('active','pe-none')
      }
    })
  }

  setActive(turboFrame) {
    if (turboFrame.id !== "user_frame" && turboFrame.id !== "admin_dash") {
      return
    }
    const links = this.element.querySelectorAll('a')

    links.forEach((link) => {
      if (link.href !== turboFrame.src) {
        link.classList.remove('active','pe-none')
      } else {
        link.classList.add('active','pe-none')
      }
    })
  }
}