-- Build Procedure INVOICE LOOKUP
use will_shippingdb;
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
