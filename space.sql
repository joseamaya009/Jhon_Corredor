CREATE DATABASE space;
USE space;

CREATE TABLE astronaut (
id_astronaut INT PRIMARY KEY,
name VARCHAR(50),
range VARCHAR(30) 
);

CREATE TABLE nave (
id_nave INT PRIMARY KEY,
name VARCHAR(50),
type VARCHAR(30),
crewmembers INT
);

CREATE TABLE burden (
id_burden INT PRIMARY KEY,
weight DECIMAL(10,2) 
);

CREATE TABLE mission (
id_mission INT PRIMARY KEY,
destination VARCHAR(50),
releasedate DATE,
state VARCHAR(50),
id_nave INT,
FOREIGN KEY (id_nave) REFERENCES nave(id_nave)
);

CREATE TABLE binnacle (
id_binnacle INT PRIMARY KEY,
entrydate DATE,
id_mission INT,
FOREIGN KEY (id_mission) REFERENCES mission(id_mission)
);

CREATE TABLE astronaut_mission (
id_astronaut INT,
id_mission INT,
PRIMARY KEY (id_astronaut, id_mission),
FOREIGN KEY (id_astronaut) REFERENCES astronaut(id_astronaut),
FOREIGN KEY (id_mission) REFERENCES mission(id_mission)
);

CREATE TABLE burden_mission (
id_burden INT,
id_mission INT,
PRIMARY KEY (id_burden, id_mission),
FOREIGN KEY (id_burden) REFERENCES burden(id_burden),
FOREIGN KEY (id_mission) REFERENCES mission(id_mission)
);

INSERT INTO astronaut VALUES
(1, 'Elena Martinez', 'Commander'),
(2, 'John Carter', 'Pilot'),
(3, 'Marta Silva', 'Engineer'),
(4, 'Yu Wang', 'Scientist'),
(5, 'Luis Ortega', 'Specialist');

INSERT INTO nave VALUES
(1, 'Odyssey X', 'Shuttle', 5),
(2, 'Luna V', 'Orbital', 3),
(3, 'Nova Star', 'Exploration', 4),
(4, 'Titan II', 'Cargo', 2),
(5, 'Solstice', 'Research', 6);

INSERT INTO burden VALUES
(1, 1200.50),
(2, 850.00),
(3, 1450.75),
(4, 600.00),
(5, 900.20);

INSERT INTO mission VALUES
(1, 'Mars', '2025-08-01', 'Scheduled', 1),
(2, 'Moon', '2025-10-15', 'In Progress', 2),
(3, 'ISS', '2024-12-12', 'Completed', 3),
(4, 'Europa', '2026-02-20', 'Scheduled', 4),
(5, 'Solar Station', '2025-06-30', 'Completed', 5);

INSERT INTO binnacle VALUES
(1, '2025-08-02', 1),
(2, '2025-10-16', 2),
(3, '2024-12-13', 3),
(4, '2026-02-21', 4),
(5, '2025-07-01', 5);

INSERT INTO astronaut_mission VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4);

INSERT INTO burden_mission VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

--1 procedimiento
GO
CREATE PROCEDURE myProc
AS
BEGIN
   SELECT * FROM astronaut;
END
EXEC myProc;

--10 sentencias sql con funciones aplicadas
--1. Mostrar los nombres de los astronautas en mayúscula
SELECT UPPER(name) AS astronaut_name_upper 
FROM astronaut;

--2. Contar cuántas naves hay registradas
SELECT COUNT(*) AS total_naves 
FROM nave;

--3. Obtener el peso total de toda la carga
SELECT SUM(weight) AS total_burden_weight 
FROM burden;

--4. Mostrar el nombre de cada nave con su tipo en una sola columna
SELECT CONCAT(name, ' - ', type) AS nave_info 
FROM nave;

--5. Calcular el promedio de peso de las cargas
SELECT AVG(weight) AS average_burden 
FROM burden;

--6. Mostrar la cantidad de caracteres en los nombres de astronautas
SELECT name, LEN(name) AS name_length 
FROM astronaut;

--7. Obtener el año de cada misión usando la fecha de lanzamiento
SELECT destination, YEAR(releasedate) AS mission_year 
FROM mission;

--8. Mostrar la fecha actual del sistema
SELECT GETDATE() AS current_system_date;

