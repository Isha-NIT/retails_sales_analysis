-- SQL Retail Sales Analysis 

-- 1. DATABASE CREATION
CREATE DATABASE retail_sa;


-- 2. TABLE CREATION
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit NUMERIC(10,2),
    cogs NUMERIC(10,2),
    total_sale NUMERIC(10,2)
);


-- 2.1 Table Visualization
SELECT * FROM retail_sales;



-- 3. DATA EXPLORATION & CLEANING

-- 3.1 Total records
SELECT COUNT(*) as total_sale FROM retail_sales;

-- 3.2 Unique customers
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- 3.3 Categories
SELECT DISTINCT category FROM retail_sales;

-- 3.4 Check for NULLs
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

	
-- 3.5 Delete NULL records
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


-- 3.6 Check for duplicates
SELECT transaction_id, COUNT(*)
FROM retail_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;



-- 4. BASIC ANALYSIS

-- 4.1 Total Revenue
SELECT SUM(total_sale) AS total_revenue
FROM retail_sales;


-- 4.2 Revenue by Category
SELECT category,
       SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY category
ORDER BY revenue DESC;


-- 4.3 Average Order Value 
SELECT ROUND(AVG(total_sale), 2) AS avg_order_value
FROM retail_sales;


-- 4.4 Sales by Gender
SELECT gender,
       COUNT(*) AS transactions,
       SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY gender;


-- 4.5 Monthly Sales Trend
SELECT TO_CHAR(month, 'Mon YYYY') AS month,
       monthly_revenue
FROM (
    SELECT DATE_TRUNC('month', sale_date) AS month,
           SUM(total_sale) AS monthly_revenue
    FROM retail_sales
    GROUP BY month
) t
ORDER BY
    EXTRACT(YEAR FROM month),
    EXTRACT(MONTH FROM month);


-- 4.6 Peak Sales Hour
SELECT
    CONCAT(hour, ':00 - ', (hour + 1) % 24, ':00') AS time_slot,
    revenue
FROM (
    SELECT
        EXTRACT(HOUR FROM sale_time) AS hour,
        SUM(total_sale) AS revenue
    FROM retail_sales
    GROUP BY hour
) t
ORDER BY revenue DESC;


-- 4.7 Top Customers
SELECT customer_id,
       SUM(total_sale) AS total_spent,
       DENSE_RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY customer_id;


-- 4.8 High Value Transactions
SELECT transaction_id,
       total_sale,
       CASE
           WHEN total_sale >= 2000 THEN 'High Value'
           WHEN total_sale >= 1000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS order_type
FROM retail_sales;



-- 5. ADVANCED CUSTOMER INSIGHTS

-- 5.1 Customers Above Average Spend
WITH customer_totals AS (
    SELECT customer_id, SUM(total_sale) AS total_spent
    FROM retail_sales
    GROUP BY customer_id
)
SELECT *
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
ORDER BY total_spent DESC;


-- 5.2 RFM (Recency, Frequency, Monetary) Analysis
WITH customer_metrics AS (
    SELECT 
        customer_id,
        MAX(sale_date) AS last_purchase,
        COUNT(transaction_id) AS frequency,
        SUM(total_sale) AS monetary
    FROM retail_sales
    GROUP BY customer_id
)
SELECT *,
    CURRENT_DATE - last_purchase AS recency
FROM customer_metrics
ORDER BY monetary DESC;



-- 6. PROFIT ANALYSIS

-- 6.1 Profit by Category
SELECT category,
       SUM(total_sale - cogs) AS profit,
       ROUND(SUM(total_sale - cogs)/SUM(total_sale)*100, 2) AS profit_margin_percent
FROM retail_sales
GROUP BY category
ORDER BY profit_margin_percent DESC;



-- 7. SALES GROWTH ANALYSIS

-- 7.1 Month-over-Month Revenue Growth %
WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', sale_date) AS month,
           SUM(total_sale) AS monthly_revenue
    FROM retail_sales
    GROUP BY month
)
SELECT TO_CHAR(month, 'Mon YYYY') AS month,
       monthly_revenue,
       LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
             / LAG(monthly_revenue) OVER (ORDER BY month)) * 100, 2) AS mom_growth_percent
FROM monthly_sales
ORDER BY
    EXTRACT(YEAR FROM month),
    EXTRACT(MONTH FROM month);











