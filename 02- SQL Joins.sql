-- Display all the data from the accounts table and all their orders details from the orders table

SELECT 
    a.*, o.*
FROM
    accounts a
        JOIN
    orders o ON a.id = o.accounts_id;


-- Display standard_qty, gloss_qty, and poster_qty from the orders table, and the corresponding website and primary_poc from the accounts table

SELECT 
    o.standard_qty,
    o.gloss_qty,
    o.poster_qty,
    a.website,
    a.primary_poc
FROM
    orders o
        JOIN
    accounts a ON o.account_id = a.id


/* Display all web_events associated with account name of Walmart. include the primary_poc, occurred_at columns from the web_events table,
   and name, channel columns from the accounts table */
   
SELECT 
    a.name, a.primary_poc, w.occurred_at, w.channel
FROM
    accounts a
        JOIN
    web_events w ON a.id = w.account_id
WHERE
    a.name = 'Walmart';


/* Display the region name for each sales rep, the name of the sales rep and their associated accounts,
   Sort the results alphabetically by account name */
   
SELECT 
    r.name AS region_name,
    s.name AS sales_rep_name,
    a.name AS account_name
FROM
    region r
        JOIN
    sales_reps s ON r.id = s.region_id
        JOIN
    accounts a ON a.sales_rep_id = s.id
ORDER BY account_name;


-- For each order display the order id, the name of the account and region associated with it as well as calculating the unit price for the order

SELECT 
    o.id AS order_id,
    r.name AS region_name,
    a.name AS account_name,
    (total_amt_usd / total) AS unit_price
FROM
    orders o
        JOIN
    accounts a ON o.account_id = a.id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
        JOIN
    region r ON r.id = s.region_id
WHERE
    (total_amt_usd / total) IS NOT NULL;
-- Note that the region table is not directly related to either the orders table or the accounts table, that's why we joined the sales_rep table to link them.
-- We added NOT NULL condition to the unit_price because some orders have 0 values in both total_amt_usd and total columns


/* For each order display the order id, the name of the account and region associated with it as well as calculating the unit price for the order, 
   only show results if the standard order quantity exceeds 100 */
   
SELECT 
    o.id AS order_id,
    r.name AS region_name,
    a.name AS account_name,
    (total_amt_usd / total) AS unit_price
FROM
    orders o
        JOIN
    accounts a ON o.account_id = a.id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
        JOIN
    region r ON r.id = s.region_id
WHERE
    (total_amt_usd / total) IS NOT NULL
        AND standard_qty > 100;


/* For each order display the order id, the name of the account and region associated with it as well as calculating the unit price for the order, 
   only show results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50, Sort the smallest unit price first */
   
SELECT 
    o.id AS order_id,
    r.name AS region_name,
    a.name AS account_name,
    ROUND((total_amt_usd / total),2) AS unit_price
FROM
    orders o
        JOIN
    accounts a ON o.account_id = a.id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
        JOIN
    region r ON r.id = s.region_id
WHERE
    (total_amt_usd / total) IS NOT NULL
        AND standard_qty > 100
        AND poster_qty > 50
ORDER BY unit_price;


/* Display the names of the sales reps in the 'Midwest' region and their associated accounts,
   Sort the results alphabetically by account name */
   
SELECT 
    r.name AS region_name,
    s.name AS sales_rep_name,
    a.name AS account_name
FROM
    region r
        JOIN
    sales_reps s ON r.id = s.region_id
        JOIN
    accounts a ON a.sales_rep_id = s.id
WHERE
    r.name = 'Midwest'
ORDER BY account_name;


/* Display the names of the sales reps whose first name starts with the letter 'S' in the 'Midwest' region and their associated accounts
   Sort the results alphabetically by account name */
   
SELECT 
    r.name AS region_name,
    s.name AS sales_rep_name,
    a.name AS account_name
FROM
    region r
        JOIN
    sales_reps s ON r.id = s.region_id
        JOIN
    accounts a ON a.sales_rep_id = s.id
WHERE
    r.name = 'Midwest' AND s.name LIKE 's%'
ORDER BY account_name;


/* Display the names of the sales reps whose last name starts with the letter 'K' in the 'Midwest' region and their associated accounts
   Sort the results alphabetically by account name */
   
SELECT 
    r.name AS region_name,
    s.name AS sales_rep_name,
    a.name AS account_name
FROM
    region r
        JOIN
    sales_reps s ON r.id = s.region_id
        JOIN
    accounts a ON a.sales_rep_id = s.id
WHERE
    r.name = 'Midwest' AND s.name LIKE '% k%'
ORDER BY account_name;


-- Display the account name and the different channels used by it, for the account whose id is 1001

SELECT DISTINCT
    a.name, w.channel
FROM
    accounts a
        JOIN
    web_events w ON a.id = w.account_id
WHERE
    a.id = 1001;


-- Display all the orders that occurred in 2015. Include the occurred_at, name, total, and total_amt_usd columns, sort the latest orders first

SELECT 
    o.occurred_at,
    a.name AS account_name,
    total AS total_quantity,
    total_amt_usd AS total_amount
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
WHERE
    YEAR(occurred_at) = 2015
ORDER BY occurred_at DESC;
