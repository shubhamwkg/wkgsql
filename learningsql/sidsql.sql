-- =============================================================================
-- SQL CLASS PRACTICE BY SIDHANT SARDAR
-- =============================================================================

-- Query Writing Sequence
-- =====================
-- SELECT
-- TOP
-- INTO
-- FROM 
-- JOIN 
-- WHERE 
-- GROUP BY 
-- HAVING 
-- ORDER BY 

-- =============================================================================
-- DATABASE CREATION AND SETUP
-- =============================================================================

-- Creating Database
CREATE DATABASE velocityBPI;

USE velocityBPI;

-- =============================================================================
-- TABLE CREATION
-- =============================================================================

-- Create Student Table
CREATE TABLE student (
    studentID INT IDENTITY(1,1),
    studentname VARCHAR(20),
    studentAge INT,
    studentHeight INT 
);

/*
Data Types Notes:
- FLOAT = for decimal numbers 
- BIGINT = for mobile numbers 
*/

-- View table structure
SELECT * FROM student;

-- Table management commands
DROP TABLE student;
TRUNCATE TABLE student;

-- =============================================================================
-- DATA INSERTION METHODS
-- =============================================================================

-- Method 1: Basic Insert
INSERT INTO student VALUES (1, 'manish', 24, 168);
INSERT INTO student VALUES (2, 'sid', 25, 169);
INSERT INTO student VALUES (3, 'sunny', 27, 170);
INSERT INTO student VALUES (4, 'akash', 23, 180);

-- Partial column insert
INSERT INTO student (studentid, studentname, studentage) 
VALUES (5, 'ronak', 22);

-- Method 2: Multiple rows insert (Best Practice)
INSERT INTO student (studentID, studentname, studentAge, studentHeight)
VALUES 
    (5, 'manish', 24, 168),
    (6, 'shubham', 25, 169),
    (7, 'ramesh', 27, 170),
    (8, 'gaurav', 23, 180);

-- Method 3: Using Identity (Auto-increment)
INSERT INTO student
VALUES 
    ('sid', 21, 169),
    ('mid', 23, 159),
    ('romit', 24, 179),
    ('harshita', 21, 149),
    ('sudesh', 27, 161),
    ('akash', 26, 166),
    ('varshita', 24, 164),
    ('mangal', 23, 163),
    ('jangal', 28, 162),
    ('sameer', 25, 160),
    ('romi', 21, 170);

-- =============================================================================
-- WHERE CLAUSE - DATA FILTERING
-- =============================================================================

-- Basic comparison operators
SELECT * FROM student WHERE studentage = 24;
SELECT * FROM student WHERE studentage > 24;
SELECT * FROM student WHERE studentage < 24;
SELECT * FROM student WHERE studentage <= 24;
SELECT * FROM student WHERE studentage >= 24;
SELECT * FROM student WHERE studentage <> 24;
SELECT * FROM student WHERE studentname <> 'manish';

-- IN Operator - Specific values
SELECT * FROM student WHERE studentage IN (23,27);
SELECT * FROM student WHERE studentage NOT IN (23,27);
SELECT * FROM student WHERE studentname IN ('manish','ramesh');

-- BETWEEN Operator - Range values
SELECT * FROM student WHERE studentage BETWEEN 23 AND 24;
SELECT * FROM student WHERE studentage NOT BETWEEN 23 AND 24;

-- LIKE Operator - Pattern matching (Wildcards)
/*
Wildcard patterns:
- s% = names starting with 's' 
- %s = names ending with 's'
- %sh% = names containing 'sh'
- %s%h% = names with 's' and 'h' anywhere
- _a% = one character before 'a'
- _ _ a% = two characters before 'a'
*/
SELECT * FROM student WHERE studentname LIKE 's%';
SELECT * FROM student WHERE studentname LIKE '%s';
SELECT * FROM student WHERE studentname LIKE '%sh%';
SELECT * FROM student WHERE studentname LIKE '%s%h%';
SELECT * FROM student WHERE studentname LIKE '_a%';
SELECT * FROM student WHERE studentname LIKE '_ _ a%';
SELECT * FROM student WHERE studentname LIKE '%a_ _';
SELECT * FROM student WHERE studentname LIKE '%a_ ';

