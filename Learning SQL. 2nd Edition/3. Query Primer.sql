# table column, a literal, an expression, and a built-in function call in a single query
SELECT
  emp_id,
  'ACTIVE',
  emp_id * 3.14159,
  UPPER(lname)
FROM employee;

# column aliases
SELECT
  emp_id,
  'ACTIVE'         status,
  emp_id * 3.14159 empid_x_pi,
  UPPER(lname)     last_name_upper
FROM employee;

# column aliases
SELECT
  emp_id,
  'ACTIVE'         AS status,
  emp_id * 3.14159 AS empid_x_pi,
  UPPER(lname)     AS last_name_upper
FROM employee;

# DISTINCT keyword
SELECT DISTINCT cust_id
FROM account;

# table links
SELECT
  employee.emp_id,
  employee.fname,
  employee.lname,
  department.name dept_name
FROM employee
  INNER JOIN department
    ON employee.dept_id = department.dept_id;

# table aliases
SELECT
  e.emp_id,
  e.fname,
  e.lname,
  d.name dept_name
FROM employee e INNER JOIN department d
    ON e.dept_id = d.dept_id;

# table aliases
SELECT
  e.emp_id,
  e.fname,
  e.lname,
  d.name dept_name
FROM employee AS e INNER JOIN department AS d
    ON e.dept_id = d.dept_id;

# WHERE clause
SELECT
  emp_id,
  fname,
  lname,
  start_date,
  title
FROM employee
WHERE (title = 'Head Teller' AND start_date > '2006-01-01')
      OR (title = 'Teller' AND start_date > '2007-01-01');

# the group by and having clauses
SELECT
  d.name,
  count(e.emp_id) num_employees
FROM department d INNER JOIN employee e
    ON d.dept_id = e.dept_id
GROUP BY d.name
HAVING count(e.emp_id) > 2;

# order by clause
SELECT
  open_emp_id,
  product_cd
FROM account
ORDER BY open_emp_id;

# order by clause
SELECT
  open_emp_id,
  product_cd
FROM account
ORDER BY open_emp_id, product_cd;

# descending sort order
SELECT
  account_id,
  product_cd,
  open_date,
  avail_balance
FROM account
ORDER BY avail_balance DESC;

# ascending sort order
SELECT
  account_id,
  product_cd,
  open_date,
  avail_balance
FROM account
ORDER BY avail_balance ASC;

# sorting via numeric placeholders
SELECT
  emp_id,
  title,
  start_date,
  fname,
  lname
FROM employee
ORDER BY 2, 5;