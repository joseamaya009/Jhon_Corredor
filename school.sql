CREATE DATABASE school;
USE school;

CREATE TABLE student (
id_student INT PRIMARY KEY,
name VARCHAR(50),
birth_date DATE
);

CREATE TABLE assignment (
id_assignment INT PRIMARY KEY,
year INT  
);

CREATE TABLE teacher (
id_teacher INT PRIMARY KEY,
name VARCHAR(50),
specialty VARCHAR(50)
);

CREATE TABLE course (
id_course INT PRIMARY KEY,
name VARCHAR(100),
level VARCHAR(30),
id_assignment INT,
FOREIGN KEY (id_assignment) REFERENCES assignment(id_assignment)
);

CREATE TABLE tuition (
id_tuition INT PRIMARY KEY,
date DATE,
id_course INT,
FOREIGN KEY (id_course) REFERENCES course(id_course)
);

CREATE TABLE student_course (
id_student INT,
id_course INT,
PRIMARY KEY (id_student, id_course),
FOREIGN KEY (id_student) REFERENCES student(id_student),
FOREIGN KEY (id_course) REFERENCES course(id_course)
);

CREATE TABLE teacher_course (
id_teacher INT,
id_course INT,
PRIMARY KEY (id_teacher, id_course),
FOREIGN KEY (id_teacher) REFERENCES teacher(id_teacher),
FOREIGN KEY (id_course) REFERENCES course(id_course)
);

INSERT INTO student VALUES
(1, 'Camila Torres', '2008-05-15'),
(2, 'Mateo Gómez', '2007-11-03'),
(3, 'Laura Sánchez', '2008-02-20'),
(4, 'Daniel Romero', '2009-01-12'),
(5, 'Sofía Vargas', '2007-09-07');

INSERT INTO assignment VALUES
(1, 2023),
(2, 2024),
(3, 2025),
(4, 2022),
(5, 2021);

INSERT INTO teacher VALUES
(1, 'Carlos Perez', 'Mathematics'),
(2, 'Maria Rojas', 'Science'),
(3, 'Andres Gutierrez', 'History'),
(4, 'Paula Medina', 'English'),
(5, 'Fernando Lopez', 'Physical Education');

INSERT INTO course VALUES
(1, 'Algebra I', 'Basic', 1),
(2, 'General Biology', 'Intermediate', 2),
(3, 'Modern History', 'Advanced', 3),
(4, 'Conversational English', 'Intermediate', 4),
(5, 'Sports Training', 'Basic', 5);

INSERT INTO tuition VALUES
(1, '2024-01-10', 1),
(2, '2024-01-11', 2),
(3, '2024-01-12', 3),
(4, '2024-01-13', 4),
(5, '2024-01-14', 5);

INSERT INTO student_course VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO teacher_course VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- 1 procedimiento
GO
CREATE PROCEDURE count_courses_by_year
    @year INT
AS
BEGIN
    SELECT COUNT(*) AS total_courses
    FROM assignment
    WHERE year = @year;
END

--10 sentencias sql con funciones aplicadas
--1. Mostrar el año de nacimiento de cada estudiante
SELECT name, YEAR(birth_date) AS birth_year
FROM student;

--2. Calcular la edad aproximada (en años)
SELECT name, DATEDIFF(YEAR, birth_date, GETDATE()) AS approx_age
FROM student;

--3. Primeros 3 caracteres del nombre del curso
SELECT name, LEFT(name, 3) AS abbreviation
FROM course;

--4. Últimos 4 caracteres del nombre del profesor
SELECT name, RIGHT(name, 4) AS ending
FROM teacher;

--5. Eliminar espacios a ambos lados del nombre del estudiante
SELECT name, LTRIM(RTRIM(name)) AS cleaned_name
FROM student;

--6. Muestra los nombres de los profesores cuya nombre no comienza con la letra "M".
SELECT name 
FROM teacher 
WHERE name NOT LIKE 'M%';

--7.  Cantidad de cursos por nivel
SELECT level, COUNT(*) AS total_courses
FROM course
GROUP BY level;

--8. Reemplazar posibles valores nulos en specialty con 'Unknown'
SELECT name, ISNULL(specialty, 'Unknown') AS specialty_checked
FROM teacher;

--9. Clasificar estudiantes según su año de nacimiento
SELECT name,
  CASE 
    WHEN YEAR(birth_date) <= 2007 THEN 'Senior'
    ELSE 'Junior'
  END AS category
