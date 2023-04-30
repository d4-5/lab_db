CREATE TABLE difficulty (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    coefficient FLOAT NOT NULL CHECK (coefficient > 0)
);

CREATE TABLE customer (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255) NOT NULL,
	balance INT NOT NULL CHECK (balance >= 0)
);

CREATE TABLE project (
    id INT IDENTITY(1,1) PRIMARY KEY,
	difficulty_id INT NOT NULL,
	FOREIGN KEY (difficulty_id) REFERENCES difficulty(id),
	customer_id INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customer(id),
	name varchar(255) NOT NULL,
	manager varchar(255) NOT NULL,
	planned_duration INT NOT NULL CHECK (planned_duration > 0),
	start_date DATE NOT NULL
);

CREATE TABLE payment (
	project_id INT NOT NULL,
	FOREIGN KEY (project_id) REFERENCES project (id),
	amount_due INT NOT NULL CHECK (amount_due >= 0),
	paid_for INT NOT NULL CHECK (paid_for >= 0),
	date DATE NOT NULL
);

CREATE TABLE position (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255) NOT NULL,
	premium INT NOT NULL CHECK (premium > 0)
);

CREATE TABLE qualification (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255) NOT NULL,
	rate INT NOT NULL CHECK (rate > 0),
);

CREATE TABLE employee (
	id INT IDENTITY (1,1) PRIMARY KEY,
	name varchar (255) NOT NULL,
	position_id INT NOT NULL,
	FOREIGN KEY (position_id) REFERENCES position (id),
	qualification_id INT NOT NULL,
	FOREIGN KEY (qualification_id) REFERENCES qualification (id) 
);

CREATE TABLE salary (
	employee_id INT NOT NULL,
	FOREIGN KEY (employee_id) REFERENCES employee (id),
	date DATE NOT NULL,
	amount INT NOT NULL CHECK (amount >= 0)
);

CREATE TABLE report (
	employee_id INT NOT NULL,
	FOREIGN KEY (employee_id) REFERENCES employee (id),
	project_id INT NOT NULL,
	FOREIGN KEY (project_id) REFERENCES project (id),
	report_date DATE NOT NULL,
	hours_worked TINYINT NOT NULL CHECK (hours_worked >= 0 AND hours_worked <= 24),
);
