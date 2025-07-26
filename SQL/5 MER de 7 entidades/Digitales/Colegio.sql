/* Crear la base de datos */
CREATE DATABASE Colegio;
USE Colegio;

/* Crear las tablas */
CREATE TABLE Curso (
    id_curso INT PRIMARY KEY,
    nombre_curso VARCHAR(50),
    area VARCHAR(50),
    valor DECIMAL(10, 2),
    cupos INT
);

CREATE TABLE Sede (
    id_sede INT PRIMARY KEY,
    nombre_sede VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Profesor (
    id_profesor INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    especialidad VARCHAR(30)
);

CREATE TABLE Matricula (
    id_matricula INT PRIMARY KEY,
    fecha DATE,
    tipo_matricula VARCHAR(15),
    valor DECIMAL(10, 2),
    id_curso INT,
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_matricula INT,
    FOREIGN KEY (id_matricula) REFERENCES Matricula(id_matricula)
);

CREATE TABLE matricula_sede (
    id_matricula INT,
    id_sede INT,
    PRIMARY KEY (id_matricula, id_sede),
    FOREIGN KEY (id_matricula) REFERENCES Matricula(id_matricula),
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

CREATE TABLE matricula_profesor (
    id_matricula INT,
    id_profesor INT,
    PRIMARY KEY (id_matricula, id_profesor),
    FOREIGN KEY (id_matricula) REFERENCES Matricula(id_matricula),
    FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor)
);

/* Insertar datos */
INSERT INTO Curso VALUES 
(1, 'Matemáticas', 'Ciencias', 500000.00, 30),
(2, 'Lengua', 'Humanidades', 450000.00, 25),
(3, 'Biología', 'Ciencias', 480000.00, 20);

INSERT INTO Sede VALUES 
(1, 'Principal', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Profesor VALUES 
(1, 'Ana', 'García', 'Matemáticas'),
(2, 'Carlos', 'Pérez', 'Lengua'),
(3, 'Marta', 'López', 'Biología');

INSERT INTO Matricula VALUES 
(1, '2025-07-01', 'Presencial', 500000.00, 1),
(2, '2025-07-05', 'Virtual', 450000.00, 2),
(3, '2025-07-10', 'Presencial', 480000.00, 3);

INSERT INTO Estudiante VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO matricula_sede VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO matricula_profesor VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_cupos_curso(IN curso_id INT)
BEGIN
    SELECT 
        id_curso,
        nombre_curso,
        cupos
    FROM Curso
    WHERE id_curso = curso_id;
END
EXEC consultar_cupos_curso;

/* Consultas */
SELECT * FROM Estudiante
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_estudiantes
FROM Estudiante;

SELECT SUM(cupos) AS total_cupos
FROM Curso;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_matriculas
FROM Matricula
GROUP BY MONTH(fecha);

SELECT MAX(valor) AS valor_max
FROM Curso;

SELECT tipo_matricula, MIN(valor) AS valor_min
FROM Matricula
GROUP BY tipo_matricula;

SELECT AVG(valor) AS promedio_valor
FROM Curso;

SELECT area, AVG(valor) AS promedio
FROM Curso
GROUP BY area
HAVING AVG(valor) > 450000;

SELECT id_curso, CAST(valor AS CHAR) AS valor_texto
FROM Curso;

SELECT id_matricula, CONVERT(fecha, CHAR) AS fecha_texto
FROM Matricula;

SELECT * FROM Estudiante
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Curso
WHERE valor > 450000;

SELECT * FROM Curso
WHERE area <> 'Ciencias';

SELECT * FROM Estudiante
WHERE id_matricula IS NULL;

SELECT * FROM Estudiante
WHERE id_matricula IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Profesor;

SELECT CONCAT(e.nombre, ' ', e.apellido) AS estudiante, m.tipo_matricula
FROM Estudiante e
JOIN Matricula m ON e.id_matricula = m.id_matricula;

SELECT c.id_curso, COUNT(m.id_matricula) AS total
FROM Curso c
JOIN Matricula m ON c.id_curso = m.id_curso
GROUP BY c.id_curso;

SELECT m.tipo_matricula, SUM(m.valor) AS total
FROM Matricula m
GROUP BY m.tipo_matricula;

SELECT c.id_curso, MAX(m.valor) AS matricula_max
FROM Curso c
JOIN Matricula m ON c.id_curso = m.id_curso
GROUP BY c.id_curso;

SELECT (SELECT MAX(valor) 
FROM Matricula);

SELECT * FROM Curso
WHERE valor > (SELECT AVG(valor) FROM Curso);

SELECT nombre, apellido FROM Estudiante
WHERE id_matricula = (SELECT id_matricula FROM Matricula ORDER BY valor ASC LIMIT 1);

SELECT * FROM Profesor
WHERE id_profesor IN (SELECT id_profesor FROM matricula_profesor);

SELECT nombre_curso FROM Curso
WHERE id_curso IN (
    SELECT id_curso FROM Matricula WHERE tipo_matricula = 'Presencial'
);

/* Alteraciones */
ALTER TABLE Estudiante ADD email VARCHAR(100);
ALTER TABLE Profesor DROP COLUMN especialidad;
ALTER TABLE Profesor ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Curso ADD estado VARCHAR(20);
ALTER TABLE Sede DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Estudiante WHERE id_estudiante = 3;
DELETE FROM Matricula WHERE valor < 400000;
DELETE FROM Curso WHERE cupos = 0;
DELETE FROM Profesor WHERE nombre = 'Carlos';
DELETE FROM Sede WHERE nombre_sede = 'Norte';

TRUNCATE TABLE Estudiante;
TRUNCATE TABLE Matricula;
TRUNCATE TABLE Curso;
TRUNCATE TABLE Profesor;
TRUNCATE TABLE Sede;

/* Eliminación de tablas y base de datos */
DROP TABLE Estudiante;
DROP TABLE Matricula;
DROP TABLE Curso;
DROP TABLE matricula_sede;
DROP DATABASE Colegio;