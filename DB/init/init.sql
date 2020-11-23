-- DROP DATABASE company;

-- CREATE DATABASE company;

-- \connect "company";
SET client_encoding TO 'utf-8';
CREATE SCHEMA company;

-- adding company schema to search_path
SET search_path TO company,public;

CREATE TABLE company.contact_person (
    contact_person_id SMALLSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(70)
);

CREATE TABLE company.client(
    client_id BIGSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    company_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(70)
);

CREATE TABLE company.supervisor(
    supervisor_id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
	position VARCHAR(15) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(70) NOT NULL
);

CREATE TABLE company.place_object(
    place_object_id SERIAL NOT NULL PRIMARY KEY,
    street VARCHAR(90) NOT NULL,
    number INTEGER NOT NULL,
    local VARCHAR(10),
	post_code VARCHAR(10),
    city VARCHAR(35) NOT NULL,
    country VARCHAR(30) NOT NULL
);

CREATE TABLE company.producer (
    producer_id SMALLSERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
	contact_person_id INTEGER,
    type_A_discount NUMERIC(3,2) CHECK(type_A_discount >= 0.00 AND type_A_discount <= 1.00),
    type_B_discount NUMERIC(3,2) CHECK(type_B_discount >= 0.00 AND type_B_discount <= 1.00),
    FOREIGN KEY (contact_person_id) REFERENCES company.contact_person(contact_person_id )
);

CREATE TABLE company.product (
    product_id SERIAL NOT NULL PRIMARY KEY,
    producer_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    price_net NUMERIC(8,2) NOT NULL,
    type_A BOOLEAN,
    type_B BOOLEAN,
    CONSTRAINT product_type CHECK(type_B != type_A),
    FOREIGN KEY (producer_id) REFERENCES company.producer(producer_id)
);

CREATE TABLE company.investment (
	investment_id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
    client_id INTEGER NOT NULL,
    place_object_id INTEGER,
    supervisor_id INTEGER NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
    CONSTRAINT check_dates CHECK(end_date > start_date),
    FOREIGN KEY (place_object_id) REFERENCES company.place_object(place_object_id),
    FOREIGN KEY (client_id) REFERENCES company.client(client_id),
    FOREIGN KEY (supervisor_id) REFERENCES company.supervisor(supervisor_id)
);

CREATE TABLE company.sub_investment (
	sub_investment_id SERIAL NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
	investment_id INTEGER NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
    CONSTRAINT check_dates CHECK(end_date > start_date),
	FOREIGN KEY(investment_id) REFERENCES company.investment(investment_id)
);

CREATE TABLE company.product_order (
    product_id BIGSERIAL NOT NULL,
	sub_investment_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (product_id) REFERENCES company.product(product_id),
    FOREIGN KEY (sub_investment_id) REFERENCES company.sub_investment(sub_investment_id),
    PRIMARY KEY(product_id, sub_investment_id)
);

CREATE ROLE management;
ALTER ROLE management LOGIN PASSWORD 'management';
ALTER ROLE management CREATEDB;
ALTER ROLE management CREATEROLE;

CREATE ROLE employee;
ALTER ROLE employee LOGIN PASSWORD 'employee';

CREATE ROLE intern;
ALTER ROLE intern LOGIN PASSWORD 'intern';

-- --ACCESS DB
REVOKE CONNECT ON DATABASE company FROM PUBLIC;
GRANT  CONNECT ON DATABASE company TO management, employee, intern;

-- --ACCESS SCHEMA
REVOKE ALL ON SCHEMA company FROM PUBLIC;
GRANT USAGE ON SCHEMA company TO management, employee, intern;

-- --ACCESS TABLES
REVOKE ALL ON ALL TABLES IN SCHEMA company FROM PUBLIC ;
GRANT SELECT, INSERT                 ON ALL TABLES IN SCHEMA company TO intern;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA company TO employee;
GRANT ALL                            ON ALL TABLES IN SCHEMA company TO management;

-- --ACCESS SEQUENCES (FROM POSTGRES 8.2)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA company TO management, employee, intern;

DROP SCHEMA public;

ALTER TABLE company.producer ADD CONSTRAINT unique_constraints UNIQUE (name);