-- Multiple conditions - AND, OR, NOT
SELECT * FROM student WHERE studentname = 'manish' AND studentage = 167;
SELECT * FROM student WHERE studentname LIKE 'm%' AND studentage = 167;
SELECT * FROM student WHERE studentname = 'manish' OR studentage = 169;
SELECT * FROM student WHERE studentage = 169 OR studentname = 'manish';

-- NULL handling
-- Note: NULL is not a value, it's like a vacuum
SELECT * FROM student WHERE studentheight IS NULL;
SELECT * FROM student WHERE studentheight IS NOT NULL;

-- Find even and odd records
SELECT * FROM student WHERE studentid % 2 = 0;    -- Even
SELECT * FROM student WHERE studentid % 2 <> 0;   -- Odd

-- =============================================================================
-- ORDER BY - SORTING DATA
-- =============================================================================

-- Basic ordering (ASC is default)
SELECT * FROM student ORDER BY studentage;
SELECT * FROM student ORDER BY studentage DESC;

-- Multiple column ordering
SELECT * FROM student ORDER BY studentage DESC, studentheight DESC;

-- =============================================================================
-- DATA TYPE STORAGE SIZES
-- =============================================================================

CREATE TABLE ##test (id TINYINT);

INSERT INTO ##test VALUES(125);
INSERT INTO ##test VALUES(80);
INSERT INTO ##test VALUES(280); -- This will cause error due to TINYINT limit

SELECT * FROM ##test;

/*
Storage sizes:
- BIGINT    : 8 bytes	
- INT       : 4 bytes	
- SMALLINT  : 2 bytes	
- TINYINT   : 1 byte (0-255)
*/

-- =============================================================================
-- ALTER TABLE - STRUCTURE MODIFICATIONS
-- =============================================================================

-- Add columns
ALTER TABLE student ADD gender CHAR(1);
ALTER TABLE student ADD phoneNumber BIGINT;
ALTER TABLE student ADD DOB DATE;

-- Drop columns
ALTER TABLE student DROP COLUMN gender;
ALTER TABLE student DROP COLUMN dob;
ALTER TABLE student DROP COLUMN phonenumber;

-- =============================================================================
-- UPDATE OPERATIONS
-- =============================================================================

-- Single column update
UPDATE student 
SET studentheight = 170 
WHERE studentid = 8;

-- Multiple columns update
UPDATE student
SET 
    studentage = 24,
    studentheight = 140,
    phonenumber = 34283748927
WHERE studentname = 'gaurav';

-- Adding and updating course IDs
ALTER TABLE student ADD courseid INT;

UPDATE student SET courseid = 1 WHERE studentid = 1;
UPDATE student SET courseid = 2 WHERE studentid = 2;
UPDATE student SET courseid = 3 WHERE studentid = 3;
UPDATE student SET courseid = 5 WHERE studentid = 4;
UPDATE student SET courseid = 6 WHERE studentid = 5;
UPDATE student SET courseid = 7 WHERE studentid = 6;
UPDATE student SET courseid = 8 WHERE studentid = 7;

-- Batch updates
UPDATE student SET courseid = 1 WHERE studentid IN (1,2);
UPDATE student SET courseid = 2 WHERE studentid IN (2,3);

-- =============================================================================
-- JOINS - COMBINING TABLES
-- =============================================================================

-- Create course table
CREATE TABLE course (
    courseid INT,
    coursename VARCHAR(20)
);

INSERT INTO course  
VALUES 
    (1, 'power bi'),
    (2, 'testing'),
    (4, 'python'),
    (5, 'c++'),
    (6, 'java'),
    (7, 'azure');

-- Different types of joins

-- INNER JOIN - Shows matching records only
SELECT * 
FROM student 
JOIN course ON student.courseid = course.courseid;

SELECT studentName, courseName 
FROM student 
JOIN course ON student.courseID = course.courseID;

-- LEFT JOIN - All records from left table
SELECT studentName, courseName
FROM student 
LEFT JOIN course ON student.courseID = course.courseID;

-- RIGHT JOIN - All records from right table
SELECT studentName, courseName
FROM student 
RIGHT JOIN course ON student.courseID = course.courseID;

-- FULL OUTER JOIN - All records from both tables
SELECT studentName, courseName
FROM student 
FULL OUTER JOIN course ON student.courseID = course.courseID;

-- Select specific columns with join
SELECT student.*, course.courseName
FROM student 
LEFT JOIN course ON student.courseID = course.courseID;

-- =============================================================================
-- JOIN PRACTICE TABLES
-- =============================================================================

