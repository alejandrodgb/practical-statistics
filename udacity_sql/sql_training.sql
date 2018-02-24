--Write a query to return the 10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at ASC
LIMIT 10;

--Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

--Write a query to return the bottom 20 orders in terms of least total. Include the id, account_id, and total.
SELECT id, account_id, total
FROM orders
ORDER BY total ASC
LIMIT 20;

--Write a query that returns the top 5 rows from orders ordered according to newest to oldest, but with the largest total_amt_usd for each date listed first for each date. You will notice each of these dates shows up as unique because of the time element. When you learn about truncating dates in a later lesson, you will better be able to tackle this question on a day, month, or yearly basis.
SELECT *
FROM orders
ORDER BY occurred_at DESC, total_amt_usd DESC
LIMIT 5;

--Write a query that returns the top 10 rows from orders ordered according to oldest to newest, but with the smallest total_amt_usd for each date listed first for each date. You will notice each of these dates shows up as unique because of the time element. When you learn about truncating dates in a later lesson, you will better be able to tackle this question on a day, month, or yearly basis.
SELECT *
FROM orders
ORDER BY occurred_at ASC, total_amt_usd ASC
LIMIT 10;

--Pull the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gross_amt_usd>=1000
LIMIT 5;

--Pull the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500
SELECT *
FROM orders
WHERE total_amt_usd<500
LIMIT 10;

--Filter the accounts table to include the company name, website, and the
--primary point of contact (primary_poc) for Exxon Mobil in the accounts table.
SELECT name, website, primary_poc
WHERE name = 'Exxon Mobil';
FROM accounts

--Create a column that divides the standard_amt_usd by the standard_qty to find
--the unit price for standard paper for each order. Limit the results to the
--first 10 orders, and include the id and account_id fields.
SELECT (standard_amt_usd/standard_qty) AS unit_price, id, account_id
FROM orders
LIMIT 10;

--Write a query that finds the percentage of revenue that comes from poster
--paper for each order. You will need to use only the columns that end
--with _usd. (Try to do this without using the total column). Include the id and
--account_id fields. NOTE - you will be thrown an error with the correct
--solution to this question. This is for a division by zero. You will learn how
--to get a solution without an error to this query when you learn about CASE
--statements in a later section. For now, you might just add some very small
--value to your denominator as a work around.
SELECT
  id,
  account_id,
  (poster_amt_usd/
    (standard_amt_usd+gloss_amt_usd+poster_amt_usd)) AS poster_prop
FROM orders;


--All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

--All companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%';

--All companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s';

---Use the accounts table to find the account name, primary_poc, and
--sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target','Nordstrom');

--Use the web_events table to find all information regarding individuals who
--were contacted via the channel of organic or adwords.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

--All the companies whose names do not start with 'C'.
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%';

--All companies whose names do not contain the string 'one' somewhere in the 
--name.
SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';

--All companies whose names do not end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE '%s';


--Which account (by name) placed the earliest order? Your solution should have 
--the account name and the date of the order.

--Find the total sales in usd for each account. You should include two columns -
--the total sales for each company's orders in usd and the company name.

--Via what channel did the most recent (latest) web_event occur, which account
--was associated with this web_event? Your query should return only three values
-- - the date, channel, and account name.

--Find the total number of times each type of channel from the web_events was 
--used. Your final table should have two columns - the channel and the number of
--times the channel was used.

--Who was the primary contact associated with the earliest web_event? 

--What was the smallest order placed by each account in terms of total usd.
--Provide only two columns - the account name and the total usd. Order from 
--smallest dollar amounts to largest.

--Find the number of sales reps in each region. Your final table should have two
--columns - the region and the number of sales_reps. Order from fewest reps to 
--most reps.

--For each account, determine the average amount of each type of paper they
--purchased across their orders. Your result should have four columns - one for 
--the account name and one for the average spent on each of the paper types.
SELECT 
    a.name, 
    AVG(o.standard_qty) avg_stand, 
    AVG(o.gloss_qty) avg_gloss, 
    AVG(o.poster_qty) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


--For each account, determine the average amount spent per order on each paper
--type. Your result should have four columns - one for the account name and one
--for the average amount spent on each paper type.
SELECT 
    a.name, 
    AVG(o.standard_amt_usd) avg_stand, 
    AVG(o.gloss_amt_usd) avg_gloss, 
    AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;


--Determine the number of times a particular channel was used in the web_events 
--table for each sales rep. Your final table should have three columns - the 
--name of the sales rep, the channel, and the number of occurrences. Order your
--table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

--Determine the number of times a particular channel was used in the web_events
--table for each region. Your final table should have three columns - the region
--name, the channel, and the number of occurrences. Order your table with the
--highest number of occurrences first.
SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

--Use DISTINCT to test if there are any accounts associated with more than one 
--region.
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

