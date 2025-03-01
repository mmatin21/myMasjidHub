import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  handleSubmit(event) {
    console.log("Form submitted!"); // Debugging: Check if the method runs

    const submitButton = document.getElementById("submit-button");
    if (submitButton) {
      submitButton.disabled = true;
    } else {
      console.error("Submit button not found!");
    }

    // Show the overlay
    const overlay = document.getElementById("overlay");
    if (overlay) {
      overlay.classList.remove("hidden");
    } else {
      console.error("Overlay not found!");
    }
  }
}