FROM student;

--10. Mostrar la fecha de matrícula en formato personalizado
SELECT id_tuition, FORMAT(date, 'dd/MM/yyyy') AS formatted_date
FROM tuition;

--5 sententacias Select adicionales - básicas 
--1. Mostrar el nombre del estudiante y el nombre del curso en el que está inscrito
SELECT s.name, c.name
FROM student s
JOIN student_course sc ON s.id_student = sc.id_student
JOIN course c ON sc.id_course = c.id_course;

--2. Mostrar el nombre del profesor y el curso que imparte
SELECT t.name, c.name
FROM teacher t
JOIN teacher_course tc ON t.id_teacher = tc.id_teacher
JOIN course c ON tc.id_course = c.id_course;

--3. Mostrar el nombre del curso y su año de asignación
SELECT c.name, a.year 
FROM course c
JOIN assignment a ON c.id_assignment = a.id_assignment;

--4. Mostrar el nombre del curso y la fecha de matrícula correspondiente
SELECT c.name, tu.date
FROM course c
JOIN tuition tu ON c.id_course = tu.id_course;

--5. Mostrar el nombre del estudiante, el nombre del curso y el profesor correspondiente
SELECT s.name, c.name, t.name 
FROM student s
JOIN student_course sc ON s.id_student = sc.id_student
JOIN course c ON sc.id_course = c.id_course
JOIN teacher_course tc ON c.id_course = tc.id_course
JOIN teacher t ON tc.id_teacher = t.id_teacher;

--5 subconsultas 
--1. Mostrar el nombre del curso en el que está inscrito el estudiante llamado 'Mateo Gómez'
SELECT name
FROM course
WHERE id_course = (
    SELECT id_course
    FROM student_course
    WHERE id_student = (
        SELECT id_student
        FROM student
        WHERE name = 'Mateo Gómez'
    )
);

--2. Mostrar la especialidad del profesor que enseña 'Modern History'
SELECT specialty
FROM teacher
WHERE id_teacher = (
    SELECT id_teacher
    FROM teacher_course
    WHERE id_course = (
        SELECT id_course
        FROM course
        WHERE name = 'Modern History'
    )
);

--3. Mostrar la fecha de matrícula del curso 'General Biology'
SELECT date
FROM tuition
WHERE id_course = (
    SELECT id_course
    FROM course
    WHERE name = 'General Biology'
);

--4. Mostrar el nombre del estudiante inscrito en el curso con el nivel 'Advanced'
SELECT name
FROM student
WHERE id_student = (
    SELECT id_student
    FROM student_course
    WHERE id_course = (
        SELECT id_course
        FROM course
        WHERE level = 'Advanced'
    )
);

--5. Mostrar el año de asignación del curso llamado 'Sports Training'
SELECT year
FROM assignment
WHERE id_assignment = (
    SELECT id_assignment
    FROM course
    WHERE name = 'Sports Training'
);

--5 alter
ALTER TABLE student ADD email VARCHAR(100);
ALTER TABLE assignment ALTER COLUMN year SMALLINT;
ALTER TABLE teacher ALTER COLUMN name VARCHAR(50) NOT NULL;
ALTER TABLE course ADD status VARCHAR(20) DEFAULT 'Active';
ALTER TABLE tuition ADD notes TEXT;

--5 update
UPDATE student SET name = 'Camila T.' WHERE id_student = 1;
UPDATE course SET level = 'Advanced' WHERE id_course = 1;
UPDATE teacher SET specialty = 'Physics' WHERE id_teacher = 2;
UPDATE assignment SET year = 2026 WHERE id_assignment = 3;
UPDATE tuition SET notes = 'Pagado'WHERE id_tuition = 1;

--5 delete
DELETE FROM student WHERE id_student = 5;
DELETE FROM assignment WHERE id_assignment = 5;
DELETE FROM course WHERE id_course = 5;
DELETE FROM teacher WHERE id_teacher = 5;
DELETE FROM tuition WHERE id_tuition = 5;

--5 truncate 
TRUNCATE TABLE student_course;
TRUNCATE TABLE teacher_course;
TRUNCATE TABLE tuition;
TRUNCATE TABLE assignment;
TRUNCATE TABLE course;

--5 drop 
DROP TABLE student_course;
DROP TABLE teacher_course;
DROP TABLE tuition;
DROP TABLE assignment;
DROP TABLE course;