START TRANSACTION;

SELECT
  i.cust_id,
  (SELECT a.account_id
   FROM account a
   WHERE a.cust_id = i.cust_id
         AND a.product_cd = 'MM')  mm_id,
  (SELECT a.account_id
   FROM account a
   WHERE a.cust_id = i.cust_id
         AND a.product_cd = 'chk') chk_id
INTO @cst_id, @mm_id, @chk_id
FROM individual i
WHERE i.fname = 'Frank' AND i.lname = 'Tucker';

INSERT INTO transaction (txn_id, txn_date, account_id,
                         txn_type_cd, amount)
VALUES (NULL, now(), @mm_id, 'CDT', 50);

INSERT INTO transaction (txn_id, txn_date, account_id,
                         txn_type_cd, amount)
VALUES (NULL, now(), @chk_id, 'DBT', 50);

UPDATE account
SET last_activity_date = now(),
  avail_balance        = avail_balance - 50
WHERE account_id = @mm_id;

UPDATE account
SET last_activity_date = now(),
  avail_balance        = avail_balance + 50
WHERE account_id = @chk_id;

COMMIT;

SELECT * FROM transaction;