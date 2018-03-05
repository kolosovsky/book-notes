SELECT
  account_id,
  product_cd,
  cust_id,
  avail_balance
FROM account
WHERE account_id = (SELECT MAX(account_id)
                    FROM account);

# ===== NONCORRELATED SUBQUERIES =====
# executed once prior to execution of the containing statement

# scalar subquery (returns a table comprising a single row and column)
SELECT
  account_id,
  product_cd,
  cust_id,
  avail_balance
FROM account
WHERE open_emp_id != (SELECT e.emp_id
                      FROM employee e INNER JOIN branch b
                          ON e.assigned_branch_id = b.branch_id
                      WHERE e.title = 'Head Teller' AND b.city = 'Woburn');

# IN operator
SELECT
  emp_id,
  fname,
  lname,
  title
FROM employee
WHERE emp_id IN (SELECT superior_emp_id
                 FROM employee);

# NOT IN operator
SELECT
  emp_id,
  fname,
  lname,
  title
FROM employee
WHERE emp_id NOT IN (SELECT superior_emp_id
                     FROM employee
                     WHERE superior_emp_id IS NOT NULL);

# comparison operator + ALL operator
SELECT
  emp_id,
  fname,
  lname,
  title
FROM employee
WHERE emp_id <> ALL (SELECT superior_emp_id
                     FROM employee
                     WHERE superior_emp_id IS NOT NULL);

# comparison operator + ALL operator
SELECT
  account_id,
  cust_id,
  product_cd,
  avail_balance
FROM account
WHERE avail_balance < ALL (SELECT a.avail_balance
                           FROM account a INNER JOIN individual i
                               ON a.cust_id = i.cust_id
                           WHERE i.fname = 'Frank' AND i.lname = 'Tucker');

# comparison operator + ANY operator
SELECT
  account_id,
  cust_id,
  product_cd,
  avail_balance
FROM account
WHERE avail_balance > ANY (SELECT a.avail_balance
                           FROM account a INNER JOIN individual i
                               ON a.cust_id = i.cust_id
                           WHERE i.fname = 'Frank' AND i.lname = 'Tucker');

# parentheses + IN operator
SELECT
  account_id,
  product_cd,
  cust_id
FROM account
WHERE (open_branch_id, open_emp_id) IN
      (SELECT
         b.branch_id,
         e.emp_id
       FROM branch b INNER JOIN employee e
           ON b.branch_id = e.assigned_branch_id
       WHERE b.name = 'Woburn Branch'
             AND (e.title = 'Teller' OR e.title = 'Head Teller'));

# ===== CORRELATED SUBQUERIES =====
# correlated subqueries are executed once for each candidate row

SELECT
  c.cust_id,
  c.cust_type_cd,
  c.city
FROM customer c
WHERE 2 = (SELECT COUNT(*)
           FROM account a
           WHERE a.cust_id = c.cust_id);

SELECT
  c.cust_id,
  c.cust_type_cd,
  c.city
FROM customer c
WHERE (SELECT SUM(a.avail_balance)
       FROM account a
       WHERE a.cust_id = c.cust_id)
BETWEEN 5000 AND 10000;

UPDATE account a
SET a.last_activity_date =
(SELECT MAX(t.txn_date)
 FROM transaction t
 WHERE t.account_id = a.account_id);

DELETE FROM department
WHERE NOT EXISTS(SELECT 1
                 FROM employee
                 WHERE employee.dept_id = department.dept_id);

# ===== Subqueries As Data Sources =====

SELECT
  d.dept_id,
  d.name,
  e_cnt.how_many num_employees
FROM department d INNER JOIN
  (SELECT
     dept_id,
     COUNT(*) how_many
   FROM employee
   GROUP BY dept_id) e_cnt
    ON d.dept_id = e_cnt.dept_id;

# data fabrication
SELECT
  groups.name,
  COUNT(*) num_customers
