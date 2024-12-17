import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log(this.element)
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
    }).then(() => {
      alert("Contact Added Successfully!");
      this.modal.classList.add("hidden");
      window.location.reload(); // Reload to update the contact list
    });
  }
}
