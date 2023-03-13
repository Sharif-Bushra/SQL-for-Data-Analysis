/* Below we will be using BASIC SQL STATEMENTS:
 Such as SELECT, FROM, WHERE, ORDER BY, LIMIT. */

-- Select all columns from the accounts table

SELECT 
    *
FROM
    accounts;
-- There are 351 rows and 7 columns in the accounts table


-- Select all columns from the orders table

SELECT 
    *
FROM
    orders;
-- There are 6,912 rows and 11 columns in the order table


-- Select all columns from the region table

SELECT
    *
FROM
    region;
-- There are 4 rows and 2 columns in the region table


-- Select all columns from the sales_reps table

SELECT
    *
FROM
    sales_reps;
-- There are 50 rows and 3 columns in the sales_reps table


-- Select all columns from the web_events table

SELECT
    *
FROM
    web_events;
-- There are 9,073 rows and 4 columns in the web_events table



-- Select only id, account_id, and occurred_at columns for all orders in the orders table

SELECT 
    id, account_id, occurred_at
FROM
    orders;
    

-- Select the distinct channels in the web_events table

SELECT DISTINCT
    channel
FROM
    web_events;
-- There are 6 distinct channels on the web events table


-- Select only occurred_at, account_id, and channel columns from the web_events table, and limit the output to only the first 15 rows

SELECT 
    occurred_at, account_id, channel
FROM
    web_events
LIMIT 15;


-- Display the 10 earliest orders from the orders table. Include the id, occurred_at, and total_amt_usd columns

SELECT 
    id, occurred_at, total_amt_usd
FROM
    orders
ORDER BY occurred_at
LIMIT 10;
-- note that ORDER BY orders the results in ascending by default, next will use descending order by ading the DESC keyword


-- Display the top 5 orders in terms of largest total_amt_usd from the orders table. Include the id, account_id, and total_amt_usd columns
-- Here we use DESC in the ORDER BY clause

SELECT 
    id, account_id, total_amt_usd
FROM
    orders
ORDER BY total_amt_usd DESC
LIMIT 5;


-- Display all information regarding individuals who were contacted via the channel of organic or adwords from web_events table

SELECT 
    *
FROM
    web_events
WHERE
    channel IN ('organic' , 'adwords');



-- Display the lowest 20 orders in terms of smallest total_amt_usd from the orders table. Include the id, account_id, and total_amt_usd columns

SELECT 
    id, account_id, total_amt_usd
FROM
    orders
ORDER BY total_amt_usd
LIMIT 20;


/* Display the id, account_id, and total_amt_usd columns from the orders table, sorted first by the account ID (in ascending order),
   and then by the total dollar amount (in descending order) */

SELECT 
    id, account_id, total_amt_usd
FROM
    orders
ORDER BY account_id , total_amt_usd DESC;


/* Display the id, account_id, and total_amt_usd columns from the orders table, but this time sorted first by total dollar amount (in descending order),
   and then by account ID (in ascending order) */

SELECT 
    id, account_id, total_amt_usd
FROM
    orders
ORDER BY total_amt_usd DESC , account_id;

-- Notice the difference in the results when you switch the column you sort on first



-- Display the first 5 rows from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000

SELECT 
    *
FROM
    orders
WHERE
    gloss_amt_usd > 1000
LIMIT 5;


-- Display the first 10 rows from the orders table that have a total_amt_usd less than 500

SELECT 
    *
FROM
    orders
WHERE
    total_amt_usd < 500
LIMIT 10;



/* Filter the accounts table to display the company name, website, and the primary point of contact (primary_poc) 
   only for the Exxon Mobil company */

SELECT 
    name, website, primary_poc
FROM
    accounts
WHERE
    name LIKE 'Exxon Mobil';



/* Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for the standard paper 'rounded to 2 decimal places' for each order.
   Limit the results to the first 10 orders from the orders table, and display the id, account_id columns as well */
   
