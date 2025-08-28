
-- ADVENTURE WORK || CTEs Mastery

-- Core sales model
SELECT * FROM sales LIMIT 10;
SELECT * FROM salesperson LIMIT 10;
SELECT * FROM salespersonregion LIMIT 10;
SELECT * FROM region LIMIT 10;
SELECT * FROM reseller LIMIT 10;
SELECT * FROM product LIMIT 10;
SELECT * FROM targets LIMIT 10;

-- Newly added / supporting tables
SELECT * FROM billofmaterials LIMIT 10;
SELECT * FROM salesorderdetail LIMIT 10;
SELECT * FROM employee LIMIT 10;
SELECT * FROM employee_dept_hist LIMIT 10;
SELECT * FROM department LIMIT 10;
SELECT * FROM specialoffer LIMIT 10;
SELECT * FROM specialofferproduct LIMIT 10;


-- ALTERING THE TABLES

ALTER TABLE sales
  ALTER COLUMN sales TYPE numeric
  USING REPLACE(REPLACE(sales, '$', ''), ',', '')::numeric;

ALTER TABLE sales
  ALTER COLUMN cost TYPE numeric
  USING REPLACE(REPLACE(cost, '$', ''), ',', '')::numeric;

ALTER TABLE sales
  ALTER COLUMN unit_price TYPE numeric
  USING REPLACE(REPLACE(unit_price, '$', ''), ',', '')::numeric;

ALTER TABLE product
  ALTER COLUMN standard_cost TYPE numeric
  USING REPLACE(REPLACE(standard_cost, '$', ''), ',', '')::numeric;

ALTER TABLE targets
  ALTER COLUMN target TYPE numeric
  USING REPLACE(REPLACE(target, '$', ''), ',', '')::numeric;

ALTER TABLE sales
  ALTER COLUMN orderdate TYPE date
  USING orderdate::date;

-- SALES ORDER DETAIL
ALTER TABLE salesorderdetail
  ALTER COLUMN specialofferid TYPE int USING specialofferid::int,
  ALTER COLUMN productid TYPE int USING productid::int;


-- EMPLOYEE
ALTER TABLE employee
  ALTER COLUMN birthdate TYPE date USING birthdate::date,
  ALTER COLUMN hiredate TYPE date USING hiredate::date,
  ALTER COLUMN salariedflag TYPE boolean USING (salariedflag::text IN ('1','t','true','Y')),
  ALTER COLUMN vacationhours TYPE integer USING vacationhours::integer,
  ALTER COLUMN sickleavehours TYPE integer USING sickleavehours::integer,
  ALTER COLUMN currentflag TYPE boolean USING (currentflag::text IN ('1','t','true','Y')),
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;

-- EMPLOYEE DEPARTMENT HISTORY
ALTER TABLE employee_dept_hist
  ALTER COLUMN startdate TYPE date USING startdate::date,
  ALTER COLUMN enddate TYPE date USING NULLIF(enddate, '')::date,
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;

-- DEPARTMENT
ALTER TABLE department
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;

-- SPECIAL OFFER
ALTER TABLE specialoffer
  ALTER COLUMN discountpct TYPE numeric USING REPLACE(discountpct, '%','')::numeric,
  ALTER COLUMN startdate TYPE date USING startdate::date,
  ALTER COLUMN enddate TYPE date USING enddate::date,
  ALTER COLUMN minqty TYPE integer USING minqty::integer,
  ALTER COLUMN maxqty TYPE integer USING NULLIF(maxqty,'')::integer,
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;

-- SPECIAL OFFER PRODUCT
ALTER TABLE specialofferproduct
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;

-- SALES ORDER DETAIL
ALTER TABLE salesorderdetail
  ALTER COLUMN orderqty TYPE integer USING orderqty::integer,
  ALTER COLUMN unitprice TYPE numeric USING REPLACE(REPLACE(unitprice,'$',''),',','')::numeric,
  ALTER COLUMN unitpricediscount TYPE numeric USING REPLACE(REPLACE(unitpricediscount,'$',''),',','')::numeric,
  ALTER COLUMN linetotal TYPE numeric USING REPLACE(REPLACE(linetotal,'$',''),',','')::numeric,
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;

