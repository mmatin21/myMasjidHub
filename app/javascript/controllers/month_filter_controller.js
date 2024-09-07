import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["year", "month"]

  connect() {
    console.log("Month Filter Controller")
  }

  updateMonths(event) {
    const selectedYear = this.yearTarget.value;
    console.log(selectedYear)
    console.log(this.monthTarget.value)
  }
}