CREATE TABLE t1 (id INT);
CREATE TABLE t2 (id INT);

INSERT INTO t1 VALUES (1),(2),(1),(0),(NULL),(NULL);
INSERT INTO t2 VALUES (2),(1),(0),(NULL),(2),(3);

-- Different join examples
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 FULL OUTER JOIN t2 ON t1.id = t2.id;

-- Self join example
SELECT * FROM t1 a JOIN t1 b ON a.id = b.id;

-- =============================================================================
-- SELF JOIN EXAMPLE
-- =============================================================================

CREATE TABLE employeesj (
    empid INT,
    empname VARCHAR(20),
    manid INT
);

INSERT INTO employeesj 
VALUES 
    (1, 'rohit', 0),
    (2, 'neha', 1),
    (3, 'manish', 1),
    (4, 'deepak', 3);

-- Self join to show employee-manager relationship
SELECT emp.empname AS employee, man.empname AS manager 
FROM employeesj AS emp 
LEFT JOIN employeesj AS man ON emp.manid = man.empid;

-- =============================================================================
-- CONSTRAINTS - DATA VALIDATION
-- =============================================================================

-- NOT NULL Constraint
CREATE TABLE samplenotnull (
    id INT NOT NULL,
    name VARCHAR(20) NOT NULL,
    age INT 
);

INSERT INTO samplenotnull VALUES (1, 'mahesh', 25);
-- INSERT INTO samplenotnull VALUES (2, NULL, 24); -- This will fail

-- UNIQUE Constraint
CREATE TABLE sampleunique (
    id INT NULL UNIQUE,
    name VARCHAR(20) NOT NULL,
    age INT 
);

INSERT INTO sampleunique VALUES (1, 'mahesh', 25);
-- INSERT INTO sampleunique VALUES (1, 'rohit', 24); -- This will fail

-- CHECK Constraint
CREATE TABLE samplecheck (
    id INT NOT NULL CHECK(id > 3),
    name VARCHAR(20) NOT NULL,
    age INT 
);

-- INSERT INTO samplecheck VALUES (2, 'mahesh', 25); -- This will fail
INSERT INTO samplecheck VALUES (4, 'rohit', 25);

-- Email validation with CHECK
CREATE TABLE samplechecktestmail (
    id INT NOT NULL,
    name VARCHAR(20) NOT NULL,
    emailid VARCHAR(30) CHECK (emailid LIKE '%@gmail.com'),
    age INT 
);

INSERT INTO samplechecktestmail VALUES(2, 'mahesh', 'abc@gmail.com', 25);
-- INSERT INTO samplechecktestmail VALUES(4, 'rohit', 'xyz@hotmail.com', 24); -- This will fail

-- DEFAULT Constraint
CREATE TABLE sampledefault (
    id INT NOT NULL,
    name VARCHAR(20),
    age INT NULL DEFAULT 23
);

INSERT INTO sampledefault (id) VALUES (5);
INSERT INTO sampledefault VALUES (4, 'rohit', 24);

-- Add default constraint to existing column
ALTER TABLE sampledefault 
ADD CONSTRAINT df_name DEFAULT 'sandesh' FOR name;

INSERT INTO sampledefault (id) VALUES (5);
INSERT INTO sampledefault (id, name) VALUES (6, 'mira');

-- Using DEFAULT keyword in INSERT
INSERT INTO sampledefault 
VALUES 
    (1, 'sidhant', DEFAULT),
    (2, DEFAULT, 20),
    (3, 'shehal', 26);

-- =============================================================================
-- PRIMARY KEY AND FOREIGN KEY
-- =============================================================================

-- Primary Key (UNIQUE + NOT NULL)
CREATE TABLE department (
    deptid INT PRIMARY KEY,
    deptname VARCHAR(20)
);

INSERT INTO department VALUES (1, 'it');
INSERT INTO department VALUES (2, 'hr'); 
INSERT INTO department VALUES (0, 'finance'); 

-- INSERT INTO department VALUES (2, 'finance'); -- This will fail (duplicate)
-- INSERT INTO department VALUES (NULL, 'finance'); -- This will fail (null)

-- Foreign Key Table
CREATE TABLE Employee (
    EmpID INT,
    EmpName VARCHAR(20),
    EmpAge INT,
    EmpDeptID INT -- References Department(deptid)
);

