CREATE VIEW customers_report AS(
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(first_name, ' ', last_name)AS customer_name,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.birthdate)) AS age
    FROM sales_facts f 
    LEFT JOIN customers_dim c ON f.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
),
customer_aggregations AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS order_count,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS months_active
    FROM base_query
    GROUP BY 1, 2, 3, 4
)

    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        CASE 
            WHEN age < 30 THEN 'Young'
            WHEN age BETWEEN 30 AND 50 THEN 'Middle'
            ELSE 'Old'
        END AS age_group,
        CASE 
            WHEN total_sales >5000 AND months_active > 12 THEN 'VIP'
            WHEN total_sales <5000 AND months_active > 12 THEN 'Regular'
            ELSE 'New'
        END AS customer_group,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_order_date))* 12+ 
        EXTRACT(month FROM AGE(CURRENT_DATE, last_order_date)) AS recency_months,
        order_count,
        total_sales,
        total_quantity,
        total_products,
        months_active,
        --Calaulate average order value
        ROUND(total_sales/order_count, 0) AS avg_order_value,
        --Calculate average monthly spend
        CASE 
            WHEN months_active = 0 THEN ROUND(total_sales ,0)
            ELSE ROUND(total_sales/months_active, 0)
        END AS avg_sales_per_month
    FROM customer_aggregations
);