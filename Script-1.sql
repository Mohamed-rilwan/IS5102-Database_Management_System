ATTACH DATABASE 'Assignment2' As 'Alias';   

CREATE TABLE Customer(  
   id VARCHAR(250)  PRIMARY KEY NOT NULL,
   name VARCHAR(250),
   email VARCHAR(250),
   phone_type VARCHAR(250),
   phone_number VARCHAR(250),
   street VARCHAR(250),
   city VARCHAR(250),
   postcode VARCHAR(250),
   country VARCHAR(250)
);



CREATE TABLE customer (
    id  VARCHAR(8),
    name      VARCHAR(50)  NOT NULL,
    email    VARCHAR(20),
    phome_type    NUMERIC(2,0),
    phone_number VARCHAR(20)
    PRIMARY KEY (id),
    
    ON DELETE CASCADE
    ON UPDATE CASCADE);