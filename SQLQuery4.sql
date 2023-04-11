INSERT INTO difficulty (name, coefficient) VALUES ('Easy', 1.0);
INSERT INTO difficulty (name, coefficient) VALUES ('Moderate', 1.5);
INSERT INTO difficulty (name, coefficient) VALUES ('Difficult', 2.0);

INSERT INTO customer (name, balance) VALUES ('John Doe', 500);
INSERT INTO customer (name, balance) VALUES ('Jane Smith', 1000);

INSERT INTO project (difficulty_id, customer_id, name, manager, planned_duration, start_date)
VALUES (1, 1, 'Project A', 'Mary Smith', 30, '2023-05-01');
INSERT INTO project (difficulty_id, customer_id, name, manager, planned_duration, start_date)
VALUES (2, 2, 'Project B', 'John Doe', 60, '2023-06-01');
INSERT INTO project (difficulty_id, customer_id, name, manager, planned_duration, start_date)
VALUES (3, 2, 'Project C', 'Bob Johnson', 90, '2023-010-01');

INSERT INTO payment (project_id, amount_due, paid_for, data)
VALUES (1, 5000, 30, '2023-06-01');
INSERT INTO payment (project_id, amount_due, paid_for, data)
VALUES (1, 10000, 60, '2023-07-01');
INSERT INTO payment (project_id, amount_due, paid_for, data)
VALUES (2, 15000, 90, '2023-08-01');

INSERT INTO position (name, premium) VALUES ('Developer', 1000);
INSERT INTO position (name, premium) VALUES ('Manager', 2000);

INSERT INTO qualification (name, rate) VALUES ('Beginner', 1);
INSERT INTO qualification (name, rate) VALUES ('Intermediate', 2);
INSERT INTO qualification (name, rate) VALUES ('Advanced', 3);

INSERT INTO employee (name, position_id, qualification_id)
VALUES ('Alice Smith', 1, 2);
INSERT INTO employee (name, position_id, qualification_id)
VALUES ('Bob Johnson', 2, 3);
INSERT INTO employee (name, position_id, qualification_id)
VALUES ('Charlie Brown', 3, 1);

INSERT INTO salary (employee_id, date, amount)
VALUES (1, '2023-05-01', 5000);
INSERT INTO salary (employee_id, date, amount)
VALUES (2, '2023-05-01', 7500);
INSERT INTO salary (employee_id, date, amount)
VALUES (2, '2023-04-01', 6000);

INSERT INTO project_employee (project_id, employee_id)
VALUES (1, 1);
INSERT INTO project_employee (project_id, employee_id)
VALUES (1, 2);
INSERT INTO project_employee (project_id, employee_id)
VALUES (2, 2);

INSERT INTO report (employee_id, project_id, report_date, hours_worked)
VALUES (1, 1, '2023-05-07', 6);
INSERT INTO report (employee_id, project_id, report_date, hours_worked)
VALUES (1, 2, '2023-06-15', 8);
