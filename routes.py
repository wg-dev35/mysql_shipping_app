#----routes done as a blueprint for further expansion --

from flask import Blueprint, render_template,request,session, redirect, url_for, jsonify
from db import db  # Import the db instance
from sqlalchemy import text, select, bindparam
import pandas as pd
from markupsafe import Markup
import json
import plotly
import plotly.express as px
import plotly.graph_objects as go

main = Blueprint('main',__name__)
@main.route('/')
@main.route("/index/")
def index():
    return render_template('index.html')

#-----------------------------------------------------------------------------------------------------------------------------
##DASHBOARD ROUTES
@main.route('/dashboard/', methods=['GET'])
def dash():
    invoice_info = fetch_invoice()
    loc_info = fetch_coords()
    return render_template('dashboard.html', invoices=invoice_info,coords=loc_info)

def fetch_invoice():
    invoices = []
    sql = f"CALL random_invoice()"
    result = db.session.execute(text(sql))
    for row in result.mappings():
        invoices.append(row)
    return invoices

def fetch_coords():
    coords = []
    sql = f"CALL random_ports()"
    result = db.session.execute(text(sql))
    for row in result:
        coords.append(row._asdict())
    return coords

@main.route('/dashboard/orders', methods=['GET'])
def notification():
    results_set = []
    sql = f"CALL random_invoice()"
    result = db.session.execute(text(sql))
    for row in result.mappings():
        results_set.append(row)
    return jsonify(results_set)
#-----------------------------------------------------------------------------------------------------------------------------
##SEARCH ROUTES
@main.route('/search/', methods=['GET'])
def search():
    return render_template('search.html')

@main.route('/search/api/tracking/', methods=['GET'])
def tracking_search():
    track_id = request.args.get('tracking')
    if not track_id:
        return render_template('_tracking_cards.html',results=[])
    sql_query = text("CALL tracking_lookup(:track_id)")
    result = db.session.execute(sql_query,{"track_id":track_id})
    results = [row._asdict() for row in result.fetchall()]
    return render_template('_tracking_cards.html', results=results)

@main.route('/search/api/<string:trackingid>/<string:trackingno>', methods=['GET'])
def full_tracking(trackingno):
    sql = f"CALL full_tracking_lookup('{trackingno}')"
    result = db.session.execute(text(sql))
    tracking_details = [row._asdict() for row in result]
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return render_template('_full_tracking.html', tracking_details=tracking_details[0] if tracking_details else None)
    else:
        return render_template('search.html', tracking_details=tracking_details[0] if tracking_details else None)
    return render_template('search.html')

@main.route('/search/api/invoice', methods=['POST'])
def invoice_search():
    results = ""
    if request.method == 'POST':
        search_term = request.form.get('invoice')
        if search_term:
            sql = f"CALL invoice_lookup('{search_term}')"
            result = db.session.execute(text(sql))
            results = [row._asdict() for row in result]
            if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                return render_template('_invoice_cards.html', results=results)
        else:
            return render_template('search.html', results=results)
    return render_template('search.html', results=results)

@main.route('/search/api/invoice/<invoiceno>', methods=['POST'])
def full_invoice(invoiceno):
    sql = f"CALL invoice_lookup('{invoiceno}')"
    result = db.session.execute(text(sql))
    invoice_details = [row._asdict() for row in result]
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return render_template('_full_invoice.html', invoice_details=invoice_details[0] if invoice_details else None)
    else:
        return render_template('search.html', invoice_details=invoice_details[0] if invoice_details else None)
    return render_template('search.html')
#-----------------------------------------------------------------------------------------------------------------------------
#QUOTE ROUTES
@main.route('/shopping/', methods=['GET'])
def quote_load():
    inventory = f'CALL inventory_menus'
    inv_items = db.session.execute(text(inventory))
    inv_menu = [row._asdict() for row in inv_items]
    location = f'CALL loc_menus'
    loc_items = db.session.execute(text(location))
    loc_menu = [row._asdict() for row in loc_items]
    return render_template('shopping.html',inv=inv_menu,loc=loc_menu)

