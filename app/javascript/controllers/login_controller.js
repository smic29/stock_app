import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "links" ]
  
  connect() {
  }

  activate(e) {
    const links = document.querySelectorAll('.nav-link')

    links.forEach((link) => { link.classList.remove('active') })
    e.target.classList.add('active')
  }

  visibility(e) {
    const icon = e.target
    const classes = Array.from(icon.classList)
    const input = icon.previousElementSibling

    if (classes.includes('fa-eye-slash')) {
      icon.classList.remove('fa-eye-slash')
      icon.classList.add('fa-eye')
      input.type = 'text'
    } else {
      icon.classList.remove('fa-eye')
      icon.classList.add('fa-eye-slash')
      input.type = 'password'
    }
  }
}
