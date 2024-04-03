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
}
