/* IS5102, Alexander Konovalov, October 2021

University database example for the cycle of lectures on SQL

Usage:
- To connect to a transient in-memory database:

    sqlite3 --init uni.sql

- To connect to a named database:

    sqlite3 <name.db> --init uni.sql
*/

.mode column
.headers on
.width 18 18 18 18
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
       ('12355', 'Pedro', 'MATH', 32000),
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
