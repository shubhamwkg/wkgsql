-- =====================================================
-- MINIMAL PostgreSQL Practice Database Setup
-- =====================================================
-- Just 3 tables with minimal data to practice ALL SQL concepts
-- =====================================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- =====================================================
-- TABLE 1: DEPARTMENTS (Master table)
-- =====================================================
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(20) NOT NULL UNIQUE,
    budget DECIMAL(10,2) DEFAULT 100000,
    location VARCHAR(20),
    created_date DATE DEFAULT CURRENT_DATE
);

-- Insert minimal department data
INSERT INTO departments (dept_name, budget, location) VALUES
('IT', 100000, 'New York'),
('HR', 80000, 'Chicago'),
('Finance', 90000, 'Boston');

-- =====================================================
-- TABLE 2: EMPLOYEES (Main table for most examples)
-- =====================================================
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    age INTEGER CHECK (age > 0),
    dept VARCHAR(10),
    salary DECIMAL(8,2) DEFAULT 50000,
    hire_date DATE,
    email VARCHAR(30) UNIQUE,
    manager_id INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    dept_id INTEGER,
    FOREIGN KEY (manager_id) REFERENCES employees(id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Insert minimal employee data (covers all scenarios)
INSERT INTO employees (name, age, dept, salary, hire_date, email, dept_id) VALUES
('Alice', 25, 'IT', 50000, '2020-01-15', 'alice@co.com', 1),
('Bob', 30, 'HR', 60000, '2019-06-20', 'bob@co.com', 2),
('Carol', 35, 'IT', 55000, '2021-03-10', 'carol@co.com', 1),
('David', 25, 'Finance', 65000, '2020-09-05', 'david@co.com', 3),
('Eve', 30, 'IT', 52000, '2018-11-12', NULL, 1), -- NULL email for testing
('Frank', 35, 'HR', 58000, '2020-07-22', 'frank@co.com', 2);

-- Set up manager relationships (for self-join examples)
UPDATE employees SET manager_id = 1 WHERE id = 5; -- Alice manages Eve
UPDATE employees SET manager_id = 2 WHERE id = 6; -- Bob manages Frank

-- =====================================================
-- TABLE 3: PROJECTS (For join examples) || E
-- =====================================================
CREATE TABLE projects (
    proj_id SERIAL PRIMARY KEY,
    proj_name VARCHAR(20) NOT NULL,
    emp_id INTEGER,
    budget DECIMAL(8,2),
    status VARCHAR(10) DEFAULT 'Active',
    start_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(id)
);

-- Insert minimal project data
INSERT INTO projects (proj_name, emp_id, budget, status) VALUES
('WebApp', 1, 50000, 'Active'),
('Mobile', 3, 40000, 'Complete'),
('Dashboard', 4, 30000, 'Active'),
('API', NULL, 25000, 'Pending'); -- NULL emp_id for testing

-- =====================================================
-- CREATE ADDITIONAL DATA VARIATIONS IN SAME TABLES || E
-- =====================================================

-- Add duplicate data for UNION/duplicate removal examples
INSERT INTO employees (name, age, dept, salary, hire_date, email, dept_id) VALUES
('Alice', 25, 'IT', 50000, '2020-01-15', 'alice2@co.com', 1); -- Duplicate name/age

-- Add data with NULLs for NULL handling examples
INSERT INTO employees (name, age, dept, salary, hire_date, dept_id) VALUES
('John', NULL, 'IT', 45000, '2023-01-01', 1), -- NULL age
('Jane', 28, NULL, 48000, '2023-02-01', NULL); -- NULL dept

-- =====================================================
-- CREATE VIEW FOR PRACTICE || E
-- =====================================================
CREATE VIEW emp_projects AS
SELECT e.name, e.dept, p.proj_name, p.status
FROM employees e 
LEFT JOIN projects p ON e.id = p.emp_id;

-- =====================================================
-- CREATE FUNCTION FOR STORED PROCEDURE PRACTICE || E
-- =====================================================
CREATE OR REPLACE FUNCTION get_employees_by_dept(dept_name VARCHAR DEFAULT 'IT')
RETURNS TABLE(name VARCHAR, age INTEGER, salary DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT e.name, e.age, e.salary
    FROM employees e
    WHERE e.dept = dept_name OR (dept_name IS NULL AND e.dept IS NULL);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- CREATE INDEX FOR PRACTICE | E
-- =====================================================
CREATE INDEX idx_emp_dept ON employees(dept);
CREATE INDEX idx_proj_status ON projects(status);

-- =====================================================
-- VERIFICATION - Check all tables have data
-- =====================================================
SELECT 'departments' as table_name, COUNT(*) as records FROM departments
UNION ALL
SELECT 'employees', COUNT(*) FROM employees  
UNION ALL
SELECT 'projects', COUNT(*) FROM projects;

-- =====================================================
-- 🎯 PRACTICE ALL CONCEPTS WITH THESE 3 TABLES:
-- =====================================================

-- BEGINNER (18 concepts):
SELECT * FROM employees;
SELECT name, age FROM employees WHERE age = 30;
SELECT * FROM employees WHERE age > 25;
SELECT * FROM employees WHERE dept IN ('IT', 'HR');
SELECT * FROM employees WHERE age BETWEEN 25 AND 35;
SELECT * FROM employees WHERE name LIKE 'A%';
SELECT * FROM employees WHERE email IS NULL;
SELECT * FROM employees WHERE age = 25 AND dept = 'IT';
SELECT * FROM employees WHERE id % 2 = 0;
SELECT * FROM employees ORDER BY age DESC;
INSERT INTO employees (name, age, dept) VALUES ('Test', 22, 'IT');
UPDATE employees SET salary = 51000 WHERE id = 1;
DELETE FROM employees WHERE name = 'Test';
ALTER TABLE employees ADD phone VARCHAR(15);
ALTER TABLE employees DROP COLUMN phone;
TRUNCATE TABLE projects; -- then re-insert data
DROP TABLE IF EXISTS temp_table;

-- INTERMEDIATE (16 concepts):
SELECT dept, COUNT(*) FROM employees GROUP BY dept;
SELECT COUNT(*) FROM employees;
SELECT SUM(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT DISTINCT dept FROM employees;
SELECT * FROM employees LIMIT 3;
SELECT dept, COUNT(*) FROM employees GROUP BY dept HAVING COUNT(*) > 1;
SELECT * FROM employees e INNER JOIN projects p ON e.id = p.emp_id;
SELECT * FROM employees e LEFT JOIN projects p ON e.id = p.emp_id;
SELECT * FROM employees e RIGHT JOIN projects p ON e.id = p.emp_id;
SELECT * FROM employees e FULL OUTER JOIN projects p ON e.id = p.emp_id;

SELECT 
    e1.name as emp, e2.name as mgr
FROM 
    employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.id;

-- ADVANCED (14 concepts):
CREATE TABLE test (id INT NOT NULL);
CREATE TABLE test2 (email VARCHAR(50) UNIQUE);
CREATE TABLE test3 (age INT CHECK(age > 0));
CREATE TABLE test4 (status VARCHAR(10) DEFAULT 'Active');
-- Primary/Foreign keys already demonstrated above
CREATE INDEX idx_name ON employees(name);
SELECT name FROM employees UNION SELECT proj_name FROM projects;
SELECT name FROM employees UNION ALL SELECT proj_name FROM projects;
CREATE VIEW emp_view AS SELECT name, dept FROM employees;
SELECT * FROM employees WHERE id IN (SELECT emp_id FROM projects);
SELECT name, CASE WHEN age > 30 THEN 'Senior' ELSE 'Junior' END FROM employees;
SELECT * FROM employees WHERE EXISTS (SELECT 1 FROM projects WHERE emp_id = employees.id);

-- EXPERT (18 concepts):
SELECT get_employees_by_dept('IT');
SELECT *, ROW_NUMBER() OVER (ORDER BY salary DESC) FROM employees;
SELECT name, dept, RANK() OVER (PARTITION BY dept ORDER BY salary DESC) FROM employees;
SELECT name, salary, dept, DENSE_RANK() OVER (PARTITION BY dept ORDER BY salary) FROM employees;
WITH high_earners AS (SELECT * FROM employees WHERE salary > 55000) SELECT name, salary FROM high_earners;
SELECT * INTO TEMP TABLE temp_emp FROM employees WHERE dept = 'IT';
DO $$ BEGIN IF 1=1 THEN RAISE NOTICE 'True'; END IF; END $$;
DO $$ DECLARE i INT := 1; BEGIN WHILE i <= 3 LOOP RAISE NOTICE '%', i; i := i + 1; END LOOP; END $$;
SELECT EXTRACT(YEAR FROM hire_date) FROM employees;
SELECT hire_date + INTERVAL '1 year' FROM employees;
SELECT AGE(CURRENT_DATE, hire_date) FROM employees;
SELECT CAST(age AS VARCHAR) FROM employees;
SELECT age::VARCHAR FROM employees; -- PostgreSQL casting

-- MASTER LEVEL:
-- Window functions with LEAD/LAG
-- Recursive CTEs
-- Advanced date functions
-- JSON operations (if needed)
-- Regular expressions with SIMILAR TO

-- =====================================================
-- 📝 NOTES:
-- =====================================================
-- This minimal 3-table setup covers ALL concepts because:
-- 1. DEPARTMENTS: Master table for FK relationships
-- 2. EMPLOYEES: Main table with all data types, constraints, self-reference
-- 3. PROJECTS: Child table for joins, has NULLs for outer join examples
-- 
-- Data variations included:
-- - NULLs for NULL handling
-- - Duplicates for UNION/DISTINCT examples  
-- - Different data types for casting
-- - Self-referencing for self-joins
-- - Mixed values for all comparison operators
-- =====================================================