-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

SELECT * FROM departments;

-- 7.3.1 Query Dates
SELECT first_name, last_name -- requesting first and last names of the employees
FROM employees -- look in the employees table 
-- look in the birth_date column 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Create another query that will search for only 1952 birth dates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- employees who were born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- employees who were born in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- employees who were born in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring. Using COUNT
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new tables
SELECT first_name, last_name
INTO retirement_info -- This statement tells Postgres that instead of generating a list of results, 
-- the data is saved as a new table completely.
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Export Data

-- Recreate the retirement_info Table with the emp_no Column
DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name, -- selects only the columns we want to view from each table.
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d -- points to the first table to be joined, Departments
INNER JOIN dept_manager as dm -- points to the second table to be joined, dept_manager
ON departments.dept_no = dept_manager.dept_no; -- indicates where Postgres should look for matches.

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	   retirement_info.first_name,
	   retirement_info.last_name,
   	   dept_emp.to_date
-- assign the left table with FROM
FROM retirement_info
-- use a LEFT JOIN to include every row of the first table (retirement_info)
LEFT JOIN dept_emp
-- tell Postgres where the two tables are linked with the ON clause.
ON retirement_info.emp_no = dept_emp.emp_no;

-- use aliases
SELECT ri.emp_no,
       ri.first_name,
	   ri.last_name,
 	   de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- perform another join, this time between the retirement_info and dept_emp tables
SELECT ri.emp_no,
	   ri.first_name,
       ri.last_name,
 	   de.to_date
-- create a new table to hold the information
INTO current_emp
-- join these two tables
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
-- because this is a table of current employees, we need to add a filter, 
-- using the WHERE keyword and the date 9999-01-01.
WHERE de.to_date = ('9999-01-01');

-- 7.3.4
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count -- creates new table
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no -- tells Postgres which columns we're using to match the data
GROUP BY de.dept_no
ORDER BY de.dept_no; -- ORDER BY does exactly as it reads: It puts the data output in order for us.

-- 7.3.5 List 1
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List 2: Management
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-- List 3: Department Retirees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);
	
-- 7.3.6 Create a Tailored List
--  list containing only employees in their department
-- SELECT * FROM dept_info;
SELECT di.emp_no,
	di.first_name,
	di.last_name,
	di.dept_name
INTO sales_dept_info
FROM dept_info as di
WHERE di.dept_name = ('Sales') -- select "Sales" team from the dept_name column

-- tailored list of employees in both the Sales and Development departments
-- SELECT * FROM dept_info;
SELECT di.emp_no,
	di.first_name,
	di.last_name,
	di.dept_name
INTO sales_dev_info
FROM dept_info as di
WHERE di.dept_name IN ('Sales', 'Development')
