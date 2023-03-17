-- Display the average number of events for each channel per day, sort from highest to lowest

SELECT 
    channel, AVG(number_of_events) AS average_number_of_events
FROM
    (SELECT 
        DATE(occurred_at) AS date,
            channel,
            COUNT(*) AS number_of_events
    FROM
        web_events
    GROUP BY 1 , 2) AS count_date
GROUP BY 1
ORDER BY 2 DESC;


-- Display the average number of events for each channel per day, sort from highest to lowest, this time using CTEs

WITH events AS
(SELECT 
    DATE(occurred_at) AS date,
    channel,
    COUNT(*) AS events
FROM
    web_events
GROUP BY 1 , 2)
	
SELECT 
    channel, AVG(events) AS average_events
FROM
    events
GROUP BY channel
ORDER BY 2 DESC;


-- Display all order details for orders that happended at the first month in P&P history, sort by occurred_at

SELECT 
    *
FROM
    orders
WHERE
    DATE_FORMAT(occurred_at, '%Y-%m') = (SELECT 
            DATE_FORMAT(MIN(occurred_at), '%Y-%m')
        FROM
            orders)
ORDER BY occurred_at;


-- Display all order details for orders that happended at the first day in P&P history, sort by occurred_at

SELECT 
    *
FROM
    orders
WHERE
    DATE(occurred_at) = (SELECT 
            DATE(MIN(occurred_at))
        FROM
            orders)
ORDER BY occurred_at;


-- Display the average paper quantity and total sales amount that happended at the first month in P&P history

SELECT 
    AVG(standard_qty) AS average_standard_quantity,
    AVG(gloss_qty) AS average_gloss_quantity,
    AVG(poster_qty) AS average_poster_quantity,
    SUM(total_amt_usd) AS total_sales
FROM
    orders
WHERE
    DATE_FORMAT(occurred_at, '%Y-%m') = (SELECT 
            DATE_FORMAT(MIN(occurred_at), '%Y-%m')
        FROM
            orders);
		

-- Display the maximum standard paper quantity ordered by one account

SELECT 
    MAX(total_standard_qty)
FROM
    (SELECT 
        a.id AS account_id,
            SUM(o.standard_qty) AS total_standard_qty
    FROM
        orders o
    JOIN accounts a ON a.id = o.account_id
    GROUP BY 1) account_qty;
	

-- Display the average amount spent in terms of total_amt_usd for the top 10 total spending accounts

SELECT 
    ROUND(AVG(total_spent),2) AS avg_top_ten_accounts
FROM
    (SELECT 
        a.name AS account_name, SUM(o.total_amt_usd) AS total_spent
    FROM
        orders o
    INNER JOIN accounts a ON a.id = o.account_id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10) highest_spending_accounts;
    
    
/* Display the average amount spent in terms of total_amt_usd, including only the companies that 
	spent more per order, on average, than the average of all orders */

SELECT 
    ROUND(AVG(avg_amt),2) AS avg_amtount
FROM
    (SELECT 
        account_id, AVG(total_amt_usd) AS avg_amt
    FROM
        orders
    GROUP BY account_id
    HAVING AVG(total_amt_usd) > (SELECT 
            AVG(total_amt_usd) AS avg_All
        FROM
            orders)) AS above_avg_amt;
    

-- Display how many times each channel was used for the account that spent the most total_amt_usd

SELECT 
    account_id, channel, COUNT(*) AS channel_usage
FROM
    web_events
GROUP BY 1 , 2
HAVING account_id = (SELECT 
        account_id
    FROM
        (SELECT 
            account_id, SUM(total_amt_usd) AS sum_amt
        FROM
            orders
        GROUP BY account_id
        ORDER BY 2 DESC
        LIMIT 1) AS highest_spending_account);

		
-- Display the account id, name, its most frequenet used channel and the number of times channel used

SELECT 
    accounts_channels_usage.id,
    accounts_channels_usage.name,
    accounts_channels_usage.channel,
    accounts_channels_usage.usage_per_channel AS max_usage_times
FROM
    (SELECT 
        accounts.id,
            accounts.name,
            channel,
            COUNT(*) AS usage_per_channel
    FROM
        accounts
    JOIN web_events ON accounts.id = web_events.account_id
    GROUP BY 1 , 2 , 3) accounts_channels_usage
        JOIN
    (
    SELECT 
        accounts_channels_usage_2.id,
            accounts_channels_usage_2.name,
            MAX(usage_per_channel) AS max_channel_count
    FROM
        (SELECT 
        accounts.id,
            accounts.name,
            channel,
            COUNT(*) AS usage_per_channel
    FROM
        accounts
    JOIN web_events ON accounts.id = web_events.account_id
    GROUP BY 1 , 2 , 3) accounts_channels_usage_2
    GROUP BY 1 , 2) account_channel_max 
    ON accounts_channels_usage.id = account_channel_max.id
        AND accounts_channels_usage.usage_per_channel = account_channel_max.max_channel_count
ORDER BY accounts_channels_usage.id;
/* This looks complix but it's not, basically we had to join the table with itself to have 1 column for channel usage count
	and another column for the max channel usage count for the account */
-- This query could be shorter if we used partitioning
-- Below is how to get the same result using CTEs, which makes the query easier to read and understand

