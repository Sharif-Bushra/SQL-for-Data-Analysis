/* In the accounts table, there is a column holding the website for each company,
	the last three digits specify what type of web address they are using */
-- Display the different extensions and the number of websites using them

SELECT 
    RIGHT(website, 3) AS extension, COUNT(*) AS number_of_websites
FROM
    accounts
GROUP BY 1
ORDER BY 2 DESC;


-- Display the first letter of each company name and how many companys begin with that letter 'or number'

SELECT 
    LEFT(name, 1) AS first_letter, COUNT(*) AS total
FROM
    accounts
GROUP BY 1
ORDER BY 2 DESC;


-- Remove leading and trailing spaces from sales reps names

SELECT 
    TRIM(name) AS sales_rep_name
FROM
    sales_reps;
    

/* Consider vowels as a, e, i, o, and u,
display the proportion of company names that start with a vowel and the proportion that starts with anything else */

WITH first_letter AS
(SELECT 
    SUM(CASE
        WHEN LEFT(name, 1) IN ('A' , 'E', 'I', 'O', 'U') THEN 1
        ELSE 0
    END) AS vowels,
    SUM(CASE
        WHEN LEFT(name, 1) NOT IN ('A' , 'E', 'I', 'O', 'U') THEN 1
        ELSE 0
    END) AS other
FROM
    accounts)
		
SELECT 
    vowels / (vowels + other) * 100 AS 'vowels_%',
    other / (vowels + other) * 100 AS 'other_%'
FROM
    first_letter;


-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc

SELECT primary_poc, 
	SUBSTRING_INDEX(primary_poc,' ',1) AS first_name,
	SUBSTRING_INDEX(primary_poc,' ',-1) AS last_name
FROM accounts;


-- Add two column for first_name and last_name to the accounts table

ALTER TABLE accounts
ADD first_name varchar(50),
ADD last_name varchar(50);

UPDATE accounts
SET first_name = SUBSTRING_INDEX(primary_poc, ' ', 1),
last_name = SUBSTRING_INDEX(primary_poc, ' ', -1);


-- The website column in the accounts table has 3 parts seperated by '.', create 3 columns containing the different parts

SELECT 
    website,
    SUBSTRING_INDEX(website, '.', 1) AS part1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(website, '.', 2),'.',-1) AS part2,
    SUBSTRING_INDEX(website, '.', -1) AS part3
FROM
    accounts;


/* Each company in the accounts table wants to create an email address for each primary_poc, 
	the email address should be the first_name.last_name of the primary_poc @ company website */
    
WITH names AS
(SELECT 
    SUBSTRING_INDEX(primary_poc, ' ', 1) AS first_name,
    SUBSTRING_INDEX(primary_poc, ' ', - 1) AS last_name,
    SUBSTRING_INDEX(website, '.', - 2) AS company_name
FROM
    accounts)

SELECT
    CONCAT(first_name,'.',last_name,'@',company_name) AS email_address
FROM
    names;


-- Add email_address column to the accounts table

ALTER TABLE accounts
ADD email_address varchar(255);

UPDATE accounts
SET email_address = CONCAT(SUBSTRING_INDEX(primary_poc, ' ', 1),'.',
    SUBSTRING_INDEX(primary_poc, ' ', - 1),'@',SUBSTRING_INDEX(website, '.', - 2));


/*We would also like to create an initial password, for each primary_poc, the password will be:
the first letter of the primary_poc's first name (uppercase),  the first letter of their last name (lowercase),
the number of characters in their full name, then the name of the company they are working with (lowercase with no spaces) */

WITH t1 AS
(SELECT 
    UPPER(LEFT(SUBSTRING_INDEX(primary_poc, ' ', 1), 1)) AS first_name_1st_letter,
    LOWER(LEFT(SUBSTRING_INDEX(primary_poc, ' ', - 1), 1)) AS last_name_1st_letter,
    LENGTH(primary_poc) AS len,
    LOWER(REPLACE(name, ' ', '')) AS company_name
FROM
    accounts)

SELECT 
    CONCAT(first_name_1st_letter,last_name_1st_letter,len,company_name) AS password
FROM
    t1;


-- Add a column for date only to the orders table, occured_at column is datetime

ALTER TABLE orders
ADD date_only date;

UPDATE orders
SET date_only = DATE(occurred_at);
