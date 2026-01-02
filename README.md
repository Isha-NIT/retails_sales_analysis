# Retail Sales Analysis

## Project Overview
This project performs a comprehensive **retail sales analysis** using SQL on transactional data. The goal is to extract actionable insights regarding **sales trends, customer behavior, product performance, and profitability**.

Key objectives:
- Clean and validate raw retail sales data
- Analyze revenue and sales trends by category, time, and customer demographics
- Identify high-value customers and transactions
- Perform advanced customer segmentation (RFM analysis)
- Evaluate profitability and profit margins by product category
- Measure sales growth over time

## Key Insights & Business Impact

- While the category *Electronics* generates the most revenue, category *Beauty* achieves the highest profit margins, emphasizing the need for category-specific strategies.
- Peak sales occur between **7 PM – 8 PM**, suggesting this time window requires optimal staffing, inventory availability, and targeted promotional campaigns.
- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 10,000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.


## Dataset Description
The dataset contains transactional retail sales data:

| Column           | Type       | Description |
|-----------------|-----------|-------------|
| transaction_id   | INT       | Unique ID for each transaction |
| sale_date        | DATE      | Date of the transaction |
| sale_time        | TIME      | Time of the transaction |
| customer_id      | INT       | Unique customer identifier |
| gender           | VARCHAR   | Customer gender |
| age              | INT       | Customer age |
| category         | VARCHAR   | Product category |
| quantity         | INT       | Number of items purchased |
| price_per_unit   | NUMERIC   | Price per item |
| cogs             | NUMERIC   | Cost of goods sold |
| total_sale       | NUMERIC   | Total transaction value |



## Project Workflow

### 1. Database & Table Creation

- **Database Creation**: The project starts by creating a database named `retail_sales_analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS) per transaction , and total sale amount.
  ( Currency values are assumed to be in INR.)


### 2. Data Exploration & Cleaning

- Verified total record count and unique customer count
- Identified all unique product categories
- Checked for null values across all columns and removed incomplete records
- Validated data integrity by checking for duplicate transactions


### 3. Basic Analysis

In this section, we performed a **basic analysis** of the retail sales dataset to understand overall sales trends, customer behavior, and transaction patterns. The key analyses conducted include:

- **Total Revenue & Average Order Value:** Calculated the overall revenue and the average value of transactions to assess business performance.  
- **Revenue by Category:** Identified which product categories contributed most to sales.  
- **Sales by Customer Demographics:** Analyzed transactions and revenue by gender to understand customer behavior.  
- **Monthly Sales Trends:** Studied revenue patterns over time to identify seasonal trends.  
- **Peak Sales Hours:** Determined the hours of the day with the highest sales activity.  
- **Top Customers & High-Value Transactions:** Identified the top-spending customers and categorized transactions into high, medium, and low value.  

These insights provided a foundational understanding of the business performance and customer behavior, serving as a basis for more advanced analyses like profitability and customer segmentation.


## 4. Advanced Customer Insights

This section delves deeper into **customer behavior and value** to inform business strategy:

- **Customers Above Average Spend:** Identified customers whose total spending exceeds the average, highlighting high-value customers.  
- **RFM Analysis (Recency, Frequency, Monetary):** Evaluated customers based on the recency of their last purchase, frequency of transactions, and total monetary value, enabling segmentation of loyal, frequent, and high-value customers.  
- **Customer Segmentation:** Insights from RFM and spending behavior help target marketing campaigns, loyalty programs, and personalized promotions.  


## 5. Profit Analysis

This section assesses **profitability at the product category level**:

- **Profit by Category:** Calculated total profit and profit margin percentage for each product category, identifying the most profitable product lines.  
- **Profit Insights:** Helps in inventory planning, pricing strategies, and prioritizing high-margin products.
- 

## 6. Sales Growth Analysis

This section evaluates **revenue trends over time** to understand business growth:

- **Month-over-Month Revenue Growth:** Measured the percentage change in revenue compared to the previous month, revealing periods of growth or decline.  
- **Revenue Trend Insights:** Helps identify seasonal patterns, assess the impact of marketing campaigns, and make informed business decisions for future growth.


## Key Queries

1. Total Revenue
```
SELECT SUM(total_sale) AS total_revenue
FROM retail_sales;
```
2.  Revenue by Category
```
SELECT category,
       SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY category
ORDER BY revenue DESC;
```
3. Monthly sales trend
```
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
```
4. Top customers
```
SELECT customer_id,
       SUM(total_sale) AS total_spent,
       DENSE_RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY customer_id;
```
5. High-Value Transactions
```
SELECT transaction_id,
       total_sale,
       CASE
           WHEN total_sale >= 2000 THEN 'High Value'
           WHEN total_sale >= 1000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS order_type
FROM retail_sales;
```
6. RFM Analysis
```
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
```
7. Profit Margin by category
```
SELECT category,
       SUM(total_sale - cogs) AS profit,
       ROUND(SUM(total_sale - cogs)/SUM(total_sale)*100, 2) AS profit_margin_percent
FROM retail_sales
GROUP BY category
ORDER BY profit_margin_percent DESC;
```


## Tools & Skills Demonstrated
- Database: PostgreSQL
- Query Language: SQL
- Advanced SQL (CTEs, Window Functions, CASE statements)
- Customer segmentation using RFM analysis
- Revenue, profitability, and growth analysis
- Business-focused data interpretation


## Future Improvements

- Implement full RFM scoring (1–5) for more granular customer segmentation
- Create views or materialized views for commonly used metrics
- Visualize insights using Power BI or Tableau
- Automate monthly revenue and growth reporting


## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to create the database and perform your analysis.
6. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Isha K S

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