-- used with query below to compare resutlts

SELECT DISTINCT id, name
FROM accounts;

--Have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

-- used with query below to compare resutlts

SELECT DISTINCT id, name
FROM sales_reps; 

--How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;
--and technically, we can get this using a SUBQUERY as shown below. This same 
--logic can be used for the other queries, but this will not be shown.

SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;

--How many accounts have more than 20 orders?
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

--Which account has the most orders?
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

--How many accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent;

--How many accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent;

--Which account has spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;

--Which account has spent the least with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;

--Which accounts used facebook as a channel to contact customers more than 6 
--times?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

--Which account used facebook most as a channel?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

--Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
--All of the top 10 are direct.

/*We would like to understand 3 different levels of customers based on the 
amount associated with their purchases. The top branch includes anyone with a 
Lifetime Value (total sales of all orders) greater than 200,000 usd. The second 
branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 
100,000 usd. Provide a table that includes the level associated with each 
account. You should provide the account name, the total sales of all orders for 
the customer, and the level. Order with the top spending customers listed first.
*/
SELECT
    a.name,
    SUM(o.total_amt_usd) AS total_spent,
    CASE WHEN SUM(o.total_amt_usd)>200000 THEN 1
         WHEN SUM(o.total_amt_usd)>100000 THEN 2
         ELSE 3 END
    AS client_category
FROM orders o
JOIN accounts a
ON o.account_id=a.id
GROUP BY a.name
ORDER BY 2 DESC;


/*We would now like to perform a similar calculation to the first, but we want 
to obtain the total amount spent by customers only in 2016 and 2017. Keep the 
same levels as in the previous question. Order with the top spending customers 
listed first.
*/
SELECT
    a.name,
    SUM(o.total_amt_usd) AS total_spent,
    CASE WHEN SUM(o.total_amt_usd)>200000 THEN 1
         WHEN SUM(o.total_amt_usd)>100000 THEN 2
         ELSE 3 END
    AS client_category
FROM orders o
JOIN accounts a
ON o.account_id=a.id
GROUP BY a.name
ORDER BY 2 DESC;

/*We would like to identify top performing sales reps, which are sales reps 
associated with more than 200 orders. Create a table with the sales rep name, 
the total number of orders, and a column with top or not depending on if they 
have more than 200 orders. Place the top sales people first in your final table.
*/

/*The previous didn't account for the middle, nor the dollar amount associated 
with the sales. Management decides they want to see these characteristics 
represented as well. We would like to identify top performing sales reps, which 
are sales reps associated with more than 200 orders or more than 750000 in total
 sales. The middle group has any rep with more than 150 orders or 500000 in 
 sales. Create a table with the sales rep name, the total number of orders, 
 total sales across all orders, and a column with top, middle, or low depending 
 on this criteria. Place the top sales people based on dollar amount of sales 
 first in your final table. You might see a few upset sales people by this 
 criteria!
*/

-- Provide the name of the sales_rep in each region with the largest amount of 
-- total_amt_usd sales.
WITH 
  orders_by_sales_rep AS (
    SELECT s.name as sales_rep, r.name as region, SUM(o.total_amt_usd) total_sales
	  FROM pnp.orders o
	  JOIN pnp.accounts a
	    ON o.account_id=a.id
	  JOIN pnp.sales_reps s
	    ON a.sales_rep_id=s.id
	  JOIN pnp.region r
	    ON s.region_id=r.id
	GROUP BY s.name, r.name
    ),
  orders_by_region AS (
    SELECT region, MAX(total_sales) total_sales
	FROM orders_by_sales_rep
	GROUP BY region
	)

SELECT a.*, b.sales_rep
FROM orders_by_region a
JOIN orders_by_sales_rep b
ON b.total_sales=a.total_sales

-- For the region with the largest sales total_amt_usd, how many total orders 
-- were placed? 
WITH
  region_totals AS (
    SELECT 
	  r.name region, sum(o.total_amt_usd) total_sales, sum(o.total) total
	FROM pnp.orders o
	JOIN pnp.accounts a
	  ON o.account_id=a.id
	JOIN pnp.sales_reps s
	  ON a.sales_rep_id=s.id
	JOIN pnp.region r
	  ON s.region_id=r.id
	GROUP BY r.name
    )

SELECT TOP 1 *
FROM region_totals
ORDER BY total_sales DESC

-- For the name of the account that purchased the most (in total over their
-- lifetime as a customer) standard_qty paper, how many accounts still had more
-- in total purchases? 


-- For the customer that spent the most (in total over their lifetime as a
-- customer) total_amt_usd, how many web_events did they have for each channel?


-- What is the lifetime average amount spent in terms of total_amt_usd for the
-- top 10 total spending accounts?


-- What is the lifetime average amount spent in terms of total_amt_usd for only
-- the companies that spent more than the average of all accounts.