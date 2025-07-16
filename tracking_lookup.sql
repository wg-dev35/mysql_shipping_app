-- Build Procedure
use will_shippingdb;
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

call tracking_lookup("7574");