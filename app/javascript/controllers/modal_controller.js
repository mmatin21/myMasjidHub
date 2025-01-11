import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.modal = this.element;
    // Add click event listener to the modal backdrop
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    // Clean up event listener when controller is disconnected
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  handleClickOutside(event) {
    // Check if click is outside the form
    if (!this.element.contains(event.target) && !event.target.closest('[data-modal-target]')) {
      // Close the modal using Turbo
      const frame = this.element.closest('turbo-frame')
      if (frame) {
        frame.src = undefined
        frame.innerHTML = ''
      }
    }
  }

  close() {
    this.modal.classList.add("hidden");
    const pledgeForm = document.getElementById("parent-form");
    pledgeForm.classList.remove("hidden");
  }

  submit(event) {
    event.preventDefault();
    const form = event.target;

    fetch(form.action, {
      method: form.method,
      body: new FormData(form),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          // Add the new contact to the Tom Select dropdown
          const searchSelectInstance = document.querySelector("[data-controller='search-select']").tomselect;
          searchSelectInstance.addOption({ value: data.id, text: data.full_name });
          searchSelectInstance.setValue(data.id);

          // Close the modal
          this.close();
        } else {
          alert("Error: " + data.errors.join(", "));
        }
      });
  }
}
