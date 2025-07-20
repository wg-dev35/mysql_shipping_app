//nest results to child div
//-----------------------------------------------------------------------------------------------------------------------------
//full results
function loadFullTracking(trackingNo) {
    const url = `/search/api/tracking/${encodeURIComponent(trackingNo)}`;
    fetch(url, {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
        },
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.text();
    })
    .then(html => {
        document.getElementById('trackingDiv').innerHTML = html;
        attachDismissListeners("#trackingDiv");
    })
    .catch(error => {
        console.error('Error fetching full tracking sheet:', error);
        document.getElementById('trackingDiv').innerHTML = '<p class="has-text-danger">Error loading tracking details.</p>';
    });
}
//    
function loadFullInvoice(invoiceNo) {
      fetch(`/search/api/invoice/${invoiceNo}`, {
          method: 'GET',
          headers: {
              'X-Requested-With': 'XMLHttpRequest',
          },
      })
      .then(response => response.text())
      .then(html => {
          document.getElementById('invoiceDiv').innerHTML = html;
          attachDismissListeners("#invoiceDiv");
      })
      .catch(error => {
          console.error('Error fetching full invoice:', error);
          document.getElementById('invoiceDiv').innerHTML = '<p class="has-text-danger">Error loading invoice details.</p>';
      });
}



//variables
document.addEventListener("DOMContentLoaded", function () {
  const trackingForm = document.querySelector('form[action="/search/api/tracking/"]');
  const productForm = document.querySelector('form[action*="/search/product"]');
  const employeeForm = document.querySelector('form[action="/employees"]');
  const invoiceForm = document.querySelector('form[action="/search/api/invoice/"]');

  const trackingResult = document.getElementById("trackingDiv");
  const trackingInfo = document.getElementById("trackingcard");
  const invoiceResult = document.getElementById("invoiceDiv");
  const invoiceInfo = document.getElementById("invoicecard");
  const productResult = document.getElementById("productsDiv");
  const employeeResult = document.getElementById("employeeDiv");
  //-----------------------------------------------------------------------------------------------------------------------------
  //TRACKING Scripts
  if (trackingForm) {
      trackingForm.addEventListener("submit", function (event) {
        event.preventDefault(); // Prevent default form submission

        const trackNo = trackingForm.querySelector('input[name="tracking"]');
        const searchTerm = trackNo ? trackNo.value : '';
        const searchUrl = `${trackingForm.action}?tracking=${encodeURIComponent(searchTerm)}`;

        fetch(searchUrl, {
          method: 'GET',
          headers: {
            "X-Requested-With": "XMLHttpRequest", // Explicitly set the header
          },
        })
          .then((response) => response.text())
          .then((data) => {
            trackingInfo.innerHTML = data;
            attachDismissListeners("#trackingcard");
          })
          .catch((error) => {
            console.error("Error fetching tracking results:", error);
            trackingInfo.innerHTML =
              '<p class="has-text-danger">Error fetching results.</p>';
          });
      });
  }
  //-----------------------------------------------------------------------------------------------------------------------------
  //INVOICE Scripts
  if (invoiceForm) {
    invoiceForm.addEventListener("submit", function (event) {
      event.preventDefault(); // Prevent default form submission

        const invoiceNo = invoiceForm.querySelector('input[name="invoice"]');
        const searchTerm = invoiceNo ? invoiceNo.value : '';
        const searchUrl = `${invoiceForm.action}?invoice=${encodeURIComponent(searchTerm)}`;

        
      fetch(searchUrl, {
        method: "GET",
        headers: {
          "X-Requested-With": "XMLHttpRequest", // Explicitly set the header
        },
      })
      .then((response) => response.text())
      .then((data) => {
        invoiceInfo.innerHTML = data;
        attachDismissListeners("#invoicecard");
      })
      .catch((error) => {
        console.error("Error fetching invoice results:", error);
        invoiceInfo.innerHTML =
        '<p class="has-text-danger">Error fetching results.</p>';
      });
    });
  }
  if (employeeForm){
    employeeForm.addEventListener("submit", function (event) {
        event.preventDefault();
        const empNo = employeeForm.querySelector('input[name="employee"]');
        const empSearch = empNo ? empNo.value : '';
        const empUrl = `/employees/api/search?employee=${encodeURIComponent(empSearch)}`;
  
      fetch(empUrl, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
            },
      })
      .then(response => response.text())
      .then(html => {
          document.getElementById('employeecard').innerHTML = html;
          attachDismissListeners("#employeecard");
      })
      .catch(error => {
            console.error('Error fetching employee information:', error);
            document.getElementById('employeecard').innerHTML = '<p class="has-text-danger">Error loading employee details.</p>';
      });
    });
  }
  // notifications
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
