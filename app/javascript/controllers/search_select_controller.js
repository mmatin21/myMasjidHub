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
    const contactModal = document.getElementById("new-contact-modal");
    const pledgeModal = document.getElementById("new-pledge-modal");
    const form = document.getElementById("parent-form");

    const contactId = document.getElementById("donation_contact_id")?.value;
    const fundraiserId = document.getElementById("donation_fundraiser_id")?.value;

    const firstNameInput = document.getElementById("modal-first-name");
    const lastNameInput = document.getElementById("modal-last-name");

    const pledgeContact = document.getElementById("pledge_contact_id");
    const pledgeFundraiser = document.getElementById("pledge_fundraiser_id");

    // Split the value into first and last name
    const [firstName, ...lastNameParts] = value.split(" ");
    const lastName = lastNameParts.join(" ");

    // Prefill the modal inputs
    if (firstNameInput) firstNameInput.value = firstName || "";
    if (lastNameInput) lastNameInput.value = lastName || "";

    if (pledgeContact) pledgeContact.value = contactId || "";
    if (pledgeFundraiser) pledgeFundraiser.value = fundraiserId || "";

    // Show the modal
    if (contactModal && contactId == "") {
      contactModal.classList.remove("hidden");
      form.classList.add("hidden")
    }
    else {
      if(pledgeModal != null) {
        pledgeModal.classList.remove("hidden");
        form.classList.add("hidden");
      }
      else {
        contactModal.classList.remove("hidden");
        form.classList.add("hidden")
      }
      
    }
  }
}