@main.route('/shopping/api/city/<string:country_name>', methods=['GET'])
def cities(country_name):
    city_match = text("CALL port_city_match(:country_param)")
    city_loc = db.session.execute(city_match,{"country_param":country_name})
    city_list = [row._asdict() for row in city_loc]
    return jsonify(city_list)

@main.route('/shopping/api/products/<string:prod_name>', methods=['GET'])
def product_search(prod_name):
    product_type = text("CALL product_typeload(:prod_name)")
    names = db.session.execute(product_type,{"prod_name":prod_name})
    name_list = [row._asdict() for row in names]
    return jsonify(name_list)

@main.route('/shopping/api/containers/<string:prod_name>/<string:prod_type>', methods=['GET'])
def shipping_containers(prod_name,prod_type):
    product_container = text("CALL shipping_containers(:prod_name, :prod_type)")
    types = db.session.execute(product_container,{"prod_name":prod_name,"prod_type":prod_type})
    type_list = [row._asdict() for row in types]
    return jsonify(type_list)

@main.route('/shopping/api/fees/<string:country_name>/<string:city_name>', methods=['GET'])
def addtl_fees(country_name,city_name):
    fees = text("CALL taxes_fees(:country_name, :city_name)")
    regions = db.session.execute(fees,{"country_name":country_name,"city_name":city_name})
    region_list = [row._asdict() for row in regions]
    return jsonify(region_list)

@main.route('/shopping/employee', methods=['GET', 'POST'])
def emp_search():
    results = ""
    if request.method == 'POST':
        search_term = request.form.get('employee')
        if search_term:
            sql = f"CALL employee_lookup('{search_term}')"
            result = db.session.execute(text(sql))
            response = [row._asdict() for row in result]
            df = pd.DataFrame(response)
            results = df.to_html(classes='table is-striped', table_id='employeeTable')
            results = Markup(results)
            if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                return results
            else:
                return render_template('search.html', results=results)
    return render_template('search.html', results=results)
#-----------------------------------------------------------------------------------------------------------------------------
##REPORTING ROUTES
@main.route('/reports/', methods=['GET', 'POST'])
def report_landing():
    return render_template('reports.html')

@main.route('/reports/sales/', methods=['GET', 'POST'])
def sales_report():
    results_set = []
    sql = 'select * from corpo_sales;'
    result = db.session.execute(text(sql))
    for row in result.mappings():
        results_set.append(row)
    df = pd.DataFrame(results_set)
    # Create Bar chart
    fig = px.bar(df, x='company_name', y='total_sales')
    # Create graphJSON
    graphJSON = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)     
    # Use render_template to pass graphJSON to html
    return render_template('reports.html', graphJSON=graphJSON)


@main.route('/charts/', methods=['GET', 'POST'])
def myChart():
    results_set = []
    sql = 'select * from shipping_orders '
    result = db.session.execute(text(sql))
    for row in result.mappings():
        results_set.append(row)
    df = pd.DataFrame(results_set)   
    # Create Bar chart
    fig = px.bar(df, x='dest_port', y='product_quantity')
    # Create graphJSON
    graphJSON = json.dumps(fig, cls=plotly.utils.PlotlyJSONEncoder)     
    # Use render_template to pass graphJSON to html
    return render_template('charts.html', graphJSON=graphJSON)
    #return render_template('dbquery.html', results=result_html)

#-----------------------------------------------------------------------------------------------------------------------------

@main.route('/db/', methods=['GET'])
def dbQuery():
    results_set = []
    sql = 'select * from shipping_corpos;'
    result = db.session.execute(text(sql))
    for row in result.mappings():
        results_set.append(row)
    df = pd.DataFrame(results_set)
    result_html = df.to_html(classes='table is-striped')
    result_html = Markup(result_html)
    return render_template('db_page.html', results=result_html)
#error routes
@main.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404


@main.errorhandler(500)
def internal_server_error(e):
    return render_template('500.html'), 500