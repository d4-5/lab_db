--difficulty
ALTER TABLE difficulty ADD UCR VARCHAR(255);
ALTER TABLE difficulty ADD DCR DATETIME;
ALTER TABLE difficulty ADD ULC VARCHAR(255);
ALTER TABLE difficulty ADD DLC DATETIME;
GO

CREATE TRIGGER difficulty_insert_t1
ON difficulty
AFTER INSERT
AS
BEGIN
    UPDATE difficulty
    SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE TRIGGER difficulty_update_t1
ON difficulty
AFTER UPDATE
AS
BEGIN
    UPDATE difficulty
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

--customer
ALTER TABLE customer ADD UCR VARCHAR(255);
ALTER TABLE customer ADD DCR DATETIME;
ALTER TABLE customer ADD ULC VARCHAR(255);
ALTER TABLE customer ADD DLC DATETIME;
GO

CREATE TRIGGER customer_insert_t1
ON customer
AFTER INSERT
AS
BEGIN
    UPDATE customer
    SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE TRIGGER customer_update_t1
ON customer
AFTER UPDATE
AS
BEGIN
    UPDATE customer
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

/* Замовник не може замовити новий проект, якщо він має неоплачені на протязі 3 місяців проекти */
--project
ALTER TABLE project ADD UCR VARCHAR(255);
ALTER TABLE project ADD DCR DATETIME;
ALTER TABLE project ADD ULC VARCHAR(255);
ALTER TABLE project ADD DLC DATETIME;
GO

CREATE TRIGGER project_insert_t1
ON project
AFTER INSERT
AS
BEGIN
	DECLARE @difficulty_id INT
	DECLARE @customer_id INT 
	DECLARE @name VARCHAR
	DECLARE @manager VARCHAR
	DECLARE @planned_duration INT
	DECLARE @start_date DATE
    DECLARE @id INT
	DECLARE @debt INT
	DECLARE @error BIT
	SET @error = 0
 	DECLARE inserted_cursor CURSOR FOR
	SELECT id, difficulty_id, customer_id, name, manager, planned_duration, start_date
	FROM inserted

	OPEN inserted_cursor
	FETCH NEXT FROM inserted_cursor INTO @id, @difficulty_id, @customer_id, @name, @manager, @planned_duration, @start_date

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @debt = SUM(pa.amount_due - pa.paid_for)
		FROM payment AS pa 
		INNER JOIN project AS pr ON pr.id = pa.project_id
		INNER JOIN customer AS c ON c.id = pr.customer_id
		WHERE pa.date <= DATEADD(mm, -3, GETDATE()) AND c.id = @customer_id
		IF @debt = 0
		BEGIN
			UPDATE project
			SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
			WHERE id = @id
		END
		ELSE
		BEGIN
			RAISERROR('Could not make a new project for customer that has a more than 3 month old debt. customer_id : %d , name : %s',17,1, @customer_id, @name)
			SET @error = 1
		END
		
		FETCH NEXT FROM inserted_cursor INTO @id, @difficulty_id, @customer_id, @name, @manager, @planned_duration, @start_date
	END

	CLOSE inserted_cursor
	DEALLOCATE inserted_cursor

	IF @error = 1
		ROLLBACK TRANSACTION
END;
GO

CREATE TRIGGER project_update_t1
ON project
AFTER UPDATE
AS
BEGIN
    UPDATE project
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

/* Створити сурогатний ключ для деякої таблиці, та написати тригер для обов’язкового 
заповнення цього поля послідовними значеннями */
--payment
ALTER TABLE payment ADD UCR VARCHAR(255);
ALTER TABLE payment ADD DCR DATETIME;
ALTER TABLE payment ADD ULC VARCHAR(255);
ALTER TABLE payment ADD DLC DATETIME;
ALTER TABLE payment ADD id INT;    
GO

CREATE TRIGGER payment_insert_t1
ON payment
INSTEAD OF INSERT
AS
BEGIN
	
	DECLARE @id INT;
    SELECT @id = COALESCE(MAX(id),0) + 1 FROM payment;
	DECLARE @project_id INT
	DECLARE @amount_due INT
	DECLARE @paid_for INT
	DECLARE @date DATE
	DECLARE cursor1 CURSOR FOR
	SELECT project_id, amount_due, paid_for, date
	FROM inserted

	OPEN cursor1;

	FETCH NEXT FROM cursor1 INTO @project_id, @amount_due, @paid_for, @date;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	  
	  INSERT INTO payment (project_id, amount_due, paid_for, date, id, UCR, DCR, ULC, DLC)
	  VALUES (@project_id, @amount_due, @paid_for, @date, @id, SUSER_NAME(), GETDATE(), SUSER_NAME(), GETDATE())
	  SET @id = @id + 1
	  FETCH NEXT FROM cursor1 INTO @project_id, @amount_due, @paid_for, @date;
	END

	CLOSE cursor1;
	DEALLOCATE cursor1;
END;
GO

CREATE TRIGGER payment_update_t1
ON payment
AFTER UPDATE
AS
BEGIN
    UPDATE payment
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted)
END;
GO

