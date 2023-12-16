USE instacart_market_basket_analysis;

-- 1 Top Reordered Products
SELECT P.product_id, P.product_name, COUNT(*) AS total_reorders
FROM Order_products_prior OPP
JOIN Products P ON OPP.product_id = P.product_id
WHERE OPP.reordered = 1
GROUP BY P.product_id, P.product_name
ORDER BY total_reorders DESC
LIMIT 10;

-- 10 Most Popular Departments by Order Count
SELECT D.department, COUNT(*) AS product_count
FROM Departments D
JOIN Products P ON D.department_id = P.department_id
JOIN Order_products_prior OPP ON P.product_id = OPP.product_id
GROUP BY D.department
ORDER BY product_count DESC;