FROM
  (SELECT SUM(a.avail_balance) cust_balance
   FROM account a INNER JOIN product p
       ON a.product_cd = p.product_cd
   WHERE p.product_type_cd = 'ACCOUNT'
   GROUP BY a.cust_id) cust_rollup
  INNER JOIN
  (SELECT
     'Small Fry' name,
     0           low_limit,
     4999.99     high_limit
   UNION ALL
   SELECT
     'Average Joes' name,
     5000           low_limit,
     9999.99        high_limit
   UNION ALL
   SELECT
     'Heavy Hitters' name,
     10000           low_limit,
     9999999.99      high_limit) groups
    ON cust_rollup.cust_balance
  BETWEEN groups.low_limit AND groups.high_limit
GROUP BY groups.name;

# ===== Task-oriented Subqueries =====

SELECT
  p.name                        product,
  b.name                        branch,
  CONCAT(e.fname, ' ', e.lname) name,
  SUM(a.avail_balance)          tot_deposits
FROM account a INNER JOIN employee e
    ON a.open_emp_id = e.emp_id
  INNER JOIN branch b
    ON a.open_branch_id = b.branch_id
  INNER JOIN product p
    ON a.product_cd = p.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
GROUP BY p.name, b.name, e.fname, e.lname
ORDER BY 1, 2;

# the same as previous but more beautiful and faster(?)
SELECT
  p.name                        product,
  b.name                        branch,
  CONCAT(e.fname, ' ', e.lname) name,
  account_groups.tot_deposits
FROM
  (SELECT
     product_cd,
     open_branch_id     branch_id,
     open_emp_id        emp_id,
     SUM(avail_balance) tot_deposits
   FROM account
   GROUP BY product_cd, open_branch_id, open_emp_id) account_groups
  INNER JOIN employee e ON e.emp_id = account_groups.emp_id
  INNER JOIN branch b ON b.branch_id = account_groups.branch_id
  INNER JOIN product p ON p.product_cd = account_groups.product_cd
WHERE p.product_type_cd = 'ACCOUNT'
ORDER BY 1, 2;

# ===== Subqueries As Expression Generators =====

SELECT
  (SELECT p.name
   FROM product p
   WHERE p.product_cd = a.product_cd
         AND p.product_type_cd = 'ACCOUNT') product,
  (SELECT b.name
   FROM branch b
   WHERE b.branch_id = a.open_branch_id)    branch,
  (SELECT CONCAT(e.fname, ' ', e.lname)
   FROM employee e
   WHERE e.emp_id = a.open_emp_id)          name,
  SUM(a.avail_balance)                      tot_deposits
FROM account a
GROUP BY a.product_cd, a.open_branch_id, a.open_emp_id
ORDER BY 1, 2;

# subquery in SELECT clause
SELECT
  all_prods.product,
  all_prods.branch,
  all_prods.name,
  all_prods.tot_deposits
FROM
  (SELECT
     (SELECT p.name
      FROM product p
      WHERE p.product_cd = a.product_cd
            AND p.product_type_cd = 'ACCOUNT') product,
     (SELECT b.name
      FROM branch b
      WHERE b.branch_id = a.open_branch_id)    branch,
     (SELECT CONCAT(e.fname, ' ', e.lname)
      FROM employee e
      WHERE e.emp_id = a.open_emp_id)          name,
     SUM(a.avail_balance)                      tot_deposits
   FROM account a
   GROUP BY a.product_cd, a.open_branch_id, a.open_emp_id
  ) all_prods
WHERE all_prods.product IS NOT NULL
ORDER BY 1, 2;

# subquery in INSERT clause
INSERT INTO account
(account_id, product_cd, cust_id, open_date, last_activity_date,
 status, open_branch_id, open_emp_id, avail_balance, pending_balance)
VALUES (NULL,
        (SELECT product_cd
         FROM product
         WHERE name = 'savings account'),
        (SELECT cust_id
         FROM customer
         WHERE fed_id = '555-55-5555'),
        '2008-09-25', '2008-09-25', 'ACTIVE',
        (SELECT branch_id
         FROM branch
         WHERE name = 'Quincy Branch'),
        (SELECT emp_id
         FROM employee
         WHERE lname = 'Portman' AND fname = 'Frank'),
        0, 0);
