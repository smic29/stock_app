import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
  }

  open() {
    const url = this.element.href
    const title = this.element.innerHTML
    const frame = document.querySelector('#modal_frame')
    const modalTitle = document.querySelector('.modal-title')

    frame.src = url
    modalTitle.innerHTML = title
  }
}
