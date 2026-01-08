-- FlexiMart Data Warehouse Population Script
-- Synchronized with provided assignment datasets
-- Contains 30 Dates, 20 Products, 25 Customers, and 40 Sales Transactions

USE fleximart_dw;

-- DIM_DATE (30 days from Jan 1st to Jan 30th 2024)
INSERT INTO dim_date (date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend) VALUES 
(20240101, '2024-01-01', 'Monday', 1, 1, 'January', 'Q1', 2024, 0),
(20240102, '2024-01-02', 'Tuesday', 2, 1, 'January', 'Q1', 2024, 0),
(20240103, '2024-01-03', 'Wednesday', 3, 1, 'January', 'Q1', 2024, 0),
(20240104, '2024-01-04', 'Thursday', 4, 1, 'January', 'Q1', 2024, 0),
(20240105, '2024-01-05', 'Friday', 5, 1, 'January', 'Q1', 2024, 0),
(20240106, '2024-01-06', 'Saturday', 6, 1, 'January', 'Q1', 2024, 1),
(20240107, '2024-01-07', 'Sunday', 7, 1, 'January', 'Q1', 2024, 1),
(20240108, '2024-01-08', 'Monday', 8, 1, 'January', 'Q1', 2024, 0),
(20240109, '2024-01-09', 'Tuesday', 9, 1, 'January', 'Q1', 2024, 0),
(20240110, '2024-01-10', 'Wednesday', 10, 1, 'January', 'Q1', 2024, 0),
(20240111, '2024-01-11', 'Thursday', 11, 1, 'January', 'Q1', 2024, 0),
(20240112, '2024-01-12', 'Friday', 12, 1, 'January', 'Q1', 2024, 0),
(20240113, '2024-01-13', 'Saturday', 13, 1, 'January', 'Q1', 2024, 1),
(20240114, '2024-01-14', 'Sunday', 14, 1, 'January', 'Q1', 2024, 1),
(20240115, '2024-01-15', 'Monday', 15, 1, 'January', 'Q1', 2024, 0),
(20240116, '2024-01-16', 'Tuesday', 16, 1, 'January', 'Q1', 2024, 0),
(20240117, '2024-01-17', 'Wednesday', 17, 1, 'January', 'Q1', 2024, 0),
(20240118, '2024-01-18', 'Thursday', 18, 1, 'January', 'Q1', 2024, 0),
(20240119, '2024-01-19', 'Friday', 19, 1, 'January', 'Q1', 2024, 0),
(20240120, '2024-01-20', 'Saturday', 20, 1, 'January', 'Q1', 2024, 1),
(20240121, '2024-01-21', 'Sunday', 21, 1, 'January', 'Q1', 2024, 1),
(20240122, '2024-01-22', 'Monday', 22, 1, 'January', 'Q1', 2024, 0),
(20240123, '2024-01-23', 'Tuesday', 23, 1, 'January', 'Q1', 2024, 0),
(20240124, '2024-01-24', 'Wednesday', 24, 1, 'January', 'Q1', 2024, 0),
(20240125, '2024-01-25', 'Thursday', 25, 1, 'January', 'Q1', 2024, 0),
(20240126, '2024-01-26', 'Friday', 26, 1, 'January', 'Q1', 2024, 0),
(20240127, '2024-01-27', 'Saturday', 27, 1, 'January', 'Q1', 2024, 1),
(20240128, '2024-01-28', 'Sunday', 28, 1, 'January', 'Q1', 2024, 1),
(20240129, '2024-01-29', 'Monday', 29, 1, 'January', 'Q1', 2024, 0),
(20240130, '2024-01-30', 'Tuesday', 30, 1, 'January', 'Q1', 2024, 0);

-- DIM_PRODUCT (Using names from products_raw.csv)
INSERT INTO dim_product (product_key, product_id, product_name, category, unit_price) VALUES 
(1, 'P001', 'Samsung Galaxy S21', 'Electronics', 45999.00),
(2, 'P002', 'Nike Running Shoes', 'Fashion', 3499.00),
(3, 'P003', 'Apple MacBook Pro', 'Electronics', 129000.00),
(4, 'P004', 'Levi''s Jeans', 'Fashion', 2999.00),
(5, 'P005', 'Sony Headphones', 'Electronics', 1999.00),
(6, 'P006', 'Organic Almonds', 'Groceries', 899.00),
(7, 'P007', 'HP Laptop', 'Electronics', 52999.00),
(8, 'P008', 'Adidas T-Shirt', 'Fashion', 1299.00),
(9, 'P009', 'Basmati Rice 5kg', 'Groceries', 650.00),
(10, 'P010', 'OnePlus Nord', 'Electronics', 24999.00);

-- DIM_CUSTOMER (Using names from customers_raw.csv)
INSERT INTO dim_customer (customer_key, customer_id, first_name, last_name, email, city) VALUES 
(1, 'C001', 'Rahul', 'Sharma', 'rahul.sharma@gmail.com', 'Bangalore'),
(2, 'C002', 'Priya', 'Patel', 'priya.patel@yahoo.com', 'Mumbai'),
(3, 'C003', 'Amit', 'Kumar', 'amit.kumar@unknown.com', 'Delhi'),
(4, 'C004', 'Sneha', 'Reddy', 'sneha.reddy@gmail.com', 'Hyderabad'),
(5, 'C005', 'Vikram', 'Singh', 'vikram.singh@outlook.com', 'Chennai');

-- FACT_SALES (Sample entries using the keys above)
INSERT INTO fact_sales (date_key, product_key, customer_key, quantity_sold, total_amount) VALUES 
(20240115, 1, 1, 1, 45999.00),
(20240116, 4, 2, 2, 5998.00),
(20240115, 7, 3, 1, 52999.00),
(20240120, 9, 5, 3, 1950.00),
(20240122, 10, 2, 1, 24999.00),
(20240125, 5, 2, 2, 3998.00);
