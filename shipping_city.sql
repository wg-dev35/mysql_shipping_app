--follow up menu for shipping cities
use will_shippingdb;
DROP Procedure IF EXISTS port_city_match;
DELIMITER ^^
CREATE PROCEDURE port_city_match (IN sel_country VARCHAR(255))
BEGIN
    select port_city
    from shipping_coords
    where port_country = sel_country
    order by port_city;
END ^^

DELIMITER ;
