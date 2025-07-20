-- Build view-salesbycompany
use will_shippingdb;
DROP VIEW IF EXISTS corpo_sales;

DELIMITER ^^
CREATE VIEW corpo_sales AS

SELECT 
    c.company_name,
    c.operating_country,
    l.port_region as company_loc,
    i.product_name,
    SUM(t.product_quantity) as total_products,
    o.dest_port,
    dest.port_region as dest_region,
    SUM(t.total_order_value) AS total_sales
FROM shipping_orders o
INNER JOIN shipping_inventory i on i.product_code = o.product_id
INNER JOIN shipping_corpos c on c.cust_id = o.cust_id
INNER JOIN shipping_coords l on c.operating_country = l.port_country
INNER JOIN order_totals t on o.order_id = t.order_id AND o.product_id = t.product_id
INNER JOIN shipping_coords dest on o.dest_port = dest.port_city
GROUP BY c.company_name, c.operating_country, l.port_region,i.product_name,o.dest_port,dest.port_region
;
^^
DELIMITER ;

-- Build view-salesbyregion
use will_shippingdb;
DROP VIEW IF EXISTS regionsales;

DELIMITER ^^
CREATE VIEW regionsales AS

SELECT 
    c.operating_country,
    l.port_region as company_loc,
    t.port_region as dest_region,
    SUM(t.total_order_value) as total_sales
FROM shipping_orders o
INNER JOIN shipping_corpos c on c.cust_id = o.cust_id
INNER JOIN shipping_coords l on c.operating_country = l.port_country
INNER JOIN order_totals t on o.order_id = t.order_id
INNER JOIN shipping_coords dest on o.dest_port = dest.port_city AND t.port_region = dest.port_region
GROUP BY c.operating_country, l.port_region,dest.port_region
;

^^
DELIMITER ;

-- Build view-order_totals
USE will_shippingdb;
DROP VIEW IF EXISTS order_totals;

DELIMITER ^^
CREATE VIEW order_totals AS
SELECT
    o.order_id,
    o.product_id,
    i.product_name,
    o.product_quantity,
    i.product_price,
    loc.port_region,
    f.taxes + f.levies AS taxes_paid,
    f.fees + f.hazard_fee AS additional_fees,
    (i.product_price * o.product_quantity) AS subtotal,
    (f.taxes + f.levies) + (i.product_price * o.product_quantity) + (f.fees + f.hazard_fee) AS total_order_value
FROM shipping_orders o
INNER JOIN shipping_inventory i ON o.product_id = i.product_code
INNER JOIN shipping_coords loc ON o.dest_port = loc.port_city -- Changed join to port_city based on procedure
INNER JOIN shipping_fees f ON loc.port_region = f.region;
^^
DELIMITER ;