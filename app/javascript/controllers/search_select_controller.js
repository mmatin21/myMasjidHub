import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    this.select = new TomSelect(this.element, {
      create: this.handleCreate.bind(this), // Custom create behavior
      persist: false,
    });
  }

  handleCreate(input, callback) {
    // Open the modal and pass the input value
    this.openModal(input);

    // Prevent Tom Select from adding the item immediately
    callback(null);
  }

  openModal(value) {
    const modal = document.getElementById("new-contact-modal");
    const firstNameInput = document.getElementById("modal-first-name");
    const lastNameInput = document.getElementById("modal-last-name");

    // Split the value into first and last name
    const [firstName, ...lastNameParts] = value.split(" ");
    const lastName = lastNameParts.join(" ");

    // Prefill the modal inputs
    if (firstNameInput) firstNameInput.value = firstName || "";
    if (lastNameInput) lastNameInput.value = lastName || "";

    // Show the modal
    if (modal) {
      modal.classList.remove("hidden");
    }
  }
}
