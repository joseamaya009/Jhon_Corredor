/* Crear la base de datos */
CREATE DATABASE Supermercado;
USE Supermercado;

/* Crear las tablas */
CREATE TABLE Producto (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(50),
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
    id_producto INT,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
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
INSERT INTO Producto VALUES 
(1, 'Arroz', 'Grano', 3500.00, 100),
(2, 'Leche', 'Lácteo', 2500.00, 80),
(3, 'Manzana', 'Fruta', 1800.00, 120);

INSERT INTO Sucursal VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Empleado VALUES 
(1, 'Ana', 'García', 'Gerente'),
(2, 'Carlos', 'Pérez', 'Cajero'),
(3, 'Marta', 'López', 'Vendedor');

INSERT INTO Venta VALUES 
(1, '2025-07-01', 'Mostrador', 7000.00, 1),
(2, '2025-07-05', 'Domicilio', 2500.00, 2),
(3, '2025-07-10', 'Mostrador', 3600.00, 3);

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
CREATE PROCEDURE consultar_stock_producto(IN producto_id INT)
BEGIN
    SELECT 
        id_producto,
        nombre_producto,
        stock
    FROM Producto
    WHERE id_producto = producto_id;
END
EXEC consultar_stock_producto;

/* Consultas */
SELECT * FROM Cliente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_clientes
FROM Cliente;

SELECT SUM(stock) AS total_stock
FROM Producto;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_ventas
FROM Venta
GROUP BY MONTH(fecha);

SELECT MAX(precio) AS precio_max
FROM Producto;

SELECT tipo_venta, MIN(total) AS venta_min
FROM Venta
GROUP BY tipo_venta;

SELECT AVG(precio) AS promedio_precio
FROM Producto;

SELECT categoria, AVG(precio) AS promedio
FROM Producto
GROUP BY categoria
HAVING AVG(precio) > 2000;

SELECT id_producto, CAST(precio AS CHAR) AS precio_texto
FROM Producto;

SELECT id_venta, CONVERT(fecha, CHAR) AS fecha_texto
FROM Venta;

SELECT * FROM Cliente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Producto
WHERE precio > 2000;

SELECT * FROM Producto
WHERE categoria <> 'Grano';

SELECT * FROM Cliente
WHERE id_venta IS NULL;

SELECT * FROM Cliente
WHERE id_venta IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Empleado;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente, v.tipo_venta
FROM Cliente c
JOIN Venta v ON c.id_venta = v.id_venta;

SELECT p.id_producto, COUNT(v.id_venta) AS total
FROM Producto p
JOIN Venta v ON p.id_producto = v.id_producto
GROUP BY p.id_producto;

SELECT v.tipo_venta, SUM(v.total) AS total
FROM Venta v
GROUP BY v.tipo_venta;

SELECT p.id_producto, MAX(v.total) AS venta_max
FROM Producto p
JOIN Venta v ON p.id_producto = v.id_producto
GROUP BY p.id_producto;

SELECT (SELECT MAX(precio) 
FROM Producto);

SELECT * FROM Producto
WHERE precio > (SELECT AVG(precio) FROM Producto);

SELECT nombre, apellido FROM Cliente
WHERE id_venta = (SELECT id_venta FROM Venta ORDER BY total ASC LIMIT 1);

SELECT * FROM Empleado
WHERE id_empleado IN (SELECT id_empleado FROM venta_empleado);

SELECT nombre_producto FROM Producto
WHERE id_producto IN (
    SELECT id_producto FROM Venta WHERE tipo_venta = 'Mostrador'
);

/* Alteraciones */
ALTER TABLE Cliente ADD email VARCHAR(100);
ALTER TABLE Empleado DROP COLUMN cargo;
ALTER TABLE Empleado ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Producto ADD estado VARCHAR(20);
ALTER TABLE Sucursal DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Venta WHERE total < 2000;
DELETE FROM Producto WHERE stock = 0;
DELETE FROM Empleado WHERE nombre = 'Carlos';
DELETE FROM Sucursal WHERE nombre_sucursal = 'Norte';

TRUNCATE TABLE Cliente;
TRUNCATE TABLE Venta;
TRUNCATE TABLE Producto;
TRUNCATE TABLE Empleado;
TRUNCATE TABLE Sucursal;

/* Eliminación de tablas y base de datos */
DROP TABLE Cliente;
DROP TABLE Venta;
DROP TABLE Producto;
DROP TABLE venta_sucursal;
DROP DATABASE Supermercado;