INSERT INTO Employee VALUES(1, 'Rohit', 26, 1);
INSERT INTO Employee VALUES(2, 'Shah', 28, 2);
INSERT INTO Employee VALUES(3, 'Man', 24, 1);
-- INSERT INTO Employee VALUES(4, 'Jyoti', 22, 3); -- This gives error
INSERT INTO Employee VALUES(3, 'Man', 24, NULL);

-- Join examples with Primary/Foreign keys
SELECT * 
FROM Employee 
INNER JOIN Department ON EmpDeptID = DeptID;

SELECT * 
FROM Employee 
LEFT JOIN Department ON EmpDeptID = DeptID;

SELECT * 
FROM Employee
RIGHT JOIN Department ON EmpDeptID = DeptID;

-- =============================================================================
-- INDEXES - PERFORMANCE OPTIMIZATION
-- =============================================================================

/*
Index Types:
1. Clustered Index   : Dictionary type : Primary key : One per table 
2. Non-Clustered Index : Normal book   : Unique key  : 999 per table 

Clustered Index:
- Data must be ordered 
- Should be unique data (typically primary key)

Non-Clustered Index:
- Used to search specific data quickly
*/

-- Create Non-Clustered Index
CREATE INDEX index1 ON department (deptid);

-- Create Clustered Index
CREATE CLUSTERED INDEX index2 ON employee (empid);

-- =============================================================================
-- STORED PROCEDURES
-- =============================================================================

-- Basic stored procedure
GO
CREATE PROCEDURE spGetEmployee
AS
BEGIN
    SELECT * 
    FROM Employee 
    LEFT JOIN Department ON EmpDeptID = DeptID;
END;
GO

-- Execute stored procedure
EXEC spGetEmployee;
GO
CREATE PROCEDURE spGetStudent(@StudId INT)
AS
BEGIN
    SELECT * 
    FROM student
    WHERE studentId = @StudId;
END;
GO

EXEC spGetStudent 1;
GO
CREATE PROCEDURE spGetStudent1(@StudId INT, @age INT)
AS
BEGIN
    SELECT * 
    FROM Student
    WHERE studentId = @StudId OR StudentAge = @age;
END;
GO

EXEC spGetStudent1 4, 23;
GO
CREATE PROCEDURE spGetStudent2(@StudId INT, @age INT = 22)
AS
BEGIN
    SELECT * 
    FROM Student
    WHERE studentId = @StudId OR studentAge = @age;
END;
GO

EXEC spGetStudent2 2, 24;
EXEC spGetStudent2 2; -- Uses default age = 22
GO
CREATE PROCEDURE spUpdateStudentAge(@StudId INT, @age INT)
AS
BEGIN
    UPDATE student
    SET studentAge = @age
    WHERE studentId = @StudId;
END;
GO

EXEC spUpdateStudentAge 2, 28;

-- View procedure details
-- SP_HELPTEXT 'spUpdateStudentAge'
SELECT * FROM sys.procedures;

-- =============================================================================
-- UNION AND UNION ALL
-- =============================================================================

/*
UNION ALL: Keeps duplicates and maintains order
UNION:     Sorts data and removes duplicates
*/

CREATE TABLE test1 (ID INT);
CREATE TABLE test2 (ID INT);

INSERT INTO test1 VALUES (1),(2),(2),(3),(4);
INSERT INTO test2 VALUES (2),(3),(4),(3),(5);

-- UNION ALL - keeps duplicates
SELECT * FROM test1
UNION ALL
SELECT * FROM test2;

-- UNION - removes duplicates and sorts
SELECT * FROM test1
UNION
SELECT * FROM test2;

-- =============================================================================
-- VIEWS - VIRTUAL TABLES
-- =============================================================================

