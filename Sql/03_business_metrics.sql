-- Total orders and total revenue (overall business size)
SELECT COUNT(DISTINCT order_id) AS total_orders, SUM(order_revenue) AS total_revenue
FROM fact_orders;
-- -- Monthly trend of orders and revenue
SELECT d.year,d.month,COUNT(DISTINCT f.order_id) AS total_orders,SUM(f.order_revenue) AS total_revenue
FROM fact_orders f
JOIN dim_date d ON DATE(f.order_purchase_timestamp) = d.order_date
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
--Overall delivery health
SELECT AVG(delivery_time_days) AS avg_delivery_days,ROUND(AVG(CASE WHEN is_delayed THEN 1 ELSE 0 END) * 100,2)
AS delayed_order_percentage
FROM fact_orders;
-- Monthly Delivery Performance
SELECT d.year,d.month,AVG(f.delivery_time_days) AS avg_delivery_days,ROUND(AVG(CASE WHEN f.is_delayed THEN 1 ELSE 0 END) * 100,2)
AS delayed_percentage
FROM fact_orders f
JOIN dim_date d ON DATE(f.order_purchase_timestamp) = d.order_date
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
-- Customer Loyalty Split: Repeat vs One-Time Buyers
SELECT CASE
WHEN customer_order_count = 1 THEN 'One-time Customer' ELSE 'Repeat Customer' END AS customer_type, COUNT(*) AS customer_count
FROM (
SELECT customer_id,COUNT(order_id) AS customer_order_count FROM fact_orders
GROUP BY customer_id) t
GROUP BY customer_type;
-- Average Order Frequency per Customer
SELECT ROUND(AVG(order_count), 2) AS avg_orders_per_customer
FROM (
SELECT customer_id,COUNT(order_id) AS order_count FROM fact_orders
GROUP BY customer_id) t;
-- Monthly Active Customers Trend
SELECT d.year,d.month,COUNT(DISTINCT f.customer_id) AS monthly_active_customers FROM fact_orders f
JOIN dim_date d ON DATE(f.order_purchase_timestamp) = d.order_date
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
-- Customer Lifetime Value Distribution
SELECT customer_id,ROUND(SUM(order_revenue), 2) AS lifetime_value,COUNT(order_id) AS total_orders FROM fact_orders
GROUP BY customer_id
ORDER BY lifetime_value DESC;
-- Average Order Value (AOV)
SELECT ROUND(SUM(order_revenue) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM fact_orders;
-- Revenue Contribution by Order Size Bucket
SELECT CASE
WHEN order_revenue < 50 THEN 'Low Value (<50)'
WHEN order_revenue BETWEEN 50 AND 200 THEN 'Mid Value (50–200)'
	ELSE 'High Value (>200)'
    END AS order_value_bucket,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(order_revenue), 2) AS total_revenue
FROM fact_orders
GROUP BY order_value_bucket
ORDER BY total_revenue DESC;
-- Revenue Concentration – Top 20% Customers
WITH customer_revenue AS (
SELECT customer_id,SUM(order_revenue) AS revenue FROM fact_orders
GROUP BY customer_id
),
ranked AS (
SELECT customer_id,revenue,NTILE(5) OVER (ORDER BY revenue DESC) AS revenue_bucket FROM customer_revenue
)
SELECT revenue_bucket,COUNT(customer_id) AS customers, ROUND(SUM(revenue), 2) AS total_revenue FROM ranked
GROUP BY revenue_bucket
ORDER BY revenue_bucket;
-- Top Revenue-Contributing Customers
SELECT COUNT(*) AS total_rows,COUNT(order_revenue) AS non_null_revenue,COUNT(*) - COUNT(order_revenue) AS null_revenue
FROM fact_orders;

SELECT COUNT(*) AS broken_orders FROM fact_orders
WHERE order_revenue IS NULL;

SELECT order_id,customer_id FROM fact_orders
WHERE order_revenue IS NULL
LIMIT 10;

