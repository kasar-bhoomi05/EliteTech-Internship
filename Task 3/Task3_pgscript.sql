-- Create a dedicated schema (optional but clean)
CREATE SCHEMA IF NOT EXISTS employeedb;
SET search_path TO employeedb;

-- Table to store department info
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Table to store employee information
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    gender CHAR(1),
    hire_date DATE,
    dept_id INT REFERENCES Departments(dept_id)
);

-- Table to store salary and bonus info
CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,
    emp_id INT REFERENCES Employees(emp_id),
    salary INT,
    bonus INT
);

-- Table to store project details
CREATE TABLE Projects (
    proj_id INT PRIMARY KEY,
    emp_id INT REFERENCES Employees(emp_id),
    proj_name VARCHAR(100),
    hours_worked INT
);

-- Inserting department records
INSERT INTO Departments VALUES
(10, 'HR'),
(20, 'Engineering'),
(30, 'Marketing');

-- Inserting employee records
INSERT INTO Employees VALUES
(1, 'Asha', 'F', '2022-01-15', 10),
(2, 'Raj', 'M', '2021-06-10', 20),
(3, 'Bhoomi', 'F', '2023-03-01', 20),
(4, 'Ali', 'M', '2020-11-20', 30);

-- Inserting salary records
INSERT INTO Salaries VALUES
(101, 1, 50000, 5000),
(102, 2, 70000, 8000),
(103, 3, 65000, 6000),
(104, 4, 45000, 4000);

-- Inserting project assignments
INSERT INTO Projects VALUES
(201, 1, 'Recruitment Drive', 40),
(202, 2, 'Backend API', 60),
(203, 3, 'Frontend Revamp', 55),
(204, 2, 'Data Migration', 30),
(205, 4, 'Product Launch', 45);

-- JOINs

-- INNER JOIN
SELECT e.emp_id, e.name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- LEFT JOIN
SELECT e.emp_id, e.name, s.salary, s.bonus
FROM Employees e
LEFT JOIN Salaries s ON e.emp_id = s.emp_id;

-- RIGHT JOIN
SELECT p.proj_name, p.hours_worked, e.name AS employee_name
FROM Employees e
RIGHT JOIN Projects p ON e.emp_id = p.emp_id;

-- Multi-table LEFT JOIN
SELECT e.emp_id, e.name, d.dept_name, s.salary
FROM Employees e
LEFT JOIN Departments d ON e.dept_id = d.dept_id
LEFT JOIN Salaries s ON e.emp_id = s.emp_id;

-- FULL OUTER JOIN (direct in PostgreSQL)
SELECT e.emp_id, e.name, d.dept_name
FROM Employees e
FULL JOIN Departments d ON e.dept_id = d.dept_id;

-- WINDOW FUNCTIONS
-- 1. ROW_NUMBER: Assign row number based on salary
SELECT e.name, s.salary,
       ROW_NUMBER() OVER (ORDER BY s.salary DESC) AS row_num
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 2. RANK: Rank employees based on salary
SELECT e.name, s.salary,
       RANK() OVER (ORDER BY s.salary DESC) AS salary_rank
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 3. DENSE_RANK: No gaps in ranks
SELECT e.name, s.salary,
       DENSE_RANK() OVER (ORDER BY s.salary DESC) AS dense_rank
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 4. NTILE: Divide into 2 salary groups
SELECT e.name, s.salary,
       NTILE(2) OVER (ORDER BY s.salary DESC) AS salary_group
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 5. LAG: Previous salary
SELECT e.name, s.salary,
       LAG(s.salary, 1) OVER (ORDER BY s.salary) AS previous_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 6. LEAD: Next salary
SELECT e.name, s.salary,
       LEAD(s.salary, 1) OVER (ORDER BY s.salary) AS next_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 7. CUME_DIST: Cumulative distribution
SELECT e.name, s.salary,
       CUME_DIST() OVER (ORDER BY s.salary) AS cum_dist
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 8. PERCENT_RANK: Percentile rank
SELECT e.name, s.salary,
       PERCENT_RANK() OVER (ORDER BY s.salary) AS percent_rank
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 9. FIRST_VALUE: First salary in list
SELECT e.name, s.salary,
       FIRST_VALUE(s.salary) OVER (ORDER BY s.salary) AS min_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 10. LAST_VALUE: Last salary in list
