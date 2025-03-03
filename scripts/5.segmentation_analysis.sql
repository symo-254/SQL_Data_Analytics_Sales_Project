--segmentation analysis for products
WITH product_segments AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost <100 THEN ' <100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE '>1000'
        END AS cost_range
    FROM products_dim
)
SELECT 
    cost_range,
    COUNT(*) AS product_count
FROM product_segments
GROUP BY cost_range
ORDER BY product_count DESC;

--segmentation analysis for customers

WITH customer_segments AS (
SELECT
    c.customer_key,
    SUM(sales_amount) AS total_spending,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS months_active
FROM sales_facts s
JOIN customers_dim c ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT
    CASE 
        WHEN total_spending >5000 AND months_active > 12 THEN 'VIP'
        WHEN total_spending <5000 AND months_active > 12 THEN 'Regular'
        ELSE 'New'
    END AS customer_group,
    COUNT(*) AS customer_count
FROM customer_segments
GROUP BY customer_group
ORDER BY customer_count DESC;