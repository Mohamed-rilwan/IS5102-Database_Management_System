/* IS5102, Alexander Konovalov, October 2020

Short reproducible workflow example for Lecture 7

Usage:
- To connect to a transient in-memory database:

    sqlite3 --init depts.sql

- To connect to a named database:

    sqlite3 <name.db> --init depts.sql
*/

-- If using DBeaver, keep the following SQLite shell commands commented out. 
-- If using SQLite shell, uncomment them for a nicely formatted output  
/*
.mode column
.headers on
.width 18 18 18 18
*/

-- Uncomment the DROP command below if you need to reset existing database
DROP TABLE department;

CREATE TABLE department (
    dept_id    CHAR(5),
    dept_name  VARCHAR(20),
    building   VARCHAR(15),
    budget     NUMERIC(12,2)
);

INSERT INTO department
VALUES ('CS', 'Computer Science', 'Jack Cole', 1500000.00),
       ('MATH','Mathematics and Statistics', 'Maths', 900000.00),
       ('PHYS', 'Physics and Astronomy', 'Physics', 1500000.00);
       
SELECT * FROM department;
