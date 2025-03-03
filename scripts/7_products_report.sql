DROP VIEW IF EXISTS products_report;
CREATE VIEW products_report AS(
WITH base_query AS (
    SELECT 
        p.product_id,
        p.product_number,
        p.product_name,
        p.category,
        cost,
        s.customer_key,
        s.order_number,
        s.order_date,
        s.quantity,
        s.sales_amount
    FROM sales_facts s
    LEFT JOIN products_dim p ON s.product_key = p.product_key
    WHERE order_date IS NOT NULL
),
products_aggregate AS (
    SELECT 
        product_id,
        product_number,
        product_name,
        category,
        SUM(cost) AS total_cost,
        COUNT(DISTINCT customer_key) AS total_customers,
        COUNT(DISTINCT order_number) AS total_orders,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date)))* 12 + 
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date)))  AS months_active,
        SUM(quantity) AS total_quantity,
        SUM(sales_amount) AS total_sales,
        SUM(sales_amount)- SUM(cost) AS total_profit
    FROM base_query
    GROUP BY 1, 2, 3, 4
)
    SELECT
        product_id,
        product_number,
        product_name,
        category,
        total_cost,
        total_sales,
        total_profit,
        CASE 
            WHEN total_profit >200000 THEN 'High Perfomarnce'
            WHEN total_profit >50000 THEN 'Medium Perfomarnce'
            ELSE 'Low Perfomarnce'
        END AS product_performance,
        total_customers,
        total_orders,
        total_quantity,
        CASE 
            WHEN total_orders = 0 THEN 0
            ELSE ROUND(total_sales/total_orders, 0) 
        END AS avg_order_value,
        CASE 
            WHEN months_active = 0 THEN total_sales
            ELSE ROUND(total_sales/months_active, 0)
        END AS avg_monthly_sales
    FROM products_aggregate
);
