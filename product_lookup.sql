-- Build Procedure
use will_shippingdb;
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

call product_lookup("");