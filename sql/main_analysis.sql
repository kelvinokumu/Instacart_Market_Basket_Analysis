-- 1. Market Basket Analysis:


-- Top 5 Products Most Commonly Added to the Cart First
SELECT P.product_name, COUNT(*) AS first_add_count
FROM Order_products_prior OP
JOIN Products P ON OP.product_id = P.product_id
WHERE OP.add_to_cart_order = 1
GROUP BY P.product_name
ORDER BY first_add_count DESC
LIMIT 5;

-- Number of Unique Products in a Single Order
SELECT AVG(unique_product_count) AS average_unique_products_per_order
FROM (
    SELECT OP.order_id, COUNT(DISTINCT OP.product_id) AS unique_product_count
    FROM Order_products_prior OP
    GROUP BY OP.order_id
) AS subquery;

-- 2. Customer Segmentation:
--  categorize customers based on the total amount they've spent on orders
WITH TotalAmountSpent AS (
  SELECT user_id, SUM(OPP.product_id) AS total_amount_spent
  FROM Orders O
  JOIN Order_products_prior OPP ON O.order_id = OPP.order_id
  GROUP BY user_id
)
SELECT customer_segment, COUNT(user_id) AS customer_count
FROM (
  SELECT TAS.user_id,
         CASE
           WHEN TAS.total_amount_spent <= 50000 THEN 'Low Spender'
           WHEN TAS.total_amount_spent > 50000 AND TAS.total_amount_spent <= 100000 THEN 'Medium Spender'
           WHEN TAS.total_amount_spent > 100000 THEN 'High Spender'
           ELSE 'Uncategorized'
         END AS customer_segment
  FROM TotalAmountSpent TAS
) AS SegmentedCustomers
GROUP BY customer_segment
ORDER BY customer_segment;


-- Different customer segments based on purchase frequency
WITH PurchaseFrequency AS (
  SELECT user_id, COUNT(DISTINCT O.order_id) AS order_count
  FROM Orders O
  GROUP BY user_id
)
SELECT customer_segment, COUNT(user_id) AS customer_count
FROM (
  SELECT PF.user_id,
         CASE
           WHEN PF.order_count <= 3 THEN 'Infrequent Shopper'
           WHEN PF.order_count > 3 AND PF.order_count <= 10 THEN 'Regular Shopper'
           WHEN PF.order_count > 10 THEN 'Frequent Shopper'
           ELSE 'Uncategorized'
         END AS customer_segment
  FROM PurchaseFrequency PF
) AS SegmentedCustomers
GROUP BY customer_segment
ORDER BY customer_segment;

-- Number of Orders Placed by Each Customer
SELECT user_id, COUNT(DISTINCT order_id) AS number_of_orders
FROM Orders
GROUP BY user_id;

-- 3. Customer Lifetime Value (CLV) Prediction:

-- Average CLV for Different Customer Segments:
SELECT customer_segment, AVG(total_amount_spent) AS average_total_amount_spent, AVG(purchase_frequency) AS average_purchase_frequency
FROM (
  SELECT user_id,
         SUM(OPP.product_id) AS total_amount_spent,
         COUNT(DISTINCT O.order_id) AS purchase_frequency,
         CASE
           WHEN SUM(OPP.product_id) > 500 AND COUNT(DISTINCT O.order_id) > 10 THEN 'High Value'
           WHEN SUM(OPP.product_id) > 500 THEN 'High Spender'
           WHEN COUNT(DISTINCT O.order_id) > 10 THEN 'Frequent Buyer'
           ELSE 'Regular Customer'
         END AS customer_segment
  FROM Orders O
  JOIN Order_products_prior OPP ON O.order_id = OPP.order_id
  GROUP BY user_id
) AS CustomerSegments
GROUP BY customer_segment;
