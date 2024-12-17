import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    this.select = new TomSelect(this.element, {
      create: true, // Allow creating new items
      persist: false,
      onItemAdd: (value) => this.openModal(value),
    });
  }

  openModal(value) {
    console.log("open modal")
    if (!this.select.options[value]) {
      const modal = document.getElementById("new-contact-modal");
      if (modal) {
        modal.classList.remove("hidden"); // Show the modal
      }
    }
  }
}
