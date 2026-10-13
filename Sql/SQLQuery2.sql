-- 12- Which states have the highest total sales and how do they rank ? CTEs .
WITH RegionPerformance AS
(
    SELECT L.StateName,
 SUM(F.Sales) AS [Total Sales] , SUM(F.Profit) AS [Total Profit]
    FROM dbo.FactSales AS F
                           JOIN dbo.DimLocation AS L
        ON F.LocationKey = L.LocationKey
    GROUP BY L.StateName
)
    SELECT StateName, [Total Sales], [Total Profit],
    DENSE_RANK() OVER ( ORDER BY [Total Sales] DESC ) AS [Sales Rank]
FROM RegionPerformance
ORDER BY [Sales Rank];
-------------------------------------------------------------------------------------------------
-- 13- How do monthly sales compare with the previous month,what is the sales growth percentage ? CTEs .
WITH MonthlySales AS
(
  SELECT D.CalendarYear , D.MonthNumber , D.MonthName,
        SUM(F.Sales) AS [Total Sales]
        FROM dbo.FactSales AS F
                            JOIN dbo.DimDate AS D
        ON F.OrderDateKey = D.DateKey
        GROUP BY D.CalendarYear, D.MonthNumber , D.MonthName), [Sales Comparison] AS
(
  SELECT CalendarYear , MonthNumber , MonthName , [Total Sales],
        LAG([Total Sales]) OVER ( ORDER BY CalendarYear, MonthNumber ) AS [Previous Month Sales]
        FROM MonthlySales
)
  SELECT CalendarYear, MonthNumber, MonthName, [Total Sales], [Previous Month Sales],
       CAST( [Total Sales] - [Previous Month Sales] AS DECIMAL(18,2) ) AS [Sales Difference],
       CAST( 100.0 * ([Total Sales] - [Previous Month Sales]) / NULLIF([Previous Month Sales], 0)
	    AS DECIMAL(10,2)) AS [Sales Growth Percent]
FROM [Sales Comparison]
ORDER BY CalendarYear, MonthNumber;
-----------------------------------------------------------------------------------------------------
-- 14- What are the overall sales KPIs ? View
CREATE OR ALTER VIEW dbo.vw_SalesKPI
AS
SELECT
    COUNT(*) AS [Total Sales Records],
    COUNT(DISTINCT OrderID) AS [Total Orders],
    COUNT(DISTINCT CustomerKey) AS [Total Customers],
    SUM(Sales) AS [Total Sales],
    SUM(Profit) AS [Total Profit],
    SUM(Quantity) AS [Total Quantity],
    AVG(Discount) AS [Average Discount],
    CAST( 100.0 * SUM(Profit) / NULLIF(SUM(Sales), 0) AS DECIMAL(10,2)) AS [Profit Margin Percent]
FROM dbo.FactSales;
-------------------------------------------------------------------------------------------------
-- 15- What are the annual sales KPIs for each year ? Stored Procedure
CREATE OR ALTER PROCEDURE dbo.usp_GetSalesKPI
    @CalendarYear INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        D.CalendarYear,
        COUNT(*) AS TotalSalesRecords,
        COUNT(DISTINCT F.OrderID) AS TotalOrders,
        COUNT(DISTINCT F.CustomerKey) AS TotalCustomers,
        SUM(F.Sales) AS TotalSales,
        SUM(F.Profit) AS TotalProfit,
        SUM(F.Quantity) AS TotalQuantity,
        CAST( 100.0 * SUM(F.Profit) / NULLIF(SUM(F.Sales), 0) AS DECIMAL(10,2)) AS ProfitMarginPercent
    FROM dbo.FactSales AS F
                            JOIN dbo.DimDate AS D
        ON F.OrderDateKey = D.DateKey
    WHERE
        @CalendarYear IS NULL
        OR D.CalendarYear = @CalendarYear
    GROUP BY D.CalendarYear
    ORDER BY D.CalendarYear;
END;
------------ ** ---------------------------------------- ** --------------------- 
