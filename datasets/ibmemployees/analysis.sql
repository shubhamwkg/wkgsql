
-- IMB EMPLOYEES DATA || WINDOW FUNCTIONS QUERIES

-- Query 1: Ranking Employee Salaries 
-- Within Each Department
-- * Business Question: 
-- "How does each employee's monthly income 
-- rank within their respective department? 
-- Show the difference between 
-- ROW_NUMBER, RANK, and DENSE_RANK."
-- * Window Function(s) Used: 
-- ROW_NUMBER(), RANK(), DENSE_RANK()
SELECT 
    "Department",
    "MonthlyIncome",
    ROW_NUMBER() OVER(
        PARTITION BY "Department" 
        ORDER BY "MonthlyIncome" DESC
    ) as row_num,
    RANK() OVER(
        PARTITION BY "Department" 
        ORDER BY "MonthlyIncome" DESC
    ) as rnk,
    DENSE_RANK() OVER(
        PARTITION BY "Department" 
        ORDER BY "MonthlyIncome" DESC
    ) as dense_rnk
FROM attrition
ORDER BY "Department"

-- Query 2: Comparing Individual Income to 
-- the Department Average
-- * Business Question: "For each employee, 
-- show their monthly income alongside 
-- the average monthly income for their department, 
-- and calculate the difference."
-- * Window Function(s) Used: AVG()
SELECT 
    a."EmployeeNumber", 
    a."MonthlyIncome", 
    av.avg_income 
    AS department_avg_income,
    (av.avg_income - a."MonthlyIncome") 
    AS difference
FROM attrition a 
JOIN (
    SELECT
        "Department",
        AVG("MonthlyIncome") as avg_income
    FROM attrition
    GROUP BY "Department"
) av ON a."Department" = av."Department"

-- Query 3: Identifying the Top 3 Employees 
-- by Salary Hike per Department
-- * Business Question: 
-- "Who are the three employees 
-- who received the highest 
-- percentage salary hike 
-- in each department?"
-- * Window Function(s) Used: 
-- RANK(), Common Table Expression (CTE)

WITH cte AS (
    SELECT 
        "EmployeeNumber",
        "PercentSalaryHike",
        "Department",
        RANK() OVER(
            PARTITION BY "Department" 
            ORDER BY "PercentSalaryHike" DESC
        ) AS rnk
    FROM attrition
)
SELECT *
FROM cte
WHERE rnk <= 3;

-- Query 4: Assigning Employees 
-- to Salary Quartiles
-- * Business Question: 
-- "Divide employees within
-- each job level into four salary quartiles 
-- to understand income distribution."
-- * Window Function(s) Used: NTILE(4)
SELECT 
    "JobLevel",
    NTILE(4) OVER(
        PARTITION BY "JobLevel" 
        ORDER BY "MonthlyIncome" DESC
    ) AS salary_quartile,
    "MonthlyIncome",
    "EmployeeNumber"
FROM attrition
ORDER BY 
    "JobLevel", 
    salary_quartile, 
    "MonthlyIncome" DESC

-- Query 5: Displaying Department Headcount 
-- on Each Employee Row
-- * Business Question: 
-- "For each employee, 
-- show the total number of people 
-- who work in their department."
-- * Window Function(s) Used: COUNT()

SELECT a."EmployeeNumber",
        hc.dept_headcount, 
        a."Department"
FROM attrition a 
    JOIN (SELECT "Department", 
        COUNT(1) AS dept_headcount
        FROM attrition
        GROUP BY "Department") hc 
    ON a."Department" = hc."Department"

-- Query 6: Calculating the Salary Gap 
-- to the Next Highest-Paid Colleague
-- * Business Question: "Within each 
-- department, what is the salary 
-- difference between each employee 
-- and the person who is paid 
-- just above them?"
-- * Window Function(s) Used: LAG()

