# table scan
SELECT
  dept_id,
  name
FROM department
WHERE name LIKE 'A%';

# add index
ALTER TABLE department
  ADD INDEX dept_name_idx (name);

# show indexes
SHOW INDEX FROM department;

# remove index
ALTER TABLE department
  DROP INDEX dept_name_idx;

# add unique index
ALTER TABLE department
  ADD UNIQUE dept_name_idx (name);

# add multicolumn index
ALTER TABLE employee
  ADD INDEX emp_names_idx (lname, fname);

# show the execution plan for the query
EXPLAIN SELECT
          cust_id,
          SUM(avail_balance) tot_bal
        FROM account
        WHERE cust_id IN (1, 5, 9, 11)
        GROUP BY cust_id;

# add constraints
ALTER TABLE product
  ADD CONSTRAINT pk_product PRIMARY KEY (product_cd);
ALTER TABLE product
  ADD CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
REFERENCES product_type (product_type_cd);

# remove constraints
ALTER TABLE product
  DROP PRIMARY KEY;
ALTER TABLE product
  DROP FOREIGN KEY fk_product_type_cd;

# add constraints at the time of table creation
CREATE TABLE product
(
  product_cd      VARCHAR(10) NOT NULL,
  name            VARCHAR(50) NOT NULL,
  product_type_cd VARCHAR(10) NOT NULL,
  date_offered    DATE,
  date_retired    DATE,
  CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
  REFERENCES product_type (product_type_cd),
  CONSTRAINT pk_product PRIMARY KEY (product_cd)
);

# update cascade clause
ALTER TABLE product
  DROP FOREIGN KEY fk_product_type_cd;
ALTER TABLE product
  ADD CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
REFERENCES product_type (product_type_cd)
  ON UPDATE CASCADE;

# update and delete cascade clauses
ALTER TABLE product
  ADD CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
REFERENCES product_type (product_type_cd)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

