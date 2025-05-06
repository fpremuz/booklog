import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star"]

  connect() {
    this.updateStarsFromSelection()
  }

  select(event) {
    const selectedValue = parseInt(event.currentTarget.dataset.value)
    this.starTargets.forEach((star) => {
      const val = parseInt(star.dataset.value)
      star.textContent = val <= selectedValue ? "★" : "☆"
    })

    const radio = document.getElementById("rating_" + selectedValue)
    if (radio) radio.checked = true
  }

  updateStarsFromSelection() {
    const checked = this.starTargets.find((star) => {
      const radio = document.getElementById("rating_" + star.dataset.value)
      return radio && radio.checked
    })

    if (checked) {
      this.select({ currentTarget: checked })
    }
  }
}