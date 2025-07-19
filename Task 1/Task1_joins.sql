-- Creating a new database for the project
CREATE DATABASE EmployeeDB;

-- Switch to the newly created database
USE EmployeeDB;

-- Table to store department info
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,                -- Unique ID for each department
    dept_name VARCHAR(50)                   -- Name of the department
);

-- Table to store employee information
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,                  -- Unique ID for each employee
    name VARCHAR(50),                        -- Employee's name
    gender CHAR(1),                          -- Gender: M/F
    hire_date DATE,                          -- Date of joining
    dept_id INT                              -- Foreign key to department
);

-- Table to store salary and bonus info
CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY,               -- Unique ID for each salary entry
    emp_id INT,                              -- Foreign key referencing Employees
    salary INT,                              -- Monthly salary
    bonus INT,                               -- Monthly bonus
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Table to store project details
CREATE TABLE Projects (
    proj_id INT PRIMARY KEY,                 -- Unique ID for each project
    emp_id INT,                              -- Foreign key referencing Employees
    proj_name VARCHAR(100),                  -- Project title
    hours_worked INT,                        -- Hours worked on the project
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
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

SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM Salaries;
SELECT * FROM Projects; 

-- INNER JOIN: Combines only matching rows from both tables
-- Shows employees with their department names 
SELECT e.emp_id, e.name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- LEFT JOIN: Returns all employees, even those who don't have salary records
-- Shows employee name along with salary and bonus (NULL if missing)
SELECT e.emp_id, e.name, s.salary, s.bonus
FROM Employees e
LEFT JOIN Salaries s ON e.emp_id = s.emp_id;

-- RIGHT JOIN: Returns all projects, even those not assigned to any employee
-- Shows project details along with the employee name (NULL if unassigned)
SELECT p.proj_name, p.hours_worked, e.name AS employee_name
FROM Employees e
RIGHT JOIN Projects p ON e.emp_id = p.emp_id;

-- LEFT JOIN (multi-table): Returns all employees with their department and salary details
-- Shows complete employee profiles, even if department or salary is missing
SELECT e.emp_id, e.name, d.dept_name, s.salary
FROM Employees e
LEFT JOIN Departments d ON e.dept_id = d.dept_id
LEFT JOIN Salaries s ON e.emp_id = s.emp_id;

-- FULL OUTER JOIN Simulation: Combines unmatched records from both Employees and Departments
-- Shows all employees and all departments, including those without a match
SELECT e.emp_id, e.name, d.dept_name
FROM Employees e
LEFT JOIN Departments d ON e.dept_id = d.dept_id

UNION

SELECT e.emp_id, e.name, d.dept_name
FROM Employees e
RIGHT JOIN Departments d ON e.dept_id = d.dept_id;