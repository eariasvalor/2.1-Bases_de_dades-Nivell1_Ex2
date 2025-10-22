CREATE DATABASE pizzeria;
USE pizzeria;

CREATE TABLE province(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE city(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
id_province INT NOT NULL,
FOREIGN KEY(id_province) REFERENCES province(id)
);

CREATE TABLE customer (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
surname VARCHAR(150) NOT NULL,
address VARCHAR(200) NOT NULL,
postal_code VARCHAR(15) NOT NULL,
city_id INT NOT NULL,
province_ide INT NOT NULL,
telephone VARCHAR(20) NOT NULL,
FOREIGN KEY(city_id) REFERENCES city(id),
FOREIGN KEY(province_ide) REFERENCES province(id)
);

CREATE TABLE store (
id INT AUTO_INCREMENT PRIMARY KEY,
address VARCHAR(150) NOT NULL,
postal_code VARCHAR(15) NOT NULL,
city_id INT NOT NULL,
province_id INT NOT NULL,
FOREIGN KEY (city_id) REFERENCES city(id),
FOREIGN KEY (province_id) REFERENCES province(id)
);

CREATE TABLE worker (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
surname VARCHAR(100) NOT NULL,
nif VARCHAR(10) NOT NULL UNIQUE,
telephone VARCHAR(20) NOT NULL,
position VARCHAR(12) NOT NULL CHECK (position IN ('COOK', 'DRIVER'))
);

CREATE TABLE category (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE product (
id INT AUTO_INCREMENT PRIMARY KEY,
type VARCHAR(9) NOT NULL,
name VARCHAR(120) NOT NULL,
description TEXT,
image_url TEXT,
price FLOAT NOT NULL,
category_id INT NOT NULL,
FOREIGN KEY (category_id) REFERENCES category(id),
CONSTRAINT check_type_ck
	CHECK (type IN ('PIZZA', 'HAMBURGER', 'DRINKS')),
    
CONSTRAINT check_price
	CHECK (price >= 0),

CONSTRAINT pizza_category_ck
	CHECK ((type = 'PIZZA' AND category_id IS NOT NULL)
		OR (type <> 'PIZZA' AND category_id IS NULL))
);

CREATE TABLE ordering (
id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT NOT NULL,
store_id INT NOT NULL,
order_date TIMESTAMP NOT NULL,
type VARCHAR(12) NOT NULL,
total_price FLOAT NOT NULL,
driver_id INT NOT NULL,
delivery_time TIMESTAMP NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customer(id),
FOREIGN KEY (store_id) REFERENCES store(id),
FOREIGN KEY (driver_id) REFERENCES worker(id),
CONSTRAINT checking_type_ck
	CHECK (type IN ('DELIVERY', 'PICK&COLLECT')),
    
CONSTRAINT checking_price
	CHECK (total_price >= 0),

CONSTRAINT delivery_order_ck
	CHECK ((type = 'DELIVERY' AND driver_id IS NOT NULL AND delivery_time IS NOT NULL)
		OR (type <> 'PICK&COLLECT' AND driver_id IS NULL AND delivery_time IS NULL))
);

CREATE TABLE online_order (
id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
qty INT NOT NULL,
unit_price FLOAT NOT NULL,
subtotal FLOAT GENERATED ALWAYS AS (qty * unit_price) STORED,
FOREIGN KEY (order_id) REFERENCES ordering(id),
FOREIGN KEY (product_id) REFERENCES product(id),
CONSTRAINT checking_qty_ck
	CHECK (qty > 0),
    
CONSTRAINT checking_unit_price
	CHECK (unit_price >= 0)
);