SELECT 
    "EmployeeNumber",
    "Department",
    "MonthlyIncome",
    LAG("MonthlyIncome") OVER (
        PARTITION BY "Department"
        ORDER BY "MonthlyIncome" DESC
    ) AS next_higher_salary,
    LAG("MonthlyIncome") OVER (
        PARTITION BY "Department"
        ORDER BY "MonthlyIncome" DESC
    ) - "MonthlyIncome" AS salary_gap
FROM attrition
ORDER BY "Department", "MonthlyIncome" DESC;

-- Query 7: Comparing an Employee's Salary 
-- to the Department's Highest Earner
-- * Business Question: "For every employee, 
-- show their salary next to the 
-- absolute highest salary in their department."
-- * Window Function(s) Used: FIRST_VALUE()

SELECT 
    "EmployeeNumber",
    "Department",
    "MonthlyIncome",
    FIRST_VALUE("MonthlyIncome") OVER (
        PARTITION BY "Department"
        ORDER BY "MonthlyIncome" DESC
    ) AS highest_salary_in_dept,
    "MonthlyIncome" - FIRST_VALUE("MonthlyIncome") OVER (
        PARTITION BY "Department"
        ORDER BY "MonthlyIncome" DESC
    ) AS gap_from_top
FROM attrition;

