-- Build Procedure
use will_shippingdb;
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

call full_tracking_lookup("");