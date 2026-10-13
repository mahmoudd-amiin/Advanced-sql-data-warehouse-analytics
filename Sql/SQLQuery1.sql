-- 1- What are the total sales, profit, and profit margin ?
SELECT SUM(Sales) AS TotalSales, SUM(Profit) AS TotalProfit,
    CAST(
        100.0 * SUM(Profit) / NULLIF(SUM(Sales), 0) AS DECIMAL(10,2)) AS ProfitMarginPercent
FROM dbo.FactSales;
-------------------------------------------------------------------------------------------------
-- 2- Which regions generate the highest sales and profit ?
SELECT  L.Region, SUM(F.Sales) AS TotalSales, SUM(F.Profit) AS TotalProfit
FROM dbo.FactSales AS F
                         JOIN dbo.DimLocation AS L
    ON F.LocationKey = L.LocationKey
GROUP BY L.Region
ORDER BY TotalSales DESC;
-------------------------------------------------------------------------------------------------
-- 3- Which product categories are the most profitable ?
SELECT P.Category,
    SUM(F.Sales) AS TotalSales , SUM(F.Profit) AS [Total Profit],
    SUM(F.Quantity) AS TotalQuantity,
    CAST(
        100.0 * SUM(F.Profit) / NULLIF(SUM(F.Sales), 0)
        AS DECIMAL(10,2)
    ) AS [Profit Margin Percent]
FROM dbo.FactSales AS F
                        JOIN dbo.DimProduct AS P
    ON F.ProductKey = P.ProductKey
GROUP BY P.Category
ORDER BY [Total Profit] DESC;
-------------------------------------------------------------------------------------------------
-- 4- Who are the top 10 customers by sales ?
SELECT TOP 10  C.CustomerID, C.CustomerName,
    SUM(F.Sales) AS [Total Sales] , SUM(F.Profit) AS [Total Profit]
FROM dbo.FactSales AS F
                           JOIN dbo.DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
GROUP BY
    C.CustomerID,
    C.CustomerName
ORDER BY [Total Sales] DESC;
-------------------------------------------------------------------------------------------------
-- 5- How do sales change over time ?
SELECT D.CalendarYear, D.MonthNumber, D.MonthName,
    SUM(F.Sales) AS [Total Sales] , SUM(F.Profit) AS [Total Profit]
FROM dbo.FactSales AS F
                        JOIN dbo.DimDate AS D
    ON F.OrderDateKey = D.DateKey
GROUP BY D.CalendarYear, D.MonthNumber, D.MonthName
ORDER BY D.CalendarYear, D.MonthNumber;
-------------------------------------------------------------------------------------------------
-- 6- Which product sub-categories generate the highest and lowest profit ?
SELECT P.Category, P.SubCategory,
 SUM(F.Sales) AS [Total Sales], SUM(F.Profit) AS [Total Profit], SUM(F.Quantity) AS [Total Quantity],
    CAST(
        100.0 * SUM(F.Profit) / NULLIF(SUM(F.Sales), 0) AS DECIMAL(10,2) ) AS [Profit Margin Percent],
    CASE
        WHEN SUM(F.Profit) < 0 THEN 'Loss'
        WHEN SUM(F.Profit) = 0 THEN 'Break-Even'
        ELSE 'Profitable'
    END AS ProfitStatus
FROM dbo.FactSales AS F
                        JOIN dbo.DimProduct AS P
    ON F.ProductKey = P.ProductKey
GROUP BY P.Category, P.SubCategory
ORDER BY [Total Profit] DESC;
-------------------------------------------------------------------------------------------------
-- 7- How do different discount levels affect sales and profitability ?
SELECT
    CASE
        WHEN F.Discount = 0 THEN 'No Discount'
        WHEN F.Discount <= 0.10 THEN 'Low Discount'
        WHEN F.Discount <= 0.30 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS [Discout Level],
    COUNT(*) AS [Number Of Sales Records],
 SUM(F.Sales) AS [TotalSales] , SUM(F.Profit) AS [Total Profit],
    CAST( AVG(F.Discount) * 100 AS DECIMAL(10,2) ) AS [Average Discount Percent],
    CAST( 100.0 * SUM(F.Profit) / NULLIF(SUM(F.Sales), 0) AS DECIMAL(10,2) ) AS [Profit Margin Percent]
