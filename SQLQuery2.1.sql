/* Сума зарплат за даний місяць */
SELECT SUM(amount) AS Total
FROM salary
WHERE MONTH(date) = MONTH(GETDATE());

/* Проекти якими керує менеджер Jonh Doe, їхні імена, дата початку, очікувана тривалість і кількість 
годин портачених на проекти за даний місяць */
SELECT p.name , p.start_date, p.planned_duration, p.manager, SUM(r.hours_worked) AS total_hours
FROM project AS p INNER JOIN report AS r 
ON p.id = r.project_id
WHERE MONTH(r.report_date) = MONTH(GETDATE()) AND p.manager = 'John Doe'
GROUP BY p.name, p.start_date, p.planned_duration, p.manager;

/* Клієнти і всі їхні не оплачені рахунки */
SELECT c.name, c.balance, pa.amount_due, pa.paid_for, pa.data
FROM customer AS c LEFT OUTER JOIN project AS pr
	ON c.id = pr.customer_id
	LEFT OUTER JOIN payment AS pa
		ON pr.id = pa.project_id
		WHERE pa.amount_due != pa.paid_for

/* Клієнти і всі їхні не оплачені рахунки давністю більше ніж 3 місяці */
SELECT c.name, c.balance, pa.amount_due, pa.paid_for, pa.data
FROM customer AS c LEFT OUTER JOIN project AS pr
	ON c.id = pr.customer_id
	LEFT OUTER JOIN payment AS pa
		ON pr.id = pa.project_id
		WHERE pa.amount_due != pa.paid_for AND MONTH(pa.data) <= MONTH(GETDATE()) - 3

/* Всі клієнти які мають хоча б один проект */
SELECT *
FROM customer AS c
WHERE EXISTS (SELECT 1 FROM project AS p WHERE c.id = p.customer_id)

/* Всі клієнти які можуть погасти всі свої борги */
SELECT *
FROM customer AS c
WHERE ( SELECT SUM(pa.amount_due - pa.paid_for) FROM project AS pr INNER JOIN payment AS pa ON pr.id = pa.project_id WHERE c.id = pr.customer_id ) <= c.balance

/* Клієнти і скільки всього кожен з них повинен заплатити */
WITH cte AS (
    SELECT c.name AS customer_name, 
           p.name AS project_name, 
           d.name AS difficulty_level,
           SUM(amount_due) AS total_amount_due
    FROM payment pm
    INNER JOIN project p ON pm.project_id = p.id
    INNER JOIN customer c ON p.customer_id = c.id
    INNER JOIN difficulty d ON p.difficulty_id = d.id
    GROUP BY c.name, p.name, d.name
)
SELECT customer_name, project_name, difficulty_level, total_amount_due
FROM cte
ORDER BY customer_name, project_name, difficulty_level;

/* Кількість годин які кожний працівник працював над кожним проектом за кожний місяць */
SELECT *
FROM (
    SELECT e.name AS employee_name, p.name AS project_name, 
           DATENAME(month, r.report_date) AS month_name, r.hours_worked
    FROM report r
    INNER JOIN employee e ON r.employee_id = e.id
    INNER JOIN project p ON r.project_id = p.id
) AS source_table
PIVOT (
    SUM(hours_worked) FOR month_name IN (
        [January], [February], [March], [April], [May], [June], 
        [July], [August], [September], [October], [November], [December]
    )
) AS pivot_table;


/* Збільшити баланс клієнта з ім'ям 'Jane Doe' на 1000 */
UPDATE customer
SET balance += 1000
WHERE name = 'Jane Doe'

/* Збільшити зарплату на 500 цього місяця всім працівникам в яких id кваліфікації 1 */
UPDATE salary
SET amount += 500
FROM salary AS s INNER JOIN employee AS e
ON e.id = s.employee_id
WHERE MONTH(s.date) = MONTH(GETDATE()) AND e.qualification_id = 1

/* Добавити нових клієнти з вказаним іменем і балансом */
INSERT INTO customer (name, balance)
VALUES
    ('John Doe', 1000),
    ('Jane Smith', 500),
    ('Bob Johnson', 250);

/* Добавити новий проект менеджер якого є випадковий працівник з id посади 1 */
INSERT INTO project (difficulty_id, customer_id, name, manager, planned_duration, start_date)
VALUES (
  1,
  1,
  'ProjectABC',
  (SELECT TOP 1 name FROM employee WHERE position_id = 1 ORDER BY NEWID()),
  30,
  '2023-05-21'
);

/* Видалити всі дані з таблиці project */
DELETE FROM payment WHERE project_id IN (SELECT id FROM project)
DELETE FROM report WHERE project_id IN (SELECT id FROM project)
DELETE FROM project

/* Видалити проект id якого дорівнює 3 */
DELETE FROM payment WHERE project_id = 3
DELETE FROM report WHERE project_id = 3
DELETE FROM project WHERE id = 3;