-- Build Procedure
use will_shippingdb;
DROP Procedure IF EXISTS employee_lookup;

DELIMITER ^^
CREATE PROCEDURE employee_lookup (IN search_term VARCHAR(255))

BEGIN
	select 
		employee_id,
		fname,
		lname,
		subsidiary,
		contracted_by,
		email	
	from shipping_emp
	where 
		employee_id LIKE CONCAT('%', search_term, '%') OR
		fname  LIKE CONCAT('%', search_term, '%') OR
		lname LIKE CONCAT('%', search_term, '%') OR
		subsidiary LIKE CONCAT('%', search_term, '%')
		;
END ^^
DELIMITER ;

call employee_lookup_lookup("");