import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loaders"
export default class extends Controller {
  connect() {
    const msg = this.element.querySelector('span')
    
    setTimeout(() => {

      msg.classList.remove('visually-hidden')
    }, 5000)

    setTimeout(() => {
      msg.innerHTML = "Yeah... Any second now..."
    }, 10000)

    setTimeout(() => {
      msg.innerHTML = "Wait or refresh. Your choice, bro."
    }, 20000)
  }
}