-- BILL OF MATERIALS
ALTER TABLE billofmaterials
  ALTER COLUMN startdate TYPE date USING startdate::date,
  ALTER COLUMN enddate TYPE date USING NULLIF(enddate,'')::date,
  ALTER COLUMN perassemblyqty TYPE numeric USING perassemblyqty::numeric,
  ALTER COLUMN modifieddate TYPE timestamp USING modifieddate::timestamp;




-- Challenge M1: 
-- Ranking Sales Territories by 
-- Total Sales and Order Volume
-- Business Scenario: The Vice President of Sales 
-- wants to see a performance leaderboard 
-- of all sales territories. 
-- The ranking should be based on total sales revenue,
-- but the report must also include 
-- the total number of unique orders for context.

WITH territory_stats AS (
  SELECT
    s.salesterritorykey,
    r.region,
    r.country,
    SUM(s.sales)                       AS total_sales,
    COUNT(DISTINCT s.salesordernumber) AS unique_orders
  FROM sales s
  LEFT JOIN region r
    ON s.salesterritorykey = r.salesterritorykey
  GROUP BY s.salesterritorykey, r.region, r.country
)
SELECT
  salesterritorykey,
  region,
  country,
  total_sales,
  unique_orders,
  RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM territory_stats
ORDER BY sales_rank, salesterritorykey;


-- Challenge M2: 
-- Identifying Products with Above-Average List 
-- Prices within their Subcategory
-- Business Scenario: 
-- The pricing department needs to 
-- identify premium products. 
-- The request is to find all products
-- whose list price is higher than 
-- the average list price of all 
-- products within their 
-- respective subcategory.


WITH sub_avg AS (
  SELECT subcategory, AVG(standard_cost) AS avg_cost
  FROM product
  GROUP BY subcategory
)
SELECT 
  p.productkey,
  p.product,
  p.subcategory,
  p.category,
  p.standard_cost,
  a.avg_cost
FROM product p
JOIN sub_avg a 
  ON p.subcategory = a.subcategory
WHERE p.standard_cost > a.avg_cost
ORDER BY p.subcategory, p.product;

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


WITH latest_year AS (
  SELECT MAX(EXTRACT(YEAR FROM orderdate))::int AS y
  FROM sales
),
resellers_with_orders AS (
  SELECT DISTINCT s.resellerkey
  FROM sales s
  JOIN latest_year ly 
    ON EXTRACT(YEAR FROM s.orderdate)::int = ly.y
)
SELECT 
  r.resellerkey,
  r.reseller,
  r.country_region
FROM reseller r
LEFT JOIN resellers_with_orders o 
  ON r.resellerkey = o.resellerkey
WHERE o.resellerkey IS NULL
ORDER BY r.reseller;

-- Challenge M4: 
-- Calculating the Average 
-- Order Value per Salesperson
-- Business Scenario: 
-- Management wants to evaluate 
-- salesperson efficiency. 
-- The request is to provide 
-- a list of all salespeople 
-- and their average revenue per order.

WITH order_totals AS (
  SELECT
    s.employeekey,
    s.salesordernumber,
    SUM(s.sales) AS order_total
  FROM sales s
  GROUP BY s.employeekey, s.salesordernumber
)
SELECT
  sp.employeekey,
  sp.employeeid,
  sp.salesperson,
  AVG(o.order_total) AS avg_order_value
FROM order_totals o
JOIN salesperson sp 
  ON o.employeekey = sp.employeekey
GROUP BY sp.employeekey, sp.employeeid, sp.salesperson
ORDER BY avg_order_value DESC;

-- Challenge M5: 
-- Listing Employees and Their 
-- Current Department from Employment History
-- Business Scenario: 
-- Human Resources needs an up-to-date 
-- report of which department 
-- each employee currently belongs to, 
-- based on their complete employment history.

