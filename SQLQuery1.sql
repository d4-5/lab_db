CREATE TABLE difficulty (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    coefficient FLOAT CHECK (coefficient > 0)
);

CREATE TABLE customer (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255),
	balance INT CHECK (balance >= 0)
);

CREATE TABLE project (
    id INT IDENTITY(1,1) PRIMARY KEY,
	difficulty_id INT,
	FOREIGN KEY (difficulty_id) REFERENCES difficulty(id),
	customer_id INT,
	FOREIGN KEY (customer_id) REFERENCES customer(id),
	name varchar(255),
	manager varchar(255),
	planned_duration INT CHECK (planned_duration > 0),
	start_date DATE
);

CREATE TABLE payment (
	project_id INT,
	FOREIGN KEY (project_id) REFERENCES project (id),
	amount_due INT CHECK (amount_due >= 0),
	paid_for INT CHECK (paid_for >= 0),
	data DATE 
);

CREATE TABLE position (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255),
	premium INT CHECK (premium > 0)
);

CREATE TABLE qualification (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255),
	rate INT CHECK (rate > 0),
);

CREATE TABLE employee (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255),
	position_id INT,
	FOREIGN KEY (position_id) REFERENCES position (id),
	qualification_id INT,
	FOREIGN KEY (qualification_id) REFERENCES qualification (id) 
);

CREATE TABLE salary (
	employee_id INT,
	FOREIGN KEY (employee_id) REFERENCES employee (id),
	date DATE,
	amount INT CHECK (amount >= 0)
);

CREATE TABLE project_employee (
	id INT IDENTITY (1,1) PRIMARY KEY,
	project_id INT,
	FOREIGN KEY (project_id) REFERENCES project(id),
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

CREATE TABLE report (
	employee_id INT,
	FOREIGN KEY (employee_id) REFERENCES employee (id),
	project_id INT,
	FOREIGN KEY (project_id) REFERENCES project (id),
	report_date DATE,
	hours_worked TINYINT  CHECK (hours_worked >= 0 AND hours_worked <= 24),
);
