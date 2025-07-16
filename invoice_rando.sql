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

call random_invoice();
