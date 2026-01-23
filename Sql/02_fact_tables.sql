CREATE TABLE fact_orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    customer_state TEXT,
    customer_city TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    total_items INTEGER,
    order_revenue NUMERIC,
    total_freight NUMERIC,
    payment_value NUMERIC,
    delivery_time_days NUMERIC,
    estimated_delivery_gap NUMERIC,
    is_delayed BOOLEAN
);

SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'fact_orders';

TRUNCATE TABLE fact_orders;

INSERT INTO fact_orders (
    order_id,
    customer_id,
    customer_state,
    customer_city,
    order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    total_items,
    order_revenue,
    total_freight,
    payment_value,
    delivery_time_days,
    estimated_delivery_gap,
    is_delayed
)
SELECT o.order_id,o.customer_id,c.customer_state,c.customer_city,o.order_status,o.order_purchase_timestamp,o.order_delivered_customer_date,
oa.total_items,oa.order_revenue,oa.total_freight,p.total_payment_value,o.delivery_time_days,o.estimated_delivery_gap,o.is_delayed FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_agg oa ON o.order_id = oa.order_id
LEFT JOIN (
    SELECT order_id,SUM(payment_value) AS total_payment_value FROM payments
    GROUP BY order_id
) p
    ON o.order_id = p.order_id;

SELECT COUNT(*) FROM fact_orders;
SELECT COUNT(DISTINCT order_id) FROM fact_orders;

CREATE VIEW dim_customer AS
SELECT DISTINCT customer_id,customer_unique_id,customer_city,customer_state FROM customers;

CREATE VIEW dim_date AS
SELECT DISTINCT order_purchase_timestamp::date AS order_date,EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
EXTRACT(MONTH FROM order_purchase_timestamp) AS month,EXTRACT(QUARTER FROM order_purchase_timestamp) AS quarter,
EXTRACT(DOW FROM order_purchase_timestamp) AS day_of_week FROM orders;