FROM dbo.FactSales AS F
GROUP BY
    CASE
        WHEN F.Discount = 0 THEN 'No Discount'
        WHEN F.Discount <= 0.10 THEN 'Low Discount'
        WHEN F.Discount <= 0.30 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY [Average Discount Percent];
-------------------------------------------------------------------------------------------------
-- 8- How many customers have placed more than one order?
SELECT C.CustomerID , C.CustomerName,
    COUNT(DISTINCT F.OrderID) AS [Number Of Orders],
 SUM(F.Sales) AS [Total Sales] , SUM(F.Profit) AS [Total Profit]
FROM dbo.FactSales AS F
                       JOIN dbo.DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
WHERE F.CustomerKey IN
(
    SELECT CustomerKey
    FROM dbo.FactSales
    GROUP BY CustomerKey
    HAVING COUNT(DISTINCT OrderID) > 1
)
GROUP BY C.CustomerID,C.CustomerName
ORDER BY [Number Of Orders] DESC, [Total Sales] DESC;
-------------------------------------------------------------------------------------------------
-- 9- How do sales and profit compare across customer segments ?
SELECT  C.Segment,
    COUNT(DISTINCT C.CustomerID) AS [Number Of Customers],
    COUNT(DISTINCT F.OrderID) AS [Number Of Orders],
 SUM(F.Sales) AS [Total Sales], SUM(F.Profit) AS [Total Profit], SUM(F.Quantity) AS [Total Quantity],
 CAST( SUM(F.Sales) / NULLIF(COUNT(DISTINCT F.OrderID), 0) AS DECIMAL(12,2) ) AS [Average Sales Per Order]
FROM dbo.FactSales AS F
                       JOIN dbo.DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
GROUP BY C.Segment
ORDER BY [Total Sales] DESC;
-------------------------------------------------------------------------------------------------
-- 10- Which states have a negative total profit?
SELECT L.StateName, L.Region,
 SUM(F.Sales) AS [Total Sales], SUM(F.Profit) AS [Total Profit],
    COUNT(DISTINCT F.OrderID) AS [Number Of Orders]
FROM dbo.FactSales AS F
                        JOIN dbo.DimLocation AS L
    ON F.LocationKey = L.LocationKey
GROUP BY L.StateName, L.Region
HAVING SUM(F.Profit) < 0
ORDER BY [Total Profit] ASC;
-------------------------------------------------------------------------------------------------
-- مهم و جامد- 11 - What is the average shipping duration for each ship mode ?
SELECT S.ShipMode,
    COUNT(*) AS [Number Of Sales Records],
    COUNT(DISTINCT F.OrderID) AS [Number Of Orders],
    AVG( CAST ( DATEDIFF( DAY, OrderDate.FullDate , ShipDate.FullDate ) AS DECIMAL(10,2)))
	     AS [Average Shipping Days],
    SUM(
        CASE
            WHEN DATEDIFF( DAY , OrderDate.FullDate , ShipDate.FullDate ) > 5 THEN 1
            ELSE 0
        END ) AS [Records Shipped After FiveDays]
FROM dbo.FactSales AS F
                       JOIN dbo.DimShipping AS S
    ON F.ShippingKey = S.ShippingKey
                       JOIN dbo.DimDate AS OrderDate
    ON F.OrderDateKey = OrderDate.DateKey
                       JOIN dbo.DimDate AS ShipDate
    ON F.ShipDateKey = ShipDate.DateKey
GROUP BY S.ShipMode
ORDER BY [Average Shipping Days];

