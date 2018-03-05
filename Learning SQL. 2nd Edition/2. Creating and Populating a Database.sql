# CREATE TABLE statement
CREATE TABLE person
(
  person_id   SMALLINT UNSIGNED,
  fname       VARCHAR(20),
  lname       VARCHAR(20),
  gender      ENUM ('M', 'F'),
  birth_date  DATE,
  street      VARCHAR(30),
  city        VARCHAR(20),
  state       VARCHAR(20),
  country     VARCHAR(20),
  postal_code VARCHAR(20),
  CONSTRAINT pk_person PRIMARY KEY (person_id)
);

# CREATE TABLE statement
CREATE TABLE favorite_food
(
  person_id SMALLINT UNSIGNED,
  food      VARCHAR(20),
  CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
  CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id)
  REFERENCES person (person_id)
);

# INSERT statement
INSERT INTO person (person_id, fname, lname, gender, birth_date)
VALUES (NULL, 'William', 'Turner', 'M', '1972-05-27');

# UPDATE statement
UPDATE person
SET street    = '1225 Tremont St.',
  city        = 'Boston',
  state       = 'MA',
  country     = 'USA',
  postal_code = '02138'
WHERE person_id = 1;

# DELETE statement
DELETE FROM person
WHERE person_id = 2;

