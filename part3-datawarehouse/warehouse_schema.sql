-- Database Warehouse: fleximart_dw
CREATE DATABASE IF NOT EXISTS fleximart_dw;
USE fleximart_dw;

-- Dimension: Date
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY, -- YYYYMMDD
    full_date DATE NOT NULL,
    day_of_week VARCHAR(15),
    day_of_month INT,
    month INT,
    month_name VARCHAR(15),
    quarter INT,
    year INT,
    is_weekend BOOLEAN
);

-- Dimension: Product
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY AUTO_INCREMENT,
    product_id_orig VARCHAR(20), -- raw product ID
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50) -- placeholder if needed
);

-- Dimension: Customer
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_id_orig VARCHAR(20), -- raw customer ID
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    segment VARCHAR(20) -- For segmentation analysis
);

-- Fact: Sales
CREATE TABLE fact_sales (
    sale_key INT PRIMARY KEY AUTO_INCREMENT,
    date_key INT,
    product_key INT,
    customer_key INT,
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2) DEFAULT 0.0,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key)
);
