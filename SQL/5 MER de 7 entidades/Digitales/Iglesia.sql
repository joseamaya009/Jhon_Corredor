/* Crear la base de datos */
CREATE DATABASE Iglesia;
USE Iglesia;

/* Crear las tablas */
CREATE TABLE Ministerio (
    id_ministerio INT PRIMARY KEY,
    nombre_ministerio VARCHAR(50),
    tipo VARCHAR(50),
    presupuesto DECIMAL(10, 2),
    miembros INT
);

CREATE TABLE Sede (
    id_sede INT PRIMARY KEY,
    nombre_sede VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Pastor (
    id_pastor INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    rol VARCHAR(30)
);

CREATE TABLE Evento (
    id_evento INT PRIMARY KEY,
    fecha DATE,
    tipo_evento VARCHAR(15),
    donacion DECIMAL(10, 2),
    id_ministerio INT,
    FOREIGN KEY (id_ministerio) REFERENCES Ministerio(id_ministerio)
);

CREATE TABLE Feligres (
    id_feligres INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_evento INT,
    FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

CREATE TABLE evento_sede (
    id_evento INT,
    id_sede INT,
    PRIMARY KEY (id_evento, id_sede),
    FOREIGN KEY (id_evento) REFERENCES Evento(id_evento),
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

CREATE TABLE evento_pastor (
    id_evento INT,
    id_pastor INT,
    PRIMARY KEY (id_evento, id_pastor),
    FOREIGN KEY (id_evento) REFERENCES Evento(id_evento),
    FOREIGN KEY (id_pastor) REFERENCES Pastor(id_pastor)
);

/* Insertar datos */
INSERT INTO Ministerio VALUES 
(1, 'Alabanza', 'Música', 2000000.00, 15),
(2, 'Juventud', 'Educación', 1500000.00, 20),
(3, 'Infantil', 'Niños', 1000000.00, 25);

INSERT INTO Sede VALUES 
(1, 'Central', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Pastor VALUES 
(1, 'Ana', 'García', 'Principal'),
(2, 'Carlos', 'Pérez', 'Juventud'),
(3, 'Marta', 'López', 'Infantil');

INSERT INTO Evento VALUES 
(1, '2025-07-01', 'Culto', 500000.00, 1),
(2, '2025-07-05', 'Reunión', 300000.00, 2),
(3, '2025-07-10', 'Campaña', 700000.00, 3);

INSERT INTO Feligres VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO evento_sede VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO evento_pastor VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_miembros_ministerio(IN ministerio_id INT)
BEGIN
    SELECT 
        id_ministerio,
        nombre_ministerio,
        miembros
    FROM Ministerio
    WHERE id_ministerio = ministerio_id;
END
EXEC consultar_miembros_ministerio;

/* Consultas */
SELECT * FROM Feligres
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_feligreses
FROM Feligres;

SELECT SUM(miembros) AS total_miembros
FROM Ministerio;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_eventos
FROM Evento
GROUP BY MONTH(fecha);

SELECT MAX(presupuesto) AS presupuesto_max
FROM Ministerio;

SELECT tipo_evento, MIN(donacion) AS donacion_min
FROM Evento
GROUP BY tipo_evento;

SELECT AVG(presupuesto) AS promedio_presupuesto
FROM Ministerio;

SELECT tipo, AVG(presupuesto) AS promedio
FROM Ministerio
GROUP BY tipo
HAVING AVG(presupuesto) > 1200000;

SELECT id_ministerio, CAST(presupuesto AS CHAR) AS presupuesto_texto
FROM Ministerio;

SELECT id_evento, CONVERT(fecha, CHAR) AS fecha_texto
FROM Evento;

SELECT * FROM Feligres
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Ministerio
WHERE presupuesto > 1200000;

SELECT * FROM Ministerio
WHERE tipo <> 'Música';

SELECT * FROM Feligres
WHERE id_evento IS NULL;

SELECT * FROM Feligres
WHERE id_evento IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Pastor;

SELECT CONCAT(f.nombre, ' ', f.apellido) AS feligres, e.tipo_evento
FROM Feligres f
JOIN Evento e ON f.id_evento = e.id_evento;

SELECT m.id_ministerio, COUNT(e.id_evento) AS total
FROM Ministerio m
JOIN Evento e ON m.id_ministerio = e.id_ministerio
GROUP BY m.id_ministerio;

SELECT e.tipo_evento, SUM(e.donacion) AS total
FROM Evento e
GROUP BY e.tipo_evento;

SELECT m.id_ministerio, MAX(e.donacion) AS evento_max
FROM Ministerio m
JOIN Evento e ON m.id_ministerio = e.id_ministerio
GROUP BY m.id_ministerio;

SELECT (SELECT MAX(presupuesto) 
FROM Ministerio);

SELECT * FROM Ministerio
WHERE presupuesto > (SELECT AVG(presupuesto) FROM Ministerio);

SELECT nombre, apellido FROM Feligres
WHERE id_evento = (SELECT id_evento FROM Evento ORDER BY donacion ASC LIMIT 1);

SELECT * FROM Pastor
WHERE id_pastor IN (SELECT id_pastor FROM evento_pastor);

SELECT nombre_ministerio FROM Ministerio
WHERE id_ministerio IN (
    SELECT id_ministerio FROM Evento WHERE tipo_evento = 'Culto'
);

/* Alteraciones */
ALTER TABLE Feligres ADD email VARCHAR(100);
ALTER TABLE Pastor DROP COLUMN rol;
ALTER TABLE Pastor ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Ministerio ADD estado VARCHAR(20);
ALTER TABLE Sede DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Feligres WHERE id_feligres = 3;
DELETE FROM Evento WHERE donacion < 200000;
DELETE FROM Ministerio WHERE miembros = 0;
DELETE FROM Pastor WHERE nombre = 'Carlos';
DELETE FROM Sede WHERE nombre_sede = 'Norte';

TRUNCATE TABLE Feligres;
TRUNCATE TABLE Evento;
TRUNCATE TABLE Ministerio;
TRUNCATE TABLE Pastor;
TRUNCATE TABLE Sede;

/* Eliminación de tablas y base de datos */
DROP TABLE Feligres;
DROP TABLE Evento;
DROP TABLE Ministerio;
DROP TABLE evento_sede;
DROP DATABASE Iglesia;