-- SQL PAYTM DATA ASSESSMENT QUESTIONS - PSYLIQ

SHOW DATABASES;
USE paytmanalytics;
SHOW TABLES;
SELECT * from paytm_table;

/* 1. What does the "Category_Grouped" column represent, and how many unique categories are there? */ 

SELECT COUNT(DISTINCT Category_Grouped) AS Unique_Categories
FROM paytm_table;

/* 2. Can you list the top 5 shipping cities in terms of the number of orders? */

SELECT Shipping_city, COUNT(*) AS Order_Count
FROM paytm_table
GROUP BY Shipping_city
ORDER BY Order_Count DESC
LIMIT 5;

/* 3. Show me a table with all the data for products that belong to the "Electronics" category. */

SELECT *
FROM paytm_table
WHERE Category = 'Electronics';

/* 4. Filter the data to show only rows with a "Sale_Flag" of 'Yes'. */

SELECT *
FROM paytm_table
WHERE Sale_Flag = 'On Sale';

/* 5. Sort the data by "Item_Price" in descending order. What is the most expensive item? */

SELECT *
FROM paytm_table
ORDER BY Item_Price DESC
LIMIT 1;

/* 6. Apply conditional formatting to highlight all products with a "Special_Price_effective" value below $50 in red. */

SELECT *
FROM paytm_table
WHERE Special_Price_effective < 50;

/* 7. Create a pivot table to find the total sales value for each category. */

SELECT Category, SUM(Item_Price) AS Total_Sales_Value
FROM paytm_table
GROUP BY Category;

/* 8. Create a bar chart to visualize the total sales for each category. */

SELECT Category, SUM(Item_Price) AS Total_Sales_Value 
FROM paytm_table 
GROUP BY Category;


/* 9. Create a pie chart to show the distribution of products in the "Family" category. */

SELECT Family, COUNT(*) AS Product_Count 
FROM paytm_table 
GROUP BY Family;

/* 10. Ensure that the "Payment_Method" column only contains valid payment methods (e.g., Visa, MasterCard). */

SELECT *
FROM paytm_table
WHERE Payment_Method = 'Prepaid';

/* 11. Calculate the average "Quantity" sold for products in the "Clothing" category, grouped by "Product_Gender." */

SELECT Product_Gender, AVG(Quantity) AS AvgQuantitySold
FROM paytm_table
WHERE Category IN ('Women Apparel', 'Men Apparel')
GROUP BY Product_Gender;

/* 12. Find the top 5 products with the highest "Value_CM1" and "Value_CM2" ratios. Create a chart to visualize this data. */

SELECT Item_NM, Value_CM1, Value_CM2, Value_CM1 / Value_CM2 AS Ratio
FROM paytm_table
WHERE Value_CM2 != 0
ORDER BY (Value_CM1 / Value_CM2) DESC
LIMIT 5;

/* 13. Identify the top 3 "Class" categories with the highest total sales. Create a stacked bar chart to represent this data. */

SELECT Class, SUM(Item_Price) AS Total_Sales
FROM paytm_table
GROUP BY Class
ORDER BY Total_Sales DESC
LIMIT 4;

/* 14. Use VLOOKUP or INDEX-MATCH to retrieve the "Color" of a product with a specific "Item_NM." */

SELECT Color
FROM paytm_table
WHERE Item_NM = 'Navy Blue Georgette Brocade Neck & Dupatta Suit Set'
GROUP BY Color;

/* 15. Calculate the total "coupon_money_effective" and "Coupon_Percentage" for products in the "Electronics" category. */
	
SELECT 
    SUM(coupon_money_effective) AS Total_Coupon_Money_Effective,
    SUM(Coupon_Percentage) AS Total_Coupon_Percentage
FROM 
    paytm_table
WHERE 
    Category = 'Electronics';

/* 16. Perform a time series analysis to identify the month with the highest total sales. */

-- REQUIRED COLUMNS ARE NOT PROVIDED IN THE DATASET.

/* 17. Calculate the total sales for each "Segment" and create a scatter plot to visualize the relationship between "Item_Price" and "Quantity" in this data. */
SELECT 
    Segment,
    SUM(Item_Price * Quantity) AS Total_Sales
FROM 
    paytm_table
GROUP BY 
    Segment;

/* 18. Use the AVERAGEIFS function to find the average "Item_Price" for products that have a "Sale_Flag" of 'Yes.' */

SELECT AVG(Item_Price) AS Average_Item_Price
FROM paytm_table
WHERE Sale_Flag = 'On Sale';

/* 19. Identify products with a "Paid_pr" higher than the average in their respective "Family" and "Brand" groups. */

SELECT p1.*
FROM paytm_table p1
INNER JOIN (
    SELECT Family, Brand, AVG(Paid_pr) AS AvgPaidPr
    FROM paytm_table
    GROUP BY Family, Brand
) AS avg_prices
ON p1.Family = avg_prices.Family
AND p1.Brand = avg_prices.Brand
WHERE p1.Paid_pr > avg_prices.AvgPaidPr;

/* 20. Create a pivot table to show the total sales for each "Color" within the "Clothing" category and use conditional formatting to highlight the highest sales. */

SELECT Color, SUM(Item_Price) AS Total_Sales
FROM paytm_table
WHERE Category IN ('Women Apparel', 'Men Apparel')
GROUP BY Color;
