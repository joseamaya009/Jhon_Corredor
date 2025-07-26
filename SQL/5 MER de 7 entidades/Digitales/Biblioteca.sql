/* Crear la base de datos */
CREATE DATABASE Biblioteca;
USE Biblioteca;

/* Crear las tablas */
CREATE TABLE Libro (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100),
    genero VARCHAR(50),
    precio DECIMAL(10, 2),
    ejemplares INT
);

CREATE TABLE Sede (
    id_sede INT PRIMARY KEY,
    nombre_sede VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Bibliotecario (
    id_bibliotecario INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    cargo VARCHAR(30)
);

CREATE TABLE Prestamo (
    id_prestamo INT PRIMARY KEY,
    fecha DATE,
    tipo_prestamo VARCHAR(15),
    valor DECIMAL(10, 2),
    id_libro INT,
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_prestamo INT,
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo)
);

CREATE TABLE prestamo_sede (
    id_prestamo INT,
    id_sede INT,
    PRIMARY KEY (id_prestamo, id_sede),
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo),
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

CREATE TABLE prestamo_bibliotecario (
    id_prestamo INT,
    id_bibliotecario INT,
    PRIMARY KEY (id_prestamo, id_bibliotecario),
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo),
    FOREIGN KEY (id_bibliotecario) REFERENCES Bibliotecario(id_bibliotecario)
);

/* Insertar datos */
INSERT INTO Libro VALUES 
(1, 'Cien años de soledad', 'Novela', 35000.00, 10),
(2, 'El Principito', 'Infantil', 25000.00, 8),
(3, 'Don Quijote', 'Clásico', 18000.00, 12);

INSERT INTO Sede VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Bibliotecario VALUES 
(1, 'Ana', 'García', 'Jefe'),
(2, 'Carlos', 'Pérez', 'Auxiliar'),
(3, 'Marta', 'López', 'Recepcionista');

INSERT INTO Prestamo VALUES 
(1, '2025-07-01', 'Sala', 0.00, 1),
(2, '2025-07-05', 'Domicilio', 2500.00, 2),
(3, '2025-07-10', 'Sala', 0.00, 3);

INSERT INTO Usuario VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO prestamo_sede VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO prestamo_bibliotecario VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_ejemplares_libro(IN libro_id INT)
BEGIN
    SELECT 
        id_libro,
        titulo,
        ejemplares
    FROM Libro
    WHERE id_libro = libro_id;
END
EXEC consultar_ejemplares_libro;

/* Consultas */
SELECT * FROM Usuario
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_usuarios
FROM Usuario;

SELECT SUM(ejemplares) AS total_ejemplares
FROM Libro;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_prestamos
FROM Prestamo
GROUP BY MONTH(fecha);

SELECT MAX(precio) AS precio_max
FROM Libro;

SELECT tipo_prestamo, MIN(valor) AS valor_min
FROM Prestamo
GROUP BY tipo_prestamo;

SELECT AVG(precio) AS promedio_precio
FROM Libro;

SELECT genero, AVG(precio) AS promedio
FROM Libro
GROUP BY genero
HAVING AVG(precio) > 20000;

SELECT id_libro, CAST(precio AS CHAR) AS precio_texto
FROM Libro;

SELECT id_prestamo, CONVERT(fecha, CHAR) AS fecha_texto
FROM Prestamo;

SELECT * FROM Usuario
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Libro
WHERE precio > 20000;

SELECT * FROM Libro
WHERE genero <> 'Novela';

SELECT * FROM Usuario
WHERE id_prestamo IS NULL;

SELECT * FROM Usuario
WHERE id_prestamo IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Bibliotecario;

SELECT CONCAT(u.nombre, ' ', u.apellido) AS usuario, p.tipo_prestamo
FROM Usuario u
JOIN Prestamo p ON u.id_prestamo = p.id_prestamo;

SELECT l.id_libro, COUNT(p.id_prestamo) AS total
FROM Libro l
JOIN Prestamo p ON l.id_libro = p.id_libro
GROUP BY l.id_libro;

SELECT p.tipo_prestamo, SUM(p.valor) AS total
FROM Prestamo p
GROUP BY p.tipo_prestamo;

SELECT l.id_libro, MAX(p.valor) AS prestamo_max
FROM Libro l
JOIN Prestamo p ON l.id_libro = p.id_libro
GROUP BY l.id_libro;

SELECT (SELECT MAX(precio) 
FROM Libro);

SELECT * FROM Libro
WHERE precio > (SELECT AVG(precio) FROM Libro);

SELECT nombre, apellido FROM Usuario
WHERE id_prestamo = (SELECT id_prestamo FROM Prestamo ORDER BY valor ASC LIMIT 1);

SELECT * FROM Bibliotecario
WHERE id_bibliotecario IN (SELECT id_bibliotecario FROM prestamo_bibliotecario);

SELECT titulo FROM Libro
WHERE id_libro IN (
    SELECT id_libro FROM Prestamo WHERE tipo_prestamo = 'Sala'
);

/* Alteraciones */
ALTER TABLE Usuario ADD email VARCHAR(100);
ALTER TABLE Bibliotecario DROP COLUMN cargo;
ALTER TABLE Bibliotecario ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Libro ADD estado VARCHAR(20);
ALTER TABLE Sede DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Usuario WHERE id_usuario = 3;
DELETE FROM Prestamo WHERE valor < 1000;
DELETE FROM Libro WHERE ejemplares = 0;
DELETE FROM Bibliotecario WHERE nombre = 'Carlos';
DELETE FROM Sede WHERE nombre_sede = 'Norte';

TRUNCATE TABLE Usuario;
TRUNCATE TABLE Prestamo;
TRUNCATE TABLE Libro;
TRUNCATE TABLE Bibliotecario;
TRUNCATE TABLE Sede;

/* Eliminación de tablas y base de datos */
DROP TABLE Usuario;
DROP TABLE Prestamo;
DROP TABLE Libro;
DROP TABLE prestamo_sede;
DROP DATABASE Biblioteca;