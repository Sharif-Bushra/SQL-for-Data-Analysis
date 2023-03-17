-- Display the total quantity of poster paper ordered in the orders table

SELECT 
    SUM(poster_qty) AS poster_total_qty
FROM
    orders;


-- Display the total quantity of standard paper ordered in the orders table

SELECT 
    SUM(standard_qty) AS standard_total_qty
FROM
    orders;


-- Display the total dollar amount of sales in the orders table

SELECT 
    SUM(total_amt_usd) AS total_sales_amount
FROM
    orders;


-- Display the order id, the total amount spent on standard and gloss paper for each order in the orders table  

SELECT 
    id,
    (standard_amt_usd + gloss_amt_usd) AS standard_gloss_amount
FROM
    orders;


-- Display the unit price for the standard paper in the orders table

SELECT 
    SUM(standard_amt_usd) / SUM(standard_qty) AS standard_unit_price
FROM
    orders;


-- Display the order id and the date it was placed on for the earliest order in the orders table 

SELECT 
    id, MIN(occurred_at)
FROM
    orders;

-- Below query gives the same results as above query without using an aggregation function

SELECT 
    id, occurred_at
FROM
    orders
ORDER BY occurred_at
LIMIT 1;


-- Display the id of the most recent web_event and when it occurred

SELECT 
    id, MAX(occurred_at)
FROM
    web_events;

-- Below query gives the same results as above query without using an aggregation function

SELECT 
    occurred_at
FROM
    web_events
ORDER BY occurred_at DESC
LIMIT 1;


-- Display the average amount and the average quantity per order for each of the paper types 

SELECT 
    AVG(standard_qty) AS avg_standard_qty,
    AVG(gloss_qty) AS avg_gloss_qty,
    AVG(poster_qty) AS avg_poster_qty,
    AVG(standard_amt_usd) AS avg_standard_amt_usd,
    AVG(gloss_amt_usd) AS avg_gloss_amt_usd,
    AVG(poster_amt_usd) AS avg_poster_amt_usd
FROM
    orders;


-- Display the account name which placed the earliest order and the date of that order.

SELECT 
    a.name, o.occurred_at
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
ORDER BY 2
LIMIT 1;


-- Display the account name and the total sales in usd for each account, sort the highest sales first

SELECT 
    a.name, SUM(o.total_amt_usd) AS total_sales
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY name
ORDER BY total_sales DESC;


-- For the most recent web_event display when did it occur, via which channel and the account name that was associated with it

SELECT 
    w.occurred_at, w.channel, a.name AS account_name
FROM
    web_events w
        JOIN
    accounts a ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;


-- Display all the channels and the total number of times each channel type was used from the web_events, sort the highest used channel first

SELECT 
    channel, COUNT(*) AS times_channel_used
FROM
    web_events
GROUP BY channel
ORDER BY times_channel_used DESC;


-- Display the sales rep name associated with the earliest web_event, and also display when did it occur

SELECT 
    w.occurred_at, s.name AS sales_rep_name
FROM
    web_events w
        JOIN
    accounts a ON a.id = w.account_id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
ORDER BY occurred_at
LIMIT 1;
-- Note that the web_events and the sales_reps tables are not directly related, that's why we used accounts table to link them


SELECT 
    w.occurred_at, a.primary_poc
FROM
    web_events w
        JOIN
    accounts a ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;


-- For each account, display the account name and the smallest order in terms of total usd, sort smallest to largest amounts

SELECT 
    a.name, MIN(total_amt_usd) AS smallest_order_amount
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order_amount;


-- Display the number of sales reps in each region along with the region name, sort from lowest number of reps to highest

SELECT 
    r.name AS region_name, COUNT(*) AS number_of_sales_reps
FROM
    region r
        JOIN
    sales_reps s ON r.id = s.region_id
GROUP BY region_name
ORDER BY number_of_sales_reps;


-- For each account display the account name, the average quantity of each type of paper they purchased across their orders. 

SELECT 
    a.name AS account_name,
    AVG(standard_qty) AS avg_standard_qty,
    AVG(gloss_qty) AS avg_gloss_qty,
    AVG(poster_qty) AS avg_poster_qty
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
GROUP BY account_name
ORDER BY account_name;


/* Display the sales rep name, channel and the number of times the channel was used in the web_events table for each sales rep, 
   sort the results from the highest number of usage */

SELECT 
    s.name AS sales_rep_name,
    w.channel,
    COUNT(*) AS number_of_channel_usage
FROM
    web_events w
        JOIN
    accounts a ON a.id = w.account_id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY sales_rep_name , channel
ORDER BY number_of_channel_usage DESC;
-- Note that the web_events and the sales_reps tables are not directly related, that's why we used accounts table to link them


-- Display the sales rep id, name and the number of accounts the sales rep worked on, sort from highest number of accounts

SELECT 
    s.id, s.name, COUNT(*) number_of_accounts
FROM
    accounts a
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY number_of_accounts DESC;


/* Display the sales rep id, name and the number of accounts the sales rep worked on, only for sales reps who worked on more than 5 accounts, 
sort from highest number of accounts */

SELECT 
    s.id, s.name, COUNT(*) number_of_accounts
FROM
    accounts a
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY 1
HAVING COUNT(s.name) > 5
ORDER BY number_of_accounts DESC;



-- Display the name of the account that has the most number of orders

