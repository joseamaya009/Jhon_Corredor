/* Crear la base de datos */
CREATE DATABASE EstacionBomberos;
USE EstacionBomberos;

/* Crear las tablas */
CREATE TABLE Bombero (
    id_bombero INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    rango VARCHAR(50)
);

CREATE TABLE Departamento (
    id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(50),
    tipo VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Emergencia (
    id_emergencia INT PRIMARY KEY,
    fecha DATE,
    tipo_emergencia VARCHAR(30),
    estado VARCHAR(20),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Ciudadano (
    id_ciudadano INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_emergencia INT,
    FOREIGN KEY (id_emergencia) REFERENCES Emergencia(id_emergencia)
);

CREATE TABLE emergencia_bombero (
    id_emergencia INT,
    id_bombero INT,
    PRIMARY KEY (id_emergencia, id_bombero),
    FOREIGN KEY (id_emergencia) REFERENCES Emergencia(id_emergencia),
    FOREIGN KEY (id_bombero) REFERENCES Bombero(id_bombero)
);

CREATE TABLE emergencia_departamento (
    id_emergencia INT,
    id_departamento INT,
    PRIMARY KEY (id_emergencia, id_departamento),
    FOREIGN KEY (id_emergencia) REFERENCES Emergencia(id_emergencia),
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

/* Insertar datos */
INSERT INTO Bombero VALUES 
(1, 'Ana', 'García', 'Teniente'),
(2, 'Carlos', 'Pérez', 'Sargento'),
(3, 'Marta', 'López', 'Bombera');

INSERT INTO Departamento VALUES 
(1, 'Rescate', 'Operativo', '3001234567'),
(2, 'Prevención', 'Educativo', '3019876543'),
(3, 'Incendios', 'Emergencia', '3025557890');

INSERT INTO Emergencia VALUES 
(1, '2025-07-01', 'Incendio', 'Atendida', 1),
(2, '2025-07-05', 'Rescate', 'Pendiente', 2),
(3, '2025-07-10', 'Fuga de gas', 'Atendida', 3);

INSERT INTO Ciudadano VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO emergencia_bombero VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO emergencia_departamento VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_emergencias_bombero(IN bombero_id INT)
BEGIN
    SELECT 
        b.id_bombero,
        b.nombre,
        e.id_emergencia,
        e.tipo_emergencia,
        e.estado
    FROM Bombero b
    JOIN emergencia_bombero eb ON b.id_bombero = eb.id_bombero
    JOIN Emergencia e ON eb.id_emergencia = e.id_emergencia
    WHERE b.id_bombero = bombero_id;
END
EXEC consultar_emergencias_bombero;

/* Consultas */
SELECT * FROM Ciudadano
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_ciudadanos
FROM Ciudadano;

SELECT COUNT(*) AS total_emergencias
FROM Emergencia;

SELECT MONTH(fecha) AS mes, COUNT(*) AS emergencias_mes
FROM Emergencia
GROUP BY MONTH(fecha);

SELECT MAX(id_emergencia) AS emergencia_max
FROM Emergencia;

SELECT tipo_emergencia, COUNT(*) AS cantidad
FROM Emergencia
GROUP BY tipo_emergencia;

SELECT estado, COUNT(*) AS cantidad
FROM Emergencia
GROUP BY estado;

SELECT tipo, COUNT(*) AS cantidad
FROM Departamento
GROUP BY tipo;

SELECT id_departamento, CAST(telefono AS CHAR) AS telefono_texto
FROM Departamento;

SELECT id_emergencia, CONVERT(fecha, CHAR) AS fecha_texto
FROM Emergencia;

SELECT * FROM Ciudadano
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Emergencia
WHERE estado = 'Atendida';

SELECT * FROM Emergencia
WHERE tipo_emergencia <> 'Incendio';

SELECT * FROM Ciudadano
WHERE id_emergencia IS NULL;

SELECT * FROM Ciudadano
WHERE id_emergencia IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Bombero;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS ciudadano, e.tipo_emergencia
FROM Ciudadano c
JOIN Emergencia e ON c.id_emergencia = e.id_emergencia;

SELECT d.id_departamento, COUNT(e.id_emergencia) AS total
FROM Departamento d
JOIN Emergencia e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento;

SELECT estado, COUNT(*) AS total
FROM Emergencia
GROUP BY estado;

SELECT d.id_departamento, MAX(e.id_emergencia) AS emergencia_max
FROM Departamento d
JOIN Emergencia e ON d.id_departamento = e.id_departamento
GROUP BY d.id_departamento;

SELECT (SELECT MAX(id_emergencia) FROM Emergencia);

SELECT * FROM Departamento
WHERE tipo = 'Emergencia';

SELECT nombre, apellido FROM Ciudadano
WHERE id_emergencia = (SELECT id_emergencia FROM Emergencia ORDER BY fecha ASC LIMIT 1);

SELECT * FROM Bombero
WHERE id_bombero IN (SELECT id_bombero FROM emergencia_bombero);

SELECT nombre_departamento FROM Departamento
WHERE id_departamento IN (
    SELECT id_departamento FROM Emergencia WHERE tipo_emergencia = 'Incendio'
);

/* Alteraciones */
ALTER TABLE Ciudadano ADD email VARCHAR(100);
ALTER TABLE Bombero ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Emergencia ADD descripcion VARCHAR(200);
ALTER TABLE Departamento DROP COLUMN telefono;

/* Eliminaciones */
DELETE FROM Ciudadano WHERE id_ciudadano = 3;
DELETE FROM Emergencia WHERE estado = 'Pendiente';
DELETE FROM Bombero WHERE nombre = 'Carlos';
DELETE FROM Departamento WHERE nombre_departamento = 'Prevención';

TRUNCATE TABLE Ciudadano;
TRUNCATE TABLE Emergencia;
TRUNCATE TABLE Bombero;
TRUNCATE TABLE Departamento;

/* Eliminación de tablas y base de datos */
DROP TABLE Ciudadano;
DROP TABLE Emergencia;
DROP TABLE emergencia_bombero;
DROP TABLE emergencia_departamento;
DROP TABLE Bombero;
DROP TABLE Departamento;
DROP DATABASE EstacionBomberos;