/* IS5102, Alexander Konovalov, October 2022

University database example for the cycle of lectures on SQL

Lectures 8 - 11

Usage:
- To connect to a transient in-memory database:

    sqlite3 --init uni.sql

- To connect to a named database:

    sqlite3 <name.db> --init uni.sql
*/

-- If using DBeaver, keep the following SQLite shell commands commented out. 
-- If using SQLite shell, uncomment them for a nicely formatted output  
/*
.mode column
.headers on
.width 18 18 18 18
*/

-- enforce foreign keys check
PRAGMA foreign_keys = TRUE;

-- Uncomment the DROP command below if you need to reset an existing
-- database. Tables are listed in the order which allows to drop them
-- without breaking foreign key constraints.
-- 
/*
DROP table teaches;
DROP table course;
DROP table student;
DROP table instructor;
DROP table department;
*/

----------------------------------------------------------------------
-- DECLARATIONS
----------------------------------------------------------------------

CREATE TABLE department (
    dept_id    CHAR(5),
    dept_name  VARCHAR(20) NOT NULL,
    building   VARCHAR(15),
    budget     NUMERIC(12,2),
    PRIMARY KEY (dept_id)
);

CREATE TABLE instructor (
    instr_id    CHAR (5), 
    instr_name  VARCHAR(20) NOT NULL,
    dept_id     VARCHAR(5),
    salary      NUMERIC (8,2),
    PRIMARY KEY (instr_id),
    FOREIGN KEY (dept_id) REFERENCES department);

CREATE TABLE student (
    stud_id   CHAR(5),
    name      VARCHAR(20) NOT NULL,
    dept_id   VARCHAR(20),
    tot_cred  NUMERIC(3,0) DEFAULT 0,
    PRIMARY KEY (stud_id),
    FOREIGN KEY (dept_id) REFERENCES department);

