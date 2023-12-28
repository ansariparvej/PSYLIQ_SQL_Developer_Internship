-- SQL PHARMA DATA ASSESSMENT QUESTIONS - PSYLIQ

SHOW DATABASES;
USE pharmaanalytics;
SHOW TABLES;
SELECT * from pharma_table;

/* 1. Retrieve all columns for all records in the dataset. */ 

SELECT * FROM pharma_table;

/* 2. How many unique countries are represented in the dataset? */

SELECT 
COUNT(DISTINCT country)
FROM pharma_table;

/* 3. Select the names of all the customers on the 'Retail' channel. */

SELECT 
`Customer Name` AS Customers_Retail
FROM pharma_table 
WHERE `Sub-channel` = 'Retail';

/* 4. Find the total quantity sold for the ' Antibiotics' product class. */

SELECT 
SUM(Quantity) AS Total_Quantity 
FROM pharma_table 
WHERE `Product Class` = 'Antibiotics';

/* 5. List all the distinct months present in the dataset. */

SELECT 
DISTINCT Month
FROM pharma_table;

/* 6. Calculate the total sales for each year. */

SELECT 
Year,
SUM(Sales) AS Total_Sales
FROM pharma_table 
GROUP BY 1;

/* 7. Find the customer with the highest sales value. */

SELECT 
`Customer Name`,
SUM(Sales) AS Total_Sales 
FROM pharma_table 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 1;

/* 8. Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'. */

SELECT 
DISTINCT `Name of Sales Rep` AS Employee
FROM pharma_table 
WHERE Manager = 'James Goodwill';

/* 9. Retrieve the top 5 cities with the highest sales. */

SELECT 
City,
SUM(Sales) AS Highest_Sales
FROM pharma_table 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* 10. Calculate the average price of products in each sub-channel. */

SELECT 
`Sub-channel`,
AVG(Price) AS Average_Price
FROM pharma_table 
GROUP BY 1
ORDER BY 2 DESC;

/* 11. Join the 'Employees' table with the 'Sales' table to get the name of the Sales Rep and the corresponding sales records. */

SELECT 
`Name of Sales Rep`,
SUM(Sales) AS Sales_Record 
FROM pharma_table
GROUP BY 1
ORDER BY 2 DESC;

/* 12. Retrieve all sales made by employees from ' Rendsburg ' in the year 2018. */

SELECT 
`Name of Sales Rep`, 
SUM(Sales) AS Total_Sales,
`YEAR` 
FROM pharma_table 
WHERE City = 'Rendsburg' AND `Year` = 2018
GROUP BY 1
ORDER BY 2 DESC;

/* 13. Calculate the total sales for each product class, for each month, and order the results by year, month, and product class. */

SELECT 
`Product Class`, 
`Month`, 
`Year`,
SUM(Sales) AS Total_Sales 
FROM pharma_table 
GROUP BY 1, 2, 3
ORDER BY `Year`, `Month`, `Product Class`;

/* 14. Find the top 3 sales reps with the highest sales in 2019. */

SELECT 
`Name of Sales Rep` AS Top_3_Sales_Rep,
SUM(Sales) AS Total_Sales 
FROM pharma_table 
WHERE year = 2019
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 3;

/* 15. Calculate the monthly total sales for each sub-channel, and then calculate the average monthly sales for each sub-channel over the years. */
	
SELECT 
`Sub-channel`,
`Month`,
`Year`,
SUM(Sales) AS Total_Sales,
AVG(SUM(Sales)) OVER (PARTITION BY `Sub-channel`, `Month`) AS Average_Sales
FROM pharma_table 
GROUP BY 1,2,3
ORDER BY 3,2;

/* 16. Create a summary report that includes the total sales, average price, and total quantity sold for each product class. */

SELECT 
`Product Class`,
SUM(Sales) AS Total_Sales, 
AVG(Price) AS Average_Price,
SUM(Quantity) AS Total_Quantity
FROM pharma_table
GROUP BY 1;

/* 17. Find the top 5 customers with the highest sales for each year. */

WITH Top_Customers AS (
SELECT 
`Customer Name`,
Sales,
`Year`,
DENSE_RANK() OVER(PARTITION BY year ORDER BY Sales DESC) AS Top_5_Customers 
FROM pharma_table)
SELECT 
*
FROM Top_Customers 
WHERE Top_5_Customers <= 5;

/* 18. Calculate the year-over-year growth in sales for each country. */

SELECT
Country,
`Year`,
SUM(Sales) AS Total_Sales,
LAG(SUM(Sales), 1, 0) OVER(PARTITION BY Country ORDER BY year) AS Previous_Year_Sales,
SUM(Sales) - LAG(SUM(Sales), 1, 0) OVER(PARTITION BY Country ORDER BY year) AS Year_Over_Year_Growth
FROM pharma_table
GROUP BY 1,2
ORDER BY 2,1;

/* 19. List the months with the lowest sales for each year. */

WITH Lowest_Sales AS (
SELECT 
`Month`,
`Year`,
SUM(Sales) AS Total_Sales,
DENSE_RANK() OVER(PARTITION BY year ORDER BY SUM(Sales) ASC) AS Ranks
FROM pharma_table
GROUP BY 1,2)
SELECT 
*
FROM Lowest_Sales
WHERE Ranks = 1;

/* 20. Calculate the total sales for each sub-channel in each country, and then find the country with the highest total sales for each sub-channel. */

WITH CTE AS (
SELECT 
`Sub-channel`,
Country,
SUM(Sales) AS Total_Sales
FROM pharma_table 
GROUP BY 1,2),

Highest_Total_Sales AS (
SELECT 
*,
DENSE_RANK() OVER (PARTITION BY `Sub-channel` ORDER BY Total_Sales DESC) AS Ranks
FROM CTE)

SELECT *
FROM Highest_Total_Sales 
WHERE Ranks = 1;