/*
Views are virtual tables that:
- Store queries, not data
- Show limited information from tables
- Update automatically when base tables change
- Can combine multiple tables
- Provide data security and simplification

Types:
GO
CREATE VIEW vwstudent 
AS 
    SELECT studentname, studentage 
    FROM student;
GO
- Restrict data access
- Make complex queries simple
GO
CREATE VIEW vwstudentcourse
AS 
    SELECT studentname, coursename 
    FROM student 
    LEFT JOIN course ON student.courseid = course.courseid;
GO
AS 
    SELECT studentname, studentage 
    FROM student;

SELECT * FROM vwstudent WHERE studentage < 25;

-- View with joins
CREATE VIEW vwstudentcourse
AS 
    SELECT studentname, coursename 
    FROM student 
    LEFT JOIN course ON student.courseid = course.courseid;

SELECT * FROM vwstudentcourse;

-- Update through view (generally avoided)
UPDATE vwstudent 
SET studentage = 25
WHERE studentname = 'rohit';

-- =============================================================================
-- SUBQUERIES - NESTED QUERIES
-- =============================================================================

-- Subquery in FROM clause
SELECT studentname  
FROM (
    SELECT studentname, studentage 
    FROM student
) AS abc;

-- Subquery in WHERE clause with IN
SELECT * 
FROM student 
WHERE studentid IN (
    SELECT studentid 
    FROM student 
    WHERE courseid = 1
);

-- Subquery with equals (returns single value)
SELECT * 
FROM student   
WHERE studentid = (
    SELECT studentid 
    FROM student 
    WHERE courseid = 1
);

-- =============================================================================
-- FINDING NTH HIGHEST SALARY USING SUBQUERIES
-- =============================================================================

CREATE TABLE payment (
    name VARCHAR(20),
    salary INT
);

INSERT INTO payment  
VALUES 
    ('a', 1000),
    ('b', 2000),
    ('c', 3000),
    ('d', 4000),
    ('e', 5000);

-- Highest salary
SELECT MAX(salary) AS salary 
FROM payment;

-- Name of person with highest salary
SELECT name 
FROM payment 
WHERE salary = (SELECT MAX(salary) FROM payment);

-- Second highest salary
SELECT MAX(salary)
FROM payment 
WHERE salary <> (SELECT MAX(salary) FROM payment);

-- Name of person with second highest salary
SELECT name 
FROM payment 
WHERE salary = (
    SELECT MAX(salary)
    FROM payment 
    WHERE salary <> (SELECT MAX(salary) FROM payment)
);

-- Third highest salary
SELECT MAX(salary)
FROM payment 
WHERE salary < (
    SELECT MAX(salary)
    FROM payment 
    WHERE salary NOT IN (SELECT MAX(salary) FROM payment)
);

-- =============================================================================
-- CTE - COMMON TABLE EXPRESSIONS
-- =============================================================================

/*
CTE (Common Table Expression):
- Another way of writing subqueries
- Comparable to views, subqueries, temp tables
- Provides temporary result set
- Must be used immediately
- Remains until running query is executed
- Can be used to create views
- Defined at start of query and can be referenced multiple times

Key advantages:
- Improved readability
- Ease in maintenance of complex queries
- Avoid intermediate storage
*/

-- Basic CTE
WITH abc AS (
    SELECT studentname, studentage 
    FROM student
)
SELECT * FROM abc;

-- CTE with column aliases
WITH ctestud1(sname, sage, cdate) AS (
    SELECT studentname, studentage, GETDATE() 
    FROM student
)
SELECT * FROM ctestud1;

-- =============================================================================
-- TEMPORARY TABLES
-- =============================================================================

/*
Local Temp Tables (#): Exist in same connection until connection closed
Global Temp Tables (##): Exist in any connection until creating connection closed
*/

-- Local Temporary Table
CREATE TABLE #localtemptable (
    id INT IDENTITY(1,1),
    name VARCHAR(20)
);

INSERT INTO #localtemptable VALUES ('john'),('johny'),('janardan');
SELECT * FROM #localtemptable;

-- Global Temporary Table
CREATE TABLE ##globaltemptable (
    id INT IDENTITY(1,1),
    name VARCHAR(20)
);

INSERT INTO ##globaltemptable VALUES ('john'),('johny'),('janardan');
SELECT * FROM ##globaltemptable;

-- Create temp table from existing table
SELECT * INTO ##student FROM student;

SELECT studentname, studentheight 
INTO ##student1 
FROM student;

-- Create backup table
SELECT * 
INTO student_20220907
FROM student;

-- =============================================================================
-- UPDATE TABLE BASED ON ANOTHER TABLE
-- =============================================================================

ALTER TABLE student ADD studentcourse VARCHAR(20);

-- Update using JOIN
UPDATE s
SET s.studentcourse = c.coursename 
FROM student s 
LEFT JOIN course c ON s.courseid = c.courseid;

-- =============================================================================
-- WINDOW FUNCTIONS
-- =============================================================================

-- Aggregate window functions
SELECT AVG(studentage) AS averageAge FROM student;

