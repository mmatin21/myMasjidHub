import { Controller } from "@hotwired/stimulus";
import { patch } from "@rails/request.js"; // Simplifies AJAX requests in Rails 7

export default class extends Controller {
  static targets = ["dropdown"];

  connect() {}

  async markAsRead() {
    if (this.hasDropdownTarget) {

      // Send a PATCH request to mark notifications as read
      const response = await patch("/notifications/mark_as_read", {
        responseKind: "turbo-stream",
      });

      if (response.ok) {
        document.getElementById("notification-badge")?.remove(); // Remove badge
      }
    }
  }
}
