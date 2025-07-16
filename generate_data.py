'''
name: generate_data.py
description: script to generate fake data for database testing and development using faker
revision history
date. desc.
04/15/25 
05/15/25 rew2orked csv file generation
'''

#########3
from faker import Faker
import mappings as k
import pandas as pd
import re
import random
from collections import OrderedDict

dummy = Faker()
rows = 250
default_tld = ".com"


#remix

#--empty lists--
cust_no, company_list,operating_countries,operating_locations = [],[],[],[]
company_contacts,contact_emails,contact_phs = [],[],[]
sales_contacts,port_contacts = [],[]
emp_subs,emp_first_name, emp_last_name, emp_country, emp_port, emp_email_addr =[],[],[],[],[],[]
product_code,product_n, product_form, product_value = [],[],[],[]

def clean_corpo(name):
    #trims company name of useless decorators (&,sons,ltd...)
    name = name.lower()
    name = re.sub(r'[,.]?\s+(ltd|inc|llc|corp|corporation|gmbh|sons|co)\b', '', name, flags=re.IGNORECASE)
    name = re.sub(r'[^\w]+', '',name)
    return name if name else "company"

def corpos():
    for i in range(rows):
        #initial seeds
        cust_id = dummy.unique.random_number(digits=3) ##unique - ties whole db primary key 
        company_name = dummy.unique.company() ##unique -foreign key constraint    
        first_name = dummy.first_name()
        last_name = dummy.last_name()
        corpo_contact = f'{first_name} {last_name}'
        #pick a place
        corpo_loc = random.choice(list(k.locale.keys()))
        locale_code = k.locale[corpo_loc]
        try:
            dummy_locale = Faker(locale_code)
        except Exception as e:
            print(f'Locale {locale_code} not supported - choosing supported locale. Error: {e}')
            dummy_locale = Faker('en_US')
        #generate location info
        chosen_city = dummy.unique.random_element(elements=k.port_loc[corpo_loc])
        chosen_ph = dummy_locale.phone_number()
        email_person = f"{first_name[0].lower()}.{last_name.lower().replace(' ','')}"
        email_domain = clean_corpo(company_name)
        tld = k.tld_country.get(corpo_loc, default_tld)
        email_addr = f'{email_person}@{email_domain}.co{tld}'
        sales_contact = dummy_locale.name()
        port_contact = dummy_locale.name()

        cust_no.append(cust_id)
        company_list.append(company_name)
        operating_countries.append(corpo_loc)
        operating_locations.append(chosen_city)
        company_contacts.append(corpo_contact)
        contact_emails.append(email_addr)
        contact_phs.append(chosen_ph)
        sales_contacts.append(sales_contact)
        port_contacts.append(port_contact)

        if (i +1) % 50 == 0:
            print(f'Generated {i + 1}/{rows} rows...')
            print("loop finished")
           

    cust_info = {
    "cust_id": cust_no,
    "company_name":company_list,
    "operating_country":operating_countries,
    "operating_location":operating_locations,
    "company_contact":company_contacts,
    "contact_email":contact_emails,
    "contact_ph":contact_phs,
    "sales_contact":sales_contacts,
    "port_contact":port_contacts,
    }

    cust_df = pd.DataFrame(cust_info)
    cust_df.to_csv("shipping_corpos.csv", index=False)
    print(cust_df[['company_name','operating_country','operating_location','company_contact','contact_email','contact_ph']].head())

def employee():
    for i in range (rows):
        emp_loc = random.choice(list(k.port_loc.keys()))
        emp_site = k.port_loc[emp_loc]

        emp_fname = dummy.first_name()
        emp_lname = dummy.last_name()
        email_tld = k.tld_country[emp_loc]
        subsidiary = dummy.random_element(elements=('Spt-septum','Wavez-zing','Freighterzz'))
        emp_subsi_email = f"{emp_fname[0].lower()}.{emp_lname.lower().replace(' ','')}" 
        emp_email = f'{emp_subsi_email}@{subsidiary}{email_tld}'

        emp_first_name.append(emp_fname)
        emp_last_name.append(emp_lname)
        emp_country.append(emp_loc)
        emp_port.append(emp_site)
        emp_email_addr.append(emp_email)
        emp_subs.append(subsidiary)

        if (i +1) % 50 == 0:
            print(f'Generated {i + 1}/{rows} rows...')
            print("loop finished")

    emp = {
        "employee_id":[dummy.unique.random_number(digits=(3)) for _ in range(rows)],
        "fname":emp_first_name,
        "lname":emp_last_name,
        "country_loc":emp_country, #port_country
        "port_loc":emp_port,  #port_code
        "email":emp_email_addr, #random company email
        "subsidiary":emp_subs, #random company from list of 3 subs
        "contracted_by":[dummy.random_element(elements=(k.contracts)) for _ in range(rows)], #random company
        "title":[dummy.random_element(elements=(k.roles)) for _ in range(rows)], #list of workers in docks and logistics
    }
    employee_df = pd.DataFrame(emp)
    employee_df.to_csv("shipping_employees.csv", index=False)
    print(employee_df[["fname","lname","country_loc","contracted_by"]].head())