SELECT 
    id,
    account_id,
    ROUND(standard_amt_usd / standard_qty, 2) AS standard_unit_price
FROM
    orders
LIMIT 10;


/* Create a column that calculates the percentage of revenue that comes from poster paper for each order.
   Limit the results to the first 10 orders from the orders table, and display the id, account_id columns as well */
   
SELECT 
    id,
    account_id,
    (poster_amt_usd / total_amt_usd) AS poster_revenue
FROM
    orders
LIMIT 10;


-- Display all the companies from the accounts table whose names start with 'C'

SELECT 
    *
FROM
    accounts
WHERE
    name LIKE 'C%';


-- Display all the companies from the accounts table whose names contain the string 'one' somewhere in the name

SELECT 
    *
FROM
    accounts
WHERE
    name LIKE '%one%';


-- Display all the companies from the accounts table whose names end with 's'

SELECT 
    *
FROM
    accounts
WHERE
    name LIKE '%s';


-- Display all the companies from the accounts table whose names has 'e' as the second character

SELECT 
    *
FROM
    accounts
WHERE
    name LIKE '_e%';


-- Display all the companies from the accounts table whose names do not start with 'C' and end with 's'

SELECT 
    *
FROM
    accounts
WHERE
    name NOT LIKE 'C%' AND name LIKE '%s';


-- Display all the companies from the accounts table whose names start with 'C' or 'W', and primary_poc contains 'ana' or 'Ana', but it doesn't contain 'san'

 SELECT 
    *
FROM
    accounts
WHERE
    (name LIKE 'C%' OR name LIKE 'W%')
        AND (primary_poc LIKE '%ana%'
        AND primary_poc NOT LIKE '%san%');
-- Notice that since Mysql is case incensitive we didn't need to include 'Ana'


-- Display the name, primary_poc, sales_rep_id columns from the accounts table for Walmart, Target, and Nordstrom

SELECT 
    name, primary_poc, sales_rep_id
FROM
    accounts
WHERE
    name IN ('Walmart' , 'Target', 'Nordstrom');


-- Display all information from the web_events table regarding individuals who were contacted via the channel of organic or adwords

SELECT 
    *
FROM
    web_events
WHERE
    channel IN ('organic' , 'adwords');
    

-- Display the name, primary_poc, and sales_rep_id columns from the accounts table for all stores except Walmart, Target, and Nordstrom

SELECT 
    name, primary_poc, sales_rep_id
FROM
    accounts
WHERE
    name NOT IN ('Walmart' , 'Target', 'Nordstrom');


-- Display all information from the web_events table regarding individuals who were contacted via any method except using organic or adwords methods

SELECT 
    *
FROM
    web_events
WHERE
    channel NOT IN ('organic' , 'adwords');


-- Display all the orders from the orders table where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0

SELECT 
    *
FROM
    orders
WHERE
    standard_qty > 100 AND poster_qty = 0
        AND gloss_qty = 0;


-- Displays the occurred_at, gloss_qty columns from the orders table where gloss_qty is between 24 and 29 (begin and end values included)

SELECT 
    occurred_at, gloss_qty
FROM
    orders
WHERE
    gloss_qty BETWEEN 24 AND 29;


-- Display all information from web_events table regarding individuals who were contacted via the organic or adwords channels, 
   and started their account at any point in 2016, sorted from newest to oldest
   
SELECT 
    *
FROM
    web_events
WHERE
    channel IN ('organic' , 'adwords')
        AND occurred_at BETWEEN '2016-01-01' AND '2016-12-31'
ORDER BY occurred_at DESC;


-- Display the id column from the orders table where either gloss_qty or poster_qty is greater than 4000

SELECT 
    id
FROM
    orders
WHERE
    gloss_qty > 4000 OR poster_qty > 4000;


-- Display all information from the orders table where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000

SELECT 
    *
FROM
    orders
WHERE
    standard_qty > 0
        AND (gloss_qty > 1000 OR poster_qty > 1000);