WITH current_dept AS (
    SELECT
        edh.businessentityid,
        edh.departmentid,
        d.name AS department_name,
        d.groupname,
        ROW_NUMBER() OVER (PARTITION BY edh.businessentityid ORDER BY edh.startdate DESC) AS rn
    FROM employee_dept_hist edh
    JOIN department d
      ON edh.departmentid = d.departmentid
    WHERE edh.enddate IS NULL
)
SELECT
    e.businessentityid,
    e.jobtitle,
    e.hiredate,
    c.department_name,
    c.groupname
FROM employee e
LEFT JOIN current_dept c
  ON e.businessentityid = c.businessentityid
WHERE c.rn = 1
ORDER BY e.businessentityid;



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


WITH sales_by_cat_year AS (
  SELECT
    p.category,
    EXTRACT(YEAR FROM s.orderdate)::int AS yr,
    SUM(s.sales) AS revenue
  FROM sales s
  JOIN product p 
    ON s.productkey = p.productkey
  GROUP BY p.category, yr
)
SELECT
  category,
  yr,
  revenue,
  LAG(revenue) OVER (PARTITION BY category ORDER BY yr) AS prev_revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (PARTITION BY category ORDER BY yr))
    / NULLIF(LAG(revenue) OVER (PARTITION BY category ORDER BY yr), 0) * 100.0,
    2
  ) AS yoy_pct
FROM sales_by_cat_year
ORDER BY category, yr;

-- Challenge T2: Customer Segmentation
-- using RFM (Recency, Frequency, Monetary) Analysis
-- Business Scenario: 
-- The marketing department wants to segment customers 
-- based on their purchasing behavior. 
-- The task is to classify 
-- all customers into segments 
-- (e.g., 'Champions', 'Loyal', 'At Risk') 
-- using RFM scores.

-- Reference date = most recent order
WITH ref AS (
  SELECT MAX(orderdate) AS ref_date FROM sales
),
cust AS (
  SELECT
    r.resellerkey,
    r.reseller,
    MAX(s.orderdate)                          AS last_order_date,
    COUNT(DISTINCT s.salesordernumber)        AS frequency,
    COALESCE(SUM(s.sales), 0)                 AS monetary
  FROM reseller r
  LEFT JOIN sales s 
    ON r.resellerkey = s.resellerkey
  GROUP BY r.resellerkey, r.reseller
),
rfm AS (
  SELECT
    c.*,
    (ref.ref_date - c.last_order_date) AS recency_days,
    NTILE(5) OVER (ORDER BY (ref.ref_date - c.last_order_date)) AS r_score,
    NTILE(5) OVER (ORDER BY frequency) AS f_score,
    NTILE(5) OVER (ORDER BY monetary)  AS m_score
  FROM cust c, ref
)
SELECT
  resellerkey,
  reseller,
  recency_days,
  frequency,
  monetary,
  r_score, f_score, m_score,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
    WHEN r_score >= 4 AND f_score >= 3                 THEN 'Loyal'
    WHEN r_score = 3  AND m_score >= 4                 THEN 'Big Spenders'
    WHEN r_score <= 2 AND f_score >= 3                 THEN 'At Risk'
    WHEN r_score <= 2 AND f_score <= 2                 THEN 'Churn Risk'
    ELSE 'Potential'
  END AS segment
FROM rfm
ORDER BY segment, monetary DESC;


