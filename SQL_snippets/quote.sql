-- component procedure
use will_shippingdb;

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


