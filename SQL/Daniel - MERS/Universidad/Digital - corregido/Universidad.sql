/*Crear DATABASE*/
CREATE DATABASE Universidad;

/*Usar DATABASE*/
USE Universidad;

/*Crear tablas*/
/*Crear tabla Estudiante*/
CREATE TABLE Estudiante (
Id_estudiante INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR (225),
Email VARCHAR (225),
);
/*Crear tabla Profesor*/
CREATE TABLE Profesor (
Id_profesor INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR (225),
Especialidad VARCHAR (225),
);
/*Crear tabla Curso*/
CREATE TABLE Curso(
Id_curso INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR (225),
Descripcion VARCHAR (225)
);
/*Crear tabla Inscripcion*/
CREATE TABLE Inscripcion (
Id_inscripcion INT IDENTITY(1,1) PRIMARY KEY,
Id_estudiante INT,
Id_profesor INT,
Id_curso INT,
Fecha_inscripcion DATE,
FOREIGN KEY (Id_estudiante) REFERENCES Estudiante (Id_estudiante),
FOREIGN KEY (Id_profesor) REFERENCES Profesor (Id_profesor),
FOREIGN KEY (Id_curso) REFERENCES Curso (Id_curso)
);

/*Insertar datos*/
/*Insertar datos en la tabla Estudiante*/
INSERT INTO Estudiante (Nombre, Email) VALUES ('Juan', 'juan@gmail.com');
INSERT INTO Estudiante (Nombre, Email) VALUES ('Carlos', 'carlos@gmail.com');
INSERT INTO Estudiante (Nombre, Email) VALUES ('Pedro', 'pedro@gmail.com');
/*Insertar datos en la tabla Profesor*/
INSERT INTO Profesor (Nombre, Especialidad) VALUES ('Pamela', 'Matematicas');
INSERT INTO Profesor (Nombre, Especialidad) VALUES ('Juana', 'Español');
INSERT INTO Profesor (Nombre, Especialidad) VALUES ('Kiko', 'Quimica');
/*Insertar datos en la tabla Curso*/
INSERT INTO Curso (Nombre, Descripcion) VALUES ('Matematicas', 'Operaciones basicas');
INSERT INTO Curso (Nombre, Descripcion) VALUES ('Español', 'Libros basicos');
INSERT INTO Curso (Nombre, Descripcion) VALUES ('Quimica', 'Compuestos quimicos');
/*Insertar datos en la tabla Inscripcion*/
INSERT INTO Inscripcion (Id_estudiante, Id_curso, Id_profesor, Fecha_inscripcion) VALUES (1, 1, 1, '2023-03-01');
INSERT INTO Inscripcion (Id_estudiante, Id_curso, Id_profesor, Fecha_inscripcion) VALUES (2, 2, 2, '2023-08-22');
INSERT INTO Inscripcion (Id_estudiante, Id_curso, Id_profesor, Fecha_inscripcion) VALUES (3, 3, 3, '2023-09-23');

/*Sentencia: SELECT*/
/*Usamos la sentencia del SELECT con las tablas*/
SELECT
E.Nombre AS Estudiante,
C.Nombre AS Curso,
P.Nombre AS Profesor,
I.Fecha_inscripcion
FROM
Inscripcion I
JOIN Estudiante E ON I.Id_estudiante = E.Id_estudiante
JOIN Curso C ON I.Id_curso = C.Id_curso
JOIN Profesor P ON I.Id_profesor = P.Id_profesor;

/*Sentencia: UPDATE*/
/*Usamos la sentencia del UPDATE con la tabla Profesor*/
UPDATE Profesor SET Especialidad = 'Fisica' WHERE Id_profesor = 1;
UPDATE Profesor SET Especialidad = 'Literatura' WHERE Id_profesor = 2;
UPDATE Profesor SET Especialidad = 'Quimica' WHERE Id_profesor = 3;
/*Ahora con la tabla Curso*/
UPDATE Curso SET Descripcion = 'Algebra avanzada' WHERE Id_curso = 1;
UPDATE Curso SET Descripcion = 'Historia universal' WHERE Id_curso = 2;
UPDATE Curso SET Descripcion = 'Biologia molecular' WHERE Id_curso = 3;
/*Ahora con la tabla Estudiante*/
UPDATE Estudiante SET Email = 'juan12@gmail.com' WHERE Id_estudiante = 1;
UPDATE Estudiante SET Email = 'carlos13@gmail.com' WHERE Id_estudiante = 2;
UPDATE Estudiante SET Email = 'pedro128@gmail.com' WHERE Id_estudiante = 3;
/*Ahora con la tabla Inscripcion*/
UPDATE Inscripcion SET Fecha_inscripcion = '2025-06-10' WHERE Id_inscripcion = 1;
UPDATE Inscripcion SET Fecha_inscripcion = '2023-06-11' WHERE Id_inscripcion = 2;
UPDATE Inscripcion SET Fecha_inscripcion = '2023-06-12' WHERE Id_inscripcion = 3;

/*Sentencia: DELETE*/
/*Usamos la sentencia del DELETE con la tabla Estudiante*/
DELETE FROM Estudiante WHERE Id_estudiante = 1;
DELETE FROM Estudiante WHERE Id_estudiante = 2;
DELETE FROM Estudiante WHERE Id_estudiante = 3;
/*Ahora con la tabla Profesor*/
DELETE FROM Profesor WHERE Id_profesor = 1;
DELETE FROM Profesor WHERE Id_profesor = 2;
DELETE FROM Profesor WHERE Id_profesor= 3;
/*Ahora con la tabla Curso*/
DELETE FROM Curso WHERE Id_curso = 1;
DELETE FROM Curso WHERE Id_curso = 2;
DELETE FROM Curso WHERE Id_curso = 3;
/*Ahora con la tabla Inscripcion*/
DELETE FROM Inscripcion WHERE Id_inscripcion = 1;
DELETE FROM Inscripcion WHERE Id_inscripcion = 2;
DELETE FROM Inscripcion WHERE Id_inscripcion = 3;

/*Sentencia: DROP*/
/*Usamos la sentencia del DROP con las tablas*/
DROP TABLE IF EXISTS Inscripcion;
DROP TABLE IF EXISTS Profesor;
DROP TABLE IF EXISTS Estudiante;
DROP TABLE IF EXISTS Curso;