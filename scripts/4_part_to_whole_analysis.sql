    --calaculate the total sales for each product category and the percentage of total sales that each category represents

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') AS sales_percentage
FROM (
    SELECT
        category,
        SUM(sales_amount) AS total_sales
    FROM sales_facts s 
    LEFT JOIN products_dim p ON s.product_key = p.product_key
    GROUP BY category
    ORDER BY total_sales DESC) AS subquery;

    --calculate the total sales from each gender and the percentage of total sales

SELECT
    gender,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') AS sales_percentage
FROM (
    SELECT
        gender,
        SUM(sales_amount) AS total_sales
    FROM sales_facts s 
    LEFT JOIN customers_dim c ON s.customer_key = c.customer_key
    GROUP BY gender
    ORDER BY total_sales DESC) AS subquery;

    --count the total number of orders for each product category and the percentage of total orders that each category represents

SELECT
    category,
    total_orders,
    SUM(total_orders) OVER() AS overall_total_orders,
    CONCAT(ROUND((total_orders / SUM(total_orders) OVER()) * 100, 2), '%') AS orders_percentage
FROM (
    SELECT
        category,
        COUNT(order_number) AS total_orders
    FROM sales_facts s 
    LEFT JOIN products_dim p ON s.product_key = p.product_key
    GROUP BY category
    ORDER BY total_orders DESC) AS subquery;

    --count the total number of orders from each gender and the percentage of total orders
SELECT
    gender,
    total_orders,
    SUM(total_orders) OVER() AS overall_total_orders,
    CONCAT(ROUND(total_orders / SUM(total_orders) OVER() * 100, 2), '%') AS orders_percentage
FROM (
SELECT
    gender,
    COUNT(order_number) AS total_orders
FROM sales_facts s  
LEFT JOIN customers_dim c ON s.customer_key = c.customer_key
GROUP BY gender
ORDER BY total_orders DESC) AS subquery;

