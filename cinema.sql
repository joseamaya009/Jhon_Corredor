CREATE DATABASE cinema;
USE cinema;

CREATE TABLE director (
id_director INT PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE actor (
id_actor INT PRIMARY KEY,
name VARCHAR(50)
);

CREATE TABLE gender (
id_gender INT PRIMARY KEY,
category VARCHAR(50)
);

CREATE TABLE movie (
id_movie INT PRIMARY KEY,
name VARCHAR(50),
duration TIME,
years INT,
id_director INT,
FOREIGN KEY (id_director) REFERENCES director(id_director)
);

CREATE TABLE criticism (
id_criticism INT PRIMARY KEY,
description VARCHAR(50),
id_movie INT,
FOREIGN KEY (id_movie) REFERENCES movie(id_movie)
);

CREATE TABLE actor_movie (
id_actor INT,
id_movie INT,
PRIMARY KEY (id_actor, id_movie),
FOREIGN KEY (id_actor) REFERENCES actor(id_actor),
FOREIGN KEY (id_movie) REFERENCES movie(id_movie)
);

CREATE TABLE gender_movie (
id_gender INT,
id_movie INT,
PRIMARY KEY (id_gender, id_movie),
FOREIGN KEY (id_gender) REFERENCES gender(id_gender),
FOREIGN KEY (id_movie) REFERENCES movie(id_movie)
);

INSERT INTO director VALUES 
(1, 'Christopher Nolan'),
(2, 'Greta Gerwig'),
(3, 'Quentin Tarantino'),
(4, 'John Lasseter'),
(5, 'Andrew Adamson');

INSERT INTO actor VALUES
(1, 'Leonardo DiCaprio'),
(2, 'Margot Robbie'),
(3, 'Cillian Murphy'),
(4, 'Wallance Shawn'),
(5, 'Mike Myers');

INSERT INTO gender VALUES
(1, 'Drama'),
(2, 'Action'),
(3, 'Comedy'),
(4, 'Comedy'),
(5, 'Fantasy');

INSERT INTO movie VALUES
(1, 'Inception', '02:28:00', 2010, 1),
(2, 'Barbie', '01:54:00', 2023, 2),
(3, 'Pulp Fiction', '02:34:00', 1994, 3),
(4, 'Toy story', '01:21:00', 1995, 4),
(5, 'Sherk', '01:29:00', 2001, 5);

INSERT INTO criticism VALUES
(1, 'Innovative and visually stunning', 1),
(2, 'Fun and stylish', 2),
(3, 'Masterpiece of modern cinema', 3),
(4, 'full of adventures and friendships', 4),
(5, 'Entertaining and fun',5);

INSERT INTO actor_movie VALUES
(1, 1),  
(2, 2),  
(3, 1), 
(4, 4),  
(5, 5);  

INSERT INTO gender_movie VALUES
(1, 1),  
(2, 1),  
(3, 2),  
(4, 4),  
(5, 5);  

--1 procedimiento cadena de texto
GO
CREATE PROCEDURE SP_prueba1
AS
BEGIN
    PRINT 'Mi primera prueba';
END;

EXEC SP_prueba1;

--10 sentencias sql con funciones aplicadas
--1. Muestra el nombre en mayúsculas de todos los directores.
SELECT UPPER(name) AS nombre_mayusculas
FROM director;

--2. Cuenta cuántas críticas hay registradas.
SELECT COUNT(*) AS total_criticas
FROM criticism;

SELECT COUNT(id_criticism) AS total_criticas
FROM criticism;

--3. Obtén la duración total de todas las películas en segundos.
SELECT SUM(DATEDIFF(SECOND, '00:00:00', duration)) AS total_segundos
FROM movie;

--4. Muestra el nombre de cada película y la cantidad de caracteres que tiene su nombre.
SELECT name AS nombre_pelicula,
       LEN(name) AS cantidad_caracteres
FROM movie;

--5. Muestra el nombre de las películas en minúsculas y el año en que se estrenaron.
SELECT LOWER(name) AS nombre_minuscula,
       years AS año_estreno
FROM movie;

--6. Muestra el promedio de duración de las películas.
SELECT AVG(DATEDIFF(SECOND, '00:00:00', duration)) AS promedio_segundos
FROM movie;

--7. Redondea a dos decimales el promedio de duración (en minutos) de las películas.
SELECT ROUND(AVG(DATEDIFF(MINUTE, 0, duration) * 1.0), 2) AS promedio_minutos
FROM movie;

--8. Muestra el año más antiguo y más reciente en que se estrenaron películas.
SELECT 
  MIN(years) AS año_mas_antiguo,
  MAX(years) AS año_mas_reciente
FROM movie;

--9.Muestra las películas cuyo nombre empieza con la letra 'S'.
-- 'A%' comienza por a
--'%A' termina por a
-- '%abc% contiene abc en cualquier parte 
--'_b' segundo caracter es b
SELECT name
FROM movie
WHERE name LIKE 'S%'

--10. Muestra una lista con el nombre de cada actor junto con el texto " participó en la película " seguido del nombre de la película en la que actuó.
SELECT CONCAT(a.name, ' participó en la película ', m.name) AS descripcion
FROM actor a
JOIN actor_movie am ON a.id_actor = am.id_actor
JOIN movie m ON am.id_movie = m.id_movie;

--5 sententacias Select adicionales - básicas 
--1. Obtener los nombres de las películas dirigidas por 'Christopher Nolan'.
SELECT name
FROM movie
WHERE id_director = 1;

SELECT m.name, d.name
FROM movie m 
JOIN director d ON m.id_movie= d.id_director
WHERE d.name = 'Christopher Nolan'

--2. Mostrar los nombres de los actores que participaron en la película 'Inception'.
SELECT a.name AS actor
FROM actor a
JOIN actor_movie am ON a.id_actor = am.id_actor
JOIN movie m ON am.id_movie = m.id_movie
WHERE m.name = 'Inception';

--3. Listar el nombre de cada película junto con su(s) categoría(s).
SELECT m.name, g.category
FROM movie m 
JOIN gender_movie gm ON m.id_movie = gm.id_movie
JOIN gender g ON gm.id_gender = g.id_gender;

--4. Obtener los nombres de los actores que han trabajado en más de una película.
SELECT a.name AS actor, COUNT(am.id_movie) AS total_peliculas
FROM actor a
JOIN actor_movie am ON a.id_actor = am.id_actor
GROUP BY a.name
HAVING COUNT(am.id_movie) > 1;

--5. Mostrar el nombre de la película, el nombre del director y la crítica correspondiente.
SELECT m.name, m.name, c.description
FROM movie m 
JOIN director d ON m.id_director = d.id_director
JOIN criticism c ON m.id_movie = c.id_movie

--5 subconsultas 
--1. Muestra el nombre de las películas cuya duración es mayor al promedio de duración de todas las películas.
SELECT name
FROM movie
WHERE duration > (
  SELECT AVG(DATEDIFF(SECOND, 0, duration)) 
  FROM movie
);

--2. Muestra el nombre del director que dirigió la película más reciente.
SELECT name
FROM director
WHERE id_director = (
  SELECT id_director
  FROM movie
  WHERE years = (SELECT MAX(years) FROM movie)
);

--3. Muestra los actores que han actuado en la misma película que 'Leonardo DiCaprio'.
SELECT name
FROM actor
WHERE id_actor IN (
  SELECT id_actor
  FROM actor_movie
  WHERE id_movie IN (
    SELECT id_movie
    FROM actor_movie
    WHERE id_actor = (
      SELECT id_actor FROM actor WHERE name = 'Leonardo DiCaprio'
    )
  )
);

--4. Muestra los nombres de las películas que tienen más de un género.
SELECT name
FROM movie
WHERE id_movie IN (
  SELECT id_movie
  FROM gender_movie
  GROUP BY id_movie
  HAVING COUNT(id_gender) > 1
);

--5. Muestra el nombre y duración de la(s) película(s) con la mayor duración.
SELECT name, duration
FROM movie
WHERE duration = (
  SELECT MAX(duration) FROM movie
);

--5 alter
ALTER TABLE movie ADD awards VARCHAR(20);
ALTER TABLE actor ALTER COLUMN name VARCHAR(55);
ALTER TABLE movie DROP COLUMN years;
ALTER TABLE director ADD CONSTRAINT unique_name UNIQUE (name);
ALTER TABLE movie ADD platforms VARCHAR(20);

--5 update
UPDATE director SET name='Vicky Jenson' WHERE id_director= 5;
UPDATE actor SET name='Tim Allen' WHERE id_actor= 4;
UPDATE gender SET category='romance' WHERE id_gender = 5;
UPDATE movie SET duration='03:00:00' WHERE id_movie= 3;
UPDATE movie SET name='Sponge Bob' WHERE id_movie= 1;

--5 delete
DELETE FROM director WHERE id_director = 5; 
DELETE FROM actor WHERE name = 'Cillian Murphy'; 
DELETE FROM gender; 
DELETE FROM movie WHERE duration = '02:28:00';
DELETE FROM criticism WHERE id_criticism= 1;

--5 truncate
TRUNCATE TABLE director; 
TRUNCATE TABLE actor;
TRUNCATE TABLE gender;
TRUNCATE TABLE movie;
TRUNCATE TABLE criticism;

--5 drop
DROP TABLE director;
DROP TABLE movie;
DROP TABLE criticism;
DROP TABLE actor;
DROP TABLE gender;
--Se puede eliminar también una base de datos y una vista
--DROP DATABASE
--DROP view