# searched case expression
SELECT
  c.cust_id,
  c.fed_id,
  CASE
  WHEN c.cust_type_cd = 'I'
    THEN CONCAT(i.fname, ' ', i.lname)
  WHEN c.cust_type_cd = 'B'
    THEN b.name
  ELSE 'Unknown'
  END name
FROM customer c LEFT OUTER JOIN individual i
    ON c.cust_id = i.cust_id
  LEFT OUTER JOIN business b
    ON c.cust_id = b.cust_id;

# simple case expression
SELECT
  c.cust_id,
  c.fed_id,
  CASE c.cust_type_cd
  WHEN 'I'
    THEN
      CONCAT(i.fname, ' ', i.lname)
  WHEN 'B'
    THEN
      b.name
  ELSE 'Unknown Customer Type'
  END
FROM customer c LEFT OUTER JOIN individual i
    ON c.cust_id = i.cust_id
  LEFT OUTER JOIN business b
    ON c.cust_id = b.cust_id;

SELECT
  YEAR(open_date) year,
  COUNT(*)        how_many
FROM account
WHERE open_date > '1999-12-31'
      AND open_date < '2006-01-01'
GROUP BY YEAR(open_date);

SELECT
  SUM(CASE
      WHEN EXTRACT(YEAR FROM open_date) = 2000
        THEN 1
      ELSE 0
      END) year_2000,
  SUM(CASE
      WHEN EXTRACT(YEAR FROM open_date) = 2001
        THEN 1
      ELSE 0
      END) year_2001,
  SUM(CASE
      WHEN EXTRACT(YEAR FROM open_date) = 2002
        THEN 1
      ELSE 0
      END) year_2002,
  SUM(CASE
      WHEN EXTRACT(YEAR FROM open_date) = 2003
        THEN 1
      ELSE 0
      END) year_2003,
  SUM(CASE
      WHEN EXTRACT(YEAR FROM open_date) = 2004
        THEN 1
      ELSE 0
      END) year_2004,
  SUM(CASE
      WHEN EXTRACT(YEAR FROM open_date) = 2005
        THEN 1
      ELSE 0
      END) year_2005
FROM account
WHERE open_date > '1999-12-31' AND open_date < '2006-01-01';

SELECT
  c.cust_id,
  c.fed_id,
  c.cust_type_cd,
  CASE
  WHEN EXISTS(SELECT 1
              FROM account a
              WHERE a.cust_id = c.cust_id
                    AND a.product_cd = 'CHK')
    THEN 'Y'
  ELSE 'N'
  END has_checking,
  CASE
  WHEN EXISTS(SELECT 1
              FROM account a
              WHERE a.cust_id = c.cust_id
                    AND a.product_cd = 'SAV')
    THEN 'Y'
  ELSE 'N'
  END has_savings
FROM customer c;

SELECT
  c.cust_id,
  c.fed_id,
  c.cust_type_cd,
  CASE (SELECT COUNT(*)
        FROM account a
        WHERE a.cust_id = c.cust_id)
  WHEN 0
    THEN 'None'
  WHEN 1
    THEN '1'
  WHEN 2
    THEN '2'
  ELSE '3+'
  END num_accounts
FROM customer c;

# ensuring that the denominator is not equal to zero
SELECT
  a.cust_id,
  a.product_cd,
  a.avail_balance /
  CASE
  WHEN prod_tots.tot_balance = 0
    THEN 1
  ELSE prod_tots.tot_balance
  END percent_of_total
FROM account a INNER JOIN
  (SELECT
     a.product_cd,
     SUM(a.avail_balance) tot_balance
   FROM account a
   GROUP BY a.product_cd) prod_tots
    ON a.product_cd = prod_tots.product_cd;