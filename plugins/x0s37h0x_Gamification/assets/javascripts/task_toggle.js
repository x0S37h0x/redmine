// assets/javascripts/task_toggle.js
$(document).on('change', '.task-checkbox', function() {
  const taskId = $(this).closest('.task-item').data('id');
  const isChecked = $(this).is(':checked');

  $.ajax({
    url: `/tasks/${taskId}/toggle_status`,
    method: 'PATCH',
    data: { status: isChecked ? 'closed' : 'open' }
  });
});
