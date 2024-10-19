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

// Checkbox click handler to complete a task or habit
document.addEventListener('click', function(event) {
  if (event.target.classList.contains('task-checkbox')) {
    const taskId = event.target.closest('.task-item').dataset.id;
    const taskType = event.target.closest('.dashboard-column').id; // Determine if it's 'habits', 'todos', or 'daily_tasks'

    completeTask(taskId, taskType);
  }
});

// Prevent multiple requests by tracking the request state
let isSubmitting = false;

// Function to mark a task as completed
function completeTask(taskId, section) {
  if (isSubmitting) return; // Prevents double submission

  const checkbox = document.querySelector(`input.task-checkbox[data-task-id="${taskId}"]`);

  if (!checkbox) {
    console.error(`Checkbox not found for task: ${taskId}`);
    return;
  }

  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  const isChecked = checkbox.checked;
  const newStatus = isChecked ? 'Erledigt' : 'Neu';

  isSubmitting = true; // Set submitting state to true

  fetch(`/daily_tasks/${taskId}/complete`, {
    method: 'POST',
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ status: newStatus })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    if (data.status === 'success') {
      console.log("Server Response: ", data);
      console.log(`Task ${taskId} completed with status: ${newStatus}`);
      
      // Update the checkbox status based on the new status
      checkbox.checked = (newStatus === 'Erledigt');
      updateSection(section); // Update the section after completing the task
      updateUserInfo();        // Update user info after task completion
    } else {
      console.error('Error completing the task:', data.message);
    }
  })
  .catch(error => {
    console.error('Error completing the task:', error);
  })
  .finally(() => {
    isSubmitting = false; // Reset the submitting state
  });
}

function openEditDailyTaskModal(taskId) {
  fetch(`/daily_tasks/${taskId}/edit`, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    // Fülle das Formular mit den erhaltenen Daten
    document.getElementById('edit-daily-task-id').value = data.id;
    document.getElementById('edit-daily-task-subject').value = data.subject;
    document.getElementById('edit-daily-task-description').value = data.description;
    document.getElementById('edit-daily-task-due-date').value = data.due_date || ''; // Fälligkeitsdatum

    // Setze die Action-URL des Formulars dynamisch mit der Task-ID
    const form = document.getElementById('edit-daily-task-form');
    form.action = `/daily_tasks/${data.id}/update`;

    // Öffne das Modal
    openModal('editDailyTaskModal');
  })
  .catch(error => {
    console.error('Error fetching daily task data: ', error);
  });
}



function openModal(modalId) {
  var modal = document.getElementById(modalId);
  modal.style.display = 'block';  // Show the modal
}

function closeModal() {
  var modals = document.querySelectorAll('.modal');
  modals.forEach(modal => {
    modal.style.display = 'none';  // Explicitly hide the modal
  });
}


// Function to open the modal
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
      sectionElement.innerHTML = html;
      console.log(`${section} section successfully updated`);
    })
    .catch(error => {
      console.error(`Error updating the ${section} section: `, error);
    });
}

function updateUserInfo() {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  
  fetch('/dashboard/user_info', {
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json'
    }
  })
  .then(response => response.text())
  .then(html => {
    const userInfoContainer = document.getElementById('custom-header-info'); // Verwende die ID
    userInfoContainer.innerHTML = html;  // Aktualisiere den User-Info-Bereich
    console.log("User info successfully updated");
  })
  .catch(error => {
    console.error("Error updating user info: ", error);
  });
}


// Function to filter ToDos by due date
function filterTodos(filterType) {
  const todos = document.querySelectorAll('.todos-column .task-item');
  todos.forEach(todo => {
    const dueDate = new Date(todo.dataset.dueDate);
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Set to the beginning of the day for comparison

    if (filterType === 'due_today') {
      todo.style.display = dueDate.toDateString() === today.toDateString() ? 'flex' : 'none';
    } else {
      todo.style.display = 'flex'; // Show all ToDos if no filter is selected
    }
  });
}

// Function to filter ToDos by project
function filterByProject() {
  const selectedProjectId = document.getElementById('project-filter').value;
  const projectSections = document.querySelectorAll('.todos-column [data-project-id]');

  projectSections.forEach(section => {
    if (selectedProjectId === "" || section.dataset.projectId === selectedProjectId) {
      section.style.display = 'block'; // Show matching projects
    } else {
      section.style.display = 'none'; // Hide non-matching projects
    }
  });
}
