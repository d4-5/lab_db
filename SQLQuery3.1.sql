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
