CREATE DATABASE hotel;
USE hotel;

CREATE TABLE guest (
id_guest INT PRIMARY KEY,
name VARCHAR(50),
card VARCHAR(100)
);

CREATE TABLE employee (
id_employee INT PRIMARY KEY,
name VARCHAR(50),
position VARCHAR(50)
);

CREATE TABLE reservation (
id_reservation INT PRIMARY KEY,
entrydate DATE,
departuredate DATE
);

CREATE TABLE service (
id_service INT PRIMARY KEY,
name VARCHAR(50),
cost DECIMAL(10, 2),
id_guest INT,
FOREIGN KEY (id_guest) REFERENCES guest (id_guest)
);

CREATE TABLE room (
id_room INT PRIMARY KEY,
number VARCHAR(10),
state VARCHAR(30),       
id_service INT,
FOREIGN KEY (id_service) REFERENCES service (id_service)
);

CREATE TABLE reservation_service (
id_reservation INT,
id_service INT,
PRIMARY KEY (id_reservation, id_service),
FOREIGN KEY (id_reservation) REFERENCES reservation(id_reservation),
FOREIGN KEY (id_service) REFERENCES service(id_service)
);

CREATE TABLE employee_service (
id_employee INT,
id_service INT,
PRIMARY KEY (id_employee, id_service),
FOREIGN KEY (id_employee) REFERENCES employee(id_employee),
FOREIGN KEY (id_service) REFERENCES service(id_service)
);

INSERT INTO guest VALUES
(1, 'Mariana Ríos', '1234-5678-9012-3456'),
(2, 'Pedro Gómez', '2345-6789-0123-4567'),
(3, 'Lucía Torres', '3456-7890-1234-5678'),
(4, 'Carlos Díaz', '4567-8901-2345-6789'),
(5, 'Valentina López', '5678-9012-3456-7890');

INSERT INTO employee VALUES
(1, 'Laura Perez', 'Reception'),
(2, 'Santiago Ruiz', 'Cleaning'),
(3, 'Andres Salazar', 'Maintenance'),
(4, 'Claudia Martinez', 'Kitchen'),
(5, 'Felipe Herrera', 'Room Service');

INSERT INTO reservation VALUES
(1, '2025-06-10', '2025-06-15'),
(2, '2025-06-12', '2025-06-14'),
(3, '2025-06-20', '2025-06-25'),
(4, '2025-07-01', '2025-07-03'),
(5, '2025-07-05', '2025-07-08');

INSERT INTO service VALUES
(1, 'Buffet Breakfast', 30.00, 1),
(2, 'Spa', 120.00, 2),
(3, 'Laundry', 45.50, 3),
(4, 'Room Service', 25.00, 4),
(5, 'Airport Transfer', 60.00, 5);

INSERT INTO room VALUES
(1, '101', 'Available', 1),
(2, '102', 'Occupied', 2),
(3, '103', 'Cleaning', 3),
(4, '104', 'Available', 4),
(5, '105', 'Maintenance', 5);

INSERT INTO reservation_service VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO employee_service VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

--1 procedimiento
GO
CREATE PROCEDURE get_service_cost_by_guest
    @id_guest INT
AS
BEGIN
    SELECT 
        g.name AS guest_name,
        s.name AS service_name,
        s.cost
    FROM guest g
    JOIN service s ON g.id_guest = s.id_guest
    WHERE g.id_guest = @id_guest;
END
EXEC get_service_cost_by_guest @id_guest = 3;

----10 sentencias sql con funciones aplicadas
--1. Longitud del nombre de los huéspedes
SELECT name, LEN(name) AS name_length
FROM guest;

--2. Convertir el nombre del empleado en mayúsculas
SELECT name, UPPER(name) AS name_uppercase
FROM employee;

--3. Convertir la posición del empleado en minúsculas
SELECT position, LOWER(position) AS position_lowercase
FROM employee;

--4. Duración de cada reserva (en días)
SELECT id_reservation, DATEDIFF(DAY, entrydate, departuredate) AS total_days
FROM reservation;

--5. Nombre del servicio con su precio
SELECT CONCAT(name, ' - $', cost) AS service_description
FROM service;

--6. Posición de la letra "a" en el nombre del huésped
SELECT name, CHARINDEX('a', name) AS position_of_a
FROM guest;

--7. Promedio de los costos de los servicios
SELECT AVG(cost) AS average_cost
FROM service;

