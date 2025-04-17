### Financial Analytics
 
 -- Total rows in sales
 SELECT COUNT(*) AS total_rows FROM gdb0041.fact_sales_monthly;
 
 -- Missing values check
 SELECT 
   COUNT(*) AS total_rows,
   COUNT(product_code) AS non_null_product_id,
   COUNT(customer_code) AS non_null_customer_id,
   COUNT(sold_quantity) AS non_null_sold_quantity
 FROM gdb0041.fact_sales_monthly;
 
 -- a. first grab customer codes for Croma india
 	SELECT * FROM dim_customer WHERE customer like "%croma%" AND market="india";
 
 -- b. Get all the sales transaction data from fact_sales_monthly table for that customer(croma: 90002002) in the fiscal_year 2021
 	SELECT * FROM fact_sales_monthly 
 	WHERE 
             customer_code=90002002 AND
             YEAR(DATE_ADD(date, INTERVAL 4 MONTH))=2021 
 	ORDER BY date asc
 	LIMIT 100000;
 
 -- c. Replacing the function created in the step:b
 	SELECT * FROM fact_sales_monthly 
 	WHERE 
             customer_code=90002002 AND
             get_fiscal_year(date)=2021 
 	ORDER BY date asc
 	LIMIT 100000;
 
 -- d. Perform joins to pull product information
 	SELECT s.date, s.product_code, p.product, p.variant, s.sold_quantity 
 	FROM fact_sales_monthly s
 	JOIN dim_product p
         ON s.product_code=p.product_code
 	WHERE 
             customer_code=90002002 AND 
     	    get_fiscal_year(date)=2021     
 	LIMIT 1000000;
 
 -- e. Performing join with 'fact_gross_price' table with the above query and generating required fields
 	SELECT 
     	    s.date, 
             s.product_code, 
             p.product, 
             p.variant, 
             s.sold_quantity, 
             g.gross_price,
             ROUND(s.sold_quantity*g.gross_price,2) as gross_price_total
 	FROM gdb0041.fact_sales_monthly s
 	JOIN gdb0041.dim_product p
             ON s.product_code=p.product_code
 	JOIN gdb0041.fact_gross_price g
             ON g.fiscal_year=get_fiscal_year(s.date)
     	AND g.product_code=s.product_code
 	WHERE 
     	    customer_code=90002002 AND 
             get_fiscal_year(s.date)=2021     
 	LIMIT 1000000;
     
 -- f. Retrieve market badge. i.e. if total sold quantity > 5 million that market is considered "Gold" else "Silver"
 SELECT 
 	DISTINCT(c.customer), sum(s.sold_quantity) as total_sold_quantity,
     c.market,
     CASE
 		WHEN sum(s.sold_quantity) > 5000000 THEN "Gold"
         ELSE "Silver"
 	END AS market_badge
 FROM gdb0041.dim_customer c
 JOIN gdb0041.fact_sales_monthly s 
 	ON c.customer_code = s.customer_code
 GROUP BY c.customer, c.market;
 
 -- g. Which markets (countries) are most profitable vs least profitable?  Identify which customer markets generate the most/least total profit.
 SELECT 
     c.market,
     ROUND(SUM(s.sold_quantity * g.gross_price), 2) AS total_revenue,
     ROUND(SUM(
         s.sold_quantity * (
             g.gross_price 
             - m.manufacturing_cost 
             - g.gross_price * (f.freight_pct + f.other_cost_pct) / 100
         )
     ), 2) AS total_profit
 FROM gdb0041.fact_sales_monthly s
 JOIN gdb0041.dim_customer c 
     ON s.customer_code = c.customer_code
 JOIN gdb0041.fact_gross_price g 
     ON s.product_code = g.product_code 
     AND s.fiscal_year = g.fiscal_year
 JOIN gdb0041.fact_manufacturing_cost m 
     ON s.product_code = m.product_code 
     AND s.fiscal_year = m.cost_year
 JOIN gdb0041.fact_freight_cost f 
     ON c.market = f.market
 GROUP BY c.market
 ORDER BY total_profit DESC;
 
 -- h. Find SKUs (unique combinations of product + variant) that have low total sales in every market – so they can be considered for discounting or discontinuation.
 SELECT 
     dp.product,
     dp.variant,
     SUM(s.sold_quantity) AS total_units_sold,
     COUNT(DISTINCT c.market) AS markets_covered
 FROM gdb0041.fact_sales_monthly s
 JOIN gdb0041.dim_product dp 
 	ON s.product_code = dp.product_code
 JOIN gdb0041.dim_customer c 
 	ON s.customer_code = c.customer_code
 GROUP BY 
 	dp.product, dp.variant
 HAVING MAX(s.sold_quantity) < 3000000 
 ORDER BY total_units_sold ASC;
 