/*Crear DATABASE*/
CREATE DATABASE Biblioteca;

/*Usar DATABASE*/
USE Biblioteca;

/*Crear tablas*/
/*Crear tabla Libro*/
CREATE TABLE Libro (
Id_libro INT PRIMARY KEY,
Titulo VARCHAR (225),
Autor VARCHAR (225),
Editorial VARCHAR (225),
Anio VARCHAR (225),
Isbn VARCHAR (20)
);
/*Crear tabla Usuario*/
CREATE TABLE Usuario (
Id_usuario INT PRIMARY KEY,
Nombre VARCHAR (225),
Apellido VARCHAR (225),
Telefono VARCHAR (225),
Correo VARCHAR (225)
);
/*Crear tabla Bibliotecario*/
CREATE TABLE Bibliotecario(
Id_bibliotecario INT PRIMARY KEY,
Nombre VARCHAR (225),
Email VARCHAR (225)
);
/*Crear tabla Prestamo*/
CREATE TABLE Prestamo (
Id_prestamo INT PRIMARY KEY,
Id_libro INT,
Id_usuario INT,
Id_bibliotecario INT,
Fecha_prestamo DATE,
Fecha_devolucion DATE,
FOREIGN KEY (Id_libro) REFERENCES Libro (Id_libro), --FOREING KEY (Id_libro) REFERENCES Libro (Id),
FOREIGN KEY (Id_usuario) REFERENCES Usuario (Id_usuario), --FOREING KEY (Id_usuario) REFERENCES Usuario (Id),
FOREIGN KEY (Id_bibliotecario) REFERENCES Bibliotecario (Id_bibliotecario) --FOREING KEY (Id_bibliotecario) REFERENCES Bibliotecario (Id),
); --Faltó esta línea

/*Insertar datos*/
/*Insertar datos en la tabla Libro*/
INSERT INTO Libro (Id_libro, Titulo, Autor, Editorial, Anio, Isbn) VALUES (1, 'Harry Potter', 'Daniel', '23232', '1943', '212121');
INSERT INTO Libro (Id_libro, Titulo, Autor, Editorial, Anio, Isbn) VALUES (2, 'Camino Fino', 'Leo Dan', '33212', '1809', '2212');
INSERT INTO Libro (Id_libro, Titulo, Autor, Editorial, Anio, Isbn) VALUES (3, 'Fino Camino', 'Dani leo', '42232', '1922', '4212');
/*Insertar datos en la tabla Usuario*/
INSERT INTO Usuario (Id_usuario, Nombre, Apellido, Telefono, Correo) VALUES (1, 'Pedro', 'Escamoso', '3213590152', 'danielsalazar@gmail.com');
INSERT INTO Usuario (Id_usuario, Nombre, Apellido, Telefono, Correo) VALUES (2, 'Juan', 'Valdez', '322410922', 'juanvaldez@gmail.com');
INSERT INTO Usuario (Id_usuario, Nombre, Apellido, Telefono, Correo) VALUES (3, 'Adrian', 'Cardenaz', '321402221', 'adriancardenaz@gmail.com');
/*Insertar datos en la tabla Bibliotecario*/
INSERT INTO Bibliotecario (Id_bibliotecario, Nombre, Email) VALUES (1, 'Dario', 'dario@gmail.com');
INSERT INTO Bibliotecario (Id_bibliotecario, Nombre, Email) VALUES (2, 'Cezar', 'cezar@gmail.com');
INSERT INTO Bibliotecario (Id_bibliotecario, Nombre, Email) VALUES (3, 'Carlos', 'carlos@gmail.com');
/*Insertar datos en la tabla Prestamo*/
INSERT INTO Prestamo (Id_prestamo, Id_libro, Id_usuario, Id_bibliotecario, Fecha_prestamo, Fecha_devolucion) VALUES (1, 1, 1, 1, '2025-05-23', '2025-06-22');
INSERT INTO Prestamo (Id_prestamo, Id_libro, Id_usuario, Id_bibliotecario, Fecha_prestamo, Fecha_devolucion) VALUES (2, 2, 2, 2, '2022-05-25', '2023-08-12');
INSERT INTO Prestamo (Id_prestamo, Id_libro, Id_usuario, Id_bibliotecario, Fecha_prestamo, Fecha_devolucion) VALUES (3, 3, 3, 3, '2021-05-22', '2022-07-24');

