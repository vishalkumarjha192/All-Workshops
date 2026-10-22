SELECT category, SUM(revenue) AS total_sales, COUNT(*) AS total_orders, SUM(quantity) AS units_sold FROM retail_sales GROUP BY category ORDER BY total_sales DESC;
