//nest results to child div

//variables
document.addEventListener("DOMContentLoaded", function () {
  const trackingForm = document.querySelector(
    'form[action*="/search/tracking"]'
  );
  const productForm = document.querySelector('form[action*="/search/product"]');
  const employeeForm = document.querySelector(
    'form[action*="/search/employee"]'
  );
  const invoiceForm = document.querySelector('form[action*="/search/invoice"]');

  const trackingResult = document.getElementById("trackingDiv");
  const trackingInfo = document.getElementById("trackingcard");
  const invoiceResult = document.getElementById("invoiceDiv");
  const invoiceInfo = document.getElementById("invoicecard");
  const productResult = document.getElementById("productsDiv");
  const employeeResult = document.getElementById("employeeDiv");

  //tracking searches
  if (trackingForm) {
    trackingForm.addEventListener("submit", function (event) {
      event.preventDefault(); // Prevent default form submission

      
      const formData = new FormData(trackingForm);
      fetch(trackingForm.action, {
        method: "GET",
        headers: {
          "X-Requested-With": "XMLHttpRequest", // Explicitly set the header
        },
      })
        .then((response) => response.text())
        .then((data) => {
          trackingResult.innerHTML = data;
        })
        .catch((error) => {
          console.error("Error fetching tracking results:", error);
          trackingResult.innerHTML =
            '<p class="has-text-danger">Error fetching results.</p>';
        });
    });
  }
  if (invoiceForm) {
    invoiceForm.addEventListener("submit", function (event) {
      event.preventDefault(); // Prevent default form submission
      const formData = new FormData(invoiceForm);
      fetch(invoiceForm.action, {
        method: "GET",
        headers: {
          "X-Requested-With": "XMLHttpRequest", // Explicitly set the header
        },
      })
        .then((response) => response.text())
        .then((data) => {
          invoiceResult.innerHTML = data;
        })
        .catch((error) => {
          console.error("Error fetching invoice results:", error);
          invoiceResult.innerHTML =
            '<p class="has-text-danger">Error fetching results.</p>';
        });
    });
  }
});

// notifications
document.addEventListener("DOMContentLoaded", () => {
  (document.querySelectorAll(".notification .delete") || []).forEach(
    ($delete) => {
      const $notification = $delete.parentNode;

      $delete.addEventListener("click", () => {
        $notification.parentNode.removeChild($notification);
      });
    }
  );
});

// form listeners for searches
function attachDismissListeners(containerSelector) {
  const container = document.querySelector(containerSelector);
  if (container) {
    const deleteButtons = container.querySelectorAll(".panel .delete");
    deleteButtons.forEach(($delete) => {
      const $panel = $delete.closest(".panel");
      if ($panel) {
        $delete.addEventListener("click", () => {
          $panel.remove();
        });
      }
    });
  }
}
