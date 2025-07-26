/* Crear la base de datos */
CREATE DATABASE Bar;
USE Bar;

/* Crear las tablas */
CREATE TABLE Bebida (
    id_bebida INT PRIMARY KEY,
    nombre_bebida VARCHAR(50),
    tipo_bebida VARCHAR(50),
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
    id_bebida INT,
    FOREIGN KEY (id_bebida) REFERENCES Bebida(id_bebida)
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
INSERT INTO Bebida VALUES 
(1, 'Cerveza', 'Alcoholica', 8000.00, 100),
(2, 'Ron', 'Alcoholica', 35000.00, 30),
(3, 'Gaseosa', 'Sin alcohol', 4000.00, 50);

INSERT INTO Sucursal VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Empleado VALUES 
(1, 'Ana', 'García', 'Bartender'),
(2, 'Carlos', 'Pérez', 'Mesero'),
(3, 'Marta', 'López', 'Cajera');

INSERT INTO Venta VALUES 
(1, '2025-07-01', 'Mostrador', 16000.00, 1),
(2, '2025-07-05', 'Mesa', 35000.00, 2),
(3, '2025-07-10', 'Mostrador', 4000.00, 3);

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
CREATE PROCEDURE consultar_stock_bebida(IN bebida_id INT)
BEGIN
    SELECT 
        id_bebida,
        nombre_bebida,
        stock
    FROM Bebida
    WHERE id_bebida = bebida_id;
END
EXEC consultar_stock_bebida;

/* Consultas */
SELECT * FROM Cliente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_clientes
FROM Cliente;

SELECT SUM(stock) AS total_stock
FROM Bebida;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_ventas
FROM Venta
GROUP BY MONTH(fecha);

SELECT MAX(precio) AS precio_max
FROM Bebida;

SELECT tipo_venta, MIN(total) AS venta_min
FROM Venta
GROUP BY tipo_venta;

SELECT AVG(precio) AS promedio_precio
FROM Bebida;

SELECT tipo_bebida, AVG(precio) AS promedio
FROM Bebida
GROUP BY tipo_bebida
HAVING AVG(precio) > 7000;

SELECT id_bebida, CAST(precio AS CHAR) AS precio_texto
FROM Bebida;

SELECT id_venta, CONVERT(fecha, CHAR) AS fecha_texto
FROM Venta;

SELECT * FROM Cliente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Bebida
WHERE precio > 7000;

SELECT * FROM Bebida
WHERE tipo_bebida <> 'Alcoholica';

SELECT * FROM Cliente
WHERE id_venta IS NULL;

SELECT * FROM Cliente
WHERE id_venta IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Empleado;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente, v.tipo_venta
FROM Cliente c
JOIN Venta v ON c.id_venta = v.id_venta;

SELECT b.id_bebida, COUNT(v.id_venta) AS total
FROM Bebida b
JOIN Venta v ON b.id_bebida = v.id_bebida
GROUP BY b.id_bebida;

SELECT v.tipo_venta, SUM(v.total) AS total
FROM Venta v
GROUP BY v.tipo_venta;

SELECT b.id_bebida, MAX(v.total) AS venta_max
FROM Bebida b
JOIN Venta v ON b.id_bebida = v.id_bebida
GROUP BY b.id_bebida;

SELECT (SELECT MAX(precio) 
FROM Bebida);

SELECT * FROM Bebida
WHERE precio > (SELECT AVG(precio) FROM Bebida);

SELECT nombre, apellido FROM Cliente
WHERE id_venta = (SELECT id_venta FROM Venta ORDER BY total ASC LIMIT 1);

SELECT * FROM Empleado
WHERE id_empleado IN (SELECT id_empleado FROM venta_empleado);

SELECT nombre_bebida FROM Bebida
WHERE id_bebida IN (
    SELECT id_bebida FROM Venta WHERE tipo_venta = 'Mostrador'
);

/* Alteraciones */
ALTER TABLE Cliente ADD email VARCHAR(100);
ALTER TABLE Empleado DROP COLUMN cargo;
ALTER TABLE Empleado ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Bebida ADD estado VARCHAR(20);
ALTER TABLE Sucursal DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Venta WHERE total < 7000;
DELETE FROM Bebida WHERE stock = 0;
DELETE FROM Empleado WHERE nombre = 'Carlos';
DELETE FROM Sucursal WHERE nombre_sucursal = 'Norte';

TRUNCATE TABLE Cliente;
TRUNCATE TABLE Venta;
TRUNCATE TABLE Bebida;
TRUNCATE TABLE Empleado;
TRUNCATE TABLE Sucursal;

/* Eliminación de tablas y base de datos */
DROP TABLE Cliente;
DROP TABLE Venta;
DROP TABLE Bebida;
DROP TABLE venta_sucursal;
DROP TABLE venta_empleado;
DROP TABLE Empleado;
DROP TABLE Sucursal;
DROP DATABASE Bar;