Shipping Operations Dashboard
Overview

This project is a web application designed to streamline various shipping operations, including tracking, invoicing, employee lookup, and reporting. It provides a user-friendly interface for managing key business processes related to logistics and supply chain.
Features

    Dashboard: View high-level overviews of invoices and location data.

    Tracking Search: Look up shipping tracking numbers to view current status and full details.

    Invoice Search: Search for invoices by ID to retrieve details.

    Employee Lookup: Search for employee information by ID or name.

    Quote Generation (In Progress): Functionality to generate shipping quotes based on inventory, locations, and fees.

    Reporting: Generate sales and shipping order reports with interactive charts.

    Database Viewer: Directly view contents of selected database tables (for administrative/development purposes).

    Responsive Design: (To be implemented/improved) User interface adapts to different screen sizes.

Technologies Used

    Backend:

        Python 3.x

        Flask (Web Framework)

        SQLAlchemy (ORM for database interaction)

        Pandas (Data manipulation for reports)

        Plotly (Interactive data visualization)

    Frontend:

        HTML5

        CSS (Bulma CSS Framework)

        JavaScript (Vanilla JS for AJAX interactions)

        Jinja2 (Templating Engine)

    Database:

        (Specify your database, e.g., MySQL, PostgreSQL, SQLite)

        Extensive use of Stored Procedures for data retrieval.

Setup and Installation

Follow these steps to get the project up and running on your local machine.
Prerequisites

    Python 3.x installed.

    pip (Python package installer).

    Your database system (e.g., MySQL, PostgreSQL) installed and running.

    Your database populated with the necessary tables and stored procedures (e.g., random_invoice, random_ports, tracking_lookup, invoice_lookup, employee_lookup, inventory_menus, loc_menus, port_city_match, product_typeload, shipping_containers, taxes_fees, corpo_sales, shipping_orders, shipping_corpos).

1. Clone the Repository

git clone (https://github.com/wg-dev35/mysql_shipping_app)
cd shipping-operations-dashboard # Or whatever your project folder is named

2. Create a Virtual Environment (Recommended)

python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

3. Install Dependencies

pip install -r requirements.txt

(You'll need to create a requirements.txt file if you haven't already. You can generate one by running pip freeze > requirements.txt in your activated virtual environment after installing all dependencies.)
4. Database Configuration

    Ensure your db.py file (or wherever your database connection is configured) correctly points to your database.

    Verify that all required stored procedures are created and accessible in your database.

5. Run the Flask Application

export FLASK_APP=app.py # Or your main Flask app file, e.g., run.py
export FLASK_ENV=development # For development mode
flask run

The application should now be running at http://127.0.0.1:5000/.
Usage

    Navigate to / or /index/ for the homepage.

    Access /dashboard/ for the main dashboard.

    Use /search/ for tracking and invoice lookups.

    Visit /employees for employee search.

    Explore /shopping/ for quote generation features.

    Check /reports/ and /charts/ for data visualizations.

    Access /db/ to view raw table data.

Project Structure (Key Files)

    app.py (or run.py): Main Flask application entry point.

    routes.py: Defines all application routes and backend logic.

    db.py: Database connection and SQLAlchemy setup.

    static/: Contains CSS (style.css), JavaScript (search.js), and other static assets.

    templates/: Contains Jinja2 HTML templates (e.g., index.html, dashboard.html, search.html, employees.html, _tracking_cards.html, _invoice_cards.html, _emp_card.html, etc.).

Technical Debt & Future Enhancements (Optional Section)

    Backend Consistency: Standardize text() object definition across all SQL queries (e.g., sql = text('SELECT ...') instead of sql = 'SELECT ...'; db.session.execute(text(sql))).

    Product Search: Implement AJAX functionality for the product search form in shopping.html to dynamically display results.

    Frontend Cleanup: Remove unused JavaScript variables (trackingResult, invoiceResult).

    Error Handling: Implement more user-friendly error messages and logging on both frontend and backend.

    Input Validation: Add robust server-side and client-side input validation for all forms.

    User Authentication: Implement a proper user login and authentication system.

    Styling & Responsiveness: Enhance overall UI/UX, ensure full responsiveness across devices, and refine Bulma usage.

    Quote Logic: Complete the backend logic for comprehensive quote calculations.

    Deployment: Prepare the application for production deployment (e.g., Gunicorn, Nginx).

License

MIT License