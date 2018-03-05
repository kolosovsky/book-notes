# GROUP BY clouse
SELECT open_emp_id
FROM account
GROUP BY open_emp_id;

# GROUP BY + count() aggregate function
SELECT
  open_emp_id,
  COUNT(*) how_many
FROM account
GROUP BY open_emp_id;

# GROUP BY + count() aggregate function + HAVING clause
SELECT
  open_emp_id,
  COUNT(*) how_many
FROM account
GROUP BY open_emp_id
HAVING COUNT(*) > 4;

# GROUP BY + max(), min(), avg(), sum(), count() aggregate functions
SELECT
  MAX(avail_balance) max_balance,
  MIN(avail_balance) min_balance,
  AVG(avail_balance) avg_balance,
  SUM(avail_balance) tot_balance,
  COUNT(*)           num_accounts
FROM account
WHERE product_cd = 'CHK';

# count() function + DISTINCT keyword
SELECT COUNT(DISTINCT open_emp_id)
FROM account;

# max() function + expression
SELECT MAX(pending_balance - avail_balance) max_uncleared
FROM account;

# multicolumn grouping
SELECT
  product_cd,
  open_branch_id,
  SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd, open_branch_id;

# GROUP BY + expression
SELECT
  EXTRACT(YEAR FROM start_date) year,
  COUNT(*)                      how_many
FROM employee
GROUP BY EXTRACT(YEAR FROM start_date);

#  WITH ROLLUP in the GROUP BY clause
SELECT
  product_cd,
  open_branch_id,
  SUM(avail_balance) tot_balance
FROM account
GROUP BY product_cd, open_branch_id WITH ROLLUP;

# HAVING clause
SELECT
  product_cd,
  SUM(avail_balance) prod_balance
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING SUM(avail_balance) >= 10000;

