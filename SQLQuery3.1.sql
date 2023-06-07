CREATE PROCEDURE salaryForEmployee 
@employee_id INT,
@month INT
AS
	DECLARE @amount INT = 0
	DECLARE @rate INT
	DECLARE @premium INT

	SELECT @rate = q.rate, @premium = p.premium
	FROM employee AS e 
	INNER JOIN qualification AS q ON q.id = e.qualification_id
	INNER JOIN position AS p ON p.id = e.position_id
	WHERE e.id = @employee_id

	SELECT @amount += SUM(d.coefficient*@rate*r.hours_worked) + @premium
	FROM report AS r 
	INNER JOIN project AS pr ON pr.id = r.project_id
	INNER JOIN difficulty AS d ON d.id = pr.difficulty_id
	WHERE r.employee_id = @employee_id AND MONTH(r.report_date) = @month

	INSERT INTO salary (employee_id, date, amount)
	VALUES (@employee_id, DATEFROMPARTS(YEAR(GETDATE()), @month, DAY(GETDATE())), COALESCE(@amount, 0))

CREATE PROCEDURE salaryForEveryEmployee 
@month INT
AS
    DECLARE @employee_id INT

    DECLARE employee_cursor CURSOR FOR
        SELECT id
        FROM employee

    OPEN employee_cursor
    FETCH NEXT FROM employee_cursor INTO @employee_id

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC salaryForEmployee @employee_id, @month
        FETCH NEXT FROM employee_cursor INTO @employee_id
    END

    CLOSE employee_cursor
    DEALLOCATE employee_cursor

CREATE PROCEDURE paymentForCustomer
@customerID INT,
@month INT
AS
    WITH cte AS (
  		SELECT r.project_id AS project_id ,SUM(q.rate*r.hours_worked) AS amount
		FROM report AS r 
		INNER JOIN employee AS e ON e.id = r.employee_id
		INNER JOIN qualification AS q ON q.id = e.qualification_id
		WHERE MONTH(r.report_date) = @month
		GROUP By r.project_id
	)
	INSERT INTO payment(project_id, amount_due, paid_for, date)
	SELECT p.id AS project_id, cte.amount*d.coefficient*1.4 AS amount_due, 0 AS paid_for, DATEFROMPARTS(YEAR(GETDATE()), @month, DAY(GETDATE())) AS date
	FROM project AS p 
	INNER JOIN difficulty AS d ON p.difficulty_id = d.id
	INNER JOIN cte ON cte.project_id = p.id
	WHERE p.customer_id = @customerID


CREATE PROCEDURE paymentForEveryCustomer
@month INT
AS
    DECLARE @customer_id INT

    DECLARE customer_cursor CURSOR FOR
        SELECT id
        FROM customer

    OPEN customer_cursor
    FETCH NEXT FROM customer_cursor INTO @customer_id

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC paymentForCustomer @customer_id, @month
        FETCH NEXT FROM customer_cursor INTO @customer_id
    END

    CLOSE customer_cursor
    DEALLOCATE customer_cursor