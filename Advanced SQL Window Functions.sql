-- Display the order time, standard_amt_usd and a running total of standard_amt_usd over order time

SELECT 
    occurred_at, standard_amt_usd,
    SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM
    orders
ORDER BY 1;


/* Display the account name, order time 'occurred_at', order month, and a monthly running total for the total_amt_usd,
	For the account with the id 3411 */
    
SELECT 
    a.name, o.occurred_at, MONTH(occurred_at),
    SUM(o.total_amt_usd) OVER (PARTITION BY MONTH(o.occurred_at) ORDER BY o.occurred_at) AS running_total
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
WHERE
    a.id = 3411
ORDER BY 2;


/* Display the order id, account_id, and total_amt_usd columns from the orders table, 
	then add a column that ranks the total_amt_usd from highest for each account */
    
SELECT 
    id, account_id, total_amt_usd,
    RANK() OVER (PARTITION BY account_id ORDER BY total_amt_usd DESC) AS total_rank
FROM
    orders;

/* Display the order id, account_id, total_amt_usd, month,
	include a column that shows a running counter for each account orders per month,
	also include columns that shows the sum, count, avg, min and max total_amt_usd for each account orders per month */
 
SELECT 
    id,
    account_id,
    total_amt_usd,
    MONTH(occurred_at) AS month,
    ROW_NUMBER() OVER main_window AS account_monthly_counter,
    SUM(total_amt_usd) OVER main_window AS account_monthly_sum,
    COUNT(total_amt_usd) OVER main_window AS account_monthly_count,
    AVG(total_amt_usd) OVER main_window AS account_monthly_avg,
    MIN(total_amt_usd) OVER main_window AS account_monthly_min,
    MAX(total_amt_usd) OVER main_window AS account_monthly_max
FROM
    orders
WINDOW main_window AS (PARTITION BY account_id,MONTH(occurred_at) ORDER BY MONTH(occurred_at));

	 
	 
-- For each month display monthly total sales, the previous month sales and the difference

SELECT
	month,
	total_amt_usd AS current_month_total,
	LAG(total_amt_usd) OVER (ORDER BY month) AS previous_month_total,
	total_amt_usd - LAG(total_amt_usd) OVER (ORDER BY month) AS difference
FROM
	(SELECT
		DATE_FORMAT(occurred_at,'%Y-%m') AS month,
		SUM(total_amt_usd) AS total_amt_usd
	FROM
		orders 
	GROUP BY 1) sub;
    
    
-- Display the account id, name, its most frequenet used channel and the number of times channel used

WITH accounts_channels_usage AS
(SELECT 
    a.id AS account_id,
    a.name AS account_name,
    w.channel,
    COUNT(*) AS usage_per_channel,
    RANK() OVER (PARTITION BY a.id ORDER BY COUNT(*) DESC) AS top_channel
FROM
    accounts a
        JOIN
    web_events w ON a.id = w.account_id
GROUP BY 1 , 3)
  
  SELECT 
    account_id,
    account_name,
    channel AS most_used_channel,
    usage_per_channel
FROM
    accounts_channels_usage
WHERE
    top_channel = 1;

 
 -- Display the total sales amount for the top performing sales rep in each region, include sales rep name
 
WITH rep_region_total AS
(SELECT 
	s.name AS rep_name,
    r.name AS region_name,
    SUM(total_amt_usd) AS total_sales_amt,
    RANK() OVER (PARTITION BY r.name ORDER BY SUM(total_amt_usd) DESC) AS top_sales_rep
FROM
    orders o
        JOIN
    accounts a ON o.account_id = a.id
        JOIN
    sales_reps s ON a.sales_rep_id = s.id
        JOIN
    region r ON r.id = s.region_id
GROUP BY 1 , 2)

SELECT 
    rep_name, region_name, total_sales_amt
FROM
    rep_region_total
WHERE
    top_sales_rep = 1
ORDER BY total_sales_amt DESC;


 /* Display the account name, order id, occurred_at, total_amt_usd and the order rank,
	for the highest 10 orders of each account, if the account has less than 10 orders display all orders with rank
    order rank 1 is the highest order for the account */
 
WITH accounts_orders AS
(SELECT 
    a.name AS account_name,
    o.id AS order_id,
    occurred_at,
    total_amt_usd,
    RANK () OVER (PARTITION BY a.name ORDER BY total_amt_usd DESC) AS orders_rank
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id)

SELECT 
    account_name,
    order_id,
    occurred_at,
    total_amt_usd,
    orders_rank
FROM
    accounts_orders
WHERE
    orders_rank BETWEEN 1 AND 10;


/* Display the account name, order id, occurred_at, total_amt_usd, the order rank and the number of orders
	for the highest 50% orders in terms of total_amt_usd of each account
    order rank 1 is the highest order for the account */

WITH accounts_orders AS
(SELECT 
    a.name AS account_name,
    o.id AS order_id,
    occurred_at,
    total_amt_usd,
    NTILE(2) OVER (PARTITION BY a.name ORDER BY total_amt_usd DESC) AS half_of_the_orders
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id)

SELECT 
    account_name,
    order_id,
    occurred_at,
    total_amt_usd,
    RANK () OVER (PARTITION BY account_name ORDER BY total_amt_usd DESC) AS orders_rank,
    COUNT(*) OVER (PARTITION BY account_name) number_of_orders
FROM
    accounts_orders
WHERE
    half_of_the_orders = 1;