-- Query 8: Calculating 
-- a 3-Person Moving Average 
-- of Job Satisfaction by Tenure
-- * Business Question: 
-- "To smooth out fluctuations, 
-- what is the 3-person moving 
-- average of job satisfaction scores, 
-- ordered by tenure (YearsAtCompany), 
-- within each job role?"
-- * Window Function(s) Used: 
-- AVG() with a framing clause
SELECT 
    "EmployeeNumber",
    "JobRole",
    "YearsAtCompany",
    "JobSatisfaction",
    AVG("JobSatisfaction") OVER (
        PARTITION BY "JobRole"
        ORDER BY "YearsAtCompany"
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_3_person
FROM attrition
ORDER BY "JobRole", "YearsAtCompany";

-- Query 9: Identifying Employees 
-- Earning Less Than the Previous 
-- Hire in Their Role
-- * Business Question: 
-- "Are there instances where
-- a new hire in a specific job role 
-- is earning less than the person 
-- hired just before them? 
-- (Assuming EmployeeNumber 
-- approximates hiring order)."
-- * Window Function(s) Used: LAG()

WITH hiring_sequence AS (
    SELECT 
        "EmployeeNumber",
        "JobRole",
        "MonthlyIncome",
        LAG("EmployeeNumber") OVER (
            PARTITION BY "JobRole"
            ORDER BY "EmployeeNumber"
        ) AS prev_employee_num,
        LAG("MonthlyIncome") OVER (
            PARTITION BY "JobRole"
            ORDER BY "EmployeeNumber"
        ) AS prev_hire_salary
    FROM attrition
)
SELECT 
    "EmployeeNumber" 
    AS current_employee,
    "JobRole",
    "MonthlyIncome" 
    AS current_salary,
    prev_employee_num 
    AS previous_employee,
    prev_hire_salary 
    AS previous_salary,
    (prev_hire_salary - "MonthlyIncome") 
    AS salary_reduction
FROM hiring_sequence
WHERE prev_hire_salary IS NOT NULL
    AND "MonthlyIncome" < prev_hire_salary
ORDER BY "JobRole", "EmployeeNumber";


-- Query 10: Calculating Each Employee's 
-- Contribution to Departmental Salary
-- * Business Question: "What percentage 
-- of the total departmental salary 
-- budget does each employee's 
-- monthly income represent?"
-- * Window Function(s) Used: SUM()

SELECT 
    "EmployeeNumber", 
    "Department", 
    "MonthlyIncome",
    ROUND(
        ("MonthlyIncome" * 100.0 / NULLIF(
            SUM("MonthlyIncome") OVER(
                PARTITION BY "Department"
                ), 0))::NUMERIC,
        2
    ) AS percent_of_dept
FROM attrition
ORDER BY "Department", percent_of_dept DESC;


-- Query 11: Finding the Most Recently 
-- Promoted Employee in Each Department
-- * Business Question: 
-- "For each department, 
-- who is the employee with 
-- the fewest years since 
-- their last promotion?"
-- * Window Function(s) Used: FIRST_VALUE()


WITH promoted_employees AS (
    SELECT 
        "Department",
        "EmployeeNumber",
        "YearsSinceLastPromotion",
        FIRST_VALUE("EmployeeNumber") OVER (
            PARTITION BY "Department"
            ORDER BY "YearsSinceLastPromotion"
        ) AS most_recently_promoted_employee,
        FIRST_VALUE("YearsSinceLastPromotion") OVER (
            PARTITION BY "Department"
            ORDER BY "YearsSinceLastPromotion"
        ) AS min_years_since_promotion
    FROM attrition
    WHERE "YearsSinceLastPromotion" IS NOT NULL
)
SELECT 
    "Department",
    "EmployeeNumber",
    "YearsSinceLastPromotion"
FROM promoted_employees
WHERE "EmployeeNumber" = most_recently_promoted_employee
ORDER BY "Department";

-- Query 12: Ranking Departments 
-- by Their Highest Individual Salary Hike
-- * Business Question: 
-- "Which department gave the 
-- single largest percentage salary 
-- hike to an individual employee, 
-- and what was that percentage?"
-- * Window Function(s) Used: MAX(), DENSE_RANK()


WITH department_max_hikes AS (
    SELECT 
        "Department",
        MAX("PercentSalaryHike") 
        AS max_hike
    FROM attrition
    GROUP BY "Department"
)
SELECT 
    dmh."Department",
    dmh.max_hike,
    DENSE_RANK() OVER(
        ORDER BY dmh.max_hike DESC
        ) AS dept_rank
FROM department_max_hikes dmh
ORDER BY dept_rank;

-- Query 13: Identifying Junior Employees 
-- Earning More Than Senior Averages
-- * Business Question: 
-- "Find all employees at Job Level 1 
-- whose monthly income is higher 
-- than the average monthly income 
-- of all employees at Job Level 2."
-- * Window Function(s) Used: 
-- AVG() combined with a subquery

SELECT 
    "EmployeeNumber",
    "JobLevel",
    "MonthlyIncome",
    "Department",
    "JobRole"
FROM attrition
WHERE "JobLevel" = 1
    AND "MonthlyIncome" > (
        SELECT AVG("MonthlyIncome")
        FROM attrition
        WHERE "JobLevel" = 2
    )
ORDER BY "MonthlyIncome" DESC

-- Query 14: Calculating the 
-- Cumulative Distribution of 
-- Job Satisfaction
-- * Business Question: 
-- "What is the cumulative distribution 
-- of employees based on their 
-- job satisfaction score? 
-- In other words, what percentage of 
-- employees have a satisfaction score 
-- less than or equal to the 
-- current employee's score?"
-- * Window Function(s) Used: CUME_DIST()

SELECT 
    "EmployeeNumber",
    "JobSatisfaction",
    "Department",
    "JobRole",
    CUME_DIST() OVER (
        ORDER BY "JobSatisfaction"
    ) AS cumulative_distribution,
    ROUND(
        (CUME_DIST() OVER (
            ORDER BY "JobSatisfaction"
            )
            )::NUMERIC * 100, 
        2
    ) AS cumulative_percentage
FROM attrition
ORDER BY 
    "JobSatisfaction", 
    cumulative_distribution

-- Query 15: Finding the Salary Difference 
-- from the Lowest-Paid Person in the Role
-- * Business Question: "For each employee, 
-- how much more do they earn than the 
-- lowest-paid person who shares their 
-- same job role?"
-- * Window Function(s) Used: FIRST_VALUE()

SELECT "EmployeeNumber",
       "JobRole",
       "MonthlyIncome",
       FIRST_VALUE("MonthlyIncome") 
       OVER(PARTITION BY "JobRole"
            ORDER BY "MonthlyIncome") 
        AS lowest_salary,
       ("MonthlyIncome" - FIRST_VALUE("MonthlyIncome") 
            OVER(PARTITION BY "JobRole"
            ORDER BY "MonthlyIncome")) AS diff
FROM attrition

