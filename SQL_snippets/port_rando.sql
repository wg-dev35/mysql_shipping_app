--pull random 50 records of coords
use will_shippingdb;
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

call random_ports;
