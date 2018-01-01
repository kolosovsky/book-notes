CREATE VIEW customer_vw
(cust_id,
    fed_id,
    cust_type_cd,
    address,
    city,
    state,
    zipcode
)
  AS
    SELECT
      cust_id,
      concat('ends in ', substr(fed_id, 8, 4)) fed_id,
      cust_type_cd,
      address,
      city,
      state,
      postal_code
    FROM customer;

SELECT
  cust_id,
  fed_id,
  cust_type_cd
FROM customer_vw;

# ===== WHY USE VIEWS =====

# data security
CREATE VIEW business_customer_vw
(cust_id,
    fed_id,
    cust_type_cd,
    address,
    city,
    state,
    zipcode
)
  AS
    SELECT
      cust_id,
      concat('ends in ', substr(fed_id, 8, 4)) fed_id,
      cust_type_cd,
      address,
      city,
      state,
      postal_code
    FROM customer
    WHERE cust_type_cd = 'B';

# data aggregation
CREATE VIEW customer_totals_vw
(cust_id,
    cust_type_cd,
    cust_name,
    num_accounts,
    tot_deposits
)
  AS
    SELECT
      cst.cust_id,
      cst.cust_type_cd,
      CASE
      WHEN cst.cust_type_cd = 'B'
        THEN
          (SELECT bus.name
           FROM business bus
           WHERE bus.cust_id = cst.cust_id)
      ELSE
        (SELECT concat(ind.fname, ' ', ind.lname)
         FROM individual ind
         WHERE ind.cust_id = cst.cust_id)
      END             cust_name,
      sum(CASE WHEN act.status = 'ACTIVE'
        THEN 1
          ELSE 0 END) tot_active_accounts,
      sum(CASE WHEN act.status = 'ACTIVE'
        THEN act.avail_balance
          ELSE 0 END) tot_balance
    FROM customer cst INNER JOIN account act
        ON act.cust_id = cst.cust_id
    GROUP BY cst.cust_id, cst.cust_type_cd;

# hiding complexity
CREATE VIEW branch_activity_vw
(branch_name,
    city,
    state,
    num_employees,
    num_active_accounts,
    tot_transactions
)
  AS
    SELECT
      br.name,
      br.city,
      br.state,
      (SELECT count(*)
       FROM employee emp
       WHERE emp.assigned_branch_id = br.branch_id)                         num_emps,
      (SELECT count(*)
       FROM account acnt
       WHERE acnt.status = 'ACTIVE' AND acnt.open_branch_id = br.branch_id) num_accounts,
      (SELECT count(*)
       FROM transaction txn
       WHERE txn.execution_branch_id = br.branch_id)                        num_txns
    FROM branch br;

# joining partitioned data
CREATE VIEW transaction_vw
(txn_date,
    account_id,
    txn_type_cd,
    amount,
    teller_emp_id,
    execution_branch_id,
    funds_avail_date
)
  AS
    SELECT
      txn_date,
      account_id,
      txn_type_cd,
      amount,
      teller_emp_id,
      execution_branch_id,
      funds_avail_date
    FROM transaction_historic
    UNION ALL
    SELECT
      txn_date,
      account_id,
      txn_type_cd,
      amount,
      teller_emp_id,
      execution_branch_id,
      funds_avail_date
    FROM transaction_current;
