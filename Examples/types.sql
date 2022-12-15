.mode column
.headers on

CREATE TABLE test_sqlite_types (
    int_val  INTEGER,
    num_val  NUMERIC,
    real_val REAL,
    text_val TEXT
);

-- Dump the table in an SQL text format
.dump test_sqlite_types

-- This works as expected
INSERT INTO test_sqlite_types
VALUES (0, 0, 0.0, '0');

SELECT * FROM test_sqlite_types;

.dump test_sqlite_types

-- This converts each entry
INSERT INTO test_sqlite_types
VALUES ('0', '0', 0, 0.0);

SELECT * FROM test_sqlite_types;

.dump test_sqlite_types

-- Let's have a more systematic look
INSERT INTO test_sqlite_types
VALUES (1, 1, 1, 1),
       (2.0, 2.0, 2.0, 2.0),
       ('3', '3', '3', '3'),
       ('4.0', '4.0', '4.0', '4.0'),
       ('five', 'five', 'five', 'five'),
       ('0.6e+1', '0.6e+1', '0.6e+1', '0.6e+1');
       
SELECT * FROM test_sqlite_types;

.dump test_sqlite_types

-- In SQLite, `INT`, `REAL`, `TEXT` (also NULL and BLOB) are storage
-- classes. A storage class is more general than a datatype. 
-- Any column in an SQLite database, except an `INTEGER PRIMARY KEY`
-- column, may be used to store a value of any storage class.
-- (see https://sqlite.org/datatype3.html)

-- How other type specifications are treated?
-- See 'Affinity Name Examples' in https://sqlite.org/datatype3.html

CREATE TABLE test_classic_types (
    char_val     CHAR, --> TEXT
    varchar_val  VARCHAR(3), --> TEXT (short enough to show overrun)
    int_val      INT, --> INTEGER
    numeric_val  NUMERIC(5,2), --> NUMERIC
    float_val    FLOAT(2), --> REAL
    wild_val     THEREISNOSUCHTYPEATALL
); 

-- types are recorded
.dump test_classic_types

INSERT INTO test_classic_types
VALUES (1, 1, 1, 1, 1, 1),
       (2.0, 2.0, 2.0, 2.0, 2.0, 2.0),
       ('3', '3', '3', '3', '3', '3'),
       ('4.000', '4.000', '4.000', '4.000', '4.000', '4.000'),
       ('five', 'five', 'five', 'five', 'five', 'five'),
       ('0.6e+1', '0.6e+1', '0.6e+1', '0.6e+1', '0.6e+1', '0.6e+1');
       
SELECT * FROM test_classic_types;

.dump test_classic_types

-- When text data is inserted into a NUMERIC column, the storage class
-- of the text is converted to INTEGER or REAL (in order of preference).
-- See more at https://sqlite.org/datatype3.html


-- Question: is it possible to enforce SQLite datatypes? Example based on
-- https://stackoverflow.com/questions/49230311/is-it-possible-to-enforce-sqlite-datatypes

-- See PRAGMA ignore_check_constraints

CREATE TABLE test_enforced_types (
    int_val  INTEGER CHECK (TYPEOF(int_val) = 'integer'),
    text_val TEXT    CHECK (TYPEOF(text_val) = 'text')
);

INSERT INTO test_enforced_types VALUES (1, '1');

INSERT INTO test_enforced_types VALUES (1, 1);

INSERT INTO test_enforced_types VALUES ('1', '1');

-- This does not work:
-- INSERT INTO test_enforced_types VALUES ('a', '1');

-- Question: what are the names of data types in other database platforms?
-- See ``SQL Data Type Quick Reference'' table at the bottom of
-- https://datacarpentry.org/sql-ecology-lesson/00-sql-introduction/index.html