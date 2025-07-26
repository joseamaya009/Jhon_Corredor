/* Crear la base de datos */
CREATE DATABASE Concesionario;
USE Concesionario;

/* Crear las tablas */
CREATE TABLE Vehiculo (
    id_vehiculo INT PRIMARY KEY,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    precio DECIMAL(12, 2),
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
    total DECIMAL(12, 2),
    id_vehiculo INT,
    FOREIGN KEY (id_vehiculo) REFERENCES Vehiculo(id_vehiculo)
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
INSERT INTO Vehiculo VALUES 
(1, 'Corolla', 'Toyota', 85000000.00, 10),
(2, 'Spark', 'Chevrolet', 45000000.00, 8),
(3, 'Duster', 'Renault', 95000000.00, 5);

INSERT INTO Sucursal VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Empleado VALUES 
(1, 'Ana', 'García', 'Vendedora'),
(2, 'Carlos', 'Pérez', 'Cajero'),
(3, 'Marta', 'López', 'Gerente');

INSERT INTO Venta VALUES 
(1, '2025-07-01', 'Mostrador', 85000000.00, 1),
(2, '2025-07-05', 'Online', 45000000.00, 2),
(3, '2025-07-10', 'Mostrador', 95000000.00, 3);

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
CREATE PROCEDURE consultar_stock_vehiculo(IN vehiculo_id INT)
BEGIN
    SELECT 
        id_vehiculo,
        modelo,
        stock
    FROM Vehiculo
    WHERE id_vehiculo = vehiculo_id;
END
EXEC consultar_stock_vehiculo;

/* Consultas */
SELECT * FROM Cliente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_clientes
FROM Cliente;

SELECT SUM(stock) AS total_stock
FROM Vehiculo;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_ventas
FROM Venta
GROUP BY MONTH(fecha);

SELECT MAX(precio) AS precio_max
FROM Vehiculo;

SELECT tipo_venta, MIN(total) AS venta_min
FROM Venta
GROUP BY tipo_venta;

SELECT AVG(precio) AS promedio_precio
FROM Vehiculo;

SELECT marca, AVG(precio) AS promedio
FROM Vehiculo
GROUP BY marca
HAVING AVG(precio) > 50000000;

SELECT id_vehiculo, CAST(precio AS CHAR) AS precio_texto
FROM Vehiculo;

SELECT id_venta, CONVERT(fecha, CHAR) AS fecha_texto
FROM Venta;

SELECT * FROM Cliente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Vehiculo
WHERE precio > 50000000;

SELECT * FROM Vehiculo
WHERE marca <> 'Toyota';

SELECT * FROM Cliente
WHERE id_venta IS NULL;

SELECT * FROM Cliente
WHERE id_venta IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Empleado;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente, v.tipo_venta
FROM Cliente c
JOIN Venta v ON c.id_venta = v.id_venta;

SELECT v.id_vehiculo, COUNT(vt.id_venta) AS total
FROM Vehiculo v
JOIN Venta vt ON v.id_vehiculo = vt.id_vehiculo
GROUP BY v.id_vehiculo;

SELECT vt.tipo_venta, SUM(vt.total) AS total
FROM Venta vt
GROUP BY vt.tipo_venta;

SELECT v.id_vehiculo, MAX(vt.total) AS venta_max
FROM Vehiculo v
JOIN Venta vt ON v.id_vehiculo = vt.id_vehiculo
GROUP BY v.id_vehiculo;

SELECT (SELECT MAX(precio) 
FROM Vehiculo);

SELECT * FROM Vehiculo
WHERE precio > (SELECT AVG(precio) FROM Vehiculo);

SELECT nombre, apellido FROM Cliente
WHERE id_venta = (SELECT id_venta FROM Venta ORDER BY total ASC LIMIT 1);

SELECT * FROM Empleado
WHERE id_empleado IN (SELECT id_empleado FROM venta_empleado);

SELECT modelo FROM Vehiculo
WHERE id_vehiculo IN (
    SELECT id_vehiculo FROM Venta WHERE tipo_venta = 'Mostrador'
);

/* Alteraciones */
ALTER TABLE Cliente ADD email VARCHAR(100);
ALTER TABLE Empleado DROP COLUMN cargo;
ALTER TABLE Empleado ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Vehiculo ADD estado VARCHAR(20);
ALTER TABLE Sucursal DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Venta WHERE total < 50000000;
DELETE FROM Vehiculo WHERE stock = 0;
DELETE FROM Empleado WHERE nombre = 'Carlos';
DELETE FROM Sucursal WHERE nombre_sucursal = 'Norte';

TRUNCATE TABLE Cliente;
TRUNCATE TABLE Venta;
TRUNCATE TABLE Vehiculo;
TRUNCATE TABLE Empleado;
TRUNCATE TABLE Sucursal;

/* Eliminación de tablas y base de datos */
DROP TABLE Cliente;
DROP TABLE Venta;
DROP TABLE Vehiculo;
DROP TABLE venta_sucursal;
DROP TABLE venta_empleado;
DROP TABLE Empleado;
DROP TABLE Sucursal;
DROP DATABASE Concesionario;