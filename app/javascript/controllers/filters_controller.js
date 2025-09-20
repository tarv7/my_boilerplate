import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filters"
export default class extends Controller {
  static targets = ["form", "input"]

  connect() {}

  clearAll() {
    // Clear all form inputs
    this.inputTargets.forEach(input => {
      if (input.type === 'checkbox' || input.type === 'radio') {
        input.checked = false
      } else {
        input.value = ''
      }
    })

    // Submit the form to reload with cleared filters
    this.formTarget.requestSubmit()
  }
}
