
-- If using DBeaver, keep the following SQLite shell commands commented out. 
-- If using SQLite shell, uncomment them for a nicely formatted output  
/*
 * 
 */
.mode table
.headers on
.width 15 15 15 15



PRAGMA foreign_keys = TRUE;


DROP TABLE IF EXISTS customer_phone;
DROP TABLE IF EXISTS order_contain;
DROP TABLE IF EXISTS order_info;
DROP TABLE IF EXISTS edition;
DROP TABLE IF EXISTS book_genre;
DROP TABLE IF EXISTS supply;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS supplier_phone;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS supply;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS customer;

--------------------------------------------------------
-- DECLARATIONS
--------------------------------------------------------

CREATE TABLE IF NOT EXISTS customer(  
   customer_id 		CHAR(10),
   name 	VARCHAR(100) NOT NULL,
   email 	VARCHAR NOT NULL UNIQUE,
   street	VARCHAR(100),
   city 	VARCHAR(100),
   postcode VARCHAR(10),
   country 	VARCHAR(50),
   PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS customer_phone(
	customer_id 	CHAR(10),
    phone_type  	VARCHAR(10),
    phone_number    VARCHAR(20),
    PRIMARY KEY (customer_id,phone_number)
    FOREIGN KEY (customer_id) REFERENCES customer
    	ON DELETE CASCADE
    	ON UPDATE CASCADE
);
   

CREATE TABLE IF NOT EXISTS order_info(
	order_id		CHAR(10),
	street			VARCHAR(100) NOT NULL,
	city			VARCHAR(100) NOT NULL,
	postcode		VARCHAR(10) NOT NULL,
	country			VARCHAR(50) NOT NULL,
	date_ordered	TEXT,	--TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS").
	date_delivered 	TEXT,	--TEXT as ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS").
	customer_id		VARCHAR(50),
	PRIMARY KEY (order_id)
	FOREIGN KEY (customer_id) REFERENCES customer
		ON DELETE SET NULL
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS book(
    book_id	   	CHAR(10),
    title      	VARCHAR(50),
    author    	VARCHAR, --Comma seperated values 
    publisher   TEXT,
    PRIMARY KEY (book_id));
   

CREATE TABLE IF NOT EXISTS order_contain(
	order_id		CHAR(10),
	book_id			CHAR(10),
	edition			INTEGER,
	edition_type	VARCHAR,
	amount			INTEGER CHECK (amount >= 0), -- quantity of a book in a order 
	PRIMARY KEY (order_id, book_id, edition, edition_type)
	FOREIGN KEY (order_id) REFERENCES order_info
		ON DELETE CASCADE
		ON UPDATE CASCADE
	FOREIGN KEY (book_id, edition, edition_type) REFERENCES edition(book_id, edition, edition_type)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


CREATE TABLE book_genre(
	book_id		CHAR(10),
	genre		VARCHAR(255),
	PRIMARY KEY (book_id)
	FOREIGN KEY (book_id) REFERENCES book(book_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE supplier(
	supplier_id		CHAR(10),
	name			VARCHAR,
	account_number	VARCHAR(50)  NOT NULL UNIQUE,
	PRIMARY KEY (supplier_id)
);

CREATE TABLE supplier_phone(
	phone		VARCHAR(20),
	supplier_id	CHAR(10),
	PRIMARY KEY (supplier_id,phone)
	FOREIGN KEY (supplier_id) REFERENCES supplier
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE review(
	book_id		CHAR(10),
	customer_id	CHAR(10),
	rating		INTEGER CHECK (rating BETWEEN 1 AND 5),
	PRIMARY KEY (book_id,customer_id)
	FOREIGN KEY (book_id) REFERENCES book
		ON DELETE CASCADE
		ON UPDATE CASCADE
	FOREIGN KEY (customer_id) REFERENCES customer
		ON DELETE CASCADE
		ON UPDATE CASCADE	
);

   
 CREATE TABLE edition(
	edition				INTEGER CHECK (edition >= 0), --Edition relation admissible values of the attribute edition are positive integers,
	edition_type		VARCHAR CHECK (edition_type IN ('audiobook','hardcover','paperback')),
	price				NUMERIC(8,2) CHECK (price >= 0), --Positive price value
	quantity_in_stock	INTEGER,
	book_id				CHAR(10),
	PRIMARY KEY (edition, edition_type, book_id)
	FOREIGN KEY (book_id) REFERENCES book
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


CREATE TABLE supply(
	supplier_id		CHAR(10),
	edition			INTEGER,
	edition_type 	VARCHAR,
	book_id			CHAR(10),
	price			REAL CHECK (price >= 0), -- Only positive real number can be used 
	PRIMARY KEY (supplier_id,edition,edition_type,book_id)
	FOREIGN KEY (edition,edition_type,book_id) REFERENCES edition(edition,edition_type,book_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	FOREIGN KEY (supplier_id) REFERENCES supplier
		ON DELETE CASCADE
		ON UPDATE CASCADE	
);


----------------------------------------------------------------------
-- TEST DATA
----------------------------------------------------------------------


INSERT INTO customer
(customer_id, name, email, street, city, postcode, country)
VALUES ('C001', 'Arya Stark', 		 	'arya.stark@outlook.com',		'Market Street',			'St Andrews',	'KY87 9JI','United Kingdom'),
       ('C002', 'Daenerys Targaryen',	 'danny.targ@outlook.com',		'North Street',				'St Andrews',	'KY16 9WJ','United Kingdom'),
       ('C003', 'Jon Snow', 			 'jon.snow@outlook.com', 		'15 S Learmonth Gardens',	'Edinburgh',	'EH41 8IJ','United Kingdom'),
       ('C004', 'Tyrion Lannister', 	 'tyrion.lanny@outlook.com',	'5 Springfield Road', 		'Sutton',		'SM13 9IH','United Kingdom'),
       ('C005', 'Jon Arryn', 			 'jon.arryn.lanny@outlook.com', '9975 Green Lane', 			'London',		'N01 9BD', 'United Kingdom'),
       ('C006', 'Khal Drogo', 		     'khal.drogo@outlook.com',		'67 Church Lane', 			'Rochester',	'ME23 6RI','United Kingdom'),
       ('C007', 'Yara Greyjoy', 		 'yara.gregory@outlook.com',	'25 George St', 			'Edinburgh',	'EH2 2PB', 'United Kingdom'),
       ('C008', 'Walder Frey', 			 'walder.frey@outlook.com',		'54 Kings Road', 			'London',		'EC40 8PE','United Kingdom'),
       ('C009', 'Viserys Targaryen', 	 'viserys.targaryen@outlook.com','28 South Street', 		'Leicester',	'LE10 9YF','United Kingdom'),
       ('C010', 'Theon Greyjoy',     	 'theon.greyjoy@outlook.com',	 '35 Deanhaugh St', 		'Edinburgh',	'EH4 1LR', 'United Kingdom');
      
      
INSERT INTO customer_phone
(customer_id, phone_type, phone_number)
VALUES ('C001', 'home', 	'(704) 412-3456'),
	   ('C002', 'home', 	'(794) 498-7654'),
       ('C003', 'work', 	'(784) 498-7659'),
       ('C004', 'office', 	'(794) 456-5433'),
       ('C005', 'work', 	'(078) 978-8748'),
       ('C006', 'personal', '(989) 849-3800'),
       ('C007', 'home', 	'(767) 536-7568'),
       ('C008', 'office', 	'(754) 876-8427'),
       ('C009', 'mobile', 	'(765) 890-0932'),
       ('C010', 'office',	'(756) 425-6562');


INSERT INTO order_info 
(order_id, street, city, postcode, country, date_ordered, date_delivered, customer_id)
VALUES ('O101',	'36 Redcliffe Way',		'Woolley',			'WF4 2FF',	'United Kingdom',	'2021-01-14T18:12:13.100Z',	'2021-01-15T18:12:13.100Z',	'C002'),
       ('O102',	'6 Crown Street', 		'Long Compton',		'ST18 2JE',	'United Kingdom',	'2002-04-12T10:12:13.100Z',	'2002-04-17T10:12:13.100Z',	'C003'),
       ('O103',	'27 Cambridge Road', 	'North Buckland',	'EX33 0DR',	'United Kingdom',	'2004-05-16T17:12:13.100Z',	'2004-05-18T17:12:13.100Z',	'C004'),
       ('O104',	'48 Terrick Rd', 		'Egglescliffe',		'TS16 7PJ',	'United Kingdom',	'2010-07-11T15:12:13.100Z',	'2010-07-16T15:12:13.100Z',	'C005'),
       ('O105',	'93 Fosse Way', 		'Ardchiavaig',		'PA67 9RJ',	'United Kingdom',	'2012-09-10T09:12:13.100Z',	'2012-09-12T09:12:13.100Z',	'C006'),
       ('O106',	'3 Rothesay Terrace', 	'Edinburgh',		'EH6 5HX',	'United Kingdom',	'2018-08-01T07:12:13.100Z',	'2018-08-06T07:12:13.100Z',	'C007'),
       ('O107',	'39 Great Jct St', 		'Edinburgh',		'EH6 5AY',	'United Kingdom',	'2021-04-12T06:12:13.100Z',	'2021-04-18T06:12:13.100Z',	'C008'),
       ('O108',	'high road', 			'St Andrews',		'KY16 9WJ',	'United Kingdom',	'2019-01-15T19:12:13.100Z',	'2019-01-16T19:12:13.100Z',	'C009'),
       ('O109',	'75 Newington Rd',		'Edinburgh',		'EH9 1QW',	'United Kingdom',	'2022-08-12T08:12:13.100Z',	'2022-08-13T08:12:13.100Z',	'C010'),
       ('O110',	'106 George St', 		'Edinburgh',		'EH2 2HT',	'United Kingdom',	'2020-02-15T19:12:13.100Z',	'2020-02-16T19:12:13.100Z',	'C009'),
	   ('O111',	'16 George St', 		'Edinburgh',		'EH2 2HT',	'United Kingdom',	'2020-02-15T19:12:13.100Z',	'2020-02-16T19:12:13.100Z',	'C002'),
	   ('O112',	'1 North George St', 	'Edinburgh',		'EH2 2HT',	'United Kingdom',	'2021-03-15T19:12:13.100Z',	'2021-03-16T19:12:13.100Z',	'C009');
      
INSERT INTO book
(book_id, title, author, publisher)
VALUES ('B201',		'A time to kill',			'John grisham',			'Ultimate Books'),
       ('B202',		'The girl on the train',	'Paula Hawkins',		'Penguin Random House'),
       ('B203',		'David Copperfield', 		'David Copperfield',	'Bradbury & Evans'),
       ('B204', 	'The Brothers Karamazov', 	'Fyodor Dostoevsky',	'The Russian Messenger'),
       ('B205', 	'The Dark Tide', 			'Alicia Jasinska',  	'Ultimate Books'),
       ('B206', 	'It Came From the Sky', 	'Chelsea Sedoti', 		'Sourcebooks Fire'),
       ('B207', 	'Never Have I Ever', 		'Isabel Yap',			'Wynwood Press'),
       ('B208', 	'A Choir of Crows', 		'Candace M. Robb',		'Severn House'),
       ('B209', 	'Cold Mountain', 			'Charles Frazier',		'Grove Atlantic'),
       ('B210', 	'Shocked Earth', 			'Saskia Goldschmidt',	'Ultimate Books'),
       ('B211',		'Beyond the End of the World','Amie Kaufman, Meagan Spooner', 'Morris Kelmscott');
  
INSERT INTO book_genre 
(book_id, genre)
VALUES ('B201', 'Science Fiction'),
       ('B202', 'Science and Technology'),
       ('B203', 'Romance'),
       ('B204', 'Diverse Literature'),
       ('B205', 'Science Fiction'),
       ('B206', 'Science and Technology'),
       ('B207', 'Science and Technology'),
       ('B208', 'Drama'),
       ('B209', 'Science and Technology'),
       ('B210', 'Science Fiction');


INSERT INTO edition
(edition, edition_type, price, quantity_in_stock, book_id)
VALUES 	(1, 'audiobook', 15.00, 	2,  'B201'),
		(1, 'paperback', 10.00, 	2,  'B201'),
		(1, 'hardcover', 12.00, 	2,  'B201'),

		(2, 'audiobook', 19.00, 	1,  'B202'),
		(2, 'paperback', 10.00, 	1,  'B202'),
		(2, 'hardcover', 15.00, 	1,  'B202'),
		
		(3, 'audiobook', 10.00,  	11, 'B203'),
		(3, 'paperback', 10.00,  	11, 'B203'),
		(3, 'hardcover', 10.00,  	11, 'B203'),
						
		(4, 'hardcover', 25.00,  	3,  'B204'),
		(4, 'audiobook', 30.00,  	4,  'B204'),
		(4, 'paperback', 22.00,  	5,  'B204'),
		
		(5, 'hardcover', 30.00,  	6,  'B205'),
		(5, 'audiobook', 20.00,  	5,  'B205'),
		(5, 'paperback', 20.00,  	5,  'B205'),
		
		(6, 'hardcover', 30.00,  	3,  'B206'),
		(6, 'audiobook', 25.00,  	4,  'B206'),
		(6, 'paperback', 20.00,  	5,  'B206'),
		
		(7, 'hardcover', 20.00,  	1,  'B207'),
		(7, 'audiobook', 10.00,  	3,  'B207'),
		(7, 'paperback', 36.00,  	4,  'B207'),
		
		(8, 'hardcover', 25.00,  	1,  'B208'),
		(8, 'audiobook', 10.00,  	3,  'B208'),
		(8, 'paperback', 36.00,  	4,  'B208'),
		
		(9, 'hardcover', 15.00,  	1,  'B209'),
		(9, 'audiobook', 10.00,  	3,  'B209'),
		(9, 'paperback', 36.00,  	4,  'B209'),
		
		(10, 'hardcover', 20.00,  	1,  'B210'),
		(10, 'audiobook', 10.00,  	3,  'B210'),
		(10, 'paperback', 36.00,  	4,  'B210');

	
INSERT INTO order_contain
(order_id, book_id, edition, edition_type, amount)
VALUES 	('O101', 	'B201', 	1, 	'audiobook', 15),
		('O102', 	'B201', 	1,	'paperback', 10),
		('O103',	'B201',		1,	'hardcover', 11),		
		('O104',	'B202',		2,	'paperback', 11),
		('O105',	'B202',		2,	'audiobook', 11),
		('O106',	'B202',		2,	'hardcover', 11),		
		('O107',	'B203',		3,	'paperback', 11),		
		('O108',	'B204',		4,	'audiobook', 11),		
		('O109',	'B205',		5,	'audiobook', 11),		
		('O110',	'B210',		10,	'audiobook', 11),
		('O111',	'B209',		9,	'audiobook', 4),
		('O112',	'B208',		8,	'audiobook', 5);		

	
INSERT INTO supplier  
(supplier_id, name, account_number)
VALUES ('S501',	'Saraband', 				'1234565778'),
       ('S502',	'Mike and Ross Supplier',	'4567898765'),
       ('S503',	'Donna Supplier', 			'1232134234'),
       ('S504',	'Rachael and Co',			'2412432564');

INSERT INTO supplier_phone
(phone, supplier_id)
VALUES ('(712) 233-4455',	'S501'),
       ('(756) 545-6456',	'S502'),
       ('(743) 234-5324',	'S503'),
       ('(783) 598-9385',	'S504');
             
INSERT INTO review
(book_id, customer_id, rating)
VALUES ('B201',	'C001',	3),
       ('B202',	'C002',	1),
       ('B203',	'C003',	4),
       ('B204',	'C004',	5),
       ('B205', 'C001', 3),
       ('B206', 'C010', 1),
       ('B207', 'C002',	4),
       ('B208', 'C002',	3),
       ('B209', 'C002',	5),       
       ('B210', 'C003', 1);
       

INSERT INTO supply
(supplier_Id, edition, edition_type, book_id, price)
VALUES ('S501',	'1',	'audiobook',	'B201',	 13.00),
       ('S501',	'1',	'paperback',	'B201',	 15.00),
       ('S501',	'1',	'hardcover',	'B201',	 15.00),
       
       ('S502',	'2',	'audiobook',	'B202',	 13.00),
       ('S502',	'2',	'paperback',	'B202',	 15.00),
       ('S502', '2',	'hardcover',    'B202',	 10.00),     
       
       ('S503',	'1',	'audiobook',	'B201',	 13.00),
       ('S503',	'2',	'paperback',	'B202',	 15.00),
       ('S503',	'3',	'hardcover',	'B203',	 15.00),
       
       ('S504',	'5',	'audiobook',	'B205',	 13.00),
       ('S504',	'6',	'paperback',	'B206',	 15.00),
       ('S504', '10',	'hardcover',    'B210',	 10.00);     

      
----------------------------------------------------------------------
-- VISUAL DATA CONTROL
----------------------------------------------------------------------

--1. List all books published by “Ultimate Books” which are in the “Science Fiction” genre;

SELECT b.book_id ,b.title ,b.author ,b.publisher, bg.genre FROM book b
JOIN book_genre bg on bg.book_id = b.book_id
	WHERE bg.genre = "Science Fiction" AND b.publisher = 'Ultimate Books';


--2. List titles and ratings of all books in the “Science and Technology” genre, ordered first by rating
--(top rated first), and then by the title;

SELECT b.title,r.rating, bg.genre FROM book b 
NATURAL JOIN review r
NATURAL JOIN book_genre bg
	WHERE bg.genre  =  'Science and Technology'
		ORDER BY rating DESC,title;


--3. List all orders placed by customers with customer address in the city of Edinburgh, since 2020, in
--chronological order, latest first;
	
SELECT oi.* FROM order_info oi
	WHERE oi.city = "Edinburgh" AND oi.date_ordered >= '2020'
		ORDER BY oi.date_ordered DESC;


--4. List all book editions which have less than 5 items in stock, together with the name, account
-- number and supply price of the minimum priced supplier for that edition.

SELECT e.*,b.title, s2.name as supplier_name, s2.account_number as supplier_account_number, MIN(s1.price) as minimum_supplier_price FROM edition e
LEFT JOIN supply s1 ON s1.edition = e.edition AND s1.edition_type = e.edition_type AND s1.book_id = e.book_id
NATURAL JOIN supplier s2
NATURAL JOIN book b -- This JOIN is performed to show book titles instead of just book id.
	WHERE e.quantity_in_stock < 5
		GROUP BY e.edition,e.edition_type,e.book_id;


--5. Calculate the total value of all audiobook sales since 2020 for each publisher;

SELECT DISTINCT publisher,MAX(total_value) FROM (

SELECT DISTINCT b.publisher, SUM(amount*price) AS total_value 
FROM order_info oi  
NATURAL JOIN order_contain oc 
NATURAL JOIN edition e
NATURAL JOIN book b
	WHERE oi.date_delivered >= '2020' AND e.edition_type = 'audiobook'
GROUP BY b.publisher

UNION 

SELECT DISTINCT publisher, 0 AS total_value FROM book)
GROUP BY publisher;



----------------------------------------------------------------------
-- ADDITONAL QUERY
----------------------------------------------------------------------


--- 1.Find the customer name and city who has provided rating for a book,
-- only if a customer has previously purchased that book previously

SELECT b.book_id,b.title,b.author,c.name AS customer_name,c.city as customer_city,r.rating, oi.date_delivered  FROM review r
	LEFT JOIN book b ON b.book_id = r.book_id
	LEFT JOIN customer c ON r.customer_id = c.customer_id
	LEFT JOIN order_contain oc ON oc.book_id = r.book_id  
	LEFT JOIN order_info oi ON (oi.customer_id = r.customer_id)
		WHERE oi.date_delivered NOT NULL
	GROUP BY c.customer_id;

--- 2. Find the total paperback book that was sold from the bookstore in chronological order (LATEST FIRST) in any particular year and displays its review if available from the customer
SELECT oc.order_id,oc.book_id,oc.edition,oc.edition_type,oi.date_delivered, r.rating FROM order_contain oc
NATURAL JOIN order_info oi
LEFT JOIN review r ON oc.book_id = r.book_id
	WHERE oc.edition_type = 'paperback'
	GROUP BY oc.book_id
	ORDER BY oi.date_delivered DESC;

-----3. Find the audiobooks book that was delivered within 5 days time period , in chronoloigcal order (latest first) and the supplier phone number
----- information for thse books

SELECT oc.*,oi.date_ordered,oi.date_delivered, sp.phone as supplier_phone_number FROM order_contain oc
NATURAL JOIN order_info oi
NATURAL JOIN supply s
NATURAL JOIN supplier_phone sp
	WHERE oi.date_delivered - oi.date_ordered < 5 AND oc.edition_type = 'audiobook'
	GROUP BY oc.book_id
	ORDER BY oi.date_delivered DESC;


----------------------------------------------------------------------
-- ADDITONAL VIEWS
----------------------------------------------------------------------

--1. Create a view that holds the information of all audiobooks whose price is greater than 10 

DROP VIEW IF EXISTS audiobook_view ;

CREATE VIEW audiobook_view AS
SELECT * FROM book AS b
NATURAL JOIN edition e 
	WHERE e.edition_type = 'audiobook' AND e.price > 10;

SELECT * FROM audiobook_view;


-- 2. Create a view that holds all books information and editions for all supplier ordered by the supply price
-- lowest first

DROP VIEW IF EXISTS supplier_book_view;

CREATE VIEW supplier_book_view AS
SELECT * FROM supply as s1
NATURAL JOIN supplier as s2
NATURAL JOIN book as b
	ORDER BY s1.price;

SELECT * FROM supplier_book_view;

