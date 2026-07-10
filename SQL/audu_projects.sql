create database audu_project;

use audu_project;

 CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    price DECIMAL(10,2));
    
    
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(255));
    
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    book_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id));
    
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id));
    
    show tables;
    
INSERT INTO books VALUES
(1,'Book 1','Author 1',10.99),
(2,'Book 2','Author 2',12.99),
(3,'Book 3','Author 3',9.99),
(4,'Book 4','Author 4',15.99),
(5,'Book 5','Author 5',8.99);

INSERT INTO customers VALUES
(1,'Customer 1','customer1@example.com','Address 1'),
(2,'Customer 2','customer2@example.com','Address 2'),
(3,'Customer 3','customer3@example.com','Address 3'),
(4,'Customer 4','customer4@example.com','Address 4'),
(5,'Customer 5','customer5@example.com','Address 5');

INSERT INTO orders VALUES
(1,1,1,2,'2023-06-01'),
(2,2,3,1,'2023-06-02'),
(3,3,2,3,'2023-06-03'),
(4,4,4,2,'2023-06-04'),
(5,5,5,1,'2023-06-05');

INSERT INTO payments VALUES
(1,1,'2023-06-02',21.98),
(2,2,'2023-06-03',9.99),
(3,3,'2023-06-04',38.97),
(4,4,'2023-06-05',31.98),
(5,5,'2023-06-06',8.99);

SELECT * FROM customers;
 
SELECT title, author FROM books;
 
SELECT SUM(quantity) AS total_books_sold FROM orders;
 
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

SELECT SUM(amount) AS total_revenue FROM payments;

SELECT c.name, SUM(p.amount) AS total_paid
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.name
ORDER BY total_paid DESC
LIMIT 1;

SELECT title, price
FROM books
ORDER BY price DESC
LIMIT 1;

SELECT c.name, SUM(o.quantity) AS books_sold
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

SELECT c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_orders DESC
LIMIT 1;

SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

CREATE TABLE orders_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

show tables;
select * from orders_log;

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
INSERT INTO orders_log(order_id, action)
VALUES (NEW.order_id, 'INSERT');

CREATE TRIGGER after_order_update
AFTER UPDATE ON orders
FOR EACH ROW
INSERT INTO orders_log(order_id, action)
VALUES (NEW.order_id, 'UPDATE');

show triggers;
show create trigger after_order_insert;
show create trigger after_order_update;

CREATE TRIGGER after_order_delete
AFTER DELETE ON orders
FOR EACH ROW
INSERT INTO orders_log(order_id, action)
VALUES (OLD.order_id, 'DELETE');

DELIMITER //

CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT * FROM orders
    WHERE customer_id = cust_id;
END //

DELIMITER ;

CALL GetCustomerOrders(1);

CREATE USER 'godwin'@'localhost' IDENTIFIED BY '1010';

GRANT SELECT, INSERT, ALTER
ON bookstore.*
TO 'godwin'@'localhost';