-- Challenge T3: 
-- Calculating the 30-Day 
-- Moving Average of Daily Sales Totals
-- Business Scenario: 
-- The finance team needs to smooth out 
-- daily sales data to identify 
-- underlying trends. The task is 
-- to calculate the 30-day 
-- moving average of total sales revenue.
WITH daily AS (
  SELECT 
    orderdate::date AS day,
    SUM(sales) AS daily_sales
  FROM sales
  GROUP BY orderdate::date
)
SELECT
  day,
  daily_sales,
  ROUND(
    AVG(daily_sales) OVER (
      ORDER BY day
      ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2
  ) AS ma_30d
FROM daily
ORDER BY day;

-- Challenge T4: 
-- Identifying the Top 3 
-- Best-Selling Products 
-- within Each Sales Territory
-- Business Scenario: 
-- Regional sales managers want to 
-- know which products are driving 
-- the most revenue in their specific territories.
WITH prod_rev AS (
  SELECT 
    s.salesterritorykey,
    s.productkey,
    SUM(s.sales) AS revenue
  FROM sales s
  GROUP BY s.salesterritorykey, s.productkey
),
ranked AS (
  SELECT
    pr.*,
    ROW_NUMBER() OVER (
      PARTITION BY salesterritorykey 
      ORDER BY revenue DESC
    ) AS rn
  FROM prod_rev pr
)
SELECT
  r.salesterritorykey,
  r.region,
  r.country,
  p.product,
  ranked.revenue
FROM ranked
JOIN region r 
  ON ranked.salesterritorykey = r.salesterritorykey
JOIN product p 
  ON ranked.productkey = p.productkey
WHERE rn <= 3
ORDER BY r.salesterritorykey, rn;

-- Challenge T5: 
-- Analyzing Salesperson Performance 
-- Against Their Quota History
-- Business Scenario: 
-- Sales leadership needs to 
-- see how salespeople are 
-- performing relative to 
-- their assigned quotas for each period. 
-- This analysis leverages 
-- the database's purpose-built history tables.
WITH monthly_sales AS (
  SELECT
    sp.employeeid,
    date_trunc('month', s.orderdate)::date AS month,
    SUM(s.sales) AS revenue
  FROM sales s
  JOIN salesperson sp 
    ON s.employeekey = sp.employeekey
  GROUP BY sp.employeeid, month
),
targets_norm AS (
  SELECT
    employeeid,
    to_date(targetmonth, 'FMDay, FMMonth DD, YYYY') AS month,
    target AS target_value
  FROM targets
),
combined AS (
  SELECT
    COALESCE(ms.employeeid, tn.employeeid) AS employeeid,
    COALESCE(ms.month, tn.month)           AS month,
    COALESCE(ms.revenue, 0)                AS revenue,
    COALESCE(tn.target_value, 0)           AS target_value
  FROM monthly_sales ms
  FULL JOIN targets_norm tn
    ON ms.employeeid = tn.employeeid
   AND ms.month = tn.month
)
SELECT
  c.employeeid,
  sp.salesperson,
  c.month,
  c.revenue,
  c.target_value,
  CASE WHEN c.target_value = 0 THEN NULL
       ELSE ROUND((c.revenue - c.target_value) / c.target_value * 100.0, 2)
  END AS pct_to_quota
FROM combined c
LEFT JOIN salesperson sp 
  ON sp.employeeid = c.employeeid
ORDER BY c.employeeid, c.month;

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
WITH orders AS (
  SELECT DISTINCT 
    resellerkey, 
    salesordernumber, 
    orderdate
  FROM sales
),
ranked AS (
  SELECT
    o.resellerkey,
    o.orderdate,
    ROW_NUMBER() OVER (
      PARTITION BY o.resellerkey 
      ORDER BY o.orderdate
    ) AS rn
  FROM orders o
)
SELECT
  re.resellerkey,
  re.reseller,
  r.orderdate AS second_order_date
FROM ranked r
JOIN reseller re 
  ON r.resellerkey = re.resellerkey
WHERE r.rn = 2
ORDER BY second_order_date;

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
SELECT
    s.specialofferid,
    s.description AS offer_description,
    s.discountpct,
    p.productkey,
    p.product AS product_name,
    SUM(sod.orderqty::int) AS total_qty,
    SUM(sod.linetotal::numeric) AS total_sales
FROM salesorderdetail sod
JOIN specialoffer s
  ON sod.specialofferid::int = s.specialofferid
JOIN product p
  ON sod.productid::int = p.productkey
JOIN specialofferproduct sop
  ON sop.productid = p.productkey
GROUP BY s.specialofferid, s.description, s.discountpct, p.productkey, p.product
ORDER BY total_sales DESC;


SELECT * FROM product LIMIT 5;

SELECT DISTINCT productid
FROM salesorderdetail
LIMIT 10;


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
SELECT
    e.businessentityid,
    e.jobtitle,
    d.name AS department_name,
    d.groupname,
    edh.startdate::date,
    COALESCE(
        CASE 
            WHEN edh.enddate ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN edh.enddate::date 
        END,
        CURRENT_DATE
    ) AS enddate,
    EXTRACT(
        YEAR FROM AGE(
            COALESCE(
                CASE 
                    WHEN edh.enddate ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN edh.enddate::date 
                END,
                CURRENT_DATE
            ), 
            edh.startdate::date
        )
    ) AS years_in_dept
FROM employee e
JOIN employee_dept_hist edh
  ON e.businessentityid = edh.businessentityid
JOIN department d
  ON edh.departmentid = d.departmentid
WHERE edh.startdate ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
ORDER BY e.businessentityid, edh.startdate::date;


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


-- This shows each product and its direct components:
SELECT
    b.productassemblyid,
    p1.product AS finished_product,
    b.componentid,
    p2.product AS component_product,
    b.perassemblyqty::numeric,
    b.startdate::date,
    COALESCE(NULLIF(b.enddate,'')::date, CURRENT_DATE) AS enddate
FROM billofmaterials b
JOIN product p1
  ON (b.productassemblyid::text ~ '^[0-9]+$' AND b.productassemblyid::int = p1.productkey)
JOIN product p2
  ON (b.componentid::text ~ '^[0-9]+$' AND b.componentid::int = p2.productkey)
WHERE b.productassemblyid::text ~ '^[0-9]+$'
  AND b.componentid::text ~ '^[0-9]+$'
ORDER BY b.productassemblyid::int, b.componentid::int;

--Which components appear most frequently across assemblies:
SELECT
    p2.product AS component_product,
    COUNT(DISTINCT b.productassemblyid::int) AS used_in_products,
    SUM(b.perassemblyqty::numeric) AS total_quantity_required
FROM billofmaterials b
JOIN product p2
  ON (b.componentid::text ~ '^[0-9]+$' AND b.componentid::int = p2.productkey)
WHERE b.componentid::text ~ '^[0-9]+$'
  AND b.productassemblyid::text ~ '^[0-9]+$'
GROUP BY p2.product
ORDER BY used_in_products DESC, total_quantity_required DESC;


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
WITH ref AS (
  SELECT MAX(orderdate) AS ref_date FROM sales
),
ltv AS (
  SELECT resellerkey, SUM(sales) AS ltv
  FROM sales
  GROUP BY resellerkey
),
cutoff AS (
  SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY ltv) AS p90
  FROM ltv
),
last_order_by_number AS (
  SELECT
    s.resellerkey,
    s.salesordernumber,
    MAX(s.orderdate) AS last_order_date
  FROM sales s
  GROUP BY s.resellerkey, s.salesordernumber
),
last_per_customer AS (
  SELECT DISTINCT ON (l.resellerkey)
    l.resellerkey, l.salesordernumber, l.last_order_date
  FROM last_order_by_number l
  ORDER BY l.resellerkey, l.last_order_date DESC
),
last_order_value AS (
  SELECT
    lpc.resellerkey,
    lpc.last_order_date,
    SUM(s.sales) AS last_order_total
  FROM last_per_customer lpc
  JOIN sales s
    ON s.resellerkey = lpc.resellerkey
   AND s.salesordernumber = lpc.salesordernumber
  GROUP BY lpc.resellerkey, lpc.last_order_date
)
SELECT
  re.resellerkey,
  re.reseller,
  l.ltv,
  lov.last_order_date,
  lov.last_order_total
FROM ltv l
JOIN cutoff c 
  ON l.ltv >= c.p90
JOIN last_order_value lov 
  ON l.resellerkey = lov.resellerkey
JOIN reseller re 
  ON re.resellerkey = l.resellerkey
JOIN ref
  ON TRUE
WHERE lov.last_order_date < ref.ref_date - INTERVAL '6 months'
ORDER BY l.ltv DESC;