SELECT studentcourse, AVG(studentage) AS averageage
FROM student 
GROUP BY studentcourse;

-- Ranking functions
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY studentcourse ORDER BY studentage) AS row_age,
    ROW_NUMBER() OVER (PARTITION BY studentcourse ORDER BY studentheight DESC) AS row_height
FROM student;

SELECT *,
    RANK() OVER (PARTITION BY studentcourse ORDER BY studentage) AS rank_age,
    RANK() OVER (PARTITION BY studentcourse ORDER BY studentheight DESC) AS rank_height
FROM student;

SELECT *,
    DENSE_RANK() OVER (PARTITION BY studentcourse ORDER BY studentage) AS agerank,
    DENSE_RANK() OVER (PARTITION BY studentcourse ORDER BY studentheight DESC) AS heightrank 
FROM student;

-- Without partition
SELECT *,
    RANK() OVER (ORDER BY studentage) AS age_rank,
    DENSE_RANK() OVER (ORDER BY studentheight DESC) AS height_dense_rank
FROM student;

-- =============================================================================
-- WINDOW FUNCTIONS PRACTICE TABLE
-- =============================================================================

CREATE TABLE department2 (
    id INT IDENTITY(1,1),
    dept VARCHAR(20),
    empname VARCHAR(20),
    empsalary INT,
    empheight INT
);

INSERT INTO department2 
VALUES 
    ('it', 'sneha', 45000, 155),
    ('it', 'manish', 35000, 187),
    ('it', 'neha', 40000, 188),
    ('it', 'shashank', 35000, 155),
    ('hr', 'rohit', 45000, 187),
    ('hr', 'krishna', 35000, 189);

-- Window function examples
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY dept ORDER BY empsalary) AS row_salary,
    ROW_NUMBER() OVER (PARTITION BY dept ORDER BY empheight DESC) AS row_height 
FROM department2;

SELECT *,
    RANK() OVER (PARTITION BY dept ORDER BY empsalary) AS rank_salary,
    RANK() OVER (PARTITION BY dept ORDER BY empheight DESC) AS rank_height 
FROM department2;

SELECT *,
    DENSE_RANK() OVER (PARTITION BY dept ORDER BY empsalary) AS dense_rank_salary,
    DENSE_RANK() OVER (PARTITION BY dept ORDER BY empheight DESC) AS dense_rank_height 
FROM department2;

-- =============================================================================
-- DATE/TIME FUNCTIONS
-- =============================================================================

-- Current date and time
SELECT GETDATE();

-- Date parts
SELECT *, 
    DATEPART(yyyy, dateofbirth) AS birthyear,
    DATEPART(mm, dateofbirth) AS birthmonth,
    DATEPART(dd, dateofbirth) AS birthday,
    DATEPART(weekday, dateofbirth) AS birthwd 
FROM student;

-- Date addition
SELECT *, 
    DATEADD(month, 13, DateOfBirth) AS BDMonthAdded,
    DATEADD(day, 15, DateOfBirth) AS BDDayAdded,
    DATEADD(year, 2, DateOfBirth) AS BDYearAdded,
    DATEADD(year, -1, DateOfBirth) AS BDYearReduced
FROM student;

-- Date difference
SELECT *,
    DATEDIFF(year, dateofbirth, GETDATE()) AS ageyear,
    DATEDIFF(month, dateofbirth, GETDATE()) AS agemonth,
    DATEDIFF(day, dateofbirth, GETDATE()) AS ageday 
FROM student;

-- Create date from parts
SELECT DATEFROMPARTS(2015, 12, 25);

-- Format date
SELECT *,
    FORMAT(dateofbirth, 'MMM-yy') AS dt,
    FORMAT(dateofbirth, 'dd-MMM-yy') AS dt1 
FROM student;

-- =============================================================================
-- DATE OF BIRTH UPDATE EXAMPLE
-- =============================================================================

ALTER TABLE student ADD dob DATE;

UPDATE student 
SET dob = CASE
    WHEN studentid = 1  THEN '10-02-1993'
    WHEN studentid = 2  THEN '02-01-1991'
    WHEN studentid = 3  THEN '09-01-1994'
    WHEN studentid = 4  THEN '07-01-1996'
    WHEN studentid = 5  THEN '12-15-1990'
    WHEN studentid = 6  THEN '06-01-1999'
    WHEN studentid = 7  THEN '06-30-1996'
    WHEN studentid = 8  THEN '01-12-1990'
    WHEN studentid = 9  THEN '08-14-1991'
    WHEN studentid = 10 THEN '05-15-1989'
    WHEN studentid = 11 THEN '06-02-1998'
    ELSE '01-01-1111'
