# UNION operator
SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
      AND (title = 'Teller' OR title = 'Head Teller')
UNION
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;

# UNION ALL operator (doesn't remove duplicates)
SELECT emp_id
FROM employee
WHERE assigned_branch_id = 2
      AND (title = 'Teller' OR title = 'Head Teller')
UNION ALL
SELECT DISTINCT open_emp_id
FROM account
WHERE open_branch_id = 2;

# INTERSECT operator. MySQL 6.0 does not implement the INTERSECT operator
# pseudo code example: [10, 11, 12, 10, 10] INTERSECT [10, 10, 11] returns [10, 11]

# INTERSECT ALL operator(doesn't remove duplicates). MySQL 6.0 does not implement the INTERSECT ALL operator
# pseudo code example: [10, 11, 12, 10, 10] INTERSECT ALL [10, 10, 11] returns [10, 10, 11]

# EXCEPT operator. MySQL 6.0 does not implement the EXCEPT operator
# pseudo code example: [10, 11, 12, 10, 10] EXCEPT [10] returns [11, 12]


# EXCEPT ALL operator (only removes one occurrence of duplicate data from set A for every occurrence in set B). MySQL 6.0 does not implement the EXCEPT ALL operator
# pseudo code example: [10, 11, 12, 10, 10] EXCEPT [10, 10] returns [10, 11, 12]



