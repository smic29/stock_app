import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transact-input"
export default class extends Controller {
  connect() {
    const sharePrice = parseInt(document.querySelector('#transaction_price').value)
    const userCash = parseInt(document.querySelector('#userCash').value)
    const quantityInput = this.element.querySelector('#transaction_quantity')
    const subBtn = this.element.querySelector('#subBtn')
    const userShareElement = document.querySelector('#userShare')
    const userShare = userShareElement?.value ? parseInt(userShareElement.value) : 0
    
    quantityInput.value = 0
    subBtn.disabled = true

    const rounded_max = Math.floor(userCash / sharePrice)
    quantityInput.max = userShare > rounded_max ? userShare : rounded_max
  }

  addQuantity(e) {
    const quantity = this.element.querySelector('#transaction_quantity')
    const currentValue = parseInt(quantity.value)
    const subBtn = this.element.querySelector('#subBtn')
    const userCash = parseInt(document.querySelector('#userCash').value)
    const userShareElement = document.querySelector('#userShare')
    const userShare = userShareElement?.value ? parseInt(userShareElement.value) : 0
    const sharePrice = parseInt(document.querySelector('#transaction_price').value)
    const buyBtn = document.querySelector('#buyBtn')
    const selBtn = document.querySelector('#selBtn')

    e.target.blur()

    if (((currentValue + 1) * sharePrice) > userCash && buyBtn) {
      buyBtn.disabled = true
    } else if (buyBtn) {
      buyBtn.disabled = false
    }

    if ((currentValue + 1) > userShare && selBtn) {
      selBtn.disabled = true
    } else if (selBtn) {
      selBtn.disabled = false
    }
    
    if (currentValue + 1 > quantity.max) {
      e.target.disabled = true
      return
    }

    quantity.value = currentValue + 1
    
    if (subBtn.disabled == true) {
      subBtn.disabled = false
    }
    
    if (quantity.value == quantity.max) {
      e.target.disabled = true
      if ((parseInt(quantity.value) * sharePrice) > userCash && buyBtn) {
        buyBtn.disabled = true
      }
    }
  }

  subQuantity(e) {
    const quantity = this.element.querySelector('#transaction_quantity')
    const currentValue = parseInt(quantity.value)
    const addBtn = this.element.querySelector('#addBtn')
    const userCash = parseInt(document.querySelector('#userCash').value)
    const userShareElement = document.querySelector('#userShare')
    const userShare = userShareElement?.value ? parseInt(userShareElement.value) : 0
    const sharePrice = parseInt(document.querySelector('#transaction_price').value)
    const buyBtn = document.querySelector('#buyBtn')
    const selBtn = document.querySelector('#selBtn')

    if (((currentValue - 1) * sharePrice) > userCash && buyBtn) {
      buyBtn.disabled = true
    } else if (buyBtn) {
      buyBtn.disabled = false
    }

    if ((currentValue - 1) <= userShare && selBtn) {
      selBtn.disabled = false
    } else if (selBtn) {
      selBtn.disabled = true
    }

    if (currentValue - 1 === 0) {
      e.target.disabled = true
    }
    
    quantity.value = currentValue - 1
    
    if (addBtn.disabled == true && quantity.value < quantity.max) {
      addBtn.disabled = false
    }

    if (quantity.value == '0') {
      if (buyBtn) {
        buyBtn.disabled = true
      }

      if (selBtn) {
        selBtn.disabled = true
      }
    }
    
  }
}
