-- LOAD COMPATIBLE CONTAINERS
use will_shippingdb;
DROP PROCEDURE IF EXISTS shipping_containers;
DELIMITER ^^
CREATE PROCEDURE shipping_containers(IN prod_name VARCHAR(255))
BEGIN
	select i.product_name,
	i.product_type,
	i.product_price,
	b.container_id,
	b.container_type,
	b.container_material,
	b.container_capacity,
	b.container_price
	from shipping_inventory i
	inner join prod_compat c on i.product_code = c.product_code
	inner join shipping_barrels b on c.container_id = b.container_id
	where prod_name = i.product_name;
END ^^ 
DELIMITER ;