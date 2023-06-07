/* Типові задачі : надання користувачам ролі або привілеї */
CREATE LOGIN admin_login WITH PASSWORD = 'password123!'
CREATE USER admin FOR LOGIN admin_login
GRANT ALTER ANY ROLE TO admin
GRANT SELECT, INSERT, UPDATE, DELETE ON project TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON report TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON difficulty TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON employee TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON payment TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON salary TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON qualification TO admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON position TO admin WITH GRANT OPTION
GRANT EXECUTE ON salaryForEmployee TO admin WITH GRANT OPTION
GRANT EXECUTE ON salaryForEveryEmployee TO admin WITH GRANT OPTION

/* Типові задачі : змінна паролю користувача за потреби */
CREATE LOGIN owner_login WITH PASSWORD = 'password123!'
CREATE USER owner FOR LOGIN owner_login
GRANT ALTER ANY LOGIN TO owner_login

/* Типові задачі : нарахування зарплати працівникам, встановлення погодинної ставки і коефіцієнта надбавки, 
визначення суми оплати для клієнта */
CREATE ROLE accountant
GRANT SELECT, INSERT, UPDATE ON payment TO accountant
GRANT SELECT, INSERT, UPDATE ON salary TO accountant
GRANT SELECT, INSERT, UPDATE ON qualification TO accountant
GRANT SELECT, INSERT, UPDATE ON position TO accountant
GRANT EXECUTE ON salaryForEmployee TO accountant
GRANT EXECUTE ON salaryForEveryEmployee TO accountant

/* Типові задача : створення нових проектів, оцінка продуктивності працівників */
CREATE ROLE managers
GRANT SELECT, INSERT ON project TO managers
GRANT SELECT ON report TO managers
GRANT SELECT ON employee TO managers
GRANT SELECT ON qualification TO managers
GRANT SELECT ON position TO managers

/* Типові задача : створення звітів про проведену роботу */
CREATE ROLE employees
GRANT SELECT, INSERT ON report TO employees
GRANT SELECT ON project TO employees

-- Призначати користувачам ролі
ALTER ROLE managers ADD MEMBER owner

-- Відкликати у користувача привілей, що також призначений через роль
REVOKE SELECT ON qualification TO owner

-- Відкликати роль у користувача
ALTER ROLE managers DROP MEMBER owner

-- Видалити роль 
DROP ROLE managers
DROP ROLE employees
DROP ROLE accountant

-- Видалити логін
DROP LOGIN owner_login
DROP LOGIN admin_login

-- Видалити користувача
DROP USER owner
DROP USER admin

-- 
EXECUTE AS LOGIN = 'owner_login';

SELECT *
FROM qualification;

REVERT;