def customs():
    customs = {
        "entry_id":[dummy.random_int() for _ in range(rows)],
        "port_of_origin":[dummy.random_element(elements=(k.port_names)) for _ in range(rows)], #port_names
        "departure_dock":[dummy.bothify(text='Dock ??$$$') for _ in range(rows)], #bothyfy
        "departure_time":[dummy.date_this_year() for _ in range(rows)], #time 24hr
        "port_of_entry":[dummy.random_element(elements=(k.port_names)) for _ in range(rows)],  #dest_country
        "arrival_dock":[dummy.bothify(text='Dock ??$$$') for _ in range(rows)],   #bothyfy
        "arrival_time":[dummy.date_this_year() for _ in range(rows)],   #time 24hr
        "ship_callsign":[dummy.bothify(text='??-??-??##?#') for _ in range(rows)],
        "disembark_time":[dummy.date_this_year() for _ in range(rows)], #time 24hr
        "unload_time":[dummy.date_this_year() for _ in range(rows)],    #time 24hr
    }
    customs_df = pd.DataFrame(customs)
    customs_df.to_csv("shipping_customs.csv", index=False)
    print(customs_df[['port_of_origin', 'port_of_entry','arrival_dock']].head())


def inventory():   
    for i in range(rows):
        item_code = dummy.unique.random_number(digits=(4)) #PRIMARY KEY UNIQUE
        product_code.append(item_code)
    inv = {
        "item_id": product_code,
        "sku":[dummy.unique.ean13() for _ in range(rows)],
        "lot_number":[dummy.unique.ean13(prefixes=('92','29')) for _ in range(rows)],
        "product_name":[dummy.random_element(elements=k.product) for _ in range(rows)], 
        "product_type":[dummy.random_element(elements=k.product_type) for _ in range(rows)],
        "product_price":[dummy.random_element(elements=k.product_price) for _ in range(rows)],
        "stock_loc":[dummy.random_element(elements=k.stock_loc) for _ in range(rows)],
    }
    stock_df = pd.DataFrame(inv)
    stock_df.to_csv("shipping_inventory.csv", index=False)
    print(stock_df[['item_id','sku','lot_number','product_price','product_name','product_type','stock_loc']].head())


def orders():

    orders = {
        "order_id":[dummy.random_number(digits=(4)) for _ in range(rows)], #unique primary key 
        "tracking_no":[dummy.unique.random_number(digits=6) for _ in range(rows)],#bothify
        "shipment_status":[dummy.random_element(elements=('Shipped','In Transit','Loading','Unloading','Disembarked','Canceled','Held In Customs')) for _ in range(rows)],#choose from status list
        "shipment_notes":[dummy.sentences() for _ in range(rows)],#lorem ipsum or maybe random phrases
        "product_code":[dummy.random_element(elements=product_code) for _ in range(rows)], #product name from inv
        "container_code":[dummy.random_element(elements=k.barrel_code) for _ in range(rows)], #product name from inv
        "ordered_by":[dummy.random_element(elements=cust_no) for _ in range(rows)], #company name from customers 
        "product_amount":[dummy.random_int(min=10, max=1500) for _ in range(rows)], #random bulk amount
        "origin_port":[dummy.random_element(elements=k.port_names) for _ in range(rows)], #port name + country (usually either brooklyn or somewhere else)
        "dest_port":[dummy.random_element(elements=k.port_names) for _ in range(rows)], #NOT BROOKLYN
        "order_date":[dummy.date_this_year() for _ in range(rows)], #random date from jan 2022 to current day 
        "ship_date":[dummy.date_this_year() for _ in range(rows)], #+30day of order date
        "est_travel_arr":[dummy.date_this_year() for _ in range(rows)],#between 20-30 days of shipdate if order_date <30days
    }
    invoice_df = pd.DataFrame(orders)
    invoice_df.to_csv("shipping_orders.csv", index=False)
    print(invoice_df[['product_code','product_amount','shipment_status','shipment_notes']].head())

if __name__== '__main__':
    corpos()
    customs()
    employee()
    inventory()
    orders()
