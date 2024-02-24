-- 1. Market Basket Analysis
-- Top 10 product pairs that are most frequently purchased together
WITH product_pairs AS (
    SELECT op1.product_id AS product1, op2.product_id AS product2
    FROM order_products_prior AS op1
    JOIN order_products_prior AS op2 ON op1.order_id = op2.order_id AND op1.product_id < op2.product_id
)
SELECT product1, product2, COUNT(*) AS pair_count
FROM product_pairs
GROUP BY product1, product2
ORDER BY pair_count DESC
LIMIT 10;

-- Top 10 products that are most commonly added to the cart first
SELECT op.product_id, p.product_name, MIN(op.add_to_cart_order) AS min_add_to_cart_order
FROM order_products_prior AS op
JOIN products AS p ON op.product_id = p.product_id
GROUP BY op.product_id, p.product_name
ORDER BY min_add_to_cart_order
LIMIT 10;

-- How many unique products are typically included in a single order
SELECT AVG(num_products) AS avg_unique_products_per_order
FROM (
    SELECT order_id, COUNT(DISTINCT product_id) AS num_products
    FROM order_products_prior
    GROUP BY order_id
) AS subquery;



-- 2. Customer Segmentation
-- Different customer segments by purchase frequency.
WITH purchase_freq_table AS (
    SELECT 
        user_id,
        COUNT(DISTINCT order_id) AS purchase_frequency
    FROM orders
    GROUP BY user_id
),
customer_segments AS (
    SELECT 
        user_id,
        CASE 
            WHEN purchase_frequency <= 5 THEN 'Low Frequency'
            WHEN purchase_frequency <= 10 THEN 'Medium Frequency'
            ELSE 'High Frequency'
        END AS segment
    FROM purchase_freq_table
),
total_customers_table AS (
    SELECT COUNT(DISTINCT user_id) AS total_customers
    FROM orders
)
SELECT 
    segment,
    COUNT(*) AS num_customers,
    ROUND(COUNT(*) * 100.0 / total_customers, 2) AS percentage
FROM customer_segments
CROSS JOIN total_customers_table
GROUP BY segment, total_customers;

-- Orders placed per customer.
SELECT user_id, COUNT(*) AS order_count
FROM orders
GROUP BY user_id
ORDER BY order_count DESC;

-- 4. Seasonal Trends Analysis:
-- What is the distribution of orders placed on different days of the week
SELECT 
    CASE 
        WHEN order_dow = 0 THEN 'Sunday'
        WHEN order_dow = 1 THEN 'Monday'
        WHEN order_dow = 2 THEN 'Tuesday'
        WHEN order_dow = 3 THEN 'Wednesday'
        WHEN order_dow = 4 THEN 'Thursday'
        WHEN order_dow = 5 THEN 'Friday'
        WHEN order_dow = 6 THEN 'Saturday'
        ELSE 'Unknown'
    END AS day_of_week,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_dow
ORDER BY order_dow;

-- 6. products that are often bought together on weekends vs. weekdays
-- Weekend
SELECT 
    p1.product_id AS product_id1,
    p1.product_name AS product_name1,
    p2.product_id AS product_id2,
    p2.product_name AS product_name2,
    COUNT(*) AS pair_count
FROM order_products_prior op1
JOIN order_products_prior op2 ON op1.order_id = op2.order_id
JOIN orders o ON op1.order_id = o.order_id
JOIN products p1 ON op1.product_id = p1.product_id
JOIN products p2 ON op2.product_id = p2.product_id
WHERE o.order_dow IN (0, 6)  -- Weekend days (0 = Sunday, 6 = Saturday)
      AND op1.product_id < op2.product_id  -- Exclude self-pairs and duplicates
GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
ORDER BY pair_count DESC
LIMIT 10;

-- Weekdays
SELECT 
    p1.product_id AS product_id1,
    p1.product_name AS product_name1,
    p2.product_id AS product_id2,
    p2.product_name AS product_name2,
    COUNT(*) AS pair_count
FROM order_products_prior op1
JOIN order_products_prior op2 ON op1.order_id = op2.order_id
JOIN orders o ON op1.order_id = o.order_id
JOIN products p1 ON op1.product_id = p1.product_id
JOIN products p2 ON op2.product_id = p2.product_id
WHERE o.order_dow NOT IN (0, 6)  -- Weekday days
      AND op1.product_id < op2.product_id  -- Exclude self-pairs and duplicates
GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
ORDER BY pair_count DESC
LIMIT 10;










