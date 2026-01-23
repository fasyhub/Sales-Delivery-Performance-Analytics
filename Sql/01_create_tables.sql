DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	customer_id TEXT PRIMARY KEY,
	customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);
SELECT COUNT(*) FROM customers;

CREATE TABLE orders (
    order_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    approval_delay_hours FLOAT,
    delivery_time_days FLOAT,
    estimated_delivery_gap FLOAT,
    is_delayed BOOLEAN
);
SELECT COUNT(*) FROM orders;

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_id VARCHAR,
    order_item_id INT,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT
);
SELECT COUNT(*) FROM order_items

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    order_id VARCHAR,
    payment_sequential INT,
    payment_type VARCHAR,
    payment_installments INT,
    payment_value FLOAT
);
SELECT COUNT(*) FROM payments

DROP TABLE IF EXISTS order_agg;
CREATE TABLE order_agg (
    order_id TEXT PRIMARY KEY,
    total_items INT,
    order_revenue NUMERIC,
    total_freight NUMERIC
);
SELECT COUNT(*) FROM order_agg

CREATE TABLE products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_lenght NUMERIC,
    product_description_lenght NUMERIC,
    product_photos_qty NUMERIC,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);
SELECT COUNT(*) FROM products;

CREATE TABLE sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);

