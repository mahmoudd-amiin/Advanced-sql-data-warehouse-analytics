# Advanced SQL Data Warehouse & Business Analytics

## Project Overview

This project demonstrates the development of a SQL Server data warehouse using a retail sales dataset. It focuses on data warehouse modeling, data integration, data validation, and business analytics using advanced SQL queries.

The project transforms raw sales data into a structured Star Schema and provides analytical insights into sales, profit, customers, products, regions, and shipping performance.

## Objectives

* Build a structured SQL Server data warehouse.
* Implement a Star Schema using fact and dimension tables.
* Load and validate data from a staging table.
* Analyze sales and profitability using SQL.
* Identify business trends and performance indicators.
* Create reusable views and stored procedures.

## Tools & Technologies

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* T-SQL
* Excel
* Data Warehouse Modeling
* ETL and Data Validation

## Data Warehouse Architecture

The project uses a Star Schema consisting of one fact table and five dimension tables.

### Fact Table

* `FactSales`

### Dimension Tables

* `DimCustomer`
* `DimProduct`
* `DimDate`
* `DimLocation`
* `DimShipping`

### Staging Table

* `stg_Superstore`

The `FactSales` table stores sales transactions and connects to the dimension tables through foreign keys. The date dimension is used twice to analyze order dates and shipping dates.

## Data Processing

The project includes:

1. Database and table creation.
2. Staging data preparation.
3. Dimension and fact table loading.
4. Primary key and foreign key relationships.
5. Data validation and reconciliation.
6. SQL indexing for analytical queries.

Data validation confirmed that the fact table contains the same number of records and the same total sales and profit as the staging data.

## Business Analysis

The project includes 15 SQL analysis tasks covering:

1. Total Sales, Profit, and Profit Margin
2. Sales and Profit by Region
3. Product Category Profitability
4. Top 10 Customers by Sales
5. Monthly Sales and Profit Trends
6. Sub-Category Profitability
7. Discount Impact on Profitability
8. Repeat Customer Analysis
9. Customer Segment Performance
10. Loss-Making States
11. Shipping Duration by Ship Mode
12. State Sales Ranking
13. Month-over-Month Sales Growth
14. Overall Sales KPI View
15. Annual Sales KPI Stored Procedure

## SQL Concepts Used

* JOINs
* Aggregate Functions
* GROUP BY and HAVING
* CASE Expressions
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* DENSE_RANK()
* LAG()
* DATEDIFF()
* Views
* Stored Procedures
* Data Validation
* Primary Keys and Foreign Keys

## Main Deliverables

* SQL scripts for data warehouse creation and loading.
* Star Schema data model.
* Data validation queries.
* Business analysis queries.
* Reusable KPI view.
* Parameterized stored procedure for annual KPI analysis.

## Dataset Scope

The project uses the `central_region` worksheet from the Superstore dataset. The analysis represents the records included in that worksheet and should not be interpreted as results for the complete Superstore dataset.

## Future Improvements

* Build an interactive Power BI dashboard.
* Add automated ETL workflows.
* Improve query performance through execution plan analysis.
* Extend the analytical model with additional business metrics.

## Author

Mahmoud Amin

Computer and Communications Engineering Student

Interested in Data Analytics, SQL, Business Intelligence, and Cybersecurity.
