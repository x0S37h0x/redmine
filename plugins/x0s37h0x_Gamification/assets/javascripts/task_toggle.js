// plugins/x0s37h0x_Gamification/assets/javascripts/task_toggle.js
document.addEventListener('DOMContentLoaded', () => {
  // Retrieve CSRF token once at the start
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

  document.querySelectorAll('.task-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', function() {
      const taskId = this.closest('.task-item').dataset.id;
      const isChecked = this.checked;

      fetch(`/tasks/${taskId}/toggle_status`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken // Include CSRF token in headers
        },
        body: JSON.stringify({ status: isChecked ? 'erledigt' : 'offen' }) // Status values
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          this.closest('.task-item').remove(); // Remove completed task from the list
        } else {
          alert("Fehler beim Aktualisieren des Status.");
          this.checked = !isChecked; // Undo the check if update failed
        }
      })
      .catch(error => {
        console.error("Fehler:", error);
        alert("Ein Fehler ist aufgetreten.");
        this.checked = !isChecked;
      });
    });
  });
});
