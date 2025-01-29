import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {

  static targets = ["contact", "pledge"]
  

  connect() {
  // Initialize TomSelect when the controller is connected
  this.initializeTomSelect();

  // Listen for Turbo stream events
  this.element.addEventListener('turbo:before-stream-render', this.cleanupPreviousWrapper.bind(this));
  this.element.addEventListener('turbo:render', this.reinitializeTomSelect.bind(this));
  }

  disconnect() {
    // Cleanup when the controller is disconnected
    if (this.element.tomselect) {
      this.element.tomselect.destroy();
    }
  }

  initializeTomSelect() {
    // Initialize TomSelect for this specific element
    if (!this.element.tomselect) {
      this.select = new TomSelect(this.element, {
        create: this.handleCreate.bind(this), // Custom create behavior
        persist: false,
      });
    }
  }

  cleanupPreviousWrapper(event) {
    // Get the target of the turbo stream
    const targetId = event.target.getAttribute('target');
    const selectElement = document.getElementById(targetId); // Find the targeted <select>

    if (selectElement && selectElement.tomselect) {
      // Destroy the TomSelect instance
      selectElement.tomselect.destroy();

      // Remove the old wrapper
      const wrapper = selectElement.closest('.ts-wrapper');
      if (wrapper) {
        wrapper.remove();
      }
    }
  }

  reinitializeTomSelect() {
    // Reinitialize TomSelect after Turbo has rendered
    if (!this.element.tomselect) {
      this.initializeTomSelect();
    }
  }

  handleCreate(input, callback) {
    // Open the modal and pass the input value
    if(this.hasContactTarget){
      this.openContactModal(input);
    }
    else {
      this.openPledgeModal(input);
    }
    // Prevent Tom Select from adding the item immediately
    callback(null);
  }

  openContactModal(value){
    const contactModal = document.getElementById("new-contact-modal");
    const form = document.getElementById("parent-form");

    contactModal.classList.remove("hidden");
    form.classList.add("hidden")
  }

  openPledgeModal(value){
    const pledgeModal = document.getElementById("new-pledge-modal");
    const form = document.getElementById("parent-form");

    const contactId = document.getElementById("donation_contact_id")?.value;
    const fundraiserId = document.getElementById("donation_fundraiser_id")?.value;

    const pledgeContact = document.getElementById("pledge_contact_id");
    const pledgeFundraiser = document.getElementById("pledge_fundraiser_id");

    if (pledgeContact) pledgeContact.value = contactId || "";
    if (pledgeFundraiser) pledgeFundraiser.value = fundraiserId || "";

    pledgeModal.classList.remove("hidden");
    form.classList.add("hidden");
  }
}
