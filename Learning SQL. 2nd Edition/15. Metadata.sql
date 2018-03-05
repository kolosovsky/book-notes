# information_schema.tables view
SELECT
  table_name,
  table_type
FROM information_schema.tables
WHERE table_schema = 'bank'
ORDER BY 1;

# information_schema.views view
SELECT
  table_name,
  is_updatable
FROM information_schema.views
WHERE table_schema = 'bank'
ORDER BY 1;

# information_schema.columns view
SELECT
  column_name,
  data_type,
  character_maximum_length char_max_len,
  numeric_precision        num_prcsn,
  numeric_scale            num_scale
FROM information_schema.columns
WHERE table_schema = 'bank' AND table_name = 'account'
ORDER BY ordinal_position;

# information_schema.statistics view (indexes)
SELECT
  index_name,
  non_unique,
  seq_in_index,
  column_name
FROM information_schema.statistics
WHERE table_schema = 'bank' AND table_name = 'account'
ORDER BY 1, 3;

# information_schema.table_constraints view
SELECT
  constraint_name,
  table_name,
  constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'bank'
ORDER BY 3, 1;

# dynamic SQL execution
SET @qry = 'SELECT cust_id, cust_type_cd, fed_id FROM customer';
PREPARE dynsql1 FROM @qry;
EXECUTE dynsql1;
DEALLOCATE PREPARE dynsql1;

# dynamic SQL execution with placeholder
SET @qry = 'SELECT product_cd, name, product_type_cd, date_offered, date_retired FROM product WHERE product_cd = ?';
PREPARE dynsql2 FROM @qry;
SET @prodcd = 'CHK';
EXECUTE dynsql2
USING @prodcd;
SET @prodcd = 'SAV';
EXECUTE dynsql2
USING @prodcd;
DEALLOCATE PREPARE dynsql2;

# dynamic SQL execution with placeholder and dynamic column names
SELECT concat('SELECT ',
              concat_ws(',', cols.col1, cols.col2, cols.col3, cols.col4,
                        cols.col5, cols.col6, cols.col7, cols.col8, cols.col9),
              ' FROM product WHERE product_cd = ?')
INTO @qry
FROM
  (SELECT
     max(CASE WHEN ordinal_position = 1
       THEN column_name
         ELSE NULL END) col1,
     max(CASE WHEN ordinal_position = 2
       THEN column_name
         ELSE NULL END) col2,
     max(CASE WHEN ordinal_position = 3
       THEN column_name
         ELSE NULL END) col3,
     max(CASE WHEN ordinal_position = 4
       THEN column_name
         ELSE NULL END) col4,
     max(CASE WHEN ordinal_position = 5
       THEN column_name
         ELSE NULL END) col5,
     max(CASE WHEN ordinal_position = 6
       THEN column_name
         ELSE NULL END) col6,
     max(CASE WHEN ordinal_position = 7
       THEN column_name
         ELSE NULL END) col7,
     max(CASE WHEN ordinal_position = 8
       THEN column_name
         ELSE NULL END) col8,
     max(CASE WHEN ordinal_position = 9
       THEN column_name
         ELSE NULL END) col9
   FROM information_schema.columns
   WHERE table_schema = 'bank' AND table_name = 'product'
   GROUP BY table_name
  ) cols;
PREPARE dynsql3 FROM @qry;
SET @prodcd = 'MM';
EXECUTE dynsql3
USING @prodcd;
DEALLOCATE PREPARE dynsql3;