

    /*Analyze the product performance by comparing the yearly sales of each product with the 
      average of current year sales of the product and by comparing the yearly sales of each 
      product with the sales of the product in the previous year */

WITH yearly_product_sales AS (
    SELECT
        EXTRACT(year FROM s.order_date) AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM sales_facts s
    JOIN products_dim p ON s.product_key = p.product_key
    GROUP BY order_year, p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) AS avg_sales,
    current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) AS sales_diff,
    CASE 
        WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) > 0 THEN 'Above AVG'
        WHEN current_sales - ROUND(AVG(current_sales) OVER (PARTITION BY product_name), 0) < 0 THEN  'Below AVG'
        ELSE 'AVG'
    END AS avg_change,

        --year over year analysis

        LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name) AS current_previous_sales_diff,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name) < 0 THEN  'Decrease'
        ELSE 'No Change'
    END AS sales_change
FROM yearly_product_sales;

