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

  checkAll(event) {
    const isChecked = event.target.checked
    const checkboxes = document.querySelectorAll('input[type="checkbox"].row-checkbox')
    checkboxes.forEach(checkbox => {
      checkbox.checked = isChecked
      this.updateSelectedIds(checkbox)
    })
  }

  openImportModal() {
    const importModal = document.getElementById("import-modal")
    importModal.classList.remove("hidden")
  }

  closeImportModal() {
    const importModal = document.getElementById("import-modal")
    importModal.classList.add("hidden")
  }

  toggleRow(event) {
    this.updateSelectedIds(event.target)
  }

  updateSelectedIds(checkbox) {
    const checkboxes = document.querySelectorAll('input[type="checkbox"].row-checkbox')
    checkboxes.forEach(cb => {
      if (cb.checked) {
        this.selectedIds.add(cb.value)
      } else {
        this.selectedIds.delete(cb.value)
      }
    })
    console.log(this.selectedIds)
    document.getElementById('selected_ids').value = Array.from(this.selectedIds).join(',')
  }
}
