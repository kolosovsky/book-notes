# check mode. with MySQL 6.0, the default behavior is now “strict” mode
# if the length of the string exceeds the maximum size for the character column the server will throw an exception
SELECT @@session.sql_mode;

# set mode. mode 'ansi' issues a warning instead of raising an exception in the previous situation
SET sql_mode = 'ansi';

# must be executed immediately after 'bad' query
SHOW WARNINGS;

# escaping
UPDATE string_tbl
SET text_fld = 'This string didn''t work, but it does now';

# escaping. the same as previous. work in MySQL and Oracle Database
UPDATE string_tbl
SET text_fld = 'This string didn\'t work, but it does now';

# quote() function. places quotes around the entire string and adds escapes to any single quotes/apostrophes
SELECT QUOTE(text_fld)
FROM string_tbl;

# char() function. builds strings from any of the 255 characters in the ASCII character set
SELECT
  'abcdefg',
  CHAR(97, 98, 99, 100, 101, 102, 103);

# concat() function
SELECT CONCAT('danke sch', CHAR(148), 'n');

# concat() function
UPDATE string_tbl
SET text_fld = CONCAT(text_fld, ', but now it is longer');

# ascii() function. takes the leftmost character in the string and returns its ASCII equivalent
SELECT ASCII('ö');

# length() function
SELECT LENGTH('Some string');

# position() function
# the first character in a string is at position 1. a return value of 0 from position() indicates that the substring could not be found
SELECT POSITION('characters' IN 'some characters');

# position() function
SELECT POSITION('characters' IN vchar_fld)
FROM string_tbl;

# locate() function
# is similar to position() function except that it allows an optional third parameter - search’s start position
SELECT LOCATE('is', 'frontend is awesome', 5);

# strcmp() function. case-insensitive
SELECT
  STRCMP('12345', '12345')   12345_12345,
  STRCMP('abcd', 'xyz')      abcd_xyz,
  STRCMP('abcd', 'QRSTUV')   abcd_QRSTUV,
  STRCMP('qrstuv', 'QRSTUV') qrstuv_QRSTUV,
  STRCMP('12345', 'xyz')     12345_xyz,
  STRCMP('xyz', 'qrstuv')    xyz_qrstuv;

# LIKE operator in the SELECT clause
SELECT
  name,
  name LIKE '%ns' ends_in_ns
FROM department;

# REGEXP operator in the SELECT clause
SELECT
  cust_id,
  cust_type_cd,
  fed_id,
  fed_id REGEXP '.{3}-.{2}-.{4}' is_ss_no_format
FROM customer;

# insert() function
SELECT INSERT('goodbye world', 9, 0, 'cruel ') string;

# insert() function
SELECT INSERT('goodbye world', 1, 7, 'hello') string;

# substring() function
SELECT SUBSTRING('goodbye cruel world', 9, 5);

# mod() function.  the modulo operator, which calculates the remainder when one number is divided into another number
SELECT MOD(10, 4);

# pow() function
SELECT POW(2, 8);

# ceil(), floor(), round() functions
SELECT
  CEIL(72.445),
  FLOOR(72.445),
  ROUND(72.49999),
  ROUND(72.5),
  ROUND(72.50001);

# round() function with second argument
SELECT
  ROUND(72.0909, 1),
  ROUND(72.0909, 2),
  ROUND(72.0909, 3);

# truncate() function
SELECT
  TRUNCATE(72.0909, 1),
  TRUNCATE(72.0909, 2),
  TRUNCATE(72.0909, 3);

# round(), truncate() with second negative argument
SELECT
  ROUND(17, -1),
  TRUNCATE(17, -1);

# sign(), abs() functions
SELECT
  account_id,
  SIGN(avail_balance),
  ABS(avail_balance)
FROM account;

SELECT
  @@global.time_zone,
  @@session.time_zone;

# set session timezone
SET time_zone = 'Europe/Zurich';

# str_to_date() function
UPDATE individual
SET birth_date = STR_TO_DATE('September 17, 2008', '%M %d, %Y')
WHERE cust_id = 9999;

# current_date(), current_time(), current_timestamp() functions
SELECT
  CURRENT_DATE(),
  CURRENT_TIME(),
  CURRENT_TIMESTAMP();

# date_add() function
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY);

# date_add() function
UPDATE transaction
SET txn_date = DATE_ADD(txn_date, INTERVAL '3:27:11' HOUR_SECOND)
WHERE txn_id = 9999;

# date_add() function
UPDATE employee
SET birth_date = DATE_ADD(birth_date, INTERVAL '9-11' YEAR_MONTH)
WHERE emp_id = 4789;

# last_day() function
SELECT LAST_DAY('2008-09-17');

# convert_tz() function
SELECT
  CURRENT_TIMESTAMP()                                  current_est,
  CONVERT_TZ(CURRENT_TIMESTAMP(), 'US/Eastern', 'UTC') current_utc;

# dayname(), monthname() function
SELECT
  DAYNAME(NOW()),
  MONTHNAME(NOW());

# extract() function
SELECT
  EXTRACT(YEAR FROM NOW())   year,
  EXTRACT(MONTH FROM NOW())  month,
  EXTRACT(DAY FROM NOW())    day,
  EXTRACT(MINUTE FROM NOW()) minute,
  EXTRACT(SECOND FROM NOW()) second;

# datediff() function
SELECT DATEDIFF('2009-09-03', '2009-06-24');

# cast() functoin
SELECT
  CAST('1456328' AS SIGNED INTEGER) integer_field,
  CAST('2008-09-17' AS DATE)        date_field,
  CAST('999ABC111' AS UNSIGNED INTEGER);
