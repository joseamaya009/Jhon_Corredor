/* Crear la base de datos */
CREATE DATABASE Banco;
USE Banco;

/* Crear las tablas */
CREATE TABLE Cuenta (
    id_cuenta INT PRIMARY KEY,
    tipo_cuenta VARCHAR(50),
    numero_cuenta CHAR(10),
    titular VARCHAR(100),
    saldo DECIMAL(12, 2)
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

CREATE TABLE Transaccion (
    id_transaccion INT PRIMARY KEY,
    fecha DATE,
    tipo_transaccion VARCHAR(15),
    monto DECIMAL(12, 2),
    id_cuenta INT,
    FOREIGN KEY (id_cuenta) REFERENCES Cuenta(id_cuenta)
);

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_transaccion INT,
    FOREIGN KEY (id_transaccion) REFERENCES Transaccion(id_transaccion)
);

CREATE TABLE transaccion_sucursal (
    id_transaccion INT,
    id_sucursal INT,
    PRIMARY KEY (id_transaccion, id_sucursal),
    FOREIGN KEY (id_transaccion) REFERENCES Transaccion(id_transaccion),
    FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE transaccion_empleado (
    id_transaccion INT,
    id_empleado INT,
    PRIMARY KEY (id_transaccion, id_empleado),
    FOREIGN KEY (id_transaccion) REFERENCES Transaccion(id_transaccion),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

/* Insertar datos */
INSERT INTO Cuenta VALUES 
(1, 'Ahorros', '1234567890', 'Laura Martínez', 1500000.00),
(2, 'Corriente', '0987654321', 'Diego Ramírez', 3000000.00),
(3, 'Ahorros', '1122334455', 'Sofía Hernández', 2200000.00);

INSERT INTO Sucursal VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Empleado VALUES 
(1, 'Ana', 'García', 'Gerente'),
(2, 'Carlos', 'Pérez', 'Cajero'),
(3, 'Marta', 'López', 'Asesor');

INSERT INTO Transaccion VALUES 
(1, '2025-07-01', 'Depósito', 500000.00, 1),
(2, '2025-07-05', 'Retiro', 200000.00, 2),
(3, '2025-07-10', 'Depósito', 750000.00, 3);

INSERT INTO Cliente VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO transaccion_sucursal VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO transaccion_empleado VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_saldo_cuenta(IN cuenta_id INT)
BEGIN
    SELECT 
        id_cuenta,
        numero_cuenta,
        saldo
    FROM Cuenta
    WHERE id_cuenta = cuenta_id;
END
EXEC consultar_saldo_cuenta;

/* Consultas */
SELECT * FROM Cliente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_clientes
FROM Cliente;

SELECT SUM(saldo) AS total_saldo
FROM Cuenta;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_transacciones
FROM Transaccion
GROUP BY MONTH(fecha);

SELECT MAX(saldo) AS saldo_max
FROM Cuenta;

SELECT tipo_transaccion, MIN(monto) AS monto_min
FROM Transaccion
GROUP BY tipo_transaccion;

SELECT AVG(saldo) AS promedio_saldo
FROM Cuenta;

SELECT tipo_cuenta, AVG(saldo) AS promedio
FROM Cuenta
GROUP BY tipo_cuenta
HAVING AVG(saldo) > 2000000;

SELECT id_cuenta, CAST(saldo AS CHAR) AS saldo_texto
FROM Cuenta;

SELECT id_transaccion, CONVERT(fecha, CHAR) AS fecha_texto
FROM Transaccion;

SELECT * FROM Cliente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Cuenta
WHERE saldo > 2000000;

SELECT * FROM Cuenta
WHERE tipo_cuenta <> 'Ahorros';

SELECT * FROM Cliente
WHERE id_transaccion IS NULL;

SELECT * FROM Cliente
WHERE id_transaccion IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Empleado;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS cliente, t.tipo_transaccion
FROM Cliente c
JOIN Transaccion t ON c.id_transaccion = t.id_transaccion;

SELECT cu.id_cuenta, COUNT(t.id_transaccion) AS total
FROM Cuenta cu
JOIN Transaccion t ON cu.id_cuenta = t.id_cuenta
GROUP BY cu.id_cuenta;

SELECT t.tipo_transaccion, SUM(t.monto) AS total
FROM Transaccion t
GROUP BY t.tipo_transaccion;

SELECT cu.id_cuenta, MAX(t.monto) AS transaccion_max
FROM Cuenta cu
JOIN Transaccion t ON cu.id_cuenta = t.id_cuenta
GROUP BY cu.id_cuenta;

SELECT (SELECT MAX(saldo) 
FROM Cuenta);

SELECT * FROM Cuenta
WHERE saldo > (SELECT AVG(saldo) FROM Cuenta);

SELECT nombre, apellido FROM Cliente
WHERE id_transaccion = (SELECT id_transaccion FROM Transaccion ORDER BY monto ASC LIMIT 1);

SELECT * FROM Empleado
WHERE id_empleado IN (SELECT id_empleado FROM transaccion_empleado);

SELECT numero_cuenta FROM Cuenta
WHERE id_cuenta IN (
    SELECT id_cuenta FROM Transaccion WHERE tipo_transaccion = 'Depósito'
);

/* Alteraciones */
ALTER TABLE Cliente ADD email VARCHAR(100);
ALTER TABLE Empleado DROP COLUMN cargo;
ALTER TABLE Empleado ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Cuenta ADD estado VARCHAR(20);
ALTER TABLE Sucursal DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Cliente WHERE id_cliente = 3;
DELETE FROM Transaccion WHERE monto < 100000;
DELETE FROM Cuenta WHERE saldo = 0;
DELETE FROM Empleado WHERE nombre = 'Carlos';
DELETE FROM Sucursal WHERE nombre_sucursal = 'Norte';

TRUNCATE TABLE Cliente;
TRUNCATE TABLE Transaccion;
TRUNCATE TABLE Cuenta;
TRUNCATE TABLE Empleado;
TRUNCATE TABLE Sucursal;

/* Eliminación de tablas y base de datos */
DROP TABLE Cliente;
DROP TABLE Transaccion;
DROP TABLE Cuenta;
DROP TABLE transaccion_sucursal;
DROP TABLE transaccion_empleado;
DROP TABLE Empleado;
DROP TABLE Sucursal;
DROP DATABASE Banco;