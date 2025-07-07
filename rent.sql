CREATE DATABASE rent;
USE rent;

CREATE TABLE customer (
id_customer INT PRIMARY KEY,
name VARCHAR(50),
phone VARCHAR(20)
);

CREATE TABLE employee (
id_employee INT PRIMARY KEY,
name VARCHAR(50),
position VARCHAR(30)
);

CREATE TABLE rent (
id_rent INT PRIMARY KEY,
cost DECIMAL(10, 2)
);

CREATE TABLE vehicle (
id_vehicle INT PRIMARY KEY,
brand VARCHAR(50),
model VARCHAR(50),
type VARCHAR(30),
state VARCHAR(10),
id_rent INT,
FOREIGN KEY (id_rent) REFERENCES rent(id_rent)
);

CREATE TABLE inspection (
id_inspection INT PRIMARY KEY,
observations TEXT,
id_vehicle INT,
FOREIGN KEY (id_vehicle) REFERENCES vehicle(id_vehicle)
);

CREATE TABLE customer_vehicle (
id_customer INT,
id_vehicle INT,
PRIMARY KEY (id_customer, id_vehicle),
FOREIGN KEY (id_customer) REFERENCES customer(id_customer),
FOREIGN KEY (id_vehicle) REFERENCES vehicle(id_vehicle)
);

CREATE TABLE employee_vehicle (
id_employee INT,
id_vehicle INT,
PRIMARY KEY (id_employee, id_vehicle),
FOREIGN KEY (id_employee) REFERENCES employee(id_employee),
FOREIGN KEY (id_vehicle) REFERENCES vehicle(id_vehicle)
);

INSERT INTO customer VALUES
(1, 'Carlos Méndez', '3124567890'),
(2, 'Lucía Torres', '3109876543'),
(3, 'Andrés Jiménez', '3112233445'),
(4, 'Sofía Romero', '3156677889'),
(5, 'Daniel Vargas', '3191122334');

INSERT INTO employee VALUES
(1, 'Paula Rios', 'Mechanic'),
(2, 'Javier Perez', 'Receptionist'),
(3, 'Monica Herrera', 'Cleaning'),
(4, 'Esteban Gomez', 'Technician'),
(5, 'Valentina Cruz', 'Supervisor');

INSERT INTO rent VALUES
(1, 320.50),
(2, 450.00),
(3, 275.75),
(4, 600.00),
(5, 390.20);

INSERT INTO vehicle VALUES
(1, 'Toyota', 'Corolla', 'Sedan', 'Available', 1),
(2, 'Chevrolet', 'Spark', 'Compact', 'Occupied', 2),
(3, 'Ford', 'Escape', 'SUV', 'Available', 3),
(4, 'Renault', 'Logan', 'Sedan', 'Maintenance', 4),
(5, 'Mazda', 'CX-5', 'SUV', 'Occupied', 5);

INSERT INTO inspection VALUES
(1, 'All in order', 1),
(2, 'Oil change needed', 2),
(3, 'Brakes checked', 3),
(4, 'Worn tires', 4),
(5, 'Battery replaced', 5);

INSERT INTO customer_vehicle VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO employee_vehicle VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

--1 procedimiento
GO
CREATE PROCEDURE get_rent_cost
    @id_rent INT
AS
BEGIN
    SELECT cost
    FROM rent
    WHERE id_rent = @id_rent;
END
EXEC get_rent_cost @id_rent = 2;

--10 sentencias sql con funciones aplicadas
--1. Mostrar los nombres de los clientes en mayúsculas
SELECT UPPER(name) AS name_upper 
FROM customer;

--2. Mostrar la suma total de todos los alquileres
SELECT SUM(cost) AS total_rent_cost 
FROM rent;

--3. Obtener el costo promedio de alquiler
SELECT AVG(cost) AS average_rent_cost 
FROM rent;

--4. Contar cuántos vehículos hay registrados
SELECT COUNT(*) AS total_vehicles 
FROM vehicle;

--5. Obtener los nombres de empleados al revés 
SELECT name, REVERSE(name) AS name_reversed
FROM employee;

--6. Extrae 4 caracteres desde la posición 2 del nombre.
SELECT name, SUBSTRING(name, 2, 4) AS part_of_name
FROM employee;

--7. Concatenar la marca y modelo del vehículo en una sola columna
SELECT CONCAT(brand, ' ', model) AS full_vehicle_name 
FROM vehicle;

--8. Mostrar el alquiler más caro
SELECT MAX(cost) AS highest_rent 
FROM rent;

