/* Crear la base de datos */
CREATE DATABASE Hotel;
USE Hotel;

/* Crear las tablas */
CREATE TABLE Huesped (
    id_huesped INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10)
);

CREATE TABLE Habitacion (
    id_habitacion INT PRIMARY KEY,
    numero VARCHAR(10),
    tipo VARCHAR(50),
    piso INT,
    precio DECIMAL(10, 2)
);

CREATE TABLE Servicio (
    id_servicio INT PRIMARY KEY,
    nombre_servicio VARCHAR(50),
    categoria VARCHAR(50),
    costo DECIMAL(10, 2)
);

CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    fecha DATE,
    tipo_reserva VARCHAR(15),
    total DECIMAL(10, 2),
    id_habitacion INT,
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_reserva INT,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);

CREATE TABLE reserva_servicio (
    id_reserva INT,
    id_servicio INT,
    PRIMARY KEY (id_reserva, id_servicio),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
);

CREATE TABLE reserva_huesped (
    id_reserva INT,
    id_huesped INT,
    PRIMARY KEY (id_reserva, id_huesped),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_huesped) REFERENCES Huesped(id_huesped)
);

/* Insertar datos */
INSERT INTO Huesped VALUES 
(1, 'Laura', 'Martínez', '1111222233'),
(2, 'Diego', 'Ramírez', '3333444455'),
(3, 'Sofía', 'Hernández', '5555666677');

INSERT INTO Habitacion VALUES 
(1, '101', 'Individual', 1, 120000.00),
(2, '202', 'Doble', 2, 180000.00),
(3, '303', 'Suite', 3, 250000.00);

INSERT INTO Servicio VALUES 
(1, 'Desayuno', 'Alimentación', 25000.00),
(2, 'Spa', 'Bienestar', 80000.00),
(3, 'Lavandería', 'Extra', 30000.00);

INSERT INTO Reserva VALUES 
(1, '2025-07-01', 'Online', 120000.00, 1),
(2, '2025-07-05', 'Presencial', 180000.00, 2),
(3, '2025-07-10', 'Online', 250000.00, 3);

INSERT INTO Cliente VALUES 
(1, 'Ana', 'García', '2222333344', 1),
(2, 'Carlos', 'Pérez', '4444555566', 2),
(3, 'Marta', 'López', '6666777788', 3);

INSERT INTO reserva_servicio VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO reserva_huesped VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_precio_habitacion(IN habitacion_id INT)
BEGIN
    SELECT 
        id_habitacion,
        numero,
        precio
    FROM Habitacion
    WHERE id_habitacion = habitacion_id;
END
EXEC consultar_precio_habitacion;

/* Consultas */
SELECT * FROM Cliente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_clientes
FROM Cliente;

SELECT SUM(precio) AS total_precio_habitaciones
FROM Habitacion;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_reservas
FROM Reserva
GROUP BY MONTH(fecha);

SELECT MAX(precio) AS precio_max
FROM Habitacion;

SELECT tipo_reserva, MIN(total) AS reserva_min
FROM Reserva
GROUP BY tipo_reserva;

SELECT AVG(precio) AS promedio_precio
FROM Habitacion;

SELECT tipo, AVG(precio) AS promedio
FROM Habitacion
GROUP BY tipo
HAVING AVG(precio) > 150000;

SELECT id_habitacion, CAST(precio AS CHAR) AS precio_texto
FROM Habitacion;

SELECT id_reserva, CONVERT(fecha, CHAR) AS fecha_texto
FROM Reserva;

SELECT * FROM Cliente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Habitacion
WHERE precio > 150000;

SELECT * FROM Habitacion
WHERE tipo <> 'Individual';

SELECT * FROM Cliente
WHERE id_reserva IS NULL;

SELECT * FROM Cliente
WHERE id_reserva IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Huesped;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente, r.tipo_reserva
FROM Cliente c
JOIN Reserva r ON c.id_reserva = r.id_reserva;

SELECT h.id_habitacion, COUNT(r.id_reserva) AS total
FROM Habitacion h
JOIN Reserva r ON h.id_habitacion = r.id_habitacion
GROUP BY h.id_habitacion;

SELECT r.tipo_reserva, SUM(r.total) AS total
FROM Reserva r
GROUP BY r.tipo_reserva;

SELECT h.id_habitacion, MAX(r.total) AS reserva_max
FROM Habitacion h
JOIN Reserva r ON h.id_habitacion = r.id_habitacion
GROUP BY h.id_habitacion;

SELECT (SELECT MAX(precio) 
FROM Habitacion);

SELECT * FROM Habitacion
WHERE precio > (SELECT AVG(precio) FROM Habitacion);

SELECT nombre, apellido FROM Cliente
WHERE id_reserva = (SELECT id_reserva FROM Reserva ORDER BY total ASC LIMIT 1);

SELECT * FROM Huesped
WHERE id_huesped IN (SELECT id_huesped FROM reserva_huesped);

SELECT numero FROM Habitacion
WHERE id_habitacion IN (
    SELECT id_habitacion FROM Reserva WHERE tipo_reserva = 'Online'
);

/* Alteraciones */
ALTER TABLE Cliente ADD email VARCHAR(100);
ALTER TABLE Huesped ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Habitacion ADD estado VARCHAR(20);
ALTER TABLE Sucursal DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Reserva WHERE total < 150000;
DELETE FROM Habitacion WHERE precio = 0;
DELETE FROM Huesped WHERE nombre = 'Carlos';
DELETE FROM Servicio WHERE nombre_servicio = 'Spa';

TRUNCATE TABLE Cliente;
TRUNCATE TABLE Reserva;
TRUNCATE TABLE Habitacion;
TRUNCATE TABLE Huesped;
TRUNCATE TABLE Servicio;

/* Eliminación de tablas y base de datos */
DROP TABLE Cliente;
DROP TABLE Reserva;
DROP TABLE Habitacion;
DROP TABLE reserva_servicio;
DROP DATABASE Hotel;