UPDATE fact_orders
SET order_revenue = 0
WHERE order_revenue IS NULL;

SELECT customer_id, ROUND(SUM(order_revenue), 2) AS customer_revenue FROM fact_orders
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 10;
-- Order Delivery Delay Rate
SELECT ROUND(100.0 * SUM(CASE WHEN is_delayed = TRUE THEN 1 ELSE 0 END) / COUNT(*),2) AS delayed_order_percentage
FROM fact_orders;
-- Average Delivery Time (Days)
SELECT ROUND(AVG(delivery_time_days), 2) AS avg_delivery_days FROM fact_orders
WHERE delivery_time_days IS NOT NULL;
-- Delivery Speed Distribution
SELECT
    CASE
        WHEN delivery_time_days <= 5 THEN 'Fast (≤5 days)'
        WHEN delivery_time_days BETWEEN 6 AND 10 THEN 'Normal (6–10 days)'
        WHEN delivery_time_days BETWEEN 11 AND 20 THEN 'Slow (11–20 days)'
        ELSE 'Very Slow (>20 days)'
    END AS delivery_bucket,
COUNT(order_id) AS total_orders FROM fact_orders
GROUP BY delivery_bucket
ORDER BY total_orders DESC;
-- Revenue Impact of Delivery Delays
SELECT is_delayed,COUNT(order_id) AS total_orders,ROUND(SUM(order_revenue), 2) AS total_revenue,ROUND(AVG(order_revenue), 2) AS avg_order_value
FROM fact_orders
GROUP BY is_delayed;
-- State-wise Delivery Delay Performance
SELECT c.customer_state,
COUNT(f.order_id) AS total_orders,ROUND(100.0 * SUM(CASE WHEN f.is_delayed = TRUE THEN 1 ELSE 0 END) / COUNT(*),2) AS delay_percentage
FROM fact_orders f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY delay_percentage DESC;
-- Which product categories generate the highest revenue?
SELECT p.product_category_name,ROUND(SUM(i.price)::numeric, 2) AS total_revenue FROM order_items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
-- Which categories sell the most items.
SELECT p.product_category_name,COUNT(i.order_id) AS total_orders FROM order_items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;
-- Price positioning of each category.
SELECT p.product_category_name,ROUND(AVG(i.price)::numeric, 2) AS avg_item_price FROM order_items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_item_price DESC;
-- Which categories are logistics-heavy.
SELECT p.product_category_name,ROUND(AVG(i.freight_value)::numeric, 2) AS avg_freight_cost FROM order_items i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_freight_cost DESC;
-- Which categories actually matter.
WITH category_revenue AS (
    SELECT p.product_category_name,SUM(i.price) AS revenue FROM order_items i
    JOIN products p ON i.product_id = p.product_id
    GROUP BY p.product_category_name
),
total AS (
    SELECT SUM(revenue) AS total_revenue FROM category_revenue
)
SELECT c.product_category_name,ROUND((c.revenue / t.total_revenue)::numeric * 100, 2) AS revenue_percentage 
FROM category_revenue c, total t
ORDER BY revenue_percentage DESC;
-- Top Sellers by Revenue.
SELECT s.seller_id,s.seller_state,ROUND(SUM(i.price)::numeric, 2) AS total_revenue FROM order_items i
JOIN sellers s ON i.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;
-- Who sells the most orders.
SELECT s.seller_id,s.seller_state,COUNT(DISTINCT i.order_id) AS total_orders FROM order_items i
JOIN sellers s ON i.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY total_orders DESC
LIMIT 10;
-- Who sells expensive orders on average.
SELECT s.seller_id,ROUND(AVG(i.price)::numeric, 2) AS avg_item_price FROM order_items i
JOIN sellers s ON i.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY avg_item_price DESC
LIMIT 10;
-- Which states dominate seller revenue.
SELECT s.seller_state,ROUND(SUM(i.price)::numeric, 2) AS state_revenue FROM order_items i
JOIN sellers s ON i.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY state_revenue DESC;




































