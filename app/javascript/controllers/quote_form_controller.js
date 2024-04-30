import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="quote-form"
export default class extends Controller {
  connect() {
    const btn = this.element.querySelector('#clearSymbol')
    const inputField = this.element.querySelector('#symbol')
    const options = this.element.querySelectorAll('.dropdown-item')
    const frame = document.querySelector('#quote_result_frame')
    const submitButton = this.element.querySelector('button.custom-btn')

    btn.addEventListener('click', () => {
      inputField.value = ''
      submitButton.disabled = true
      inputField.focus()
    })

    options.forEach(item => {
      item.addEventListener('click',() => {
        const symbol = item.textContent.trim()
        inputField.value = symbol
        submitButton.disabled = false
        inputField.focus()
      })
    })
  }

  toggleSubmitButton(e) {
    const submitButton = this.element.querySelector('button.custom-btn')

    console.log(e.target.value.trim() === '')
    submitButton.disabled = e.target.value.trim() === "";
  }
}