SELECT e.name, s.salary,
       LAST_VALUE(s.salary) OVER (ORDER BY s.salary
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 11. AVG using OVER (global)
SELECT e.name, s.salary,
       AVG(s.salary) OVER () AS avg_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id;

-- 12. AVG per department using PARTITION BY
SELECT e.name, d.dept_name, s.salary,
       AVG(s.salary) OVER (PARTITION BY d.dept_name) AS dept_avg
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 13. SUM over department
SELECT e.name, d.dept_name, s.salary,
       SUM(s.salary) OVER (PARTITION BY d.dept_name) AS total_salary_per_dept
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 14. COUNT of employees per department
SELECT e.name, d.dept_name,
       COUNT(*) OVER (PARTITION BY d.dept_name) AS dept_count
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- 15. MIN salary in department
SELECT e.name, d.dept_name, s.salary,
       MIN(s.salary) OVER (PARTITION BY d.dept_name) AS min_dept_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 16. MAX salary in department
SELECT e.name, d.dept_name, s.salary,
       MAX(s.salary) OVER (PARTITION BY d.dept_name) AS max_dept_salary
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 17. ROW_NUMBER with PARTITION BY (department)
SELECT e.name, d.dept_name, s.salary,
       ROW_NUMBER() OVER (PARTITION BY d.dept_name ORDER BY s.salary DESC) AS row_in_dept
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 18. RANK with PARTITION BY (department)
SELECT e.name, d.dept_name, s.salary,
       RANK() OVER (PARTITION BY d.dept_name ORDER BY s.salary DESC) AS rank_in_dept
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 19. DENSE_RANK with PARTITION BY (department)
SELECT e.name, d.dept_name, s.salary,
       DENSE_RANK() OVER (PARTITION BY d.dept_name ORDER BY s.salary DESC) AS dense_rank_in_dept
FROM Employees e
JOIN Salaries s ON e.emp_id = s.emp_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- CTEs
WITH HighEarners AS (
  SELECT e.emp_id, e.name, s.salary
  FROM Employees e
  JOIN Salaries s ON e.emp_id = s.emp_id
  WHERE s.salary > (SELECT AVG(salary) FROM Salaries)
)
SELECT * FROM HighEarners;

WITH DeptSalary AS (
  SELECT d.dept_name, SUM(s.salary) AS total_salary
  FROM Employees e
  JOIN Salaries s ON e.emp_id = s.emp_id
  JOIN Departments d ON e.dept_id = d.dept_id
  GROUP BY d.dept_name
)
SELECT * FROM DeptSalary;

WITH LatestHire AS (
  SELECT *
  FROM Employees
  WHERE hire_date = (SELECT MAX(hire_date) FROM Employees)
)
SELECT * FROM LatestHire;

-- Subqueries

SELECT name FROM Employees
WHERE emp_id IN (
  SELECT s.emp_id FROM Salaries s
  WHERE s.salary > (SELECT salary FROM Salaries WHERE emp_id = 2)
);

SELECT dept_name FROM Departments
WHERE dept_id IN (
  SELECT e.dept_id FROM Employees e
  JOIN Salaries s ON e.emp_id = s.emp_id
  GROUP BY e.dept_id
  HAVING AVG(s.salary) > 60000
);

SELECT name FROM Employees
WHERE emp_id IN (
  SELECT emp_id FROM Salaries
  WHERE bonus = (SELECT MAX(bonus) FROM Salaries)
);

SELECT proj_name FROM Projects
WHERE hours_worked = (SELECT MAX(hours_worked) FROM Projects);

SELECT name FROM Employees
WHERE emp_id NOT IN (
  SELECT DISTINCT emp_id FROM Projects
);

SELECT e.name,
       (SELECT COUNT(*) FROM Projects p WHERE p.emp_id = e.emp_id) AS total_projects
FROM Employees e;