SELECT 
    a.name AS account_name, COUNT(*) AS number_of_orders
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY number_of_orders DESC
LIMIT 1;


-- Display the name of the account that has spent more than 30,000 usd total across all orders, sort from highest total amount

SELECT 
    a.name AS account_name, SUM(total_amt_usd) AS total_amount
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
HAVING total_amount > 30000
ORDER BY total_amount DESC;


-- Display the name of the account that has spent the least total amount of dollars in orders 

SELECT 
    a.name AS account_name, SUM(total_amt_usd) AS total_amount
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY total_amount
LIMIT 1;


-- Display the account name that used facebook channel the most, include channel name and number of times used 
   
SELECT 
    a.name AS account_name, w.channel, COUNT(*) AS total_usage
FROM
    web_events w
        JOIN
    accounts a ON a.id = w.account_id
WHERE
    channel = 'facebook'
GROUP BY account_name , channel
ORDER BY total_usage DESC
LIMIT 1;


-- Display the most used channel and the total usage

SELECT 
    channel, COUNT(*) AS total_usage
FROM
    web_events
GROUP BY channel
ORDER BY total_usage DESC
LIMIT 1;


-- Display the sales in terms of total dollars for all orders in each year, sort from greatest to least

SELECT 
    YEAR(occurred_at) AS sales_year,
    SUM(total_amt_usd) AS yearly_total_sales
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;
-- looking at the yearly totals, we notice that 2013 and 2017 have much smaller totals than all other years,
-- Which is due to missing data as both years have data available for only one month  


-- Display the sales in terms of total dollars for all orders in each month, sort from greatest to least

SELECT 
    MONTH(occurred_at) AS sales_month,
    SUM(total_amt_usd) AS monthly_total_sales
FROM
    orders
WHERE
    YEAR(occurred_at) IN (2014 , 2015, 2016)
GROUP BY 1
ORDER BY 2 DESC;
-- Excluded the partial data for 2013 and 2017
-- The greatest sales amounts occur in December


-- Display the year-month in which Walmart spent the most on gloss paper in terms of dollars, include the total amount

SELECT 
    CONCAT(YEAR(occurred_at),
            '-',
            MONTH(occurred_at)) AS month_year, -- DATE_FORMAT(occurred_at,'%Y-%m') is simpler
    SUM(gloss_amt_usd) AS total_gloss_amt
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
WHERE
    a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


/* Display the account_id, total_amt_usd, occurred_at
   and include a column that returns 'Large' if the order is $3000 or more, or returns 'Small' if the order is smaller than $3000 */
   
SELECT 
    account_id,
    total_amt_usd,
    occurred_at,
    (CASE
        WHEN total_amt_usd >= 3000 THEN 'Large'
        ELSE 'Small'
    END) AS order_size
FROM
    orders;


/* Display the number of orders in each of three categories, based on the total number of items in each order, 
   the three categories are: 'Greater than 2000', 'Between 1000 and 2000' and 'Less than 1000' */
   
SELECT 
    (CASE
        WHEN total > 2000 THEN 'Greater than 2000'
        WHEN total >= 1000 AND total <= 2000 THEN 'Between 1000 and 2000'
        ELSE 'Less than 1000'
    END) AS order_category,
    COUNT(*) AS number_of_orders
FROM
    orders
GROUP BY 1;



/* Display the account name, total_amt_usd for all the orders associated with this account
   and include a column that returns 'Top' if the total orders amount is greater than $200,000,
   or returns 'Middle' if the total orders amount is between $100,000 and $200,000 more,
   or returns 'Low' if the total orders amount is less than $100,000,
   sort with the top spending customers listed first */

SELECT 
    a.name AS account_name,
    SUM(total_amt_usd) AS total_sales_for_account,
    (CASE
        WHEN SUM(total_amt_usd) > 200000 THEN 'Top'
        WHEN
            SUM(total_amt_usd) >= 100000
                AND SUM(total_amt_usd) <= 200000
        THEN
            'Middle'
        ELSE 'Low'
    END) AS customer_level
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY total_sales_for_account DESC;


/* Display the sales rep name, total number of orders,
   include a column that returns 'Top' if the sales rep has more than 200 orders, or returns 'Normal' otherwise,
   sort the sales reps with the highest number of orders first */

SELECT 
    sales_reps.name,
    COUNT(*) AS total_number_of_orders,
    (CASE
        WHEN COUNT(*) > 200 THEN 'Top'
        ELSE 'normal'
    END) AS sales_rep_performance_level
FROM
    orders
        JOIN
    accounts ON accounts.id = orders.account_id
        JOIN
    sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY 1
ORDER BY 2 DESC;


/* Display the sales rep name, total number of orders, total sales across all orders
   include a column that returns 'Top' if the sales rep has more than 200 orders or has total sales greater than $750,000,
   or returns 'Middle' if the sales rep has more than 150 orders or has total sales greater than $5000,000,
   or returns 'Normal' otherwise,
   sort the sales reps with the highest total sales first */
   
SELECT 
    s.name,
    COUNT(*) AS total_number_of_orders,
    SUM(total_amt_usd) AS total_sales,
    (CASE
        WHEN
            COUNT(*) > 200
                OR SUM(total_amt_usd) > 750000
        THEN
            'top'
        WHEN
            COUNT(*) > 150
                OR SUM(total_amt_usd) > 500000
        THEN
            'middle'
        ELSE 'low'
    END) AS sales_rep_level
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY total_sales DESC;
