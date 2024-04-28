import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quote-form"
export default class extends Controller {
  connect() {
    const btn = this.element.querySelector('#clearSymbol')
    const inputField = this.element.querySelector('#symbol')
    const options = this.element.querySelectorAll('.dropdown-item')
    const frame = document.querySelector('#quote_result_frame')

    btn.addEventListener('click', () => {
      inputField.value = ''
    })

    options.forEach(item => {
      item.addEventListener('click',() => {
        const symbol = item.textContent.trim()
        inputField.value = symbol
      })
    })
  }
}
