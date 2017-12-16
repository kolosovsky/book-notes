# JOIN (implicit CROSS JOIN)
SELECT
  e.fname,
  e.lname,
  d.name
FROM employee e
  JOIN department d;

# INNER JOIN
SELECT
  a.account_id,
  b.cust_id,
  b.name
FROM account a INNER JOIN business b
    ON a.cust_id = b.cust_id;

# LEFT OUTER JOIN
SELECT
  c.cust_id,
  b.name
FROM customer c LEFT OUTER JOIN business b
    ON c.cust_id = b.cust_id;

# RIGHT OUTER JOIN
SELECT
  c.cust_id,
  b.name
FROM customer c RIGHT OUTER JOIN business b
    ON c.cust_id = b.cust_id;

# self OUTER JOIN
SELECT
  e.fname,
  e.lname,
  e_mgr.fname mgr_fname,
  e_mgr.lname mgr_lname
FROM employee e INNER JOIN employee e_mgr
    ON e.superior_emp_id = e_mgr.emp_id;

# self LEFT OUTER JOIN
SELECT
  e.fname,
  e.lname,
  e_mgr.fname mgr_fname,
  e_mgr.lname mgr_lname
FROM employee e LEFT OUTER JOIN employee e_mgr
    ON e.superior_emp_id = e_mgr.emp_id;

# self RIGHT OUTER JOIN
SELECT
  e.fname,
  e.lname,
  e_mgr.fname mgr_fname,
  e_mgr.lname mgr_lname
FROM employee e RIGHT OUTER JOIN employee e_mgr
    ON e.superior_emp_id = e_mgr.emp_id;

# CROSS JOIN
SELECT DATE_ADD('2008-01-01',
                INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
FROM
  (SELECT 0 num
   UNION ALL
   SELECT 1 num
   UNION ALL
   SELECT 2 num
   UNION ALL
   SELECT 3 num
   UNION ALL
   SELECT 4 num
   UNION ALL
   SELECT 5 num
   UNION ALL
   SELECT 6 num
   UNION ALL
   SELECT 7 num
   UNION ALL
   SELECT 8 num
   UNION ALL
   SELECT 9 num) ones
  CROSS JOIN
  (SELECT 0 num
   UNION ALL
   SELECT 10 num
   UNION ALL
   SELECT 20 num
   UNION ALL
   SELECT 30 num
   UNION ALL
   SELECT 40 num
   UNION ALL
   SELECT 50 num
   UNION ALL
   SELECT 60 num
   UNION ALL
   SELECT 70 num
   UNION ALL
   SELECT 80 num
   UNION ALL
   SELECT 90 num) tens
  CROSS JOIN
  (SELECT 0 num
   UNION ALL
   SELECT 100 num
   UNION ALL
   SELECT 200 num
   UNION ALL
   SELECT 300 num) hundreds
WHERE DATE_ADD('2008-01-01',
               INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2009-01-01'
ORDER BY 1;

SELECT
  days.dt,
  COUNT(t.txn_id)
FROM transaction t RIGHT OUTER JOIN
  (SELECT DATE_ADD('2004-01-01',
                   INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
   FROM
     (SELECT 0 num
      UNION ALL
      SELECT 1 num
      UNION ALL
      SELECT 2 num
      UNION ALL
      SELECT 3 num
      UNION ALL
      SELECT 4 num
      UNION ALL
      SELECT 5 num
      UNION ALL
      SELECT 6 num
      UNION ALL
      SELECT 7 num
      UNION ALL
      SELECT 8 num
      UNION ALL
      SELECT 9 num) ones
     CROSS JOIN
     (SELECT 0 num
      UNION ALL
      SELECT 10 num
      UNION ALL
      SELECT 20 num
      UNION ALL
      SELECT 30 num
      UNION ALL
      SELECT 40 num
      UNION ALL
      SELECT 50 num
      UNION ALL
      SELECT 60 num
      UNION ALL
      SELECT 70 num
      UNION ALL
      SELECT 80 num
      UNION ALL
      SELECT 90 num) tens
     CROSS JOIN
     (SELECT 0 num
      UNION ALL
      SELECT 100 num
      UNION ALL
      SELECT 200 num
      UNION ALL
      SELECT 300 num) hundreds
   WHERE DATE_ADD('2004-01-01',
                  INTERVAL (ones.num + tens.num + hundreds.num) DAY) <
         '2005-01-01') days
    ON days.dt = t.txn_date
GROUP BY days.dt
ORDER BY 1;

# NATURAL JOIN (implicit INNER JOIN)
SELECT
  a.account_id,
  a.cust_id,
  c.cust_type_cd,
  c.fed_id
FROM account a NATURAL JOIN customer c;

# NATURAL JOIN (implicit CROSS JOIN)
SELECT
  a.account_id,
  a.cust_id,
  a.open_branch_id,
  b.name
FROM account a NATURAL JOIN branch b;