END;

-- Date function examples
SELECT *, DATEPART(mm, dob) AS dobmonth FROM student;
SELECT *, DATEDIFF(year, dob, GETDATE()) AS age FROM student;
SELECT *, GETDATE() AS today FROM student;
SELECT *, DATEADD(year, 3, dob) AS [date after 3 years] FROM student;
SELECT *, DATEADD(year, -3, dob) AS [date before 3 years] FROM student;
SELECT *, FORMAT(dob, 'dd-MM-yyyy') AS dt FROM student;

-- =============================================================================
-- DATA TYPE CONVERSION
-- =============================================================================

-- CONVERT function
SELECT *, CONVERT(DATE, dateofbirth) AS dt FROM student;

-- CAST function
SELECT *, CAST(dateofbirth AS DATE) AS dt FROM student;

-- Variable conversion example
DECLARE @a VARCHAR(2) = '2';
DECLARE @b VARCHAR(2) = '3';
DECLARE @c VARCHAR(2) = '4';

SELECT CAST(@a AS INT) * CAST(@b AS INT) * CAST(@c AS INT) AS result;

-- =============================================================================
-- SQL EXECUTION ORDER
-- =============================================================================

/*
SQL Query Execution Order:
1. FROM table 
2. ON
3. JOIN
4. WHERE
5. GROUP BY
6. HAVING
7. SELECT
8. DISTINCT
9. ORDER BY
10. LIMIT/TOP
*/

SELECT 
    -- TOP 1
    PositionID, COUNT(*) AS cnt
FROM player
WHERE PlayerID <= 10
GROUP BY PositionID
HAVING COUNT(*) >= 2
ORDER BY cnt DESC;

-- =============================================================================
-- CASE WHEN - CONDITIONAL LOGIC
-- =============================================================================

SELECT *,
    CASE 
        WHEN studentage <= 22 THEN 'kid'
        WHEN studentage <= 25 THEN 'young'
        ELSE 'old'
    END AS agecategory
FROM student;

-- =============================================================================
-- IF ELSE - CONDITIONAL STATEMENTS
-- =============================================================================

DECLARE @flag INT = 2;

IF @flag = 2 
BEGIN 
    SELECT 'Condition is true';
END
ELSE
BEGIN
    SELECT 'Condition is false';
END;

-- =============================================================================
-- WHILE LOOP
-- =============================================================================

-- Number multiplication loop
DECLARE @count INT = 2;
WHILE @count <= 200
BEGIN 
    SELECT @count;
    SET @count = @count * 2;
END;

-- Student records loop
DECLARE @id INT = 1;
WHILE @id <= 3
BEGIN 
    SELECT * FROM student WHERE studentid = @id;
    SET @id = @id + 1;
END;

-- =============================================================================
-- JOIN PRACTICE WITH THREE TABLES
-- =============================================================================

CREATE TABLE ##table1 (ID INT);
CREATE TABLE ##table2 (ID INT);
CREATE TABLE ##table3 (ID INT);

INSERT INTO ##table1 VALUES(1),(2),(1),(0),(NULL),(NULL);
INSERT INTO ##table2 VALUES(2),(1),(0),(NULL),(2),(3);
INSERT INTO ##table3 VALUES(4),(2),(2),(1),(NULL),(1);

SELECT * FROM ##table1;
SELECT * FROM ##table2;
SELECT * FROM ##table3;

-- =============================================================================
-- DELETE DUPLICATES USING CTE
-- =============================================================================

CREATE TABLE ##temp (
    id INT,
    name VARCHAR(20)
);

INSERT INTO ##temp
VALUES 
    (1, 'vishal'),
    (2, 'rohit'),
    (2, 'rohit'),
    (3, 'manjiri'),
    (2, 'rohit'),
    (3, 'manjiri');

SELECT * FROM ##temp;

-- Delete duplicates keeping only first occurrence
WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) AS rn 
    FROM ##temp
)
DELETE FROM cte WHERE rn <> 1;

-- =============================================================================
-- END OF SQL PRACTICE
-- =============================================================================