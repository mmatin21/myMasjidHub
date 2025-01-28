import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Initially hide all group contents
    this.hideAllGroups()
  }

  hideAllGroups() {
    const contents = this.element.querySelectorAll('[data-group-content]')
    contents.forEach(content => {
      content.classList.add('hidden')
    })
  }

  toggleGroup(event) {
    const group = event.currentTarget.dataset.group
    const icon = event.currentTarget.querySelector(`[data-group-icon="${group}"]`)
    const contents = this.element.querySelectorAll(`[data-group-content="${group}"]`)
    
    // Toggle visibility for all elements in the group
    contents.forEach(content => {
      if (content.classList.contains('hidden')) {
        content.classList.remove('hidden')
      } else {
        content.classList.add('hidden')
      }
    })
    
    // Toggle the arrow rotation
    icon.classList.toggle('rotate-180')
  }
} 