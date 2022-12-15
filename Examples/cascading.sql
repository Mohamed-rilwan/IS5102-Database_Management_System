-- Example to illustrate ON UPDATE
.mode column
.headers on
PRAGMA foreign_keys = TRUE;

-- Create tables

CREATE TABLE genre (
    code, 
    genre_name,
    PRIMARY KEY (code));

CREATE TABLE film (
    film_id, 
    film_title, 
    genre_code, 
    PRIMARY KEY (film_id), 
    FOREIGN KEY (genre_code) REFERENCES genre(code)
        ON UPDATE CASCADE 
        ON DELETE CASCADE);

-- Populate them with some data

INSERT INTO genre 
VALUES ("001", "Science Fiction"), 
       ("002", "Comedy");

INSERT INTO film 
VALUES ("TFE", "The Fifth Element", "001" ), 
       ("GD", "Groundhog Day", "002");

-- Inspect data

SELECT * FROM genre;
SELECT * FROM film;

-- Check that this update in `genre` propagates to `film`

UPDATE genre 
   SET code = "000" 
 WHERE code = "001";

SELECT * FROM genre;
SELECT * FROM film;

-- Check that this deletion in `genre` also causes deletion in `film`

DELETE FROM genre 
 WHERE code="002";

SELECT * FROM genre;
SELECT * FROM film;

-- Uncomment the next lines if you want to repeat this again, again and again ...
-- DROP TABLE genre;
-- DROP TABLE film;
