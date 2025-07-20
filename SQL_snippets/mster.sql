-- master procedures

-- randomize invoice generation procedure
use will_shippingdb;
DROP Procedure IF EXISTS random_invoice;
DELIMITER ^^
CREATE PROCEDURE random_invoice()
BEGIN
select 
o.order_id as 'Invoice #',
o.ordered_by as 'Purchaser',
o.order_date as 'Ordered On',
o.product_quantity as 'Amount Ordered',
o.dest_port as 'Destination',
o.shipment_status as 'Status'
from shipping_orders as o, (
            select o.order_id as iid
            from shipping_orders o
            order by RAND()
            limit 6
            ) tmp
where o.order_id = tmp.iid;

END ^^
DELIMITER ;

--pull random port locations
DROP Procedure IF EXISTS random_ports;
DELIMITER ^^
CREATE PROCEDURE random_ports ()
BEGIN
	

select
     port_city,
	 port_country,
	 port_lattitude,
	 port_longitude 
from shipping_coords s,(
		select world_portcode as wcode
		from shipping_coords
		order by RAND()
		limit 10
		) tmp
where s.world_portcode = tmp.wcode;

END ^^
DELIMITER ;

-- emp_lookup
DROP Procedure IF EXISTS employee_lookup;

DELIMITER ^^
CREATE PROCEDURE employee_lookup (IN search_term VARCHAR(255))

BEGIN
	select 
		employee_id,
		fname,
		lname,
		subsidiary,
		contracted_by,
		email	
	from shipping_emp
	where 
		employee_id LIKE CONCAT('%', search_term, '%') OR
		fname  LIKE CONCAT('%', search_term, '%') OR
		lname LIKE CONCAT('%', search_term, '%') OR
		subsidiary LIKE CONCAT('%', search_term, '%')
		;
END ^^
DELIMITER ;


-- full tracking lookup
DROP Procedure IF EXISTS full_tracking_lookup;

DELIMITER ^^
CREATE PROCEDURE full_tracking_lookup (IN trace_no VARCHAR(6))

BEGIN
select 
	o.order_id,
	o.tracking_no,
	o.cust_id,
	o.shipment_status,
	o.product_id,
	i.product_name,
	o.product_quantity,
	o.order_date,
	o.ship_date,
	o.est_arrival,
	o.origin_port,
	c.port_lattitude as origin_lat,
	c.port_longitude as origin_long,
	o.dest_port,
	c.port_lattitude as dest_lat,
	c.port_longitude as dest_long
	from shipping_orders o 
	join shipping_inventory i on o.product_id = i.product_code
    join shipping_coords c on o.origin_port=c.port_city
    join shipping_coords d on o.dest_port=d.port_city
	where o.tracking_no = trace_no;

END ^^
DELIMITER ;

-- -- Build Procedure INVOICE LOOKUP
DROP Procedure IF EXISTS invoice_lookup;

DELIMITER ^^
CREATE PROCEDURE invoice_lookup (IN inv_no VARCHAR(6))

BEGIN
	select 
	o.order_id,
	i.product_name,
	o.shipment_status,
	o.product_quantity,
	o.order_date,
	o.shipment_note as notes,
	o.origin_port as origin,
	o.dest_port as destination,
	i.product_price,
    (f.taxes + f.levies) as taxes_paid,
	(f.fees + f.hazard_fee) as additional_fees,
    (i.product_price * o.product_quantity) as subtotal,
    (f.taxes + f.levies) + (i.product_price * o.product_quantity) + (f.fees + f.hazard_fee)  as total
	from shipping_orders as o 
	inner join shipping_inventory i on o.product_id = i.product_code
	inner join shipping_coords loc on o.dest_port = loc.port_city
	inner join shipping_fees f on loc.port_region = f.region
	where o.order_id = inv_no;

END ^^
DELIMITER ;


-- product_lookup
DROP Procedure IF EXISTS product_lookup;

DELIMITER ^^
CREATE PROCEDURE product_lookup (IN prod_name VARCHAR(6))

BEGIN
	select product_name,
	item_price,
	product_quantity,
	product_stock,
	stock_loc
	from shipping_inventory 
	where product_name = prod_name;

END ^^
DELIMITER ;

-- inventory
DROP Procedure IF EXISTS inventory_menus;
DELIMITER ^^
CREATE PROCEDURE inventory_menus ()
BEGIN
	select 
	product_name
	from shipping_inventory ORDER BY product_name GROUP BY product_name;

END ^^
DELIMITER ;
-- type
DROP Procedure IF EXISTS inventory_type;
DELIMITER ^^
CREATE PROCEDURE inventory_type ()
BEGIN
	select 
	product_type
	from shipping_inventory ORDER BY product_type GROUP BY product_type;

END ^^
DELIMITER ;


-- locations
DROP Procedure IF EXISTS loc_menus;
DELIMITER ^^
CREATE PROCEDURE loc_menus() 
BEGIN
	select 
    distinct port_country
	from shipping_coords ORDER BY port_country;
END ^^
DELIMITER ;

DROP PROCEDURE IF EXISTS product_typeload;
DELIMITER ^^
CREATE PROCEDURE product_typeload(IN choice VARCHAR(255))
BEGIN
	select distinct product_type
	from shipping_inventory
	where product_name = choice
	ORDER by product_type;
END ^^ 
DELIMITER ;


-- pageload
DROP Procedure IF EXISTS quote_menus;
DELIMITER ^^
CREATE PROCEDURE quote_menus()
BEGIN
    CALL inventory_menus();
    CALL loc_menus();
END ^^
DELIMITER ;



-- Build view-salesbycompany
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

-- Build Procedure
DROP Procedure IF EXISTS tracking_lookup;

DELIMITER ^^
CREATE PROCEDURE tracking_lookup (IN trace_no VARCHAR(6))

BEGIN
	select tracking_no,
	order_id,
	shipment_status,
	product_id,
	product_quantity,
	order_date,
	ship_date,
	est_arrival
	from shipping_orders 
	where tracking_no = trace_no;

END ^^
DELIMITER ;