--position
ALTER TABLE position ADD UCR VARCHAR(255);
ALTER TABLE position ADD DCR DATETIME;
ALTER TABLE position ADD ULC VARCHAR(255);
ALTER TABLE position ADD DLC DATETIME;
GO

CREATE TRIGGER position_insert_t1
ON position
AFTER INSERT
AS
BEGIN
    UPDATE position
    SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE TRIGGER position_update_t1
ON position
AFTER UPDATE
AS
BEGIN
    UPDATE position
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

--qualification
ALTER TABLE qualification ADD UCR VARCHAR(255);
ALTER TABLE qualification ADD DCR DATETIME;
ALTER TABLE qualification ADD ULC VARCHAR(255);
ALTER TABLE qualification ADD DLC DATETIME;
GO

CREATE TRIGGER qualification_insert_t1
ON qualification
AFTER INSERT
AS
BEGIN
    UPDATE qualification
    SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE TRIGGER qualification_update_t1
ON qualification
AFTER UPDATE
AS
BEGIN
    UPDATE qualification
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

--employee
ALTER TABLE employee ADD UCR VARCHAR(255);
ALTER TABLE employee ADD DCR DATETIME;
ALTER TABLE employee ADD ULC VARCHAR(255);
ALTER TABLE employee ADD DLC DATETIME;
GO

CREATE TRIGGER employee_insert_t1
ON employee
AFTER INSERT
AS
BEGIN
    UPDATE employee
    SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

CREATE TRIGGER employee_update_t1
ON employee
AFTER UPDATE
AS
BEGIN
    UPDATE employee
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
GO

--salary
ALTER TABLE salary ADD UCR VARCHAR(255);
ALTER TABLE salary ADD DCR DATETIME;
ALTER TABLE salary ADD ULC VARCHAR(255);
ALTER TABLE salary ADD DLC DATETIME;
GO

CREATE TRIGGER salart_insert_t1
ON salary
AFTER INSERT
AS
BEGIN
    UPDATE salary
    SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE employee_id IN (SELECT employee_id FROM inserted) AND date IN (SELECT date FROM inserted);
END;
GO

CREATE TRIGGER salary_update_t1
ON salary
AFTER UPDATE
AS
BEGIN
    UPDATE salary
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE employee_id IN (SELECT employee_id FROM inserted) AND date IN (SELECT date FROM inserted);
END;
GO

/* Кожен виконавець не може прозвітувати виконання більше 10 годин роботи в день */
--report
ALTER TABLE report ADD UCR VARCHAR(255);
ALTER TABLE report ADD DCR DATETIME;
ALTER TABLE report ADD ULC VARCHAR(255);
ALTER TABLE report ADD DLC DATETIME;
CREATE UNIQUE INDEX idx_report_employee_project_date
ON report (employee_id, project_id, report_date);
GO

CREATE TRIGGER report_insert_t1
ON report
AFTER INSERT
AS
BEGIN
	DECLARE @hours_total INT
	DECLARE @project_id INT
	DECLARE @employee_id INT
	DECLARE @hours_worked TINYINT
	DECLARE @report_date DATE
    DECLARE @error BIT
    SET @error = 0
	DECLARE inserted_cursor CURSOR FOR
    SELECT project_id, employee_id, hours_worked, report_date
    FROM inserted

    OPEN inserted_cursor
    FETCH NEXT FROM inserted_cursor INTO @project_id, @employee_id, @hours_worked, @report_date

    WHILE @@FETCH_STATUS = 0
    BEGIN
		SELECT @hours_total = COALESCE(SUM(r.hours_worked),0)
		FROM report AS r
		WHERE r.employee_id = @employee_id AND r.report_date = @report_date
		IF @hours_total + @hours_worked > 10
		BEGIN
            DECLARE @date_string VARCHAR(10)
            SET @date_string = CAST(@report_date AS VARCHAR)
            RAISERROR('Could not report more than 10 hours of work. employee_id: %d, report_date: %s',17,1, @employee_id, @date_string)
            SET @error = 1
        END
		ELSE
        BEGIN
			UPDATE report
			SET UCR = SUSER_NAME(), DCR = GETDATE(), ULC = SUSER_NAME(), DLC = GETDATE()
			WHERE employee_id = @employee_id AND project_id = @project_id AND report_date = @report_date
		END

        FETCH NEXT FROM inserted_cursor INTO @project_id, @employee_id, @hours_worked, @report_date
    END

    CLOSE inserted_cursor
    DEALLOCATE inserted_cursor

    IF @error = 1
        ROLLBACK TRANSACTION
END;
GO

CREATE TRIGGER report_update_t1
ON report
AFTER UPDATE
AS
BEGIN
    UPDATE report
    SET ULC = SUSER_NAME(), DLC = GETDATE()
    WHERE employee_id IN (SELECT employee_id FROM inserted)
        AND project_id IN (SELECT project_id FROM inserted) 
        AND report_date IN (SELECT report_date FROM inserted);
END;
GO