/*Sentencia: SELECT*/
/*Usamos la sentencia del SELECT con la tabla Libro*/
SELECT * FROM Libro;
SELECT Titulo, Autor FROM Libro WHERE CAST(Anio AS INT) > 1999;
SELECT Titulo FROM Libro WHERE Editorial = '42232';
/*Ahora con la tabla Usuario*/
SELECT * FROM Usuario;
SELECT Nombre, Apellido FROM Usuario WHERE Telefono = '3213590152';
SELECT Nombre FROM Usuario WHERE Id_usuario = 1;
/*Ahora con la tabla Bibliotecario*/
SELECT * FROM Bibliotecario;
SELECT Nombre FROM Bibliotecario;
SELECT Email FROM Bibliotecario WHERE Id_bibliotecario = 10
/*Ahora con la tabla Prestamo*/
SELECT Fecha_prestamo FROM Prestamo;
SELECT * FROM Prestamo WHERE Id_usuario = 5;
SELECT Id_libro FROM Prestamo;

/*Sentencia: SELECT-JOIN*/
/*Usamos la sentencia del SELECT-JOIN con la tabla Libro*/
SELECT
Prestamo.Id_prestamo AS Id_prestamo,
Usuario.Nombre AS Nombre_usuario,
Libro.Titulo AS Titulo_libro,
Bibliotecario.Nombre AS Nombre_bibliotecario,
Prestamo.Fecha_prestamo,
Prestamo.Fecha_devolucion
FROM Prestamo
JOIN Usuario ON Prestamo.Id_usuario = Usuario.Id_usuario
JOIN Libro ON Prestamo.Id_libro = Libro.Id_libro
JOIN Bibliotecario ON Prestamo.Id_bibliotecario = Bibliotecario.Id_bibliotecario;

/*Sentencia: UPDATE*/
/*Usamos la sentencia del UPDATE con la tabla Libro*/
UPDATE Libro SET Titulo = 'Juan Kijot' WHERE Id_libro = 3;
UPDATE Libro SET Autor = 'Pedro' WHERE Id_libro = 2;
UPDATE Libro SET Editorial = '232122' WHERE Id_libro = 1;
/*Ahora con la tabla Usuario*/
UPDATE Usuario SET Nombre = 'Carlos' WHERE Id_usuario = 3;
UPDATE Usuario SET Telefono = '3213590152' WHERE Id_usuario = 1;
UPDATE Usuario SET Apellido = 'Zambrano' WHERE Id_usuario = 2;
/*Ahora con la tabla Bibliotecario*/
UPDATE Bibliotecario SET Nombre = 'Juana' WHERE Id_bibliotecario = 2;
UPDATE Bibliotecario SET Email = 'juana@gmail.com' WHERE Id_bibliotecario = 1;
UPDATE Bibliotecario SET Nombre = 'Carlos' WHERE Email = 'carlos@gmail.com';
/*Ahora con la tabla Prestamo*/
UPDATE Prestamo SET Fecha_prestamo = '2022-05-25' WHERE Id_prestamo = 1;
UPDATE Prestamo SET Id_usuario = 2 WHERE Id_usuario = 2;
UPDATE Prestamo SET Fecha_devolucion = '2023-02-12' WHERE Id_prestamo = 3;

/*Sentencia: DELETE*/
/*Usamos la sentencia del DELETE con la tabla Libro*/
DELETE FROM Prestamo WHERE Id_libro = 3;
DELETE FROM Prestamo WHERE Id_libro IN (SELECT Id_libro FROM Libro WHERE Autor = 'Daniel');
DELETE FROM Libro WHERE Id_libro = 3;
DELETE FROM Libro WHERE Autor = 'Daniel';
/*Ahora con la tabla Usuario*/
DELETE FROM Usuario WHERE Id_usuario = 1;
DELETE FROM Usuario WHERE Id_usuario = 2;
/*Ahora con la tabla Bibliotecario*/
DELETE FROM Usuario WHERE Id_usuario = 2;
DELETE FROM Usuario WHERE Id_usuario = 1;
DELETE FROM Bibliotecario WHERE Email IS NULL;
/*Ahora con la tabla Prestamo*/
DELETE FROM Prestamo WHERE Id_prestamo = 1;
DELETE FROM Prestamo WHERE Id_prestamo = 2;