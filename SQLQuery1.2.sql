INSERT INTO difficulty (name, coefficient) 
VALUES 
	('Easy', 0.5), 
	('Medium', 1.0), 
	('Hard', 1.5);

INSERT INTO customer (name, balance) 
VALUES 
	('John Smith', 10000), 
	('Jane Doe', 5000), 
	('Mike Johnson', 15000), 
	('Sarah Lee', 20000), 
	('Alex Brown', 7500);

INSERT INTO project (difficulty_id, customer_id, name, manager, planned_duration, start_date) 
VALUES 
	(1, 1, 'Project 1', 'John Doe', 30, '2023-02-15'), 
	(2, 2, 'Project 2', 'Mary Johnson', 60, '2023-02-12'), 
	(3, 3, 'Project 3', 'Alex Green', 90, '2023-04-10'), 
	(1, 4, 'Project 4', 'Karen White', 120, '2023-04-01'), 
	(1, 5, 'Project 5', 'Michael Black', 150, '2023-04-05');

INSERT INTO payment (project_id, amount_due, paid_for, date) 
VALUES 
	(1, 10000, 0, '2023-04-18'), 
	(1, 5000, 0, '2023-03-18'), 
	(1, 10000, 0, '2023-02-18'), 
	(2, 15000, 0, '2023-04-17'),
	(2, 10000, 0, '2023-03-17'),
	(3, 20000, 0, '2023-04-16'), 
	(4, 25000, 0, '2023-04-15'), 
	(5, 30000, 0, '2023-04-14');

INSERT INTO position (name, premium) 
VALUES 
	('PositionA', 1000), 
	('PositionB', 2000), 
	('PositionC', 3000), 
	('PositionD', 5000), 
	('PositionE', 7000);

INSERT INTO qualification (name, rate) 
VALUES 
	('QualificationA', 5000), 
	('QualificationB', 8000), 
	('QualificationC', 12000),
	('QualificationD', 10000), 
	('QualificationE', 15000);

INSERT INTO employee (name, position_id, qualification_id) 
VALUES 
	('Bob Johnson', 1, 1), 
	('Alice Brown', 2, 2), 
	('Charlie Green', 3, 3), 
	('David Lee', 4, 4), 
	('Emily White', 5, 5);

INSERT INTO salary (employee_id, date, amount) 
VALUES 
	(1, '2023-04-01', 5000), 
	(1, '2023-03-01', 5000), 
	(1, '2023-02-01', 5000), 
	(2, '2023-04-01', 8000),
	(2, '2023-02-01', 8000),
	(3, '2023-04-01', 12000), 
	(4, '2023-04-01', 10000), 
	(4, '2023-03-01', 10000), 
	(4, '2023-02-01', 10000), 
	(4, '2023-01-01', 10000), 
	(5, '2023-04-01', 15000);

INSERT INTO report (employee_id, project_id, report_date, hours_worked) 
VALUES 
	(1, 1, '2023-04-18', 8), 
	(2, 1, '2023-04-18', 7), 
	(3, 2, '2023-04-17', 6), 
	(4, 2, '2023-04-17', 8), 
	(5, 3, '2023-04-16', 9);
