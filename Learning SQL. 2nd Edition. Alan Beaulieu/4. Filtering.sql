# BETWEEN operator (with dates)
SELECT
  emp_id,
  fname,
  lname,
  start_date
FROM employee
WHERE start_date BETWEEN '2005-01-01' AND '2007-01-01';

# BETWEEN operator (with numbers)
SELECT
  account_id,
  product_cd,
  cust_id,
  avail_balance
FROM account
WHERE avail_balance BETWEEN 3000 AND 5000;

# BETWEEN operator (with strings. by the order of the characters within your character set)
# the order in which the characters within a character set are sorted is called a collation
SELECT
  cust_id,
  fed_id
FROM customer
WHERE cust_type_cd = 'I'
      AND fed_id BETWEEN '500-00-0000' AND '999-99-9999';

# IN operator
SELECT
  account_id,
  product_cd,
  cust_id,
  avail_balance
FROM account
WHERE product_cd IN ('CHK', 'SAV', 'CD', 'MM');

# IN operator + subquery
SELECT
  account_id,
  product_cd,
  cust_id,
  avail_balance
FROM account
WHERE product_cd IN (SELECT product_cd
                     FROM product
                     WHERE product_type_cd = 'ACCOUNT');

# NOT IN operator
SELECT
  account_id,
  product_cd,
  cust_id,
  avail_balance
FROM account
WHERE product_cd NOT IN ('CHK', 'SAV', 'CD', 'MM');

SELECT
  emp_id,
  fname,
  lname
FROM employee
WHERE LEFT(lname, 1) = 'T';

# LIKE operator + wildcards. _ (exactly one character) and % (any number of characters (including 0))
SELECT lname
FROM employee
WHERE lname LIKE '_a%e%';

# LIKE operator + wildcards
SELECT
  cust_id,
  fed_id
FROM customer
WHERE fed_id LIKE '___-__-____';

# REGEXP operator
SELECT
  emp_id,
  fname,
  lname
FROM employee
WHERE lname REGEXP '^[FG]';

# IS NULL operator
SELECT
  emp_id,
  fname,
  lname,
  superior_emp_id
FROM employee
WHERE superior_emp_id IS NULL;

# IS NOT NULL operator
SELECT
  emp_id,
  fname,
  lname,
  superior_emp_id
FROM employee
WHERE superior_emp_id IS NOT NULL;

