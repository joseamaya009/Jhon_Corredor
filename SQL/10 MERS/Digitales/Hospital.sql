/* Crear la base de datos */
CREATE DATABASE Hospital;
USE Hospital;

/* Crear las tablas */
CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10)
);

CREATE TABLE Sala (
    id_sala INT PRIMARY KEY,
    nombre_sala VARCHAR(50),
    tipo VARCHAR(50),
    piso INT
);

CREATE TABLE Medico (
    id_medico INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    especialidad VARCHAR(30)
);

CREATE TABLE Consulta (
    id_consulta INT PRIMARY KEY,
    fecha DATE,
    tipo_consulta VARCHAR(15),
    valor DECIMAL(10, 2),
    id_paciente INT,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)
);

CREATE TABLE Tratamiento (
    id_tratamiento INT PRIMARY KEY,
    nombre_tratamiento VARCHAR(50),
    categoria VARCHAR(50),
    costo DECIMAL(10, 2),
    id_consulta INT,
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);

CREATE TABLE consulta_sala (
    id_consulta INT,
    id_sala INT,
    PRIMARY KEY (id_consulta, id_sala),
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta),
    FOREIGN KEY (id_sala) REFERENCES Sala(id_sala)
);

CREATE TABLE consulta_medico (
    id_consulta INT,
    id_medico INT,
    PRIMARY KEY (id_consulta, id_medico),
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta),
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico)
);

/* Insertar datos */
INSERT INTO Paciente VALUES 
(1, 'Laura', 'Martínez', '1111222233'),
(2, 'Diego', 'Ramírez', '3333444455'),
(3, 'Sofía', 'Hernández', '5555666677');

INSERT INTO Sala VALUES 
(1, 'Urgencias', 'Emergencia', 1),
(2, 'Cirugía', 'Especializada', 2),
(3, 'Pediatría', 'General', 3);

INSERT INTO Medico VALUES 
(1, 'Ana', 'García', 'Pediatra'),
(2, 'Carlos', 'Pérez', 'Cirujano'),
(3, 'Marta', 'López', 'General');

INSERT INTO Consulta VALUES 
(1, '2025-07-01', 'General', 50000.00, 1),
(2, '2025-07-05', 'Especializada', 120000.00, 2),
(3, '2025-07-10', 'General', 70000.00, 3);

INSERT INTO Tratamiento VALUES 
(1, 'Antibiótico', 'Medicamento', 30000.00, 1),
(2, 'Cirugía menor', 'Procedimiento', 100000.00, 2),
(3, 'Vacuna', 'Prevención', 20000.00, 3);

INSERT INTO consulta_sala VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO consulta_medico VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_tratamiento_paciente(IN paciente_id INT)
BEGIN
    SELECT 
        p.id_paciente,
        p.nombre,
        t.nombre_tratamiento,
        t.costo
    FROM Paciente p
    JOIN Consulta c ON p.id_paciente = c.id_paciente
    JOIN Tratamiento t ON c.id_consulta = t.id_consulta
    WHERE p.id_paciente = paciente_id;
END
EXEC consultar_tratamiento_paciente;

/* Consultas */
SELECT * FROM Paciente
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_pacientes
FROM Paciente;

SELECT SUM(costo) AS total_costo_tratamientos
FROM Tratamiento;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_consultas
FROM Consulta
GROUP BY MONTH(fecha);

SELECT MAX(costo) AS costo_max
FROM Tratamiento;

SELECT tipo_consulta, MIN(valor) AS consulta_min
FROM Consulta
GROUP BY tipo_consulta;

SELECT AVG(costo) AS promedio_costo
FROM Tratamiento;

SELECT categoria, AVG(costo) AS promedio
FROM Tratamiento
GROUP BY categoria
HAVING AVG(costo) > 25000;

SELECT id_tratamiento, CAST(costo AS CHAR) AS costo_texto
FROM Tratamiento;

SELECT id_consulta, CONVERT(fecha, CHAR) AS fecha_texto
FROM Consulta;

SELECT * FROM Paciente
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Tratamiento
WHERE costo > 25000;

SELECT * FROM Tratamiento
WHERE categoria <> 'Medicamento';

SELECT * FROM Paciente
WHERE id_paciente NOT IN (SELECT id_paciente FROM Consulta);

SELECT * FROM Paciente
WHERE id_paciente IN (SELECT id_paciente FROM Consulta);

SELECT CONCAT(nombre, ' ', apellido) 
FROM Medico;

SELECT CONCAT(p.nombre, ' ', p.apellido) AS paciente, c.tipo_consulta
FROM Paciente p
JOIN Consulta c ON p.id_paciente = c.id_paciente;

SELECT t.id_tratamiento, COUNT(c.id_consulta) AS total
FROM Tratamiento t
JOIN Consulta c ON t.id_consulta = c.id_consulta
GROUP BY t.id_tratamiento;

SELECT c.tipo_consulta, SUM(c.valor) AS total
FROM Consulta c
GROUP BY c.tipo_consulta;

SELECT t.id_tratamiento, MAX(c.valor) AS consulta_max
FROM Tratamiento t
JOIN Consulta c ON t.id_consulta = c.id_consulta
GROUP BY t.id_tratamiento;

SELECT (SELECT MAX(costo) 
FROM Tratamiento);

SELECT * FROM Tratamiento
WHERE costo > (SELECT AVG(costo) FROM Tratamiento);

SELECT nombre, apellido FROM Paciente
WHERE id_paciente = (SELECT id_paciente FROM Consulta ORDER BY valor ASC LIMIT 1);

SELECT * FROM Medico
WHERE id_medico IN (SELECT id_medico FROM consulta_medico);

SELECT nombre_tratamiento FROM Tratamiento
WHERE id_tratamiento IN (
    SELECT id_tratamiento FROM Tratamiento WHERE categoria = 'Medicamento'
);

/* Alteraciones */
ALTER TABLE Paciente ADD email VARCHAR(100);
ALTER TABLE Medico DROP COLUMN especialidad;
ALTER TABLE Medico ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Tratamiento ADD estado VARCHAR(20);
ALTER TABLE Sala ALTER COLUMN nombre_sala VARCHAR(100);

/* Eliminaciones */
DELETE FROM Paciente WHERE id_paciente = 3;
DELETE FROM Consulta WHERE valor < 50000;
DELETE FROM Tratamiento WHERE costo = 0;
DELETE FROM Medico WHERE nombre = 'Carlos';
DELETE FROM Sala WHERE nombre_sala = 'Cirugía';

TRUNCATE TABLE Paciente;
TRUNCATE TABLE Consulta;
TRUNCATE TABLE Tratamiento;
TRUNCATE TABLE Medico;
TRUNCATE TABLE Sala;

/* Eliminación de tablas y base de datos */
DROP TABLE Paciente;
DROP TABLE Consulta;
DROP TABLE Tratamiento;
DROP TABLE consulta_sala;
DROP TABLE consulta_medico;
DROP TABLE Medico;
DROP TABLE Sala;
DROP DATABASE Hospital;