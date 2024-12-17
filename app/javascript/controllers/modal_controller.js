import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.modal = this.element;
  }

  close() {
    this.modal.classList.add("hidden");
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
