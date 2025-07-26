/* Crear la base de datos */
CREATE DATABASE EstacionPolicia;
USE EstacionPolicia;

/* Crear las tablas */
CREATE TABLE Agente (
    id_agente INT PRIMARY KEY,
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

CREATE TABLE Caso (
    id_caso INT PRIMARY KEY,
    fecha DATE,
    tipo_caso VARCHAR(30),
    estado VARCHAR(20),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Ciudadano (
    id_ciudadano INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_caso INT,
    FOREIGN KEY (id_caso) REFERENCES Caso(id_caso)
);

CREATE TABLE caso_agente (
    id_caso INT,
    id_agente INT,
    PRIMARY KEY (id_caso, id_agente),
    FOREIGN KEY (id_caso) REFERENCES Caso(id_caso),
    FOREIGN KEY (id_agente) REFERENCES Agente(id_agente)
);

CREATE TABLE caso_departamento (
    id_caso INT,
    id_departamento INT,
    PRIMARY KEY (id_caso, id_departamento),
    FOREIGN KEY (id_caso) REFERENCES Caso(id_caso),
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

/* Insertar datos */
INSERT INTO Agente VALUES 
(1, 'Ana', 'García', 'Teniente'),
(2, 'Carlos', 'Pérez', 'Sargento'),
(3, 'Marta', 'López', 'Patrullera');

INSERT INTO Departamento VALUES 
(1, 'Judicial', 'Investigación', '3001234567'),
(2, 'Tránsito', 'Operativo', '3019876543'),
(3, 'Infancia', 'Social', '3025557890');

INSERT INTO Caso VALUES 
(1, '2025-07-01', 'Robo', 'Abierto', 1),
(2, '2025-07-05', 'Accidente', 'Cerrado', 2),
(3, '2025-07-10', 'Violencia', 'Abierto', 3);

INSERT INTO Ciudadano VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO caso_agente VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO caso_departamento VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_casos_agente(IN agente_id INT)
BEGIN
    SELECT 
        a.id_agente,
        a.nombre,
        c.id_caso,
        c.tipo_caso,
        c.estado
    FROM Agente a
    JOIN caso_agente ca ON a.id_agente = ca.id_agente
    JOIN Caso c ON ca.id_caso = c.id_caso
    WHERE a.id_agente = agente_id;
END
EXEC consultar_casos_agente;

/* Consultas */
SELECT * FROM Ciudadano
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_ciudadanos
FROM Ciudadano;

SELECT COUNT(*) AS total_casos
FROM Caso;

SELECT MONTH(fecha) AS mes, COUNT(*) AS casos_mes
FROM Caso
GROUP BY MONTH(fecha);

SELECT MAX(id_caso) AS caso_max
FROM Caso;

SELECT tipo_caso, COUNT(*) AS cantidad
FROM Caso
GROUP BY tipo_caso;

SELECT estado, COUNT(*) AS cantidad
FROM Caso
GROUP BY estado;

SELECT tipo, COUNT(*) AS cantidad
FROM Departamento
GROUP BY tipo;

SELECT id_departamento, CAST(telefono AS CHAR) AS telefono_texto
FROM Departamento;

SELECT id_caso, CONVERT(fecha, CHAR) AS fecha_texto
FROM Caso;

SELECT * FROM Ciudadano
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Caso
WHERE estado = 'Abierto';

SELECT * FROM Caso
WHERE tipo_caso <> 'Robo';

SELECT * FROM Ciudadano
WHERE id_caso IS NULL;

SELECT * FROM Ciudadano
WHERE id_caso IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Agente;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS ciudadano, ca.tipo_caso
FROM Ciudadano c
JOIN Caso ca ON c.id_caso = ca.id_caso;

SELECT d.id_departamento, COUNT(c.id_caso) AS total
FROM Departamento d
JOIN Caso c ON d.id_departamento = c.id_departamento
GROUP BY d.id_departamento;

SELECT estado, COUNT(*) AS total
FROM Caso
GROUP BY estado;

SELECT d.id_departamento, MAX(c.id_caso) AS caso_max
FROM Departamento d
JOIN Caso c ON d.id_departamento = c.id_departamento
GROUP BY d.id_departamento;

SELECT (SELECT MAX(id_caso) FROM Caso);

SELECT * FROM Departamento
WHERE tipo = 'Investigación';

SELECT nombre, apellido FROM Ciudadano
WHERE id_caso = (SELECT id_caso FROM Caso ORDER BY fecha ASC LIMIT 1);

SELECT * FROM Agente
WHERE id_agente IN (SELECT id_agente FROM caso_agente);

SELECT nombre_departamento FROM Departamento
WHERE id_departamento IN (
    SELECT id_departamento FROM Caso WHERE tipo_caso = 'Robo'
);

/* Alteraciones */
ALTER TABLE Ciudadano ADD email VARCHAR(100);
ALTER TABLE Agente ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Caso ADD descripcion VARCHAR(200);
ALTER TABLE Departamento DROP COLUMN telefono;

/* Eliminaciones */
DELETE FROM Ciudadano WHERE id_ciudadano = 3;
DELETE FROM Caso WHERE estado = 'Cerrado';
DELETE FROM Agente WHERE nombre = 'Carlos';
DELETE FROM Departamento WHERE nombre_departamento = 'Tránsito';

TRUNCATE TABLE Ciudadano;
TRUNCATE TABLE Caso;
TRUNCATE TABLE Agente;
TRUNCATE TABLE Departamento;

/* Eliminación de tablas y base de datos */
DROP TABLE Ciudadano;
DROP TABLE Caso;
DROP TABLE caso_agente;
DROP TABLE caso_departamento;
DROP TABLE Agente;
DROP TABLE Departamento;
DROP DATABASE EstacionPolicia;