WITH accounts_channels_usage AS
(SELECT 
    accounts.id,
    accounts.name,
    channel,
    COUNT(*) AS usage_per_channel
FROM
    accounts
        JOIN
    web_events ON accounts.id = web_events.account_id
GROUP BY 1 , 2 , 3),

accounts_max_usage AS
(SELECT 
    id, name, MAX(usage_per_channel) AS max_usage_times
FROM
    accounts_channels_usage
GROUP BY 1 , 2)

SELECT 
    a1.id,
    a1.name,
    a1.channel,
    a1.usage_per_channel AS max_channel_usage
FROM
    accounts_channels_usage a1
        JOIN
    accounts_max_usage a2 ON a1.id = a2.id
        AND a1.usage_per_channel = a2.max_usage_times
ORDER BY 1;


-- Display the total sales amount for the top performing sales rep in each region

SELECT region_name,	MAX(total_sales_per_rep) AS max_sales_per_rep
FROM
	(SELECT 
    r.name AS region_name,
    s.id AS sales_rep_id,
    s.name AS sales_rep_name,
    SUM(o.total_amt_usd) AS total_sales_per_rep
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
        JOIN
    region r ON r.id = s.region_id
GROUP BY 1 , 2 , 3
ORDER BY 2 , 3) salesrep_region_sales
GROUP BY 1;

-- Display the total sales amount for the top performing sales rep in each region, include sales rep name

SELECT 
    top_sales_rep, region, sales_amtount
FROM
    (SELECT 
        region_name, MAX(total_amt) AS max_amt
    FROM
        (SELECT 
        s.name AS rep_name,
            r.name AS region_name,
            SUM(total_amt_usd) AS total_amt
    FROM
        orders o
    JOIN accounts a ON o.account_id = a.id
    JOIN sales_reps s ON a.sales_rep_id = s.id
    JOIN region r ON r.id = s.region_id
    GROUP BY 1 , 2) AS rep_total
    GROUP BY 1) AS region_max_sales
        JOIN
    (SELECT 
        s.name AS top_sales_rep,
            r.name AS region,
            SUM(total_amt_usd) AS sales_amtount
    FROM
        orders o
    JOIN accounts a ON o.account_id = a.id
    JOIN sales_reps s ON a.sales_rep_id = s.id
    JOIN region r ON r.id = s.region_id
    GROUP BY 1 , 2) AS rep_region_sales ON region_max_sales.region_name = rep_region_sales.region
        AND region_max_sales.max_amt = rep_region_sales.sales_amtount
ORDER BY 3 DESC;

-- Below is how to get the same result using CTEs, which makes the query easier to read and understand

WITH rep_region_sales AS  
(SELECT 
    s.name AS rep_name,
    r.name AS region,
    SUM(total_amt_usd) AS rep_sales
FROM
    orders o
        JOIN
    accounts a ON o.account_id = a.id
        JOIN
    sales_reps s ON a.sales_rep_id = s.id
        JOIN
    region r ON r.id = s.region_id
GROUP BY 1 , 2),

region_max_sales AS
(SELECT 
    region, MAX(rep_sales) AS max_amt
FROM
    rep_region_sales
GROUP BY 1)

SELECT 
    rep_name AS top_sales_rep,
    r1.region,
    rep_sales AS sales_amtount
FROM
    rep_region_sales r1
        JOIN
    region_max_sales r2 ON r1.region = r2.region
        AND r1.rep_sales = r2.max_amt
ORDER BY 3 DESC;


-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed

SELECT 
    largest_sales_region.region_id,
    largest_sales_region.region_name,
    total_number_of_orders
FROM
    (SELECT 
        r.id AS region_id,
            r.name AS region_name,
            SUM(o.total_amt_usd) AS region_total_sales
    FROM
        orders o
    JOIN accounts a ON a.id = o.account_id
    JOIN sales_reps s ON s.id = a.sales_rep_id
    JOIN region r ON r.id = s.region_id
    GROUP BY 1 , 2
    ORDER BY 3 DESC
    LIMIT 1) largest_sales_region
        JOIN
    (SELECT 
        r.id AS region_id,
            r.name AS region_name,
            COUNT(*) AS total_number_of_orders
    FROM
        orders o
    JOIN accounts a ON a.id = o.account_id
    JOIN sales_reps s ON s.id = a.sales_rep_id
    JOIN region r ON r.id = s.region_id
    GROUP BY 1 , 2) region_with_total_orders ON largest_sales_region.region_id = region_with_total_orders.region_id;

-- Another way to get the same results of the above query

SELECT 
    r.id AS region_id,
    r.name AS region_name,
    COUNT(*) total_orders
FROM
    sales_reps s
        JOIN
    accounts a ON a.sales_rep_id = s.id
        JOIN
    orders o ON o.account_id = a.id
        JOIN
    region r ON r.id = s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT 
        MAX(total_amt)
    FROM
        (SELECT 
            r.name region_name, SUM(o.total_amt_usd) total_amt
        FROM
            sales_reps s
        JOIN accounts a ON a.sales_rep_id = s.id
        JOIN orders o ON o.account_id = a.id
        JOIN region r ON r.id = s.region_id
        GROUP BY 1) sub);
