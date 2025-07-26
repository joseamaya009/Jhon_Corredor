/* Crear la base de datos */
CREATE DATABASE Alcaldia;
USE Alcaldia;

/* Crear las tablas */
CREATE TABLE Departamento (
    id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(50),
    tipo VARCHAR(50),
    presupuesto DECIMAL(12, 2),
    empleados INT
);

CREATE TABLE Sede (
    id_sede INT PRIMARY KEY,
    nombre_sede VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(20)
);

CREATE TABLE Funcionario (
    id_funcionario INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    cargo VARCHAR(30)
);

CREATE TABLE Tramite (
    id_tramite INT PRIMARY KEY,
    fecha DATE,
    tipo_tramite VARCHAR(15),
    valor DECIMAL(10, 2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Ciudadano (
    id_ciudadano INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    documento CHAR(10),
    id_tramite INT,
    FOREIGN KEY (id_tramite) REFERENCES Tramite(id_tramite)
);

CREATE TABLE tramite_sede (
    id_tramite INT,
    id_sede INT,
    PRIMARY KEY (id_tramite, id_sede),
    FOREIGN KEY (id_tramite) REFERENCES Tramite(id_tramite),
    FOREIGN KEY (id_sede) REFERENCES Sede(id_sede)
);

CREATE TABLE tramite_funcionario (
    id_tramite INT,
    id_funcionario INT,
    PRIMARY KEY (id_tramite, id_funcionario),
    FOREIGN KEY (id_tramite) REFERENCES Tramite(id_tramite),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

/* Insertar datos */
INSERT INTO Departamento VALUES 
(1, 'Salud', 'Social', 50000000.00, 20),
(2, 'Educación', 'Social', 80000000.00, 30),
(3, 'Obras Públicas', 'Infraestructura', 120000000.00, 15);

INSERT INTO Sede VALUES 
(1, 'Principal', 'Cra 10 #20-30', '3001234567'),
(2, 'Norte', 'Av 45 #67-89', '3019876543'),
(3, 'Sur', 'Cll 100 #50-60', '3025557890');

INSERT INTO Funcionario VALUES 
(1, 'Ana', 'García', 'Jefe'),
(2, 'Carlos', 'Pérez', 'Analista'),
(3, 'Marta', 'López', 'Auxiliar');

INSERT INTO Tramite VALUES 
(1, '2025-07-01', 'Licencia', 120000.00, 1),
(2, '2025-07-05', 'Permiso', 80000.00, 2),
(3, '2025-07-10', 'Certificado', 50000.00, 3);

INSERT INTO Ciudadano VALUES 
(1, 'Laura', 'Martínez', '1111222233', 1),
(2, 'Diego', 'Ramírez', '3333444455', 2),
(3, 'Sofía', 'Hernández', '5555666677', 3);

INSERT INTO tramite_sede VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO tramite_funcionario VALUES 
(1, 1),
(2, 2),
(3, 3);

/* Procedimiento */
GO
CREATE PROCEDURE consultar_presupuesto_departamento(IN departamento_id INT)
BEGIN
    SELECT 
        id_departamento,
        nombre_departamento,
        presupuesto
    FROM Departamento
    WHERE id_departamento = departamento_id;
END
EXEC consultar_presupuesto_departamento;

/* Consultas */
SELECT * FROM Ciudadano
WHERE nombre LIKE '%au%';

SELECT COUNT(*) AS total_ciudadanos
FROM Ciudadano;

SELECT SUM(empleados) AS total_empleados
FROM Departamento;

SELECT MONTH(fecha) AS mes, COUNT(*) AS total_tramites
FROM Tramite
GROUP BY MONTH(fecha);

SELECT MAX(presupuesto) AS presupuesto_max
FROM Departamento;

SELECT tipo_tramite, MIN(valor) AS tramite_min
FROM Tramite
GROUP BY tipo_tramite;

SELECT AVG(presupuesto) AS promedio_presupuesto
FROM Departamento;

SELECT tipo, AVG(presupuesto) AS promedio
FROM Departamento
GROUP BY tipo
HAVING AVG(presupuesto) > 60000000;

SELECT id_departamento, CAST(presupuesto AS CHAR) AS presupuesto_texto
FROM Departamento;

SELECT id_tramite, CONVERT(fecha, CHAR) AS fecha_texto
FROM Tramite;

SELECT * FROM Ciudadano
WHERE apellido IN ('Martínez', 'Ramírez');

SELECT * FROM Departamento
WHERE presupuesto > 60000000;

SELECT * FROM Departamento
WHERE tipo <> 'Social';

SELECT * FROM Ciudadano
WHERE id_tramite IS NULL;

SELECT * FROM Ciudadano
WHERE id_tramite IS NOT NULL;

SELECT CONCAT(nombre, ' ', apellido) 
FROM Funcionario;

SELECT CONCAT(c.nombre, ' ', c.apellido) AS ciudadano, t.tipo_tramite
FROM Ciudadano c
JOIN Tramite t ON c.id_tramite = t.id_tramite;

SELECT d.id_departamento, COUNT(t.id_tramite) AS total
FROM Departamento d
JOIN Tramite t ON d.id_departamento = t.id_departamento
GROUP BY d.id_departamento;

SELECT t.tipo_tramite, SUM(t.valor) AS total
FROM Tramite t
GROUP BY t.tipo_tramite;

SELECT d.id_departamento, MAX(t.valor) AS tramite_max
FROM Departamento d
JOIN Tramite t ON d.id_departamento = t.id_departamento
GROUP BY d.id_departamento;

SELECT (SELECT MAX(presupuesto) 
FROM Departamento);

SELECT * FROM Departamento
WHERE presupuesto > (SELECT AVG(presupuesto) FROM Departamento);

SELECT nombre, apellido FROM Ciudadano
WHERE id_tramite = (SELECT id_tramite FROM Tramite ORDER BY valor ASC LIMIT 1);

SELECT * FROM Funcionario
WHERE id_funcionario IN (SELECT id_funcionario FROM tramite_funcionario);

SELECT nombre_departamento FROM Departamento
WHERE id_departamento IN (
    SELECT id_departamento FROM Tramite WHERE tipo_tramite = 'Licencia'
);

/* Alteraciones */
ALTER TABLE Ciudadano ADD email VARCHAR(100);
ALTER TABLE Funcionario DROP COLUMN cargo;
ALTER TABLE Funcionario ALTER COLUMN nombre VARCHAR(100);
ALTER TABLE Departamento ADD estado VARCHAR(20);
ALTER TABLE Sede DROP COLUMN direccion;

/* Eliminaciones */
DELETE FROM Ciudadano WHERE id_ciudadano = 3;
DELETE FROM Tramite WHERE valor < 60000;
DELETE FROM Departamento WHERE empleados = 0;
DELETE FROM Funcionario WHERE nombre = 'Carlos';
DELETE FROM Sede WHERE nombre_sede = 'Norte';

TRUNCATE TABLE Ciudadano;
TRUNCATE TABLE Tramite;
TRUNCATE TABLE Departamento;
TRUNCATE TABLE Funcionario;
TRUNCATE TABLE Sede;

/* Eliminación de tablas y base de datos */
DROP TABLE Ciudadano;
DROP TABLE Tramite;
DROP TABLE Departamento;
DROP TABLE tramite_sede;
DROP TABLE tramite_funcionario;
DROP TABLE Funcionario;
DROP TABLE Sede;
DROP DATABASE Alcaldia;