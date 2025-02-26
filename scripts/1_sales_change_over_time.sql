--sales performance over time analysis

   --yearly sales performance
SELECT
    EXTRACT(year FROM order_date) AS year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales_facts
WHERE order_date IS NOT NULL
GROUP BY year
ORDER BY year;

    --quarterly sales performance
    SELECT
        EXTRACT(year FROM order_date) AS year,
        CONCAT('Q',EXTRACT(quarter FROM order_date)) AS quarter_start,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(quantity) AS total_quantity
    FROM sales_facts
    WHERE order_date IS NOT NULL
    GROUP BY year, quarter_start
    ORDER BY year, quarter_start;

   --monthly sales performance

SELECT
    to_char(order_date, 'Mon') AS months,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales_facts
WHERE order_date IS NOT NULL
GROUP BY months
ORDER BY months;
            --OR
SELECT
    to_char(order_date, 'yyyy-MM') AS order_date1,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales_facts
WHERE order_date IS NOT NULL
GROUP BY order_date1
ORDER BY order_date1;  