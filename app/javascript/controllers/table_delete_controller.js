import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table-delete"
export default class extends Controller {
  connect() {
    this.selectedIds = new Set()
  }

  toggleDeleteCheckboxes() {
    const checkboxes = document.querySelectorAll('input[type="checkbox"].row-checkbox')
    const mainCheckbox = document.getElementById('checkbox-all')
    mainCheckbox.classList.toggle('hidden')
    checkboxes.forEach(checkbox => checkbox.classList.toggle('hidden'))
    document.getElementById('deleteAllButton').classList.toggle('hidden')
  }

  checkAll() {
    const isChecked = event.target.checked
    const checkboxes = document.querySelectorAll('input[type="checkbox"].row-checkbox')
    checkboxes.forEach(checkbox => {
      checkbox.checked = isChecked
      this.updateSelectedIds(checkbox)
    })
  }

  toggleRow() {
    this.updateSelectedIds(event.target)
  }

  updateSelectedIds(checkbox) {
    const id = checkbox.value
    if (checkbox.checked) {
      this.selectedIds.add(id)
    } else {
      this.selectedIds.delete(id)
    }
    document.getElementById('selected_ids').value = Array.from(this.selectedIds).join(',')
  }
}
