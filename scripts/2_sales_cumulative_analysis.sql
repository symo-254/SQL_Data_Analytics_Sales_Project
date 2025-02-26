    --calculate the total sales and cumulative sales for each month

SELECT
    date_of_order,
    total_sales,
    SUM(total_sales) OVER(ORDER BY date_of_order) AS cumulative_sales
FROM (
    SELECT
        DATE_TRUNC('month', order_date) ::DATE AS date_of_order,
        SUM(sales_amount) AS total_sales
    FROM sales_facts
    WHERE order_date IS NOT NULL
    GROUP BY date_of_order
    ORDER BY  date_of_order) AS subquery; 

    --calculate the total sales  cumulative sales and the moving average of price for each month partition by year

SELECT
    date_of_order,
    total_sales,
    SUM(total_sales) OVER w AS cumulative_sales,
    ROUND(AVG(avg_price) OVER w,0) AS moving_average_price
FROM (
    SELECT
        DATE_TRUNC('month', order_date) ::DATE AS date_of_order,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM sales_facts
    WHERE order_date IS NOT NULL
    GROUP BY date_of_order
    ORDER BY  date_of_order) AS subquery
WINDOW w AS (PARTITION BY EXTRACT(year FROM date_of_order) ORDER BY date_of_order);

    --calculate the total sales and cumulative sales and the moving average of price for each year

SELECT
    date_of_order,
    total_sales,
    SUM(total_sales) OVER(ORDER BY date_of_order) AS cumulative_sales,
    ROUND(AVG(avg_price) OVER(ORDER BY date_of_order),0) AS moving_average_price
FROM (
    SELECT
        DATE_TRUNC('year', order_date) ::DATE AS date_of_order,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM sales_facts
    WHERE order_date IS NOT NULL
    GROUP BY date_of_order
    ORDER BY  date_of_order) AS subquery; 