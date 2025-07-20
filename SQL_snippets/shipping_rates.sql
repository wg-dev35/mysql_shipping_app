-- follow up menu for shipping rates
use will_shippingdb;
DROP Procedure IF EXISTS taxes_fees;
DELIMITER ^^
CREATE PROCEDURE taxes_fees (IN sel_country VARCHAR(255), IN sel_city VARCHAR(255))
BEGIN
	select l.port_country,
	l.port_city,
	f.taxes,
	f.levies,
	f.fees,
	f.hazard_fee
	from shipping_fees f
	inner join shipping_coords l on l.port_region = f.region
	where sel_country = l.port_country and sel_city = l.port_city;
END ^^
DELIMITER ;