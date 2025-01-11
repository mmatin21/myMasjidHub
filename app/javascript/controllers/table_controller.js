import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggleGroup(event) {
    const groupName = event.currentTarget.dataset.group
    const rows = document.querySelectorAll(`[data-group-content="${groupName}"]`)
    const icon = document.querySelector(`[data-group-icon="${groupName}"]`)
    
    rows.forEach(row => {
      row.classList.toggle('hidden')
    })
    
    // Rotate icon when toggled
    icon.style.transform = icon.style.transform === 'rotate(-90deg)' 
      ? 'rotate(0deg)' 
      : 'rotate(-90deg)'
  }
} 