--9. Convertir a minúsculas el estado de cada misión
SELECT destination, LOWER(state) AS lowercase_state 
FROM mission;

--10. Contar cuántas misiones tienen estado "Completed"
SELECT COUNT(*) AS completed_missions
FROM mission
WHERE state = 'Completed';

--5 sententacias Select adicionales - básicas 
--1. Mostrar el nombre del astronauta y el destino de la misión en la que participó
SELECT a.name, m.destination
FROM astronaut a
JOIN astronaut_mission am ON a.id_astronaut = am.id_astronaut
JOIN mission m ON am.id_mission = m.id_mission;

--2. Mostrar el nombre de la nave y el destino de la misión asociada
SELECT n.name, m.destination
FROM nave n
JOIN mission m ON n.id_nave = m.id_nave;

--3. Mostrar la carga (peso) y el destino de la misión donde fue utilizada
SELECT b.weight, m.destination
FROM burden b
JOIN burden_mission bm ON b.id_burden = bm.id_burden
JOIN mission m ON bm.id_mission = m.id_mission;

--4. Mostrar el nombre del astronauta y el tipo de nave de la misión en la que participó
SELECT a.name, n.type 
FROM astronaut a
JOIN astronaut_mission am ON a.id_astronaut = am.id_astronaut
JOIN mission m ON am.id_mission = m.id_mission
JOIN nave n ON m.id_nave = n.id_nave;

--5. Mostrar la fecha de entrada en bitácora y el destino de la misión correspondiente
SELECT b.entrydate, m.destination
FROM binnacle b
JOIN mission m ON b.id_mission = m.id_mission;

--5 subconsultas 
--1.  Mostrar el nombre del astronauta con ID igual al que participó en la misión 1
SELECT name
FROM astronaut
WHERE id_astronaut = (
    SELECT id_astronaut
    FROM astronaut_mission
    WHERE id_mission = 1
);

--2. Mostrar el destino de la misión con mayor ID
SELECT destination
FROM mission
WHERE id_mission = (
    SELECT MAX(id_mission)
    FROM mission
);

--3. Mostrar el nombre de la nave usada en la misión con destino 'Moon'
SELECT name
FROM nave
WHERE id_nave = (
    SELECT id_nave
    FROM mission
    WHERE destination = 'Moon'
);

--4. Mostrar el peso de la carga usada en la misión 3
SELECT weight
FROM burden
WHERE id_burden = (
    SELECT id_burden
    FROM burden_mission
    WHERE id_mission = 3
);

--5.  Mostrar la fecha de entrada en bitácora para la misión con destino 'ISS'
SELECT entrydate
FROM binnacle
WHERE id_mission = (
    SELECT id_mission
    FROM mission
    WHERE destination = 'ISS'
);
--5 alter
ALTER TABLE astronaut ADD nationality VARCHAR(30);
ALTER TABLE burden ALTER COLUMN weight FLOAT;
ALTER TABLE mission ADD mission_duration INT;
ALTER TABLE nave ADD manufacturer VARCHAR(50);
ALTER TABLE mission ADD CONSTRAINT UQ_destination UNIQUE(destination);

--5 update
UPDATE astronaut SET name = 'Elena Martínez López' WHERE id_astronaut = 1;
UPDATE nave SET crewmembers = 7 WHERE id_nave = 5;
UPDATE mission SET state = 'Completed' WHERE id_mission = 2;
UPDATE burden SET weight = 950.00 WHERE id_burden = 2;
UPDATE binnacle SET entrydate = '2025-08-03' WHERE id_binnacle = 1;

--5 delete
DELETE FROM astronaut WHERE id_astronaut = 5;
DELETE FROM nave WHERE id_nave = 4;
DELETE FROM burden WHERE id_burden = 4;
DELETE FROM mission WHERE id_mission = 4;
DELETE FROM binnacle WHERE id_binnacle = 4;

--5 truncate
TRUNCATE TABLE astronaut_mission;
TRUNCATE TABLE burden_mission;
TRUNCATE TABLE binnacle;
TRUNCATE TABLE burden;
TRUNCATE TABLE rent;

--5 drop
DROP TABLE astronaut_mission;
DROP TABLE burden_mission;
DROP TABLE binnacle;
DROP TABLE burden;
DROP TABLE astronaut;