--8. Servicio más caro y más barato
SELECT MAX(cost) AS most_expensive, MIN(cost) AS cheapest
FROM service;

--9. Reemplazar espacios en nombre del empleado por guiones bajos
SELECT name, REPLACE(name, ' ', '_') AS formatted_name
FROM employee;

--1O. Nombre del huésped al revés
SELECT name, REVERSE(name) AS reversed_name
FROM guest;

--5 sententacias Select adicionales - básicas 
--1. Nombre del huésped y el servicio que utiliza
SELECT g.name, s.name 
FROM guest g
INNER JOIN service s ON g.id_guest = s.id_guest;

--2. Número de habitación y el estado del servicio asociado
SELECT r.number, r.state, s.name 
FROM room r
INNER JOIN service s ON r.id_service = s.id_service;

--3. Nombre del empleado y el servicio que presta
SELECT e.name, s.name
FROM employee e
INNER JOIN employee_service es ON e.id_employee = es.id_employee
INNER JOIN service s ON es.id_service = s.id_service;

--4. Fecha de entrada y salida de cada reserva con el nombre del servicio incluido
SELECT res.entrydate, res.departuredate, s.name
FROM reservation res
INNER JOIN reservation_service rs ON res.id_reservation = rs.id_reservation
INNER JOIN service s ON rs.id_service = s.id_service;

--5. Mostrar el nombre del huésped, el número de habitación y el servicio que utiliza
SELECT g.name, r.number, s.name
FROM guest g
INNER JOIN service s ON g.id_guest = s.id_guest
INNER JOIN room r ON s.id_service = r.id_service;

--5 subconsultas 
--1. Mostrar el nombre del huésped que tiene el servicio más caro
SELECT name
FROM guest
WHERE id_guest = (
    SELECT id_guest
    FROM service
    WHERE cost = (SELECT MAX(cost) FROM service)
);

--2. Mostrar el número de la habitación asignada al servicio llamado 'Laundry'
SELECT number
FROM room
WHERE id_service = (
    SELECT id_service
    FROM service
    WHERE name = 'Laundry'
);

--3. Mostrar el nombre del empleado que brindó el servicio con ID 2
SELECT name
FROM employee
WHERE id_employee = (
    SELECT id_employee
    FROM employee_service
    WHERE id_service = 2
);

--4. Mostrar el nombre del servicio que usó el huésped con tarjeta '5678-9012-3456-7890'
SELECT name
FROM service
WHERE id_guest = (
    SELECT id_guest
    FROM guest
    WHERE card = '5678-9012-3456-7890'
);

--5.  Mostrar la fecha de salida de la reserva que usó el servicio más barato
SELECT departuredate
FROM reservation
WHERE id_reservation = (
    SELECT id_reservation
    FROM reservation_service
    WHERE id_service = (
        SELECT id_service
        FROM service
        WHERE cost = (SELECT MIN(cost) FROM service)
    )
);

--5 alter
ALTER TABLE employee ALTER COLUMN name VARCHAR(50) NOT NULL;
ALTER TABLE guest ADD email VARCHAR(100);
ALTER TABLE service ADD rating INT;
ALTER TABLE room ALTER COLUMN number VARCHAR(100);
ALTER TABLE reservation ADD notes TEXT;

--5 update
UPDATE guest SET name = 'Mariana R. López' WHERE id_guest = 1;
UPDATE room SET state = 'Available' WHERE id_room = 2;
UPDATE service SET cost = cost + 10 WHERE id_service = 3;
UPDATE employee SET name = 'Felipe H. Torres' WHERE id_employee = 5;
UPDATE reservation SET departuredate = '2025-07-04' WHERE id_reservation = 4;

--5 delete
DELETE FROM employee_service WHERE id_employee = 5 AND id_service = 5;
DELETE FROM room WHERE id_room = 5;
DELETE FROM guest WHERE id_guest = 4;
DELETE FROM service WHERE id_service = 2;
DELETE FROM reservation WHERE id_reservation = 1;

--5 truncate
TRUNCATE TABLE employee_service;
TRUNCATE TABLE reservation_service;
TRUNCATE TABLE room;
TRUNCATE TABLE employee;
TRUNCATE TABLE service;

--5 drop
DROP TABLE employee_service;
DROP TABLE reservation_service;
DROP TABLE room;
DROP TABLE service;
DROP TABLE reservation;