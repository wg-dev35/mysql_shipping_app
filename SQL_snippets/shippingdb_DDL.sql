/*
Author: Will
Date: 04/14/25
Descr: DDL for Shipping DB - basic table struct
Revision History
Name. Date. Description
wa  04/14/25 initial framework for shipping db
wa  04/29/25 transfer to local db for testing and implementation as stored procedure
wa  04/30/25 procedure conversion success - will need to edit if additional tables added
wa  05/10/25 optimized and included additional tables
wa  05/15/25 fixed table outcomes and changed which tables load
*/
-- use sbi_uloli_alguera; class db
use will_shippingdb;
-- Build Procedure
DROP Procedure IF EXISTS corpo_build;

DELIMITER ^^
CREATE PROCEDURE corpo_build()

BEGIN

  -- BUILD TABLES
  DROP TABLE IF EXISTS shipping_corpos;
  CREATE TABLE `shipping_corpos` (
    `cust_id` INT PRIMARY KEY NOT NULL,
    `company_name` VARCHAR (255) NOT NULL,
    `operating_country` VARCHAR (255) NOT NULL,
    `operating_location` VARCHAR (255) NOT NULL,
    `company_contact` VARCHAR (255),
    `contact_email` VARCHAR (255),
    `contact_ph` VARCHAR (255),
    `sales_contact` VARCHAR (255) NOT NULL,
    `port_contact` VARCHAR (255) NOT NULL
  );

  DROP TABLE IF EXISTS shipping_customs;
  CREATE TABLE `shipping_customs` (
    `entry_id` INT PRIMARY KEY NOT NULL,
    `port_of_origin` VARCHAR (255),
    `departure_dock` VARCHAR (255) DEFAULT NULL,
    `departure_time` DATETIME,
    `port_of_entry` VARCHAR (255),
    `arrival_dock` VARCHAR (255) DEFAULT NULL,
    `arrival_time` DATETIME,
    `ship_callsign` VARCHAR (255),
    `disembark_time` DATETIME,
    `unload_time` DATETIME
  );

  DROP TABLE IF EXISTS shipping_emp;
  CREATE TABLE `shipping_emp` (
    `employee_id` INT PRIMARY KEY NOT NULL,
    `fname` VARCHAR (255),
    `lname` VARCHAR (255),
    `country_loc` VARCHAR (255),
    `port_loc` VARCHAR (255),
    `email` VARCHAR (255),
    `subsidiary` VARCHAR (255),
    `contracted_by` VARCHAR (255) NOT NULL,
    `title` VARCHAR (255)
  );

  DROP TABLE IF EXISTS shipping_inventory;
  CREATE TABLE `shipping_inventory` (
    `product_code` INT PRIMARY KEY NOT NULL,
    `sku` VARCHAR(13) NOT NULL,
    `lot_number` VARCHAR(13) NOT NULL,
    `product_name` VARCHAR(255) NOT NULL,
    `product_type` varchar(255) NOT NULL,
    `product_price` DECIMAL(5,2) NOT NULL,
    `stock_loc` VARCHAR(255)
  );

  DROP TABLE IF EXISTS shipping_orders;
  CREATE TABLE `shipping_orders` (
    `order_id` INT PRIMARY KEY,
    `tracking_no` VARCHAR(255),
    `shipment_status` VARCHAR(255), 
    `shipment_note` VARCHAR(255), 
    `product_id` INT NOT NULL,
    `container_id` INT NOT NULL,
    `cust_id` VARCHAR(64),
    `product_quantity` INT DEFAULT NULL,
    `origin_port` VARCHAR(255),
    `dest_port` VARCHAR(255),
    `order_date` DATETIME,
    `ship_date` DATETIME,
    `est_arrival` DATETIME
  );

  DROP TABLE IF EXISTS shipping_coords;
  CREATE TABLE `shipping_coords` (
    `world_portcode` VARCHAR(8) PRIMARY KEY NOT NULL,
    `port_city` VARCHAR (255) NOT NULL,
    `port_country` VARCHAR (255) NOT NULL,
    `port_lattitude` DECIMAL(12,8) NOT NULL,
    `port_longitude` DECIMAL(12,8) NOT NULL,
    `port_region` VARCHAR(64) NOT NULL
  );

  DROP TABLE IF EXISTS shipping_barrels;
  CREATE TABLE `shipping_barrels` (
    `container_id` INT PRIMARY KEY,
    `container_type` VARCHAR (255) NOT NULL,
    `container_material` VARCHAR (255) NOT NULL,
    `container_capacity_gal` INT NOT NULL,
    `container_capacity_cub` DECIMAL(7,2) NOT NULL,
    `container_dimensions` VARCHAR (255),
    `container_weight_lb` DECIMAL(5,2),
    `container_weight_kg` DECIMAL(5,2) NOT NULL,
    `container_price` VARCHAR (255) NOT NULL
  );

  DROP TABLE IF EXISTS shipping_fees;
  CREATE TABLE `shipping_fees` (
    `region` VARCHAR(255) NOT NULL,
    `taxes` DECIMAL(7,2) NOT NULL,
    `levies` DECIMAL(7,2) NOT NULL,
    `fees` DECIMAL(7,2) NOT NULL,
    `hazard_fee` DECIMAL(7,2)
  );
  create table prod_compat(
	container_id INT NOT NULL, 
	product_code INT NOT NULL,
	PRIMARY KEY (product_code,container_id),
	FOREIGN KEY (product_code) REFERENCES shipping_inventory(product_code) on delete cascade,
	FOREIGN KEY (container_id) REFERENCES shipping_barrels(container_id) on update cascade
  );
END ^^

DELIMITER ;
call corpo_build();

-- Load data 
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_corpos.csv'
  INTO TABLE shipping_corpos
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

  -- Load data INTo shipping_customs table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_customs.csv'
  INTO TABLE shipping_customs
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

  -- Load data INTo shipping_emp table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_employees.csv'
  INTO TABLE shipping_emp
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

  -- Load data INTo shipping_inventory table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_inventory.csv'
  INTO TABLE shipping_inventory
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

  -- Load data INTo shipping_orders table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_orders.csv'
  INTO TABLE shipping_orders
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

    -- Load data INTo shipping_coords table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_port_coords.csv'
  INTO TABLE shipping_coords
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

      -- Load data INTo shipping_barrels table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_barrels.csv'
  INTO TABLE shipping_barrels
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

      -- Load data INTo shipping_FEES table
  LOAD DATA LOCAL INFILE '/home/gooey/devwork/sql_class/project/shipping_fees.csv'
  INTO TABLE shipping_fees
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;
      -- Load data into product compatability table
  LOAD DATA LOCAL INFILE '/home/kenguy/dev/training_projects/shipping_site/shipping_compatibility.csv'
INTO TABLE prod_compat
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;
