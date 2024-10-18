// Event Listener for successful AJAX requests (creating habits, daily tasks, and ToDos)
document.addEventListener('ajax:success', function(event) {
  var detail = event.detail;
  var data = detail[0];

  // Log the server response for debugging
  console.log("Server response:", data);

  // Check if the response status is "success"
  if (data.status && data.status === "success") {
    // Close the modal on success
    closeModal();

    // Update only the relevant section (e.g., 'habits', 'daily_tasks', or 'todos')
    if (data.section) {
      updateSection(data.section); // Pass the section to be updated
    }
  } else if (data.status && data.status === "error") {
    // Handle error case
    alert("Error from dashboard.js: " + data.message);
  } else {
    console.error("Unknown response structure:", data);
    alert("An unknown error occurred.");
  }
});

// Event Listener for AJAX errors
document.addEventListener('ajax:error', function(event) {
  var detail = event.detail;
  var errorData = detail[0];

  // Log error details for debugging
  console.error("AJAX request error:", errorData);

  // Display an error message
  alert("An error occurred: " + errorData);
});

// Modal handling: open and close modals using plain JavaScript
document.addEventListener('click', function(event) {
  // Open modal
  if (event.target.classList.contains('open-modal')) {
    var targetModal = event.target.getAttribute('data-target');
    openModal(targetModal);
  }

  // Close modal
  if (event.target.classList.contains('close-modal')) {
    closeModal();  // Close all open modals
  }
});

// Function to close the modal
function openModal(modalId) {
  var modal = document.getElementById(modalId);
  modal.style.display = 'block';  // Show the modal
  modal.style.opacity = '1';      // Ensure visibility
}

function closeModal() {
  var modals = document.querySelectorAll('.modal');
  modals.forEach(modal => {
    modal.style.display = 'none';  // Explicitly hide the modal
    modal.style.opacity = '0';     // Optional: Fade out effect
  });
}

function updateSection(section) {
      const sectionElement = document.querySelector(`#${section}-column`);
  
  // Check if the section element exists before updating it
  if (!sectionElement) {
    console.error(`Section ${section}-column not found on the page.`);
    return;
  }
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  fetch(`/dashboard/update_section?section=${section}`, {
    headers: {
      'X-CSRF-Token': csrfToken
    }
  })
  .then(response => response.text())
  .then(html => {
    // Update the specific section
    // Update the specific section
    sectionElement.innerHTML = html;
    console.log(`${section} section successfully updated`);
  })
  .catch(error => {
    console.error(`Error updating the ${section} section: `, error);
  });
}


// Funktion zum Filtern von ToDos nach Fälligkeitsdatum
function filterTodos(filterType) {
  const todos = document.querySelectorAll('.todos-column .task-item');
  todos.forEach(todo => {
    const dueDate = new Date(todo.dataset.dueDate);
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Setze die Zeit auf den Tagesbeginn zur Vergleichsberechnung

    if (filterType === 'due_today') {
      todo.style.display = dueDate.toDateString() === today.toDateString() ? 'flex' : 'none';
    } else {
      todo.style.display = 'flex'; // Alle ToDos anzeigen, wenn kein Filter ausgewählt ist
    }
  });
}

// Funktion zum Filtern von ToDos nach Projekt
function filterByProject() {
  const selectedProjectId = document.getElementById('project-filter').value;
  const projectSections = document.querySelectorAll('.todos-column [data-project-id]');

  projectSections.forEach(section => {
    if (selectedProjectId === "" || section.dataset.projectId === selectedProjectId) {
      section.style.display = 'block'; // Zeigt die passenden Projekte an
    } else {
      section.style.display = 'none'; // Versteckt die nicht übereinstimmenden Projekte
    }
  });
}
