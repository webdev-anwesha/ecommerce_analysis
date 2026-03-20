/* Query 1 BUSINESS OVERVIEW */

SELECT
    COUNT(DISTINCT o.order_id)                        AS total_orders,
    COUNT(DISTINCT o.customer_id)                     AS total_customers,
    ROUND(SUM(p.payment_value::NUMERIC), 2)           AS total_revenue,
    ROUND(AVG(p.payment_value::NUMERIC), 2)           AS avg_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';

/* Query 2 MONTHLY REVENUE TREND */

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::TIMESTAMP) AS month,
    ROUND(SUM(p.payment_value::NUMERIC), 2)                    AS monthly_revenue,
    COUNT(DISTINCT o.order_id)                                  AS total_orders
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

/* Query 3 TOP 10 CATEGORIES BY REVENUE */

SELECT
    COALESCE(pr.product_category_name, 'Unknown') AS category,
    COUNT(DISTINCT oi.order_id)                    AS total_orders,
    ROUND(SUM(oi.price::NUMERIC), 2)               AS total_revenue
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

/* Query 4 PAYMENT METHOD DISTRIBUTION */

SELECT
    payment_type,
    COUNT(*)                                                      AS usage_count,
    ROUND(SUM(payment_value::NUMERIC), 2)                        AS total_value,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)          AS usage_pct
FROM payments
WHERE payment_value ~ '^[0-9]+(\.[0-9]+)?$'
GROUP BY payment_type
ORDER BY usage_count DESC;

/* Query 5  TOP 10 STATES BY UMBER OF CUSTOMERS */

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers
WHERE customer_state ~ '^[A-Z]+$'
GROUP BY customer_state
ORDER BY unique_customers DESC
LIMIT 10;

/* Query 6: Average Delivery Time by State */

SELECT
    c.customer_state,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (
            o.order_delivered_customer_date - 
            o.order_purchase_timestamp
        )) / 86400
    )::NUMERIC, 1) AS avg_delivery_days,
    COUNT(*) AS delivered_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days ASC
LIMIT 10;

-- 86400 is the no of seconds in a day

/* Query 7: Repeat vs One-Time Customers */

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM customer_orders
GROUP BY customer_type;

/* Query 8: Late Delivery Analysis by State */

SELECT
    c.customer_state,
    COUNT(*) AS late_deliveries,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (
            o.order_delivered_customer_date -
            o.order_estimated_delivery_date::TIMESTAMP
        )) / 86400
    )::NUMERIC, 1) AS avg_days_late
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date::TIMESTAMP
GROUP BY c.customer_state
ORDER BY late_deliveries DESC
LIMIT 10;

/* Query 9: Top 10 Best Selling Products by Category */

SELECT
    pr.product_category_name AS category,
    COUNT(*) AS times_sold,
    ROUND(SUM(oi.price::NUMERIC), 2) AS total_revenue
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND pr.product_category_name IS NOT NULL
GROUP BY pr.product_category_name
ORDER BY times_sold DESC
LIMIT 10;