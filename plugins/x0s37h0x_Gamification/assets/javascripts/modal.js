// JavaScript for Modal Opening and Closing
document.addEventListener('DOMContentLoaded', function () {
  // Open modal when button is clicked
  document.querySelectorAll('.open-modal').forEach(button => {
    button.addEventListener('click', function () {
      const modalId = this.getAttribute('data-target');
      document.getElementById(modalId).style.display = 'block';
    });
  });

  // Close modal when close button is clicked
  document.querySelectorAll('.close-modal').forEach(closeButton => {
    closeButton.addEventListener('click', function () {
      const modal = this.closest('.modal');
      modal.style.display = 'none';
    });
  });

  // Close modal when user clicks outside the modal-content
  window.onclick = function (event) {
    document.querySelectorAll('.modal').forEach(modal => {
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    });
  };
});