--9. Mostrar el alquiler más barato
SELECT MIN(cost) AS lowest_rent 
FROM rent;

--10. Contar cuántos empleados hay con el cargo "Technician"
SELECT COUNT(*) AS technician_count
FROM employee
WHERE position = 'Technician';

--5 sententacias Select adicionales - básicas 
--1. Muestra el nombre del cliente y el modelo del vehículo que tiene asignado.
SELECT c.name, v.model
FROM customer c
INNER JOIN customer_vehicle cv ON c.id_customer = cv.id_customer
INNER JOIN vehicle v ON cv.id_vehicle = v.id_vehicle;

--2. Muestra el nombre del empleado y el tipo de vehículo que atiende
SELECT e.name, v.type
FROM employee e
INNER JOIN employee_vehicle ev ON e.id_employee = ev.id_employee
INNER JOIN vehicle v ON ev.id_vehicle = v.id_vehicle;

--3. Muestra el nombre del cliente, la marca del vehículo que alquiló y el estado del vehículo.
SELECT c.name, v.brand, v.state
FROM customer c
INNER JOIN customer_vehicle cv ON c.id_customer = cv.id_customer
INNER JOIN vehicle v ON cv.id_vehicle = v.id_vehicle;

--4. Muestra el nombre del empleado, el modelo del vehículo y su posición laboral.
SELECT e.name, v.model, e.position
FROM employee e
INNER JOIN employee_vehicle ev ON e.id_employee = ev.id_employee
INNER JOIN vehicle v ON ev.id_vehicle = v.id_vehicle;

--5. Muestra el nombre del cliente, el tipo de vehículo y el estado del vehículo que utiliza.
SELECT c.name, v.type, v.state
FROM customer c
INNER JOIN customer_vehicle cv ON c.id_customer = cv.id_customer
INNER JOIN vehicle v ON cv.id_vehicle = v.id_vehicle;

--5 subconsultas 
--1. Mostrar el modelo del vehículo con el costo de renta más alto
SELECT model
FROM vehicle
WHERE id_rent = (
    SELECT id_rent
    FROM rent
    WHERE cost = (SELECT MAX(cost) FROM rent)
);

--2.  Mostrar el nombre del cliente con ID igual al del cliente que tiene el teléfono '3109876543'
SELECT name
FROM customer
WHERE id_customer = (
    SELECT id_customer
    FROM customer
    WHERE phone = '3109876543'
);

--3. Mostrar la marca del vehículo inspeccionado con ID 3
SELECT brand
FROM vehicle
WHERE id_vehicle = (
    SELECT id_vehicle
    FROM inspection
    WHERE id_inspection = 3
);

--4. Mostrar el nombre del empleado que trabaja con el vehículo 4
SELECT name
FROM employee
WHERE id_employee = (
    SELECT id_employee
    FROM employee_vehicle
    WHERE id_vehicle = 4
);

--5. Mostrar el costo de la renta asociada al vehículo con modelo 'Spark'
SELECT cost
FROM rent
WHERE id_rent = (
    SELECT id_rent
    FROM vehicle
    WHERE model = 'Spark'
);

--5 alter
ALTER TABLE customer ADD email VARCHAR(100);
ALTER TABLE employee ADD salary DECIMAL(10, 2);
ALTER TABLE vehicle ADD license_plate VARCHAR(20);
ALTER TABLE customer ALTER COLUMN phone VARCHAR(30);
ALTER TABLE inspection ADD inspection_date DATE;

--5 update
UPDATE customer SET name = 'Carlos M. Méndez' WHERE id_customer = 1;
UPDATE vehicle SET state = 'Available' WHERE id_vehicle = 2;
UPDATE rent SET cost = cost + 50 WHERE id_rent = 3;
UPDATE employee SET position = 'Manager' WHERE id_employee = 5;
UPDATE inspection SET observations = 'Tires replaced' WHERE id_inspection = 4;

--5 delete
DELETE FROM customer WHERE id_customer = 5;
DELETE FROM vehicle WHERE id_vehicle = 3;
DELETE FROM customer_vehicle WHERE id_customer = 4;
DELETE FROM employee WHERE id_employee = 2;
DELETE FROM inspection WHERE id_inspection = 1;

--5 truncate
TRUNCATE TABLE employee_vehicle;
TRUNCATE TABLE customer_vehicle;
TRUNCATE TABLE inspection;
TRUNCATE TABLE rent;
TRUNCATE TABLE vehicle;

--5 drop
DROP TABLE rent;
DROP TABLE employee_vehicle;
DROP TABLE inspection;
DROP TABLE customer;
DROP TABLE vehicle;