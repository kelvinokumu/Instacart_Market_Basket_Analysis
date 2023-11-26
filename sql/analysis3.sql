SELECT product_id, product_name, COUNT(*) AS total_reorders
FROM Order_products_prior
WHERE reordered = 1
GROUP BY product_id, product_name
ORDER BY total_reorders DESC
LIMIT 10;


SELECT order_hour_of_day, COUNT(*) AS order_count
FROM Orders
GROUP BY order_hour_of_day
ORDER BY order_count DESC;


SELECT A.aisle, COUNT(*) AS product_count
FROM Aisles A
JOIN Products P ON A.aisle_id = P.aisle_id
GROUP BY A.aisle
ORDER BY product_count DESC
LIMIT 10;


SELECT user_id, AVG(days_since_prior_order) AS avg_days_between_orders
FROM Orders
GROUP BY user_id;


SELECT D.department, 
       SUM(OPP.reordered) AS total_reordered,
       COUNT(*) AS total_products,
       SUM(OPP.reordered) / COUNT(*) AS reorder_rate
FROM Departments D
JOIN Products P ON D.department_id = P.department_id
LEFT JOIN Order_products_prior OPP ON P.product_id = OPP.product_id
GROUP BY D.department
ORDER BY reorder_rate DESC;


SELECT order_dow, COUNT(*) AS order_count
FROM Orders
GROUP BY order_dow
ORDER BY order_count DESC
LIMIT 1;



