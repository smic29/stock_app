import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
  }

  open() {
    const url = this.element.getAttribute('href')
    const title = this.element.tagName === 'TR' ? this.element.firstElementChild.innerHTML : this.element.innerHTML
    const frame = document.querySelector('#modal_frame')
    const modalTitle = document.querySelector('.modal-title')

    frame.src = url
    modalTitle.innerHTML = title
  }

  submit(e){
    if (e.detail.formSubmission.result.success) {
      this.element.reset()
      $('#appModal').modal('hide')
    }
  }

  show(){
    console.log(this.element.getAttribute('href'))
  }
}