CREATE TABLE course (
    course_id  VARCHAR(8),
    title      VARCHAR(50),
    dept_id    VARCHAR(20),
    credits    NUMERIC(2,0),
    PRIMARY KEY (course_id),
    FOREIGN KEY (dept_id) references department
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE TABLE course_runs (
    course_id  VARCHAR(8),
    year       INTEGER,
    semester   INTEGER,
    PRIMARY KEY (course_id, year, semester),
    FOREIGN KEY (course_id) references course);
 
CREATE TABLE teaches (
    instr_id  CHAR(5),
    course_id VARCHAR(8),
    PRIMARY KEY (instr_id,course_id),
    FOREIGN KEY (instr_id) references instructor,
    FOREIGN KEY (course_id) references course);

CREATE TABLE prereq (
    course_id  VARCHAR(8),
    prereq_id  VARCHAR(8),
    PRIMARY KEY (course_id),
    FOREIGN KEY (prereq_id) references course(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

----------------------------------------------------------------------
-- TEST DATA
----------------------------------------------------------------------
       
INSERT INTO department
VALUES ('CS', 'Computer Science', 'Jack Cole', 1500000.00),
       ('CHEM', 'Chemistry', 'Purdie',200000.00),
       ('MATH','Maths and Stats', 'Maths', 900000.00),
       ('PHYS', 'Phys and Astro', 'Physics', 1500000.00);

INSERT INTO instructor 
VALUES ('45797', 'Bob', 'CS', 28000),
       ('23541', 'Javier', 'CS', 33600),
       ('22418', 'Karolina', 'CS', 27000),
       ('34123', 'Layla', 'MATH', 27000),
       ('12355', 'Petro', 'MATH', 32000),
       ('52412', 'Jan', 'MATH', 29300),
       ('21357', 'Isaac', 'CHEM', 37500),
       ('13842', 'Ali', 'CHEM', 34900),
       ('23456', 'Alice', 'PHYS', 29500),
       ('45638', 'Sana', 'PHYS', 31500);

INSERT INTO student 
VALUES ('64545', 'Abdul', 'MATH', 180),
       ('78778', 'Martha', 'MATH', 90),
       ('99680', 'Eliot', 'CHEM', 90),
       ('78621', 'Bartosz', 'CHEM', 90),
       ('67868', 'Elias', 'CS', 90),
       ('87690', 'Joao', 'CS', 90),
       ('79879', 'Tom', 'CS', 90),
       ('90780', 'Julia', 'CS', 120),
       ('89675', 'Eilidh', 'PHYS', 120),
       ('96544', 'Sarah', 'PHYS', 180);

INSERT INTO course 
VALUES ('CS1234', 'Python', 'CS', 15),
       ('CS1001', 'Intro to Java', 'CS', 15),
       ('CS2234', 'Haskell','CS', 15),
       ('CS5099', 'Dissertation', 'CS', 30),
       ('MT4665', 'Algebra', 'MATH', 15),
       ('MT2001', 'Analysis', 'MATH', 15),
       ('MT2005', 'Group Theory', 'MATH', 15),
       ('MT5002', 'Fractals', 'MATH', 15),
       ('CH5002', 'Biochemistry', 'CHEM', 15),
       ('CH5012', 'NMR', 'CHEM', 15),
       ('CH3033', 'Organic chemistry', 'CHEM', 15),
       ('CH5015', 'Group project', 'CHEM', 30),
       ('PH4001', 'Electronics', 'PHYS', 15),
       ('PH4002', 'Lasers', 'PHYS', 15),
       ('PH3457', 'Photonics', 'PHYS', 30);

INSERT INTO course_runs
VALUES ('CS1234', 2019, 2), ('CS1234', 2020, 2), -- Python
       ('CS1001', 2019, 1), ('CS1001', 2020, 1), -- Intro to Java
       ('CS2234', 2019, 2), ('CS2234', 2020, 2), -- Haskell
       ('CS5099', 2019, 1), ('CS5099', 2020, 1), -- Dissertation
       ('CS5099', 2019, 2), ('CS5099', 2020, 2), -- Dissertation
       ('MT4665', 2019, 1), ('MT4665', 2020, 1), -- Algebra
       ('MT2001', 2019, 1), ('MT2001', 2020, 1), -- Analysis
       ('MT2005', 2019, 2), ('MT2005', 2020, 2), -- Group Theory
       ('MT5002', 2019, 1),                      -- Fractals
       ('CH5002', 2019, 1),                      -- Biochemistry
                            ('CH5012', 2020, 1), -- NMR
       ('CH3033', 2019, 1), ('CH3033', 2020, 1), -- Organic chemistry
       ('CH5015', 2019, 1), ('CH5015', 2020, 1), -- Group project
       ('CH5015', 2019, 2), ('CH5015', 2020, 2), -- Group project
       ('PH4001', 2019, 1), ('PH4001', 2020, 2), -- Electronics
       ('PH4002', 2019, 1), ('PH4002', 2020, 1), -- Lasers
                            ('PH3457', 2020, 1); -- Photonics
       
INSERT INTO teaches 
VALUES ('45797', 'CS1234'),
       ('45797', 'CS2234'),
       ('23541', 'CS1001'),
       ('22418', 'CS5099'),
       ('34123', 'MT2001'),
       ('52412', 'MT5002'),
       ('21357', 'CH5002'),
       ('13842', 'CH5012'),
       ('12355', 'MT4665'),
       ('23456', 'PH3457');

INSERT INTO prereq
VALUES ('MT5002', 'MT2001'),
       ('MT2005', 'MT4665');
       
----------------------------------------------------------------------
-- VISUAL DATA CONTROL
----------------------------------------------------------------------

-- An asterisk denotes "all attributes"
-- This "control" does not check anything, but if we can't see the
-- tables, then something definitely went wrong with defining them.

SELECT * FROM department;

SELECT * FROM instructor;

SELECT * FROM student;

SELECT * FROM course;

SELECT * FROM course_runs;

SELECT * FROM teaches;

SELECT * FROM prereq;
----------------------------------------------------------------------
-- EXAMPLE QUERIES FOR LECTURE 8
----------------------------------------------------------------------


-- Simple queries

-- Find the department names of all instructors
SELECT instr_name FROM instructor;

-- Find the department names of all instructors and remove duplicated
SELECT DISTINCT dept_id FROM instructor;

-- Explicitly specify that duplicated should not be removed
SELECT ALL dept_id FROM instructor;

-- Using arithmetic operations in queries
SELECT instr_id, instr_name, salary/12 FROM instructor;


-- Using WHERE

-- Specify conditions that the result must satisfy.
SELECT instr_name
  FROM instructor
 WHERE dept_id = 'PHYS' AND salary > 30000;

-- Generates every possible (instructor, teaches) pair
-- with all attributes from both relations.
SELECT * FROM instructor, teaches;

-- For all instructors who have taught courses, find their names
-- and the course ID of the courses they taught.
SELECT instr_name, course_id
  FROM instructor, teaches
 WHERE instructor.instr_id = teaches.instr_id;


-- NATURAL JOIN
 
-- `NATURAL JOIN` matches tuples with the same values for all 
-- common attributes, retaining only one copy of each common column 
SELECT * FROM instructor NATURAL JOIN teaches;

-- Compare NATURAL JOIN with the following (it has `instr_id` twice )
SELECT *
  FROM instructor, teaches
 WHERE instructor.instr_id = teaches.instr_id;

-- Also compare the following NATURAL JOIN 
SELECT instr_name, course_id FROM instructor NATURAL JOIN teaches;

-- and the next query. Are they equivalent? 
SELECT instr_name, course_id
  FROM instructor, teaches
 WHERE instructor.instr_id = teaches.instr_id;


-- AS for renaming
 
-- Renaming relations and attributes using the AS clause 
SELECT instr_id, instr_name, salary/12 as monthly_salary
  FROM instructor;
  
-- Find the names of all instructors who have a higher salary 
-- than some instructor in Physics:

SELECT DISTINCT T.instr_name
  FROM instructor AS T, instructor AS S
 WHERE T.salary > S.salary
   AND S.dept_id = 'PHYS';


-- More examples of INSERT

INSERT INTO course (course_id, title, dept_id, credits)
VALUES ('IS5102', 'DBMS','CS', 15);

INSERT INTO course (course_id, title, credits, dept_id)
VALUES ('IS5040', 'HCI', 15, 'CS');

INSERT INTO student
VALUES ('65467', 'Emma', 'CS', NULL);

INSERT INTO student (stud_id, name, dept_id)
VALUES ('83456', 'Nick', 'MATH' );

----------------------------------------------------------------------
-- EXAMPLE QUERIES FOR LECTURE 9
----------------------------------------------------------------------

-- Add all instructors to the student relation with `tot_creds`
-- set to zero
INSERT INTO student
SELECT instr_id, instr_name, dept_id, 0
  FROM instructor;

-- Revert the previous update (we rely on the ID of students and
-- instructors being non-overlapping)
DELETE FROM student
  WHERE stud_id IN 
        (SELECT instr_id
           FROM instructor);
           
-- Increase salaries of instructors whose salary is over £30,000
-- by 3%, and all others receive a 5% raise
UPDATE instructor
  SET salary = 
        CASE
            WHEN salary <= 30000
                THEN salary * 1.05
            ELSE salary * 1.03
        END;

-- Find the names of all instructors whose name includes
-- the substring `PH`
SELECT instr_name
  FROM instructor
 WHERE dept_id LIKE '%PH%';
 
-- List in alphabetic order the names of all instructors
SELECT DISTINCT instr_name
  FROM instructor
 ORDER BY instr_name;

-- List instructors by descending order of their salaries
  SELECT DISTINCT instr_name, salary
    FROM instructor
   ORDER BY salary DESC;

-- Find all students whose total credits is NULL.
SELECT name
  FROM student
 WHERE tot_cred IS NULL;
 
-- Find the average salary of instructors in the Physics department
SELECT AVG (salary)
  FROM instructor
 WHERE dept_id = 'PHYS';
 
-- Find the total number of instructors who teach at least one course
SELECT COUNT (DISTINCT instr_id)
  FROM teaches;

-- Find the number of tuples in the `course` relation
SELECT COUNT (*)
  FROM course;
  
-- Find the average salary of instructors in each department
SELECT dept_id, AVG (salary) AS "Average Salary"
  FROM instructor
 GROUP BY dept_id;  
 
-- Now use NATURAL JOIN to output department name instead of ID
SELECT dept_name, AVG (salary) AS "Average Salary"
  FROM instructor NATURAL JOIN department
 GROUP BY dept_id; 
 
-- Find the names and average salaries of all departments whose
--  average salary is greater than 30000
SELECT dept_id, AVG (salary)
  FROM instructor
 GROUP BY dept_id
HAVING AVG (salary) > 30000;

-- Find the total sum of all annual salaries
SELECT SUM (salary)
  FROM instructor;
