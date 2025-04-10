DROP DATABASE IF EXISTS sms;
create DATABASE IF not exists sms;
USE sms;

CREATE TABLE customer (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL
);
CREATE TABLE Employee (
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
    oriduct_name VARCHAR(255) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Employee(employee_id)
);
CREATE TABLE Product (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL
);
CREATE TABLE Orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    total DECIMAL(10,2),
    FOREIGN KEY(customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY(employee_id) REFERENCES Employee(employee_id)
);
CREATE TABLE LineItem (
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2),
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(product_id) REFERENCES Product(product_id)
);
-- Questions
-- 1. List all customers with customer_id, customer_name in the database, returning a list of all customers present in the order table.
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id;
-- 2. List all orders with order_id, order_date, customer_id, employee_id, total for a given customer, returning all orders for the specified customer_id.
SELECT DISTINCT o.order_id, o.order_date, o.customer_id, o.employee_id, o.total 
FROM Orders o
WHERE o.customer_id = 1;
-- 3. List all line items for an order, returning a list of all line items for a given order_id.
SELECT *
FROM LineItem
WHERE order_id = 1;
-- 4. Compute the order total (quantity * price) from the line items for a given order ID. You must use a User Defined Function.
DELIMITER //
CREATE FUNCTION order_total(p_order_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(quantity * price) INTO total
    FROM LineItem
    WHERE order_id = p_order_id;
    RETURN total;
END //
DELIMITER ;

-- 5. Add a new customer to the database. You must use a Stored Procedure.
DELIMITER //
CREATE PROCEDURE AddCustomer(
    IN custID INT,
    IN custName VARCHAR(100)   
)
BEGIN
    INSERT INTO customer (customer_id, customer_name) 
    VALUES (custID, custName);
END;
//
DELIMITER ;
-- 6. Delete a customer from the database, and also make sure to delete related Orders and LineItems. You must use a Stored Procedure.
DELIMITER //

CREATE PROCEDURE delete_customer_with_orders(IN cus_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
   
    DELETE FROM LineItem 
    WHERE order_id IN (
        SELECT order_id 
	FROM Orders 
	WHERE customer_id = cus_id
    );

    DELETE FROM Orders WHERE customer_id = cus_id;

    DELETE FROM Customer WHERE customer_id = cus_id;

    COMMIT;
END //

DELIMITER ;
-- 7. Update a customer in the database. You must use a Stored Procedure.
DELIMITER //
CREATE PROCEDURE UpdateCustomer(IN p_customer_id INT, IN p_new_name VARCHAR(255))
BEGIN
    UPDATE Customer
    SET customer_name = p_new_name
    WHERE customer_id = p_customer_id;
END //;
DELIMITER ;
-- 8. Create a new order in the database.
INSERT INTO Orders(order_date, customer_id, employee_id, total)
VALUES (NOW(), 20, 14, 20);  

-- 9. Create a new LineItem in the database.
INSERT INTO LineItem(order_id, product_id, quantity, price)
VALUES (2, 5, 3, 100.00);
-- 10.Update the total amount for an order in the database.
UPDATE orders 
SET total = (	SELECT SUM(quantity * price) 
				FROM lineitem 
				WHERE order_id = 2)
WHERE order_id = 2;
