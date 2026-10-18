Select * from sales_data
Limit 10;

/*Check missing values*/

SELECT
    COUNT(*) AS Total_Rows,
    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Product_Name IS NULL) AS Missing_Product_Name,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Revenue IS NULL) AS Missing_Revenue,
    SUM(Cost IS NULL) AS Missing_Cost,
    SUM(Profit IS NULL) AS Missing_Profit
FROM Sales_data;


/*Check whether financial values were imported correctly*/

SELECT *
FROM sales_data
WHERE Revenue IS NULL
   OR Cost IS NULL
   OR Profit IS NULL;
   
   
/*Overall sales KPIs*/

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Quantity) AS Total_Units_Sold,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        100 * SUM(Profit) / NULLIF(SUM(Revenue), 0),
        2
    ) AS Overall_Profit_Margin_Percent
FROM Sales_data;


/*Monthly revenue and profit*/

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM Sales_data
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Sales_Month;


/*Business question: Which region performs best in terms of revenue, and does it also perform well in profitability?*/

SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        100 * SUM(Profit) / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin_Percent
FROM Sales_data
GROUP BY Region
ORDER BY Total_Revenue DESC
limit 1;

/*Which products and categories contribute the most to sales and profit?*/
SELECT
	Product_Name,
    Category,
    ROUND(SUM(Revenue),2) as Total_Sales,
    ROUND(SUM(Profit),2) as Total_Profit
    FROM Sales_data
    GROUP BY Product_Name,
    Category
    ORDER BY Total_sales desc;
    
/*Which customers contribute most to revenue, and should the business prioritize retaining them?*/
SELECT 
	Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Revenue),2) as Total_Revenue,
    ROUND(SUM(Profit),2) as Total_Profit
    FROM sales_data
    GROUP BY Customer_ID,
    Customer_Name
    ORDER BY Total_Revenue Desc
    LIMIT 10;
    
    
    /*Low-margin products*/
    
    SELECT
    Product_Name,
    Category,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        100 * SUM(Profit) / NULLIF(SUM(Revenue), 0),
        2
    ) AS Profit_Margin_Percent
FROM Sales_data
GROUP BY Product_Name, Category
HAVING 100 * SUM(Profit) / NULLIF(SUM(Revenue), 0) < 15
ORDER BY Profit_Margin_Percent;


/*Rank products by revenue*/

WITH Product_Sales AS (
    SELECT
        Product_ID,
        Product_Name,
        SUM(Revenue) AS Total_Revenue
    FROM Sales_data
    GROUP BY Product_ID, Product_Name
)
SELECT
    Product_ID,
    Product_Name,
    ROUND(Total_Revenue, 2) AS Total_Revenue,
    RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Rank
FROM Product_Sales
ORDER BY Revenue_Rank;
    

/*Compare monthly revenue with the previous available month*/

WITH Monthly_Sales as(
		SELECT
        CAST(DATE_FORMAT(Order_Date, '%Y-%m-01') as DATE) As Sales_Month,
        ROUND(SUM(Revenue),2)as Total_Revenue	
        FROM Sales_Data
        GROUP BY CAST(DATE_FORMAT(Order_Date, '%Y-%m-01') as DATE)
	),
    
Comparision as(
		SELECT 
        Sales_Month,
        Total_Revenue,
        LAG(Total_Revenue) OVER(
        ORDER BY Sales_Month) as Previous_Month_Revenue
        FROM Monthly_Sales
	)
    
    SELECT
    Sales_Month,
    ROUND(Total_Revenue,2)as Total_Revenue,
    ROUND(Previous_Month_Revenue,2) as Previous_Month_Revenue,
    ROUND(Total_Revenue - Previous_Month_Revenue,2) as Sales_Difference,
	ROUND(100 * (Total_Revenue - Previous_Month_Revenue)/ NULLIF(Previous_Month_Revenue, 0),2) AS Growth_Percent
    FROM Comparision
    ORDER BY Sales_Month;
        

