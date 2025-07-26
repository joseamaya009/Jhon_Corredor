/* Crear la base de datos */
CREATE DATABASE Restaurante;
USE Restaurante;

/* Crear las tablas */
CREATE TABLE Plato (
    id_plato INT PRIMARY KEY,
    nombre_plato VARCHAR(50),
    categoria VARCHAR(50),
    precio DECIMAL(10, 2),
    stock INT
);

CREATE TABLE Sucursal (
    id_sucursal INT PRIMARY KEY,
    nombre_sucursal VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    cargo VARCHAR(30)
);

CREATE TABLE Venta (
    id_venta INT PRIMARY KEY,
    fecha DATE,
    tipo_venta VARCHAR(15),
    total DECIMAL(10, 2),
    id_plato INT,
    FOREIGN KEY (id_plato) REFERENCES Plato(id_plato)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_venta INT,
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE venta_sucursal (
    id_venta INT,
    id_sucursal INT,
    PRIMARY KEY (id_venta, id_sucursal),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE venta_empleado (
    id_venta INT,
    id_empleado INT,
    PRIMARY KEY (id_venta, id_empleado),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

/* Insertar datos */
INSERT INTO Plato VALUES 
(1, 'Bandeja Paisa', 'Típico', 25000.00, 50),
(2, 'Pizza', 'Internacional', 32000.00, 40),
(3, 'Ensalada', 'Vegetariano', 18000.00, 60);

INSERT INTO Sucursal VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Empleado VALUES 
(1, 'Ana', 'García', 'Chef'),
(2, 'Carlos', 'Pérez', 'Mesero'),
(3, 'Marta', 'López', 'Cajera');

INSERT INTO Venta VALUES 
(1, '2025-07-01', 'Mostrador', 25000.00, 1),
(2, '2025-07-05', 'Domicilio', 32000.00, 2),
(3, '2025-07-10', 'Mostrador', 18000.00, 3);

INSERT INTO Cliente VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO venta_sucursal VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO venta_empleado VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_stock_plato(IN plato_id INT)
BEGIN
    SELECT 
        id_plato,
        nombre_plato,
        stock
    FROM Plato
    WHERE id_plato = plato_id;
END
EXEC consultar_stock_plato;

/* Consultas */
SELECT * FROM Cliente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_clientes
FROM Cliente;

SELECT SUM(stock) AS total_stock
FROM Plato;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_ventas
FROM Venta
GROUP BY MONTH(fecha);

SELECT MAX(precio) AS precio_max
FROM Plato;

SELECT tipo_venta, MIN(total) AS venta_min
FROM Venta
GROUP BY tipo_venta;

SELECT AVG(precio) AS promedio_precio
FROM Plato;

SELECT categoria, AVG(precio) AS promedio
FROM Plato
GROUP BY categoria
HAVING AVG(precio) > 20000;

SELECT id_plato, CAST(precio AS CHAR) AS precio_texto
FROM Plato;

SELECT id_venta, CONVERT(fecha, CHAR) AS fecha_texto
FROM Venta;

SELECT * FROM Cliente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Plato
WHERE precio > 20000;

SELECT * FROM Plato
WHERE categoria <> 'Típico';

SELECT * FROM Cliente
WHERE id_venta IS NULL;

SELECT * FROM Cliente
WHERE id_venta IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Empleado;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente, v.tipo_venta
FROM Cliente c
JOIN Venta v ON c.id_venta = v.id_venta;

SELECT p.id_plato, COUNT(v.id_venta) AS total
FROM Plato p
JOIN Venta v ON p.id_plato = v.id_plato
GROUP BY p.id_plato;

SELECT v.tipo_venta, SUM(v.total) AS total
FROM Venta v
GROUP BY v.tipo_venta;

SELECT p.id_plato, MAX(v.total) AS venta_max
FROM Plato p
JOIN Venta v ON p.id_plato = v.id_plato
GROUP BY p.id_plato;

SELECT (SELECT MAX(precio) 
FROM Plato);

SELECT * FROM Plato
WHERE precio > (SELECT AVG(precio) FROM Plato);

SELECT nombre, apellido FROM Cliente
WHERE id_venta = (SELECT id_venta FROM Venta ORDER BY total ASC LIMIT 1);

SELECT * FROM Empleado
WHERE id_empleado IN (SELECT id_empleado FROM venta_empleado);

SELECT nombre_plato FROM Plato
WHERE id_plato IN (
    SELECT id_plato FROM Venta WHERE tipo_venta = 'Mostrador'
);

/* Alteraciones */
ALTER TABLE Cliente ADD email VARCHAR(100);
ALTER TABLE Empleado DROP COLUMN cargo;
ALTER TABLE Empleado ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Plato ADD estado VARCHAR(20);
ALTER TABLE Sucursal DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Venta WHERE total < 20000;
DELETE FROM Plato WHERE stock = 0;
DELETE FROM Empleado WHERE nombre = 'Carlos';
DELETE FROM Sucursal WHERE nombre_sucursal = 'Norte';

TRUNCATE TABLE Cliente;
TRUNCATE TABLE Venta;
TRUNCATE TABLE Plato;
TRUNCATE TABLE Empleado;
TRUNCATE TABLE Sucursal;

/* Eliminación de tablas y base de datos */
DROP TABLE Cliente;
DROP TABLE Venta;
DROP TABLE Plato;
DROP TABLE venta_sucursal;
DROP TABLE venta_empleado;
DROP TABLE Empleado;
DROP TABLE Sucursal;
DROP DATABASE Restaurante;