
-- MSSQL CTE MASTERY

RESTORE FILELISTONLY FROM DISK = 
'/var/opt/mssql/backup/adventureworks2022.bak';
GO


RESTORE DATABASE AdventureWorks2022
FROM DISK = 
'/var/opt/mssql/backup/adventureworks2022.bak'
WITH MOVE 
'AdventureWorks2022' 
TO '/var/opt/mssql/data/AdventureWorks2022.mdf',
     MOVE 'AdventureWorks2022_log' 
     TO '/var/opt/mssql/data/AdventureWorks2022_log.ldf';
GO

SELECT name, state_desc FROM sys.databases;
GO

SELECT * FROM Person.Person

USE AdventureWorks2022;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO


RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/adventureworksdw2022.bak';
GO

RESTORE DATABASE AdventureWorksDW2022
FROM DISK = '/var/opt/mssql/backup/adventureworksdw2022.bak'
WITH MOVE 'AdventureWorksDW2022' TO '/var/opt/mssql/data/AdventureWorksDW2022.mdf',
     MOVE 'AdventureWorksDW2022_log' TO '/var/opt/mssql/data/AdventureWorksDW2022_log.ldf';
GO


-- Sales
SELECT * FROM Sales.CountryRegionCurrency;
SELECT * FROM Sales.CreditCard;
SELECT * FROM Sales.Currency;
SELECT * FROM Sales.CurrencyRate;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.PersonCreditCard;
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesOrderHeaderSalesReason;
SELECT * FROM Sales.SalesPerson;
SELECT * FROM Sales.SalesPersonQuotaHistory;
SELECT * FROM Sales.SalesReason;
SELECT * FROM Sales.SalesTaxRate;
SELECT * FROM Sales.SalesTerritory;
SELECT * FROM Sales.SalesTerritoryHistory;
SELECT * FROM Sales.ShoppingCartItem;
SELECT * FROM Sales.SpecialOffer;
SELECT * FROM Sales.SpecialOfferProduct;
SELECT * FROM Sales.Store;

-- Production
SELECT * FROM Production.BillOfMaterials;
SELECT * FROM Production.Culture;
SELECT * FROM Production.Document;
SELECT * FROM Production.Illustration;
SELECT * FROM Production.Location;
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductCostHistory;
SELECT * FROM Production.ProductDescription;
SELECT * FROM Production.ProductDocument;
SELECT * FROM Production.ProductInventory;
SELECT * FROM Production.ProductListPriceHistory;
SELECT * FROM Production.ProductModel;
SELECT * FROM Production.ProductModelIllustration;
SELECT * FROM Production.ProductModelProductDescriptionCulture;
SELECT * FROM Production.ProductPhoto;
SELECT * FROM Production.ProductProductPhoto;
SELECT * FROM Production.ProductReview;
SELECT * FROM Production.ProductSubcategory;
SELECT * FROM Production.ProductVendor;
SELECT * FROM Production.ScrapReason;
SELECT * FROM Production.TransactionHistory;
SELECT * FROM Production.TransactionHistoryArchive;
SELECT * FROM Production.UnitMeasure;
SELECT * FROM Production.WorkOrder;
SELECT * FROM Production.WorkOrderRouting;

-- Person
SELECT * FROM Person.Address;
SELECT * FROM Person.AddressType;
SELECT * FROM Person.BusinessEntity;
SELECT * FROM Person.BusinessEntityAddress;
SELECT * FROM Person.BusinessEntityContact;
SELECT * FROM Person.ContactType;
SELECT * FROM Person.CountryRegion;
SELECT * FROM Person.EmailAddress;
SELECT * FROM Person.Password;
SELECT * FROM Person.Person;
SELECT * FROM Person.PersonPhone;
SELECT * FROM Person.PhoneNumberType;
SELECT * FROM Person.StateProvince;

-- HumanResources
SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;
SELECT * FROM HumanResources.EmployeePayHistory;
SELECT * FROM HumanResources.JobCandidate;
SELECT * FROM HumanResources.Shift;

-- Purchasing
SELECT * FROM Purchasing.ProductVendor;
SELECT * FROM Purchasing.PurchaseOrderDetail;
SELECT * FROM Purchasing.PurchaseOrderHeader;
SELECT * FROM Purchasing.ShipMethod;
SELECT * FROM Purchasing.Vendor;

-- dbo
SELECT * FROM dbo.AWBuildVersion;
SELECT * FROM dbo.DatabaseLog;
SELECT * FROM dbo.ErrorLog;

-- Challenge M1: 
-- Ranking Sales Territories by 
-- Total Sales and Order Volume
-- Business Scenario: The Vice 
-- President of Sales 
-- wants to see a performance leaderboard 
-- of all sales territories. 
-- The ranking should be based 
-- on total sales revenue,
-- but the report must also include 
-- the total number of unique 
-- orders for context.

WITH TerritoryStats AS (
    SELECT
        st.TerritoryID,
        st.Name
        AS TerritoryName,
        SUM(soh.TotalDue)
        AS TotalSalesRevenue,
        COUNT(DISTINCT soh.SalesOrderID) 
        AS TotalUniqueOrders
    FROM Sales.SalesTerritory st
    JOIN Sales.SalesOrderHeader soh
         ON soh.TerritoryID = st.TerritoryID
    GROUP BY st.TerritoryID, st.Name
)
SELECT *
FROM TerritoryStats
ORDER BY TotalSalesRevenue DESC;

-- Challenge M2: 
-- Identifying Products with 
-- Above-Average List 
-- Prices within their Subcategory
-- Business Scenario: 
-- The pricing department needs to 
-- identify premium products. 
-- The request is to find all products
-- whose list price is higher than 
-- the average list price of all 
-- products within their 
-- respective subcategory.

WITH SubCatAvg AS (
    SELECT ProductSubcategoryID,
           AVG(ListPrice) AS AvgListPrice
    FROM Production.Product
    GROUP BY ProductSubcategoryID
)
SELECT p.ProductID,
       p.Name,
       p.ProductSubcategoryID,
       p.ListPrice,
       sca.AvgListPrice
FROM Production.Product p
JOIN SubCatAvg sca
  ON sca.ProductSubcategoryID = p.ProductSubcategoryID
WHERE p.ListPrice > sca.AvgListPrice
ORDER BY p.ProductSubcategoryID, p.ListPrice DESC;

SELECT * FROM Production.Product

-- Challenge M3: 
-- Finding Customers Who Have Not 
-- Placed an Order in the Most 
-- Recent Year of Data
-- Business Scenario: 
-- The marketing team wants to 
-- launch a re-engagement campaign 
-- targeting "dormant" customers. 
-- The task is to identify all customers 
-- who have not made a purchase 
-- in the latest full year 
-- available in the sales data.

WITH LatestYear AS (
    SELECT YEAR(MAX(OrderDate)) AS Yr
    FROM Sales.SalesOrderHeader
),
DormantCustomers AS (
    SELECT c.CustomerID,
           c.AccountNumber,
           c.PersonID
    FROM Sales.Customer c
    WHERE NOT EXISTS (
        SELECT 1
        FROM Sales.SalesOrderHeader soh
        WHERE soh.CustomerID = c.CustomerID
          AND YEAR(soh.OrderDate) = 
          (SELECT Yr FROM LatestYear)
    )
)
SELECT *
FROM DormantCustomers
ORDER BY CustomerID;

-- Challenge M4: 
-- Calculating the Average 
-- Order Value per Salesperson
-- Business Scenario: 
-- Management wants to evaluate 
-- salesperson efficiency. 
-- The request is to provide 
-- a list of all salespeople 
-- and their average revenue per order.

WITH SalesOrderValue AS (
    SELECT
        soh.SalesPersonID,
        soh.TotalDue
    FROM Sales.SalesOrderHeader soh
    WHERE soh.SalesPersonID IS NOT NULL
),
AvgPerSalesPerson AS (
    SELECT
        SalesPersonID,
        COUNT(*)            
        AS OrderCount,
        SUM(TotalDue)       
        AS TotalRevenue,
        AVG(TotalDue)       
        AS AvgOrderValue
    FROM SalesOrderValue
    GROUP BY SalesPersonID
)
SELECT *
FROM AvgPerSalesPerson
ORDER BY AvgOrderValue DESC;

-- Challenge M5: 
-- Listing Employees and Their 
-- Current Department from 
-- Employment History
-- Business Scenario: 
-- Human Resources needs 
-- an up-to-date report 
-- of which department 
-- each employee currently 
-- belongs to, 
-- based on their complete 
-- employment history.

WITH CurrentDept AS (
    SELECT
        e.BusinessEntityID,
        e.NationalIDNumber,
        d.Name AS CurrentDepartment
    FROM HumanResources.Employee e
    JOIN HumanResources.EmployeeDepartmentHistory dh
         ON dh.BusinessEntityID = e.BusinessEntityID
        AND dh.EndDate IS NULL
    JOIN HumanResources.Department d
         ON d.DepartmentID = dh.DepartmentID
)
SELECT *
FROM CurrentDept
ORDER BY BusinessEntityID;



-- Challenge T1: 
-- Year-Over-Year Sales 
-- Growth Analysis by 
-- Product Category
-- Business Scenario: 
-- The executive board requires 
-- a strategic overview of performance. 
-- The task is to calculate the 
-- year-over-year (YoY) sales 
-- growth percentage for 
-- each product category.


WITH SalesByYearCat AS (
    /* revenue per calendar year & category */
    SELECT
        YEAR(soh.OrderDate)
        AS SalesYear,
        pc.ProductCategoryID,
        pc.Name
        AS CategoryName,
        SUM(sod.LineTotal) 
        AS Revenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod 
    ON sod.SalesOrderID 
    = soh.SalesOrderID
    JOIN Production.Product p  
    ON p.ProductID 
    = sod.ProductID
    JOIN Production.ProductSubcategory psc
    ON psc.ProductSubcategoryID 
    = p.ProductSubcategoryID
    JOIN Production.ProductCategory pc
    ON pc.ProductCategoryID 
    = psc.ProductCategoryID
    GROUP BY 
    YEAR(soh.OrderDate), 
    pc.ProductCategoryID, 
    pc.Name
),
YoGGrowth AS (
    /* compare each year to the previous one */
    SELECT
        SalesYear,
        ProductCategoryID,
        CategoryName,
        Revenue,
        LAG(Revenue) 
        OVER (
            PARTITION BY 
            ProductCategoryID
            ORDER BY SalesYear)
        AS PrevYearRevenue,
        CASE
            WHEN 
            LAG(Revenue) OVER (
                PARTITION BY 
                ProductCategoryID
                ORDER BY SalesYear) = 0
            THEN NULL
            ELSE
            ROUND(
                100.0 * (
                    Revenue -
                    LAG(Revenue) 
                    OVER (
                    PARTITION BY 
                    ProductCategoryID
                    ORDER BY SalesYear)
                    )/ NULLIF(
                           LAG(Revenue) 
                           OVER (
                            PARTITION BY 
                            ProductCategoryID
                            ORDER BY 
                            SalesYear)
                            ,0), 2)
        END AS YoYGrowthPct
    FROM SalesByYearCat
)
SELECT *
FROM YoGGrowth
WHERE PrevYearRevenue IS NOT NULL   -- suppress first year
ORDER BY CategoryName, SalesYear;


-- Challenge T2: 
-- Customer Segmentation
-- using RFM (Recency, Frequency, 
-- Monetary) Analysis
-- Business Scenario: 
-- The marketing department 
-- wants to segment customers 
-- based on their 
-- purchasing behavior. 
-- The task is to classify 
-- all customers into segments 
-- (e.g., 'Champions', 
-- 'Loyal', 'At Risk') 
-- using RFM scores.

WITH RFM AS (
    SELECT
        c.CustomerID,
        DATEDIFF(day, 
        MAX(soh.OrderDate), 
        (SELECT MAX(OrderDate) 
        FROM Sales.SalesOrderHeader)) 
        AS Recency,
        COUNT(DISTINCT soh.SalesOrderID)                                                    AS Frequency,
        SUM(soh.TotalDue)                                                                   AS Monetary
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh 
    ON soh.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
),
RFM_Score AS (
    SELECT
        CustomerID,
        NTILE(5) OVER (ORDER BY Recency  DESC) AS R,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F,
        NTILE(5) OVER (ORDER BY Monetary  ASC) AS M
    FROM RFM
),
Segment AS (
    SELECT
        CustomerID,
        R * 100 + F * 10 + M AS RFM_Score,
        CASE
            WHEN R >= 4 AND F >= 4 AND M >= 4 
            THEN 'Champions'
            WHEN R >= 3 AND F >= 3            
            THEN 'Loyal'
            WHEN R <= 2 AND F <= 2            
            THEN 'At Risk'
            ELSE 'Others'
        END AS Segment
    FROM RFM_Score
)
SELECT *
FROM Segment
ORDER BY Segment, CustomerID;


-- Challenge T3: 
-- Calculating the 30-Day 
-- Moving Average of Daily Sales Totals
-- Business Scenario: 
-- The finance team needs to smooth out 
-- daily sales data to identify 
-- underlying trends. The task is 
-- to calculate the 30-day 
-- moving average of total sales revenue.


WITH DailySales AS (
    SELECT
        CAST(OrderDate AS date) AS SaleDate,
        SUM(TotalDue)           AS DailyRevenue
    FROM Sales.SalesOrderHeader
    GROUP BY CAST(OrderDate AS date)
),
MovingAvg AS (
    SELECT
        SaleDate,
        DailyRevenue,
        AVG(DailyRevenue) OVER (
            ORDER BY SaleDate
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) AS MovingAvg30
    FROM DailySales
)
SELECT *
FROM MovingAvg
ORDER BY SaleDate;

-- Challenge T4: 
-- Identifying the Top 3 
-- Best-Selling Products 
-- within Each Sales Territory
-- Business Scenario: 
-- Regional sales managers want to 
-- know which products are driving 
-- the most revenue in their 
-- specific territories.

WITH TerritoryProductSales AS (
    /* revenue per territory-product */
    SELECT
        soh.TerritoryID,
        sod.ProductID,
        SUM(sod.LineTotal) 
        AS ProductRevenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod 
    ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY 
    soh.TerritoryID, 
    sod.ProductID
),
Ranked AS (
    SELECT
        TerritoryID,
        ProductID,
        ProductRevenue,
        DENSE_RANK() 
        OVER (
            PARTITION BY TerritoryID
            ORDER BY ProductRevenue 
            DESC) 
        AS rnk
    FROM TerritoryProductSales
)
SELECT TerritoryID, ProductID, ProductRevenue
FROM Ranked
WHERE rnk <= 3
ORDER BY TerritoryID, rnk;


-- Challenge T5: 
-- Analyzing Salesperson Performance 
-- Against Their Quota History
-- Business Scenario: 
-- Sales leadership needs to 
-- see how salespeople are 
-- performing relative to 
-- their assigned quotas for each period. 
-- This analysis leverages 
-- the database's purpose-built 
-- history tables.

WITH QuotaSales AS (
    SELECT
        p.BusinessEntityID,
        p.FirstName + ' ' + p.LastName       
        AS SalesPerson,
        DATEADD(month, DATEDIFF(month, 0, q.QuotaDate), 0) 
        AS PeriodStart,
        q.SalesQuota                         
        AS Quota,
        COALESCE(SUM(soh.TotalDue), 0)       
        AS ActualSales
    FROM Sales.SalesPerson sp
    JOIN Person.Person p
        ON p.BusinessEntityID 
        = sp.BusinessEntityID
    JOIN Sales.SalesPersonQuotaHistory q
        ON q.BusinessEntityID 
        = sp.BusinessEntityID
    LEFT JOIN Sales.SalesOrderHeader soh
        ON soh.SalesPersonID 
        = sp.BusinessEntityID
       AND soh.OrderDate >= q.QuotaDate
       AND soh.OrderDate <  DATEADD(month, 1, q.QuotaDate)
    GROUP BY
        p.BusinessEntityID, p.FirstName, p.LastName,
        DATEADD(month, DATEDIFF(month, 0, q.QuotaDate), 0),
        q.SalesQuota
)
SELECT *
FROM QuotaSales
ORDER BY SalesPerson, PeriodStart;


-- Challenge T6: 
-- Finding the Second Order 
-- Date for Every Customer
-- Business Scenario: 
-- The customer analytics team 
-- wants to measure the time 
-- it takes for a new customer 
-- to become a repeat customer. 
-- The task is to find the date 
-- of the second order for every customer.

WITH SecondOrder AS (
    SELECT
        CustomerID,
        OrderDate,
        ROW_NUMBER() 
        OVER (
            PARTITION BY CustomerID 
            ORDER BY OrderDate) 
        AS rn
    FROM Sales.SalesOrderHeader
)
SELECT CustomerID, OrderDate AS SecondOrderDate
FROM SecondOrder
WHERE rn = 2
ORDER BY CustomerID;

-- Challenge T7: 
-- Correlating Special Offer 
-- Campaigns with Product Sales Lift
-- Business Scenario: 
-- The marketing team wants 
-- to know if their "Volume Discount" 
-- campaign actually increased 
-- sales for the targeted products. 
-- The task is to compare the 
-- average daily sales of products 
-- during a special offer period 
-- to their average daily sales 
-- outside of any offer period.

WITH OfferPeriod AS (
    /* map every product to its “Volume Discount” date range */
    SELECT
        sop.ProductID,
        MIN(so.StartDate) AS OfferStart,
        MAX(so.EndDate)   AS OfferEnd
    FROM Sales.SpecialOffer so
    JOIN Sales.SpecialOfferProduct sop ON sop.SpecialOfferID = so.SpecialOfferID
    WHERE so.Description LIKE '%Volume Discount%'
    GROUP BY sop.ProductID
),
DailySales AS (
    /* daily sales per product, flagging offer days */
    SELECT
        sod.ProductID,
        CAST(soh.OrderDate AS date) AS SaleDay,
        SUM(sod.LineTotal)          AS SalesAmt,
        CASE WHEN op.ProductID IS NOT NULL
                  AND soh.OrderDate BETWEEN op.OfferStart AND op.OfferEnd
             THEN 1 ELSE 0 END     AS InOffer
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID
    LEFT JOIN OfferPeriod op        ON op.ProductID = sod.ProductID
    GROUP BY sod.ProductID,
             CAST(soh.OrderDate AS date),
             CASE WHEN op.ProductID IS NOT NULL
                       AND soh.OrderDate BETWEEN op.OfferStart AND op.OfferEnd
                  THEN 1 ELSE 0 END
),
Lift AS (
    SELECT
        ProductID,
        AVG(CASE WHEN InOffer = 1 THEN SalesAmt END) AS AvgDailyDuring,
        AVG(CASE WHEN InOffer = 0 THEN SalesAmt END) AS AvgDailyOutside
    FROM DailySales
    GROUP BY ProductID
)
SELECT
    ProductID,
    AvgDailyDuring,
    AvgDailyOutside,
    ROUND(100.0 * (AvgDailyDuring - AvgDailyOutside) / NULLIF(AvgDailyOutside, 0), 2) AS LiftPct
FROM Lift
ORDER BY LiftPct DESC;


-- Challenge T8: 
-- Recursive Employee Hierarchy: 
-- Listing All Subordinates for a Given Manager
-- Business Scenario: 
-- An organizational chart tool 
-- needs to be populated. 
-- For a specific high-level manager, 
-- generate a list of all employees 
-- who report to them, 
-- directly or indirectly, 
-- down the entire chain of command. 
-- This is a classic hierarchical problem 
-- that leverages the self-referencing 
-- nature of the Employee table. 

DECLARE @ManagerID int = 2;   -- top manager to start from

WITH Org AS (
    /* seed */
    SELECT BusinessEntityID, NationalIDNumber, JobTitle, OrganizationNode, 0 AS Lvl
    FROM HumanResources.Employee
    WHERE BusinessEntityID = @ManagerID

    UNION ALL

    /* subordinates */
    SELECT e.BusinessEntityID,
           e.NationalIDNumber,
           e.JobTitle,
           e.OrganizationNode,
           o.Lvl + 1
    FROM HumanResources.Employee e
    JOIN Org o
        ON e.OrganizationNode.GetAncestor(1) = o.OrganizationNode
)
SELECT *
FROM Org
WHERE Lvl > 0
ORDER BY Lvl, BusinessEntityID;


-- Challenge T9: 
-- Recursive Product Assembly: 
-- Full Bill of Materials (BOM) Explosion
-- Business Scenario: 
-- The production planning team 
-- needs to know every single component 
-- (and sub-component) 
-- required to build a specific bicycle, 
-- along with the total quantity 
-- of each base component needed. 
-- This query "explodes" a finished product 
-- into its constituent parts, 
-- leveraging the hierarchical 
-- structure of the BillOfMaterials table.  


DECLARE @ProductID int = 749;   -- AdventureWorks “Road-650 Black, 58”

WITH BOM AS (
    /* anchor = top-level product */
    SELECT
        ProductAssemblyID = @ProductID,
        ComponentID       = @ProductID,
        PerAssemblyQty    = CAST(1 AS decimal(8,2)),
        BomLevel          = 0
    UNION ALL
    /* recursive = explode sub-assemblies */
    SELECT
        b.ComponentID,
        bm.ComponentID,
        CAST(b.PerAssemblyQty * bm.PerAssemblyQty AS decimal(8,2)),
        b.BomLevel + 1
    FROM BOM b
    JOIN Production.BillOfMaterials bm
        ON bm.ProductAssemblyID = b.ComponentID
       AND bm.EndDate IS NULL        -- only active BOM rows
)
SELECT
    ComponentID,
    SUM(PerAssemblyQty) AS TotalQty
FROM BOM
WHERE BomLevel > 0          -- exclude the top assembly
GROUP BY ComponentID
ORDER BY ComponentID;

-- Challenge T10: 
-- Identifying "Churned" 
-- High-Value Customers 
-- and Their Last Purchase Details
-- Business Scenario: 
-- The customer retention team 
-- wants to analyze its most valuable 
-- customers who have recently 
-- stopped purchasing. 
-- The task is to identify the 
-- top 10% of customers by 
-- lifetime value who have not 
-- ordered in the last 6 months, 
-- and show their last order date 
-- and the total value of that last order.

DECLARE @Cutoff date = DATEADD(month, -6, (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader));

WITH Lifetime AS (
    SELECT
        c.CustomerID,
        SUM(soh.TotalDue) AS LifetimeValue,
        MAX(soh.OrderDate) AS LastOrderDate
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON soh.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
),
Churners AS (
    SELECT *,
           PERCENT_RANK() OVER (ORDER BY LifetimeValue DESC) AS pr
    FROM Lifetime
    WHERE LastOrderDate < @Cutoff
)
SELECT
    CustomerID,
    LastOrderDate,
    LifetimeValue      AS LastOrderTotalValue
FROM Churners
WHERE pr <= 0.10          -- top 10 %
ORDER BY LifetimeValue DESC;