import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["autocomplete", "city", "state", "zipcode"];

  connect() {
    if (this.hasAutocompleteTarget) {
      this.autocomplete = new google.maps.places.Autocomplete(
        this.autocompleteTarget,
        { types: ["geocode"] }
      );

      this.autocomplete.addListener("place_changed", () => this.fillInAddress());
    } else {
      console.error("Autocomplete target not found or is not an input element.");
    }
  }

  fillInAddress() {
    const place = this.autocomplete.getPlace();
    const addressComponents = place.address_components;

    addressComponents.forEach((component) => {
      const types = component.types;

      if (types.includes("locality")) {
        this.cityTarget.value = component.long_name; // City
      }

      if (types.includes("administrative_area_level_1")) {
        this.stateTarget.value = component.short_name; // State
      }

      if (types.includes("postal_code")) {
        this.zipcodeTarget.value = component.long_name; // Zipcode
      }
    });
  }
}
