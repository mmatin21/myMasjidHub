import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = ["select"]; // Target for the dependent select box
  static values = {
    url: String, // The endpoint to fetch data
    params: Object, // Stores the parameters dynamically
  };

  connect() {
    if (this.selectTarget.id === "") {
      this.selectTarget.id = Math.random().toString(36); // Ensure each select has a unique ID
    }
    this.getPledges();
  }

  change(event) {
    this.getPledges();
  }

  getPledges(){
     // Find values from the select boxes in the form
     const contactId = document.getElementById("donation_contact_id")?.value;
     const fundraiserId = document.getElementById("donation_fundraiser_id")?.value;
     const pledgeId = document.getElementById("donation_pledge_id")?.id;

     console.log(pledgeId)

     if (!contactId || !fundraiserId) {
       console.warn("Both Contact and Fundraiser must be selected.");
       return;
     }
 
     // Prepare URLSearchParams with both parameters
     const params = new URLSearchParams({
       contact_id: contactId,
       fundraiser_id: fundraiserId,
       target: pledgeId,
     });
 
     console.log("Params being sent:", params.toString()); 

    // Send a request to fetch the updated options
    get(`${this.urlValue}?${params.toString()}`, {
      responseKind: "turbo-stream",
    });
  }

  // change(event) {
  //   let params = new URLSearchParams()
  //   params.append(this.paramValue, event.target.selectedOptions[0].value)
  //   params.append("target", this.selectTarget.id)
  //   console.log(this.paramValue, event.target.selectedOptions[0].value)
  
  //   get(`${this.urlValue}?${params}`, {
  //     responseKind: "turbo-stream"
  //   })
  // }
}



