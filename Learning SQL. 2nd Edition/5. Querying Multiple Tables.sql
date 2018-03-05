# JOIN keyword
SELECT
  e.fname,
  e.lname,
  d.name
FROM employee e
  JOIN department d;

# ON subclause + JOIN keyword
SELECT
  e.fname,
  e.lname,
  d.name
FROM employee e
  JOIN department d
    ON e.dept_id = d.dept_id;

# ON subclause + INNER JOIN keyword. the same as previous. INNER is default.
SELECT
  e.fname,
  e.lname,
  d.name
FROM employee e
  INNER JOIN department d
    ON e.dept_id = d.dept_id;

# USING subclause. the same as ON. can be use if the names of the columns are identical
SELECT
  e.fname,
  e.lname,
  d.name
FROM employee e INNER JOIN department d
  USING (dept_id);

# an older join syntax
SELECT
  e.fname,
  e.lname,
  d.name
FROM employee e, department d
WHERE e.dept_id = d.dept_id;

# STRAIGHT_JOIN keyword (place the tables in the desired order)
SELECT STRAIGHT_JOIN
  a.account_id,
  c.fed_id,
  e.fname,
  e.lname
FROM customer c INNER JOIN account a
    ON a.cust_id = c.cust_id
  INNER JOIN employee e
    ON a.open_emp_id = e.emp_id
WHERE c.cust_type_cd = 'B';

# self-join
SELECT
  e.fname,
  e.lname,
  e_mgr.fname mgr_fname,
  e_mgr.lname mgr_lname
FROM employee e INNER JOIN employee e_mgr
    ON e.superior_emp_id = e_mgr.emp_id;

# non-equi-join
SELECT
  e.emp_id,
  e.fname,
  e.lname,
  e.start_date
FROM employee e INNER JOIN product p
    ON e.start_date >= p.date_offered
       AND e.start_date <= p.date_retired
WHERE p.name = 'no-fee checking';

# non-equi-join
SELECT
  e1.fname,
  e1.lname,
  'VS' vs,
  e2.fname,
  e2.lname
FROM employee e1 INNER JOIN employee e2
    ON e1.emp_id != e2.emp_id
WHERE e1.title = 'Teller' AND e2.title = 'Teller';

