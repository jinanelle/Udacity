
-- Q1
-- Use the Invoice table to determine the countries that have the most invoices. Provide a table of BillingCountry and Invoices ordered by the number of invoices for each country. The country with the most invoices should appear first.

SELECT BillingCountry, COUNT(*)
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC



-- Q2
-- We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns the 1 city that has the highest sum of invoice totals. Return both the city name and the sum of all invoice totals.
-- check your solution
-- The top city for Invoice dollars was Prague with an amount of 90.24

SELECT BillingCity, SUM(Total)
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1



-- Q3
-- The customer who has spent the most money will be declared the best customer. Build a query that returns the person who has spent the most money. I found the solution by linking the following three: Invoice, InvoiceLine, and Customer tables to retrieve this information, but you can probably do it with fewer!
-- check your solution
-- The customer who spent the most according to invoices was Customer 6 with 49.62 in purchases.

SELECT i.CustomerId, c.FirstName, C.LastName, SUM(i.Total)
FROM Invoice i
JOIN Customer c
ON i.CustomerId = c.CustomerId
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 1



-- Q4
-- The team at Chinook would like to identify all the customers who listen to Rock music. Write a query to return the email, first name, last name, and Genre of all Rock Music listeners. Return your list ordered alphabetically by email address starting with 'A'.
-- Check your solution
-- Your final table should have 59 rows and 4 columns.

SELECT c.Email, c.FirstName, c.LastName, g.Name
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine l ON i.InvoiceId = l.invoiceId
JOIN Track t ON l.TrackId = t.TrackId
JOIN Genre g ON g.GenreId = t.GenreId
WHERE g.Name ='Rock'
GROUP BY 1, 2, 3
ORDER BY 1




-- Q5
-- Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
-- You should only need to use the Customer and Invoice tables.
-- Check Your Solution
-- Though there are only 24 countries, your query should return 25 rows because the United Kingdom has 2 customers that share the maximum.

WITH cc AS (
SELECT c.CustomerId, i.BillingCountry, SUM(i.Total) Total
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 1,2
), cm AS (
SELECT CustomerId, BillingCountry, Max(Total) Maxy
FROM cc
GROUP BY 2
)
SELECT cc.CustomerId, c.FirstName, c.LastName, cc.BillingCountry, cc.Total
FROM cc 
JOIN Customer c ON cc.CustomerId = c.CustomerId
WHERE Total = (SELECT Maxy FROM cm WHERE cm.BillingCountry = cc.BillingCountry )